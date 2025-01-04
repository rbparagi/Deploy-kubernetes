import os
import sqlite3
import pandas as pd
from datetime import datetime, timedelta
import time

# Define the path to the Chrome history database
history_path = os.path.expanduser('~') + "/Library/Application Support/Google/Chrome/Default/History"

# Check if the history file exists
if not os.path.exists(history_path):
    raise FileNotFoundError(f"Chrome history file not found at {history_path}")

# Retry mechanism for database connection
max_retries = 5
retry_delay = 3  # seconds

for attempt in range(max_retries):
    try:
        # Connect to the SQLite database
        conn = sqlite3.connect(history_path)
        cursor = conn.cursor()
        break
    except sqlite3.OperationalError as e:
        if "database is locked" in str(e):
            print(f"Database is locked, retrying in {retry_delay} seconds...")
            time.sleep(retry_delay)
        else:
            raise
else:
    raise Exception("Failed to connect to the database after several attempts")

# Calculate the start and end timestamps for today
epoch_start = datetime(1601, 1, 1)
today_start = datetime.combine(datetime.today(), datetime.min.time())
today_end = datetime.combine(datetime.today(), datetime.max.time())
today_start_timestamp = int((today_start - epoch_start).total_seconds() * 1_000_000)
today_end_timestamp = int((today_end - epoch_start).total_seconds() * 1_000_000)

# Query to retrieve URL, visit time, and visit duration for today
query = f"""
SELECT 
    urls.url, 
    visits.visit_time, 
    visits.visit_duration
FROM 
    urls, visits
WHERE 
    urls.id = visits.url AND
    visits.visit_time BETWEEN {today_start_timestamp} AND {today_end_timestamp}
"""

try:
    cursor.execute(query)
    rows = cursor.fetchall()
except sqlite3.Error as e:
    print(f"An error occurred: {e}")
    conn.close()
    exit(1)

# Convert visit_time from WebKit timestamp to datetime
def convert_time(webkit_timestamp):
    epoch_start = datetime(1601, 1, 1)
    delta = timedelta(microseconds=webkit_timestamp)
    return epoch_start + delta

# Process the data
data = []
for row in rows:
    url = row[0]
    visit_time = convert_time(row[1])
    visit_duration = row[2] / 1_000_000 / 60  # Convert microseconds to minutes
    data.append((url, visit_time, visit_duration))

# Create a DataFrame
df = pd.DataFrame(data, columns=['URL', 'Visit Time', 'Visit Duration (minutes)'])

# Calculate total time spent on each URL
time_spent = df.groupby('URL')['Visit Duration (minutes)'].sum().sort_values(ascending=False)

# Display the top 10 URLs by time spent
print(time_spent.head(10))

# Close the database connection
conn.close()

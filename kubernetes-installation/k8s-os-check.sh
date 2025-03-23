#!/bin/bash

echo "🔍 Checking Kubernetes OS Pre-requisites..."

# Check OS type
echo -e "\n👉 Checking OS type..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "✅ OS: $NAME $VERSION"
else
    echo "❌ Cannot determine OS version"
fi

# Check swap status
echo -e "\n👉 Checking Swap..."
SWAP_STATUS=$(swapon --summary)
if [ -z "$SWAP_STATUS" ]; then
    echo "✅ Swap is disabled"
else
    echo "❌ Swap is enabled"
    echo "Run: sudo swapoff -a && sudo sed -i '/swap/d' /etc/fstab"
fi

# Check hostname
echo -e "\n👉 Checking Hostname..."
hostnamectl

# Check NTP/Time Sync
echo -e "\n👉 Checking time sync service..."
if systemctl is-active --quiet systemd-timesyncd || systemctl is-active --quiet chronyd || systemctl is-active --quiet ntpd; then
    echo "✅ Time sync service is active"
else
    echo "❌ Time sync service not active"
    echo "Install and enable NTP or Chrony"
fi

# Check firewall (UFW or firewalld)
echo -e "\n👉 Checking Firewall status..."
if command -v ufw &> /dev/null; then
    sudo ufw status verbose
elif command -v firewall-cmd &> /dev/null; then
    sudo firewall-cmd --state
else
    echo "⚠️ No firewall tool detected"
fi

# Check SELinux status
echo -e "\n👉 Checking SELinux status..."
if command -v getenforce &> /dev/null; then
    SELINUX_STATUS=$(getenforce)
    echo "SELinux mode: $SELINUX_STATUS"
    if [ "$SELINUX_STATUS" != "Permissive" ] && [ "$SELINUX_STATUS" != "Disabled" ]; then
        echo "❌ Set SELinux to permissive: sudo setenforce 0"
    else
        echo "✅ SELinux is permissive/disabled"
    fi
else
    echo "Not applicable (SELinux not installed)"
fi

# Check container runtime (containerd)
echo -e "\n👉 Checking container runtime (containerd)..."
if command -v containerd &> /dev/null && systemctl is-active --quiet containerd; then
    echo "✅ containerd is installed and running"
else
    echo "❌ containerd is not installed or running"
    echo "Install: sudo apt install -y containerd"
fi

# Check kernel modules
echo -e "\n👉 Checking kernel modules..."
for module in overlay br_netfilter; do
    if lsmod | grep -q "$module"; then
        echo "✅ $module loaded"
    else
        echo "❌ $module not loaded. Run: sudo modprobe $module"
    fi
done

# Check sysctl parameters
echo -e "\n👉 Checking kernel parameters..."
REQUIRED_SETTINGS=("net.bridge.bridge-nf-call-ip6tables=1" "net.bridge.bridge-nf-call-iptables=1" "net.ipv4.ip_forward=1")
for setting in "${REQUIRED_SETTINGS[@]}"; do
    KEY=$(echo "$setting" | cut -d= -f1)
    EXPECTED=$(echo "$setting" | cut -d= -f2)
    ACTUAL=$(sysctl -n "$KEY")
    if [ "$ACTUAL" == "$EXPECTED" ]; then
        echo "✅ $KEY = $ACTUAL"
    else
        echo "❌ $KEY is $ACTUAL, expected $EXPECTED"
        echo "Fix: echo \"$setting\" | sudo tee -a /etc/sysctl.d/k8s.conf && sudo sysctl --system"
    fi
done

# Check kernel version
echo -e "\n👉 Checking kernel version..."
KERNEL_VERSION=$(uname -r)
echo "Kernel Version: $KERNEL_VERSION"

# Check cgroup version
echo -e "\n👉 Checking cgroup version..."
CGROUP=$(stat -fc %T /sys/fs/cgroup)
if [ "$CGROUP" = "cgroup2fs" ]; then
    echo "✅ cgroup v2 is enabled"
else
    echo "⚠️ cgroup v1 is in use. Kubernetes works with both, but v2 is preferred."
fi

echo -e "\n✅ Pre-check complete. Review any ❌ above before proceeding with Kubernetes installation."

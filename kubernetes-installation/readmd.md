/**
 * ## Kubernetes Installation Prerequisites
 *
 * This documentation provides a beginner-friendly explanation of the prerequisites required for setting up Kubernetes.
 * Each prerequisite is explained with relatable analogies to simplify understanding.
 *
 * ### Prerequisites Overview:
 *
 * 1. **Operating System (OS):**
 *    - The foundational software managing hardware and applications.
 *    - Kubernetes relies on Linux-specific features.
 *    - Recommended OS: Ubuntu, CentOS, Debian, Amazon Linux.
 *    - **Analogy:** OS is like your home's structure; Kubernetes fits Linux like specific furniture fits certain house designs.
 *
 * 2. **Swap Space:**
 *    - Reserved disk space used when RAM is full.
 *    - Swap should be disabled for predictable Kubernetes performance.
 *    - **Analogy:** RAM is like a kitchen countertop; swap is like a distant storeroom—slower and inconvenient.
 *
 * 3. **Hostname Configuration:**
 *    - Unique name for identifying a server in a network.
 *    - Kubernetes uses hostnames for internal communication.
 *    - **Analogy:** Hostnames are like house numbers in a locality.
 *
 * 4. **Time Synchronization (NTP):**
 *    - Ensures all servers have synchronized time.
 *    - Critical for logs, coordination, and security certificates.
 *    - **Analogy:** Synchronizing clocks to catch a train or attend a meeting on time.
 *
 * 5. **Firewall Configuration:**
 *    - Monitors and controls network traffic.
 *    - Adjust firewall rules to allow Kubernetes communication.
 *    - **Analogy:** Firewall settings are like a home's security gate, allowing only trusted visitors.
 *
 * 6. **SELinux/AppArmor:**
 *    - Linux security modules restricting unauthorized access.
 *    - Adjust configurations to avoid blocking Kubernetes processes.
 *    - **Analogy:** Security guards in an apartment—too strict guards may block valid residents.
 *
 * 7. **Container Runtime:**
 *    - Software responsible for running containers (e.g., containerd, CRI-O, Docker).
 *    - Kubernetes manages containers but relies on a runtime to execute them.
 *    - **Analogy:** Kubernetes is the restaurant manager; the runtime is the chef preparing meals.
 *
 * 8. **Kernel Modules:**
 *    - Additional software components for Linux kernel functionality.
 *    - Required modules: `overlay`, `br_netfilter`.
 *    - **Analogy:** Kernel modules are like extra kitchen appliances providing additional functionality.
 *
 * 9. **Kernel Parameters (sysctl):**
 *    - Settings to adjust Linux kernel behavior.
 *    - Key parameters: `net.bridge.bridge-nf-call-iptables`, `net.ipv4.ip_forward`.
 *    - **Analogy:** Adjusting TV settings for perfect clarity ensures smooth Kubernetes communication.
 *
 * 10. **Linux Kernel Version:**
 *     - The core of the OS managing resources.
 *     - Kubernetes requires newer kernel versions (4.x or newer).
 *     - **Analogy:** Old kernels are like outdated smartphone software—modern features may not work.
 *
 * 11. **cgroups:**
 *     - Control groups for limiting and monitoring resource usage.
 *     - Kubernetes uses cgroups to isolate and allocate resources for containers.
 *     - **Analogy:** cgroups are like office partitions, ensuring proper resource allocation.
 */

Let's go deeper into each prerequisite in a simple, clear, and beginner-friendly way.

I'll explain using relatable analogies to help you easily understand the concepts.

✅ 1. Operating System (OS)
What is an OS?
The Operating System (OS) is the main software on your computer or server that manages hardware, software, and applications.
Example: Windows, Linux, macOS.

Why does Kubernetes care about OS?
Kubernetes relies heavily on Linux because it uses Linux-specific features for managing containers, processes, and networking.

Recommendation:
Use Linux distributions like Ubuntu, CentOS, Debian, or Amazon Linux.

Analogy:
Think of OS as your home's structure and design. Kubernetes is built specifically for Linux architecture, much like certain furniture fits only certain house designs.

✅ 2. Swap Space
What is Swap?
Swap space is a reserved area on your hard drive (disk) used temporarily by the OS when physical RAM (memory) is full. It extends your RAM virtually, but it’s slower because disk access is slower than RAM.

Why disable Swap in Kubernetes?
Kubernetes expects fast response times and predictable resource allocation. Using swap can make container performance slow and unpredictable.

How to Disable Swap:
bash
Copy
Edit
sudo swapoff -a  # disables swap immediately
sudo sed -i '/swap/d' /etc/fstab  # permanently disables swap
Analogy (Indian context):
RAM is like your kitchen countertop—easy and fast to access ingredients. Swap is like storing your spices far away in a storeroom—slow and inconvenient when cooking quickly.

✅ 3. Hostname Configuration
What is a Hostname?
A hostname is a unique name given to your computer/server within a network, so it can be identified easily.

Why hostname is important?
Kubernetes identifies nodes (servers) using hostnames for internal communication.

Set hostname example:
bash
Copy
Edit
hostnamectl set-hostname master-node
Analogy:
Like your house number in a locality, hostnames let Kubernetes easily find each node (house).

✅ 4. Time Synchronization (NTP)
What is Time Synchronization?
Ensuring all servers have the exact same time, usually using protocols like NTP (Network Time Protocol).

Why time sync is critical?
Kubernetes components and containerized apps rely heavily on accurate timing for logs, coordination, security certificates, and scheduling.

How to setup NTP?
bash
Copy
Edit
sudo apt install -y ntp
sudo systemctl enable ntp --now
Analogy:
Like synchronizing your clock with Indian Standard Time to ensure you catch your train or meeting at the exact right moment.

✅ 5. Firewall Configuration
What is a Firewall?
A firewall monitors incoming and outgoing network traffic and decides whether to allow or block specific connections.

Why adjust Firewall settings?
Kubernetes components communicate on specific network ports. A firewall blocking these ports will prevent Kubernetes from working properly.

Analogy:
Firewall settings are like your home's security gate. You must explicitly allow your friends (Kubernetes components) through the gate (firewall rules).

✅ 6. SELinux/AppArmor
What are SELinux and AppArmor?
They are Linux security modules that restrict access to software and processes to prevent unauthorized activity or hacking.

Why adjust SELinux/AppArmor?
Default security configurations may block Kubernetes processes or containers. Kubernetes requires either permissive or custom-configured modes.

Analogy:
Think of SELinux/AppArmor like security guards in an apartment. If they're too strict, even residents (valid processes) may face unnecessary restrictions.

✅ 7. Container Runtime
What is a Container Runtime?
Software responsible for running containers (packaged applications with their dependencies). Examples include containerd, CRI-O, and Docker.

Why Kubernetes needs it?
Kubernetes manages containers, but it doesn't directly run them. A container runtime actually runs and manages the lifecycle of containers.

Analogy:
Kubernetes is the restaurant manager who decides when and where meals are served, but the container runtime is the chef actually preparing and serving the food.

✅ 8. Kernel Modules
What are Kernel Modules?
Linux kernel modules are additional software components that can be loaded into the kernel (core of OS) to add functionality without rebooting.

Why enable kernel modules?
Kubernetes networking and container management rely on specific kernel modules such as:

overlay: helps in layering container filesystem efficiently.

br_netfilter: handles Kubernetes network traffic filtering.

Analogy:
Kernel modules are like extra appliances (e.g., mixer-grinder) you can attach to your kitchen without rebuilding it completely, providing extra functionality.

✅ 9. Kernel Parameters (sysctl)
What are Kernel Parameters?
Settings to adjust Linux kernel behavior (networking, memory, CPU handling, etc.).

Why are Kernel parameters important?
Kubernetes networking demands specific kernel parameter settings for packet forwarding and filtering.

Key parameters:

net.bridge.bridge-nf-call-iptables: Enables filtering on bridge networks.

net.ipv4.ip_forward: Allows forwarding of network packets.

Analogy:
Like tuning your TV settings to get the perfect clarity—adjusting kernel parameters ensures Kubernetes communicates smoothly and clearly.

✅ 10. Linux Kernel Version
What is the Linux Kernel?
It's the core of the OS, managing hardware and software resources.

Why Kernel version matters?
Kubernetes relies on certain features available only in newer Linux kernels (4.x or newer recommended).

Check kernel version:

bash
Copy
Edit
uname -r
Analogy:
Old kernel versions are like outdated smartphone software—certain modern apps (features of Kubernetes) won't run properly unless updated.

✅ 11. cgroups
What are cgroups?
"Control groups (cgroups)" limit and monitor resource usage (CPU, memory) of processes.

Why cgroups are crucial?
Kubernetes uses cgroups to precisely control and isolate resources assigned to containers.

Analogy:
cgroups are like room partitions or cabins in an office, clearly marking each team's space and ensuring resources (meeting rooms, equipment) are properly allocated.
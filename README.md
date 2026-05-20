# Active-Directory-Implementation-in-Azure

<img src="https://i.imgur.com/pU5A58S.png" alt="Microsoft Active Directory Logo" width="200"/>

---
## Project Summary
**Type:** Technology Implementation / Walkthrough

This project demonstrates the end-to-end deployment and configuration of an on-premises-style Active Directory environment hosted entirely in Microsoft Azure. Two Azure Virtual Machines are provisioned — one acting as a Windows Server 2022 Domain Controller (DC-1) and one as a Windows 11 client machine (Client-1). Active Directory Domain Services (AD DS) is installed, a domain is created, and the client machine is joined to the domain. Organizational Units, user accounts, and admin accounts are configured and demonstrated throughout.

**Languages Used:**
- PowerShell (user account creation, automation scripts)

**Environments Used:**
- Microsoft Azure (Cloud Platform)
- Windows Server 2022 (Domain Controller VM — DC-1)
- Windows 11 Pro (Client VM — Client-1)

**Technology / Applications / Services Used:**
- Azure Virtual Machines
- Azure Virtual Network (VNet)
- Active Directory Domain Services (AD DS)
- DNS (Windows Server)
- Remote Desktop Protocol (RDP)
- PowerShell ISE

---
## High-Level Deployment and Configuration Steps

1. Deploy Domain Controller VM (DC-1) in Azure and set static private IP
2. Deploy Client VM (Client-1) on the same VNet
3. Install Active Directory Domain Services on DC-1
4. Promote DC-1 to a Domain Controller and create a new forest (`mydomain.com`)
5. Create Organizational Units (`_ADMINS`, `_EMPLOYEES`) and admin user account
6. Create bulk domain users with PowerShell
7. Configure Client-1 DNS to point to DC-1's private IP
8. Join Client-1 to the domain
9. Verify Client-1 appears in ADUC
10. Log into Client-1 as a domain user via RDP

---
## Demonstration

PART 1: AZURE INFRASTRUCTURE SETUP
Step 1: Create Azure Resource Group
Objective: Create a dedicated Resource Group to organize all resources for this project.

Log in to the Azure Portal
Click + Create a resource at the top left
Search for Resource group and click it
Click Create
Fill in the details:

Subscription: (Select your subscription)
Resource group name: AD-Lab
Region: East US


Click Review + create
Click Create
<img width="1870" height="884" alt="image" src="https://github.com/user-attachments/assets/67f8b5d6-a6f9-43e9-addd-d2f7f34148a6" />

Step 2: Create Virtual Network
Objective: Set up a Virtual Network where both VMs will communicate.

In the Azure Portal, navigate to Virtual networks
Click + Create
Fill in the following:

Subscription: (Your subscription)
Resource group: AD-Lab
Name: AD-VNet
Region: East US


Click Next: IP Addresses
Verify the default address space is 10.0.0.0/16 and subnet is default (10.0.0.0/24)
Click Review + create → Create
<img width="1866" height="883" alt="image" src="https://github.com/user-attachments/assets/934fb534-fb0a-44d3-80e3-8c79c67638ed" />
<img width="1869" height="886" alt="image" src="https://github.com/user-attachments/assets/f52413fb-2bcb-4c06-b8df-b6b2db4fd628" />

Step 3: Create Domain Controller VM (DC-1)
Objective: Deploy a Windows Server 2022 VM that will become the Domain Controller.

In Azure Portal, click + Create a resource
Search for Windows Server 2022 Datacenter
Click Create
Fill in Basics tab:

Subscription: (Your subscription)
Resource group: AD-Lab
Virtual machine name: DC-1
Region: East US
Image: Windows Server 2022 Datacenter
Size: Standard_D2s_v3 (or similar)
Username: labuser (or your choice)
Password: Create a strong password and save it
Public inbound ports: Select RDP (3389)

<img width="1869" height="905" alt="image" src="https://github.com/user-attachments/assets/de8c603b-1fed-4b62-ac76-cf57be9e6adc" />
Click Next: Networking
Configure Networking:

Virtual network: AD-VNet
Subnet: default (10.0.0.0/24)
Public IP: (Auto-created)
NIC network security group: Advanced → Create new
Inbound rules: Ensure RDP (3389) is allowed


Click Review + create → Create
<img width="1883" height="894" alt="image" src="https://github.com/user-attachments/assets/31547441-2167-4442-9c57-f1f161fc4f2f" />

Wait for deployment to complete. This may take 3-5 minutes. Once complete, you'll see a "Deployment successful" message.
<img width="359" height="152" alt="image" src="https://github.com/user-attachments/assets/05155078-7494-49a8-99ed-682b1599bacf" />

Step 4: Set DC-1's Network Interface to Static IP
Objective: Lock DC-1's private IP address so it doesn't change (required for it to be a reliable DNS server).

Navigate to DC-1 resource (click the Go to resource button or search for it)
On the left menu, click Networking
Click the Network Interface link (usually named something like dc-1***)
<img width="1872" height="893" alt="image" src="https://github.com/user-attachments/assets/1b9d4190-6911-4f67-ba95-7217875e05c4" />








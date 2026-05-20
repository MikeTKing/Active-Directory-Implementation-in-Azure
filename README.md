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

### Part 1: Azure Resource Setup

**Step 1 — Deploy Both VMs in Azure**  
Two Virtual Machines are created in the same Resource Group (`AD-Lab`) and VNet (`AD-VNet`) in East US — `DC-1` (Windows Server 2022) and `Client-1` (Windows 11 Pro). Both show **Status: Running**.

![Both VMs running in Azure Portal](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step01-azure-vms-running.png)

---

**Step 2 — Set DC-1's Private IP to Static**  
Navigate to DC-1's NIC → IP Configurations → Edit → set Allocation to **Static**. DC-1's private IP is locked to `10.0.0.4`.

<img width="1568" alt="DC-1 Static IP Configuration" src="https://github.com/user-attachments/assets/255ac892-78d0-4169-96d4-4f2ac5519c3d">

---

### Part 2: Installing Active Directory

**Step 3 — Promote DC-1 to Domain Controller**  
After installing the AD DS role, the promotion wizard is launched. **Add a new forest** is selected and the root domain name is set to `mydomain.com`.

<img width="1568" alt="AD DS Promotion Wizard" src="https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step03-adds-promotion-wizard.png">

---

**Step 4 — AD DS Installation**  
Install Active Directory Domain Services via Server Manager.

![AD DS Role Installation](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step4-ad-installation.png)

**Step 5 — AD DS Installation Confirmed**  
Server Manager shows AD DS and DNS roles installed and healthy.

![Server Manager - AD DS and DNS Installed](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step04-server-manager-adds-installed.png)

---

### Part 3: Creating Organizational Units and Users

**Step 6 — Create OUs in ADUC**  
Two Organizational Units are created: `_EMPLOYEES` and `_ADMINS`.

![ADUC OUs Created](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step05-aduc-ous-created.png)

---

**Step 7 — Create a Domain Admin Account**  
User `mike_admin` (Michael King) created in the `_ADMINS` OU and added to Domain Admins group.

![mike_admin Account Creation](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step06-mike-admin-created.png)

---

**Step 8 — Create Bulk Users with PowerShell**  
PowerShell script used to create multiple user accounts in the `_EMPLOYEES` OU.

![PowerShell Bulk User Creation](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step07-powershell-user-creation.png)

---

**Step 9 — Verify Users in ADUC**

![Employees OU Populated](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step08-aduc-employees-populated.png)

---

### Part 4: Joining Client-1 to the Domain

**Step 10 — Set Client-1 DNS to DC-1's Private IP**

![Client-1 DNS Configuration](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step09-client1-dns-set.png)

---

**Step 11 — Join Client-1 to the Domain**

![Domain Join Confirmation](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step10-domain-join.png)

---

**Step 12 — Verify Client-1 in ADUC**

![Client-1 in AD Computers Container](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step11-aduc-client1-verified.png)

---

### Part 5: Logging in as a Domain User

**Step 13 — RDP into Client-1 as a Domain User**

![RDP Login as Domain User](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step12-rdp-domain-user-login.png)

---

**Step 14 — Domain User Successfully Logged In**

![Domain User Logged In - System Info](https://github.com/MikeTKing/Active-Directory-Implementation-in-Azure/blob/main/step13-domain-user-logged-in.png)


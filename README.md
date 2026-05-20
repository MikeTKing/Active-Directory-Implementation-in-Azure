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

On the left menu, click IP configurations
Click on the IP configuration (usually named ipconfig1)

<img width="1877" height="891" alt="image" src="https://github.com/user-attachments/assets/2000b79a-2ad8-4fcd-b164-b9f28297ba18" />

Change Allocation from Dynamic to Static
Keep the IP address as is (Azure should auto-assign something like 10.0.0.5)
Click Save
<img width="383" height="896" alt="image" src="https://github.com/user-attachments/assets/9f6c5760-9af5-48e5-bdb9-ab6054408004" />

Important: Note down DC-1's private IP address (e.g., 10.0.0.5). You'll need this when configuring Client-1's DNS.

Step 5: Create Client VM (Client-1)
Objective: Deploy a Windows 11 Pro VM that will be a domain client.

In Azure Portal, click + Create a resource
Search for Windows 11 Pro
Click Create
Fill in Basics tab:

Subscription: (Your subscription)
Resource group: AD-Lab
Virtual machine name: Client-1
Region: East US
Image: Windows 11 Pro
Size: Standard_D2s_v3
Username: localuser (or your choice)
Password: Create a strong password and save it
Public inbound ports: Select RDP (3389)

<img width="1871" height="925" alt="image" src="https://github.com/user-attachments/assets/636a9785-45c4-4caa-a599-c3b1cab6cd16" />

Click Next: Networking
Configure Networking:

Virtual network: AD-VNet (same as DC-1)
Subnet: default (10.0.0.0/24) (same as DC-1)
Public IP: (Auto-created)
NIC network security group: (Use the existing one or create new)


Click Review + create → Create
<img width="1875" height="920" alt="image" src="https://github.com/user-attachments/assets/18a5c2a4-834b-44ef-a1b8-38274424ec97" />

Wait for deployment to complete.

<img width="1870" height="886" alt="image" src="https://github.com/user-attachments/assets/62c251b6-14df-41a7-a68f-b3d583664809" />

PART 2: REMOTE DESKTOP CONNECTION & INITIAL DC-1 SETUP
Step 6: Connect to DC-1 via Remote Desktop
Objective: Establish an RDP connection to DC-1 so you can configure Active Directory.

Navigate to DC-1 in the Azure Portal
Copy the public ip address from your vm to paste into the rdp.
<img width="1581" height="899" alt="image" src="https://github.com/user-attachments/assets/1ee28e2d-288e-4aa2-9ba6-749fcef7e832" />

Input your username and password with the credentials you used to create the DC-1 VM

<img width="401" height="485" alt="image" src="https://github.com/user-attachments/assets/86fac659-af50-4c6b-b78e-456c5bfc58c3" />


<img width="456" height="471" alt="image" src="https://github.com/user-attachments/assets/b4391e91-850c-4ff4-98d0-c64ea70a19f6" />


<img width="398" height="439" alt="image" src="https://github.com/user-attachments/assets/1d8338f9-62b6-47e6-83d7-eb10a6a6f4a5" />

You are now logged into DC-1 as the local admin (labuser).

If its your first time logging in and you are met with this screen just hit accept and we can continue with the next step.

<img width="1911" height="1075" alt="image" src="https://github.com/user-attachments/assets/cd35fa6f-2973-45e3-9e13-bfea465a016e" />

Step 7: Install Active Directory Domain Services Role
Objective: Add the AD DS role to DC-1 (this is required before promoting it to a Domain Controller).

On DC-1, open Server Manager (should be open by default; if not, click the Windows icon and search for it)
Click Add Roles and Features on the right side


<img width="1925" height="1052" alt="image" src="https://github.com/user-attachments/assets/11d633d1-834a-4a46-a8c1-697e946d9b89" />

In the wizard that opens, click Next on the "Before You Begin" page
On "Installation Type," select Role-based or feature-based installation and click Next

<img width="783" height="554" alt="image" src="https://github.com/user-attachments/assets/0e236f2c-b0ba-4cf7-95ac-9ae2b4d83f7a" />

On "Server Selection," verify DC-1 is selected and click Next
On "Server Roles," scroll down and check the box for Active Directory Domain Services

<img width="782" height="557" alt="image" src="https://github.com/user-attachments/assets/43c92b4e-7d13-4c60-8e27-b3cafd1da79a" />

A popup will appear asking about additional features. Click Add Features

<img width="408" height="436" alt="image" src="https://github.com/user-attachments/assets/f7510a12-479f-4298-9224-4dda42aba252" />

Click Next through the remaining screens

On the "Confirmation" page, review that AD DS is selected

Click Install

Wait for the installation to complete. You'll see a "Installation succeeded" message.

<img width="780" height="562" alt="image" src="https://github.com/user-attachments/assets/774b206c-5411-4a4c-aa10-ef9b97894795" />

You can close the wizard, but do NOT restart yet — you'll restart after promotion.

Step 8: Promote DC-1 to Domain Controller
Objective: Promote DC-1 to a Domain Controller and create a new Active Directory forest.

In Server Manager, notice a flag icon at the top with an exclamation mark. Click it.
Click Promote this server to a domain controller

<img width="1909" height="407" alt="image" src="https://github.com/user-attachments/assets/02ee19f4-6910-4512-9150-0bc9660ffb86" />

In the Active Directory Domain Services Configuration Wizard:

On "Deployment Configuration," select Add a new forest
In Root domain name, enter: mydomain.com
Click Next
<img width="763" height="559" alt="image" src="https://github.com/user-attachments/assets/dc25e2e8-9cd1-4c93-b119-264df07a90d0" />

On "Domain Controller Options":

Forest Functional Level: Windows Server 2025 (or default)
Domain Functional Level: Windows Server 2025 (or default)
Password: Enter a Directory Services Restore Mode (DSRM) password and confirm it
Check the box for DNS server (it should auto-check)
Click Next
<img width="760" height="553" alt="image" src="https://github.com/user-attachments/assets/816114b2-d167-41a3-8921-743580426329" />

On "DNS Options," click Next (defaults are fine)
On "Additional Options," click Next (NetBIOS name will auto-populate as MYDOMAIN)
On "Paths," click Next (default paths are fine)
On "Review Options," verify all settings and click Next
On "Prerequisites Check," if all checks pass, click Install
<img width="770" height="565" alt="image" src="https://github.com/user-attachments/assets/ecdc9c47-7817-4595-aa4f-4754f8b0d5db" />

Important: The server will restart automatically to complete the promotion. This may take several minutes.
Wait for the restart and reconnect. When you reconnect via RDP:

Your name will now be DC-1.mydomain.com (the domain is part of your identity) and the Active Directory should show being healthy(all green).

<img width="397" height="480" alt="image" src="https://github.com/user-attachments/assets/8c846796-daf0-4de2-b770-a76f0b4040e2" />

<img width="1917" height="1005" alt="image" src="https://github.com/user-attachments/assets/14247cf8-07c4-4967-b7dd-9e0c7f3af3fc" />

PART 3: ACTIVE DIRECTORY ADMINISTRATION
Step 9: Open Active Directory Users and Computers (ADUC)
Objective: Access the Active Directory administration tool to create Organizational Units and user accounts.

On DC-1, open Active Directory Users and Computers

Click Start → search for Active Directory Users and Computers
Or, in Server Manager, click Tools (top right) → Active Directory Users and Computers
<img width="795" height="776" alt="image" src="https://github.com/user-attachments/assets/06a9c5b0-3cdb-4e2c-baf7-6b61292ee52a" />

ADUC opens. Expand mydomain.com in the left pane to see the domain structure.
<img width="749" height="532" alt="image" src="https://github.com/user-attachments/assets/2a35b7c7-87f2-48dc-91a5-1783277ee356" />

Step 10: Create Organizational Units
Objective: Create two OUs to organize admin and employee accounts.

In ADUC, right-click on mydomain.com in the left pane
Select New → Organizational Unit
<img width="625" height="398" alt="image" src="https://github.com/user-attachments/assets/5d249e27-77c2-4abe-a64d-23027c22c8d3" />

In the dialog, enter the name: _EMPLOYEES
Click OK

<img width="433" height="376" alt="image" src="https://github.com/user-attachments/assets/6d906214-8a4f-4c8d-a648-6d1e5aa9deb8" />

Repeat the process to create a second OU named _ADMINS
<img width="747" height="518" alt="image" src="https://github.com/user-attachments/assets/9cd8b17d-1c5a-4e4c-a67f-e2cf7260c441" />

Step 11: Create a Domain Admin User Account
Objective: Create an admin account that will be used to manage the domain.

In ADUC, navigate to the _ADMINS OU (click on it in the left pane)
Right-click _ADMINS 
Select New → User
<img width="549" height="355" alt="image" src="https://github.com/user-attachments/assets/eaee3e66-33cc-482b-8c9b-5f666a6e7cd6" />

Fill in the New Object - User dialog:

First name: 
Last name: 
User logon name: use mike_admin as an example
Click Next

<img width="430" height="366" alt="image" src="https://github.com/user-attachments/assets/d3313328-dd73-4414-9b19-6d29b1fcf1a8" />

Set the password:

Password: Create a strong password (e.g., Password123!)
Confirm password: Re-enter it
Uncheck "User must change password at next logon" (optional, but helpful for a lab)
Click Next

<img width="434" height="375" alt="image" src="https://github.com/user-attachments/assets/093e0e42-9dba-41ea-b3b2-3d7892feedc0" />

Click Finish

<img width="749" height="522" alt="image" src="https://github.com/user-attachments/assets/207a78f8-1d07-4f7d-ad46-aa7457ade8e7" />

Step 12: Add mike_admin to Domain Admins Group
Objective: Grant Domain Administrator privileges to the mike_admin account.

In ADUC, double-click on mike_admin to open his properties
Click the Member Of tab
<img width="402" height="535" alt="image" src="https://github.com/user-attachments/assets/3c88c5b2-7926-4729-b9e9-10eda1091a7e" />

Click Add
In the Select Groups dialog, type Domain Admins in the text field
Click Check Names to validate
Click OK

<img width="459" height="286" alt="image" src="https://github.com/user-attachments/assets/e9d9bd01-0ce2-4da8-83f8-b4a49d6f93e8" />
<img width="406" height="535" alt="image" src="https://github.com/user-attachments/assets/24fd5582-a5dd-4158-b234-3715090a47e2" />

Click Apply → OK to close the properties window

Step 13: Create Bulk User Accounts with PowerShell
Objective: Automate the creation of multiple user accounts in the _EMPLOYEES OU.

On DC-1, open PowerShell ISE as Administrator

Click Start → search for PowerShell ISE
Right-click it → Run as administrator
<img width="762" height="715" alt="image" src="https://github.com/user-attachments/assets/06354a40-d8c2-4807-8341-ff7d0632947d" />

In the script pane (top half), paste the following PowerShell script:
<img width="1710" height="905" alt="image" src="https://github.com/user-attachments/assets/121ddcaa-5bac-454b-af33-3cbc5c107f36" />

Click the Run Script button (green play button) or press F5
<img width="1245" height="725" alt="image" src="https://github.com/user-attachments/assets/7ea24941-a503-478d-a437-630270969c20" />

Close PowerShell ISE

Step 14: Verify Users in ADUC
Objective: Confirm that all bulk users were created in the _EMPLOYEES OU.

Go back to ADUC
Click on the _EMPLOYEES OU in the left pane
In the right pane, you should see all the newly created user accounts
<img width="748" height="526" alt="image" src="https://github.com/user-attachments/assets/2afb89f9-18d5-4d71-b733-d0f93992e9f5" />

PART 4: CLIENT VM CONFIGURATION & DOMAIN JOIN
Step 15: Connect to Client-1 via Remote Desktop
Objective: Establish an RDP connection to Client-1 to configure it for domain joining.

Copy the public ip address from Client-1 

<img width="1489" height="882" alt="image" src="https://github.com/user-attachments/assets/a2680d27-cd49-408b-9fa7-698b9927b6b8" />

Open another rdp and input your credentials 

Username: labuser (or whatever you set during Client-1 creation)

Password: (The password you created for Client-1)

<img width="403" height="479" alt="image" src="https://github.com/user-attachments/assets/eae3540e-cb07-499b-8028-89fe84420c3f" />

Step 16: Configure Client-1's DNS to Point to DC-1
Objective: Set Client-1's DNS server to DC-1's private IP address so it can resolve the domain.
Via Azure Portal (Easiest)

In Azure Portal, go to Client-1 resource
Click Networking on the left menu
Click the Network Interface link
<img width="1878" height="897" alt="image" src="https://github.com/user-attachments/assets/a50c1ac9-cd1c-4e6e-8be7-bbc2b6d8a046" />

Click DNS servers on the left menu
Select Custom
Enter DC-1's private IP address (e.g., 10.0.0.5 from Step 4)
Click Save
<img width="1871" height="895" alt="image" src="https://github.com/user-attachments/assets/412fa7a0-84ca-4608-ab3d-ca2430b57f6c" />

Wait 1-2 minutes for the change to take effect.

Step 17: Test DNS Resolution (Verification)
Objective: Confirm that Client-1 can now resolve the domain.

On Client-1, open Command Prompt or PowerShell (click Start → search for cmd or powershell)
Type the following command:
ipconfig /all
Press Enter
<img width="1122" height="625" alt="image" src="https://github.com/user-attachments/assets/ffa46abf-91f1-44f9-b522-e688c8f75367" />

Expected output: The server should show DC-1's IP address and the domain should resolve successfully (as shown above, the name resolves to an IP address with 0% packet loss on ping).

Step 18: Join Client-1 to the Domain
Objective: Add Client-1 to the mydomain.com domain.

On Client-1, open System settings

Click Start → Settings → System → About
<img width="1199" height="931" alt="image" src="https://github.com/user-attachments/assets/8430745c-2402-4c79-afcd-b7cef73c5e6f" />

Click on advanced system settings 
In the System Properties window, click the Change... button
<img width="412" height="464" alt="image" src="https://github.com/user-attachments/assets/888177c3-fd88-4c1b-8bcb-77d8ecf212e5" />

In the Computer Name/Domain Changes dialog:

Computer name: Keep as Client-1 (or change if desired)

Member of: Select Domain

Domain field: Type mydomain.com

Click OK
<img width="321" height="384" alt="image" src="https://github.com/user-attachments/assets/9594b719-e852-4a64-bddf-fa013b65957a" />

When prompted for credentials, enter:

Username: mydomain.com\mike_admin (the domain admin account you created)

Password: (The password for mike_admin)

Click OK

<img width="455" height="382" alt="image" src="https://github.com/user-attachments/assets/68aa5b11-8764-471a-833e-e26ad2dc296d" />

<img width="297" height="152" alt="image" src="https://github.com/user-attachments/assets/3882666a-f488-487d-9b3e-d714794e5f79" />

Click OK on the success dialog

Click Close on System Properties

Restart Client-1 when prompted

Step 19: Verify Client-1 Appears in ADUC
Objective: Confirm that Client-1 is now visible in Active Directory.

Go back to DC-1 (via RDP or reconnect if disconnected)
Open Active Directory Users and Computers (ADUC)
Navigate to Computers container under mydomain.com
Look for Client-1 in the list

<img width="753" height="528" alt="image" src="https://github.com/user-attachments/assets/432f5932-e0ff-408d-ad84-28d645778ee5" />

Step 20: Log Into Client-1 as a Domain User
Objective: Demonstrate successful login using a domain user account.

On Client-1, restart it (if not already restarted from Step 18)
Enter domain user credentials:

Username: mydomain.com\john.doe (one of the bulk-created users)
Password: Password123!
Press Enter

<img width="402" height="480" alt="image" src="https://github.com/user-attachments/assets/d6cd9146-7f79-4407-aee3-6e0e4c2cc401" />

Wait for the profile to load (first-time login may take longer as the system creates the profile)

(Optional) Open Command Prompt and type whoami to confirm the domain context
<img width="1913" height="1031" alt="image" src="https://github.com/user-attachments/assets/3389a0f5-162f-4ca5-810b-b1d5fc8c3b93" />









































































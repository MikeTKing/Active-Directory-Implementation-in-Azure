# Define the OU path
$OUPath = "OU=_EMPLOYEES,DC=mydomain,DC=com"

# Create an array of user names
$users = @(
    "john.doe",
    "jane.smith",
    "bob.johnson",
    "alice.williams",
    "charlie.brown",
    "diana.prince",
    "evan.harris",
    "fiona.clark",
    "george.martin",
    "hannah.lee"
)

# Default password for new users
$password = ConvertTo-SecureString "Password123!" -AsPlainText -Force

# Create each user
foreach ($user in $users) {
    New-ADUser -Name $user `
               -SamAccountName $user `
               -UserPrincipalName "$user@mydomain.com" `
               -Path $OUPath `
               -AccountPassword $password `
               -Enabled $true `
               -PasswordNotRequired $false `
               -ChangePasswordAtLogon $false
    
    Write-Host "Created user: $user"
}

Write-Host "All users created successfully!"

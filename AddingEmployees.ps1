$PASSWORD_FOR_USERS = "Password1"

$User_First_Last_List = @(
    "Aiden Bell",
    "Brianna Clark",
    "Carlos Diaz"
    # ... add more as needed
)

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

foreach ($n in $User_First_Last_List) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)"

    New-ADUser -AccountPassword $password `
        -GivenName $first `
        -Surname $last `
        -DisplayName $username `
        -Name $username `
        -EmployeeID $username `
        -PasswordNeverExpires $true `
        -Path "ou=_EMPLOYEES,$((Get-ADDomain).distinguishedName)" `
        -Enabled $true
}
param(
    [string]$source="c:\temp\GroupProject2Usernames.csv",
    [string]$destination="c:\temp\destination.csv",
    [switch]$output,
    [switch]$help
)

if ($help)
{
    write-host "This script adds users from a .csv to the Active Directory. Please provide a source destination and an output destination along with the 'output' switch parameter if you would like a file describing the added users, or just the source destination if you don't."
}
else
{
    # Import active directory module for running AD cmdlets
    Import-Module activedirectory

    #Store the data from GroupProject2Usernames.csv in the $ADUsers variable
    $ADUsers = Import-csv $source #C:temp\GroupProject2Usernames.csv

    # create an array to store added users
    $AddedUsers = @()

    #Loop through each row containing user details in the CSV file 
    foreach ($User in $ADUsers)
    {
	    #Store username variable from csv's user data
	    $Username = $User.UserName

	    #Check to see if the user already exists in AD
	    if (Get-ADUser -F {SamAccountName -eq $Username})
	    {
		    #If user does exist, give a warning
		    Write-Warning "A user account with username $Username already exist in Active Directory."
	    }
	    else
	    {
		    #User does not exist so proceed to create the new user account

		    #Store first-, and last- name variables from csv's user data
		    $Firstname 	= $User.FirstName
		    $Lastname 	= $User.LastName

		    #Account will be created in the OU provided by the $OU variable read from the CSV file
		    New-ADUser `
			-SamAccountName $Username `
			-Name "$Firstname $Lastname" `
			-GivenName $Firstname `
			-Surname $Lastname `
			-Enabled $True `
			-DisplayName "$Lastname, $Firstname" `
			-AccountPassword (convertto-securestring "pass1234" -AsPlainText -Force) -ChangePasswordAtLogon $True #Require users to users to change password at first logon

		    $AddedUsers += Get-ADUser $Username | Select SAMAccountName, SID
            }
    }

    #if output flag is true, export $AddedUsers to .csv
    if ($output) {
        $AddedUsers | Export-Csv -Path $destination -NoTypeInformation
    }
}

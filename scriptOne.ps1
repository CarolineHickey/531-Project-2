#Get-Member -- shows info on theobject
# Import active directory module for running AD cmdlets
Import-Module activedirectory

#This is the path up until the passed in csv file:
$CSVPartialPath = 'C:Users\Administrator\Downloads\'

#param($name= <value>) -- then access it through $name
#This is the variable assigned to the input of argument 0
$CSVFile = $args[0] #GroupProject2Usernames.csv

#This variabe is the rsult of concatonating the two above
$CSVPath = $CSVPartialPath + $CSVFile

#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv $CSVPath #C:Users\Administrator\Downloads\GroupProject2Usernames.csv

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
		
	$Username 	= $User.UserName
	$Firstname 	= $User.FirstName
	$Lastname 	= $User.LastName
	#$Password 	= $User.password
    #$Password = $User.Password


	#Check to see if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Username already exist in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser `
            -SamAccountName $Username `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `

            #Require users to users to change password at first logon
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True
            
	}
}


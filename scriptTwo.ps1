param(
    [string]$ip=".",
    [switch]$help
)

if ($help)
{
    write-host "This script gathers information on a computer from a given IP Address and outputs it to a .txt file. Please provide an IP Address."
}
else
{
    #create an array to store gathered information
    $Info = @()

    # Bios Information
    $Info += "==================================="
    $Info += "=         BIOS Information        ="
    $Info += "==================================="
    $Info += Get-WmiObject Win32_bios -ComputerName $ip

    # Programs installed on the computer
    $Info += "==================================="
    $Info += "=  Programs Installed On Computer ="
    $Info += "==================================="
    $Info += Get-WmiObject Win32_product -ComputerName $ip

    # current programs running
    $Info += "==================================="
    $Info += "=   Programs Running On Computer  ="
    $Info += "==================================="
    $Info += -Query "select * from win32_service where State='Running'" -ComputerName $ip |
        Format-List -Property PSComputerName, Name, ExitCode, Name, ProcessID, StartMode, State, Status

    # accounts that exist on the computer
    $Info += "==================================="
    $Info += "=       Accounts On Computer      ="
    $Info += "==================================="
    $Info += Get-WmiObject Win32_UserAccount -ComputerName $ip

    #output information to .csv
    $Info | Out-File -FilePath .\outputComputerInformation.txt
}

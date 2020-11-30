#==========================================================================
# POWERSHELL FUNCTION LIBRARY
# List of all functions in this script:
# -------------------------------------
# -Upload Function
#   - Add-NAVAppStorage  -> To Upload files 
# -Download Function
#   - Download-NAVAppStorage  -> To Download files

# Function Add-NAVAppStorage: To Upload files from Local machine to Azure Storage
function Add-NAVAppStorage {
    param(
        [Parameter(Mandatory=$true)][String]$Environment,
        [Parameter(Mandatory=$true)][String]$Name,
        [Parameter(Mandatory=$true)][String]$Version,
        [Parameter(Mandatory=$true)][array]$Filepath
    )
    process {
        [string]$Destination= "\\amsnavappconf.file.core.windows.net\navappfile\tmp\bar\$Environment\$Name\$Version"
        if (!(Test-Path -path $destination)) 
        {New-Item $destination -Type Directory}
        Copy-item -Path $Filepath –Destination $Destination -Recurse -Force
    }
	end {
        DS_WriteLog "I" "END FUNCTION - $FunctionName" $LogFile
    }
    }

# Download-NAVAppStorage: To Download files from Azure Storage to Local Machine
function Download-NAVAppStorage {
    param(
        [Parameter(Mandatory=$true)][String]$Environment,
        [Parameter(Mandatory=$true)][String]$Name,
        [Parameter(Mandatory=$false)][String]$Version,   
        [Parameter(Mandatory=$true)][string]$Filepath
    )  
process {
If([string]::IsNullOrEmpty($Version))
{
$Version = (Get-ChildItem "\\amsnavappconf.file.core.windows.net\navappfile\tmp\bar\$Environment\$Name\" | Select Name | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) }| select -Last 1 | ft -hidetableheaders | Out-String).trim()
Copy-item -Path \\amsnavappconf.file.core.windows.net\navappfile\tmp\bar\$Environment\$Name\$Version –Destination $Filepath -Recurse
    }
else
{
Copy-item -Path \\amsnavappconf.file.core.windows.net\navappfile\tmp\bar\$Environment\$Name\$Version –Destination $Filepath -Recurse
}
}
}
#==========================================================================
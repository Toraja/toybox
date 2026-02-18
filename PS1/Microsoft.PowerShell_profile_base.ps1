# <Console setup>
# Set console encoding to UTF8
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

# <Env>
$env:System32 = "$env:SystemRoot\System32"
$env:LC_ALL="C.UTF-8"	# This is to avoid garbled characters in the output of git log
if($env:Path -notmatch "$("$env:USERPROFILE\bin" -replace "\\","\\")"){
    $env:Path += ";$env:USERPROFILE\bin"
}
# PS1/bin
if($env:Path -notmatch "$("$PSScriptRoot\bin" -replace "\\","\\")"){
    $env:Path += ";$PSScriptRoot\bin"
}
# External commands
if($env:Path -notmatch "$("$env:USERPROFILE\Documents\WindowsPowerShell\bin" -replace "\\","\\")"){
    $env:Path += ";$env:USERPROFILE\Documents\WindowsPowerShell\bin"
}

# <Keybind>
Set-Variable -Name PROFILE_KEYBIND -Value "$PSScriptRoot\Microsoft.PowerShell_profile_keybind.ps1"
if (Test-Path -PathType Leaf -Path $PROFILE_KEYBIND) {
	. $PROFILE_KEYBIND
}

# <Machine Independent Variables>
Set-Variable -Name StartMenuProg "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
Set-Variable -Name TaskbarPinned "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

# <Alias>
# Commands
Set-Alias -Name posh -Value powershell.exe
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name pd -Value Push-Location
Set-Alias -Name pod -Value Pop-Location
Set-Alias -Name dirname -Value Split-Path
Set-Alias -Name gf -Value Get-Function
Set-Alias -Name title -value Set-Title
Set-Alias -Name tt -value Set-Title

# <Function>
Remove-Item -ErrorAction Ignore alias:cd
function cd {
	param(
		[string] $Path = $HOME
	)
	if ($Path -eq "-"){
		if ($OLDPWD -eq $null){
			Write-Host -ForegroundColor Red -Object '$OLDPWD is not set'
			return
		}
		$Path = $OLDPWD
	}

	if ((Get-Item $Path).fullname -ne $PWD){
		Set-Variable -Name OLDPWD -Value $PWD -Scope Global
	}

	Set-Location -Path $Path
}

Remove-Item -ErrorAction Ignore alias:pwd
function pwd {
	$(Get-Location).path
}

function env {
	Get-ChildItem env:
}

function grep {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Pattern,
		[Parameter(Position=1, ParameterSetName="Path")] [string] $Path,
		[Parameter(ValueFromPipeline, ParameterSetName="Input")] [System.Object[]] $InputObject
	)

	Process{
		if($PSBoundParameters.ContainsKey("Path")){
			Select-String -Pattern $Pattern -Path $Path
		}
		else{
			Out-String -InputObject $InputObject -Stream | Select-String -Pattern $Pattern
		}
	}
}

function find {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Filter,
		[Parameter(Position=1)] [string] $Path = ".",
		[ValidateSet('File', 'Directory')] [string] $Type,
		[Parameter()] [switch] $Regex,
		[Parameter()] [int] $Depth
	)

	Remove-Variable -Name fisult -ErrorAction SilentlyContinue -Scope Global

	$findcmd = "Get-ChildItem -Recurse -Force -Path $Path {0}"
	$findparam = [System.Collections.ArrayList]::new()
	$setvarcmd = ' | %{$PSItem.Fullname} | Set-Variable -Name fisult -Scope Global'

	if($PSBoundParameters.ContainsKey('Type')){
		$findparam.Add('-' + $Type) > $null
	}
	if($PSBoundParameters.ContainsKey('Depth')){
		$findparam.Add("-Depth $Depth") > $null
	}
	if($Regex){ # This if clause must be the last to add param as it can be pipe
		$findparam.Add("| ?{`$PSItem.Name -cmatch `"$Filter`"}") > $null
	}
	else{
		$findparam.Add("-Filter $Filter") > $null
	}
	$findcmd = $findcmd -f ($findparam -join " ")

	Invoke-Expression -Command ${findcmd}${setvarcmd}
	$fisult
}

function which {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Cmd
	)
	Get-Command $Cmd | Select-Object -ExpandProperty Definition
}

function basename {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path,
		[switch] $TrimExtention
	)

		if($TrimExtention){
			$Property = 'BaseName'
		}
		else{
			$Property = 'Name'
		}
	Get-Item -Path $Path | %{$_.${Property}}
}

function fullname {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path
	)

	Get-Item -Path $Path | %{$_.fullname}
}

# Get the path that symlink points to
function realpath {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path
	)
	Get-ChildItem $Path | Select-Object -ExpandProperty Target
}

function touch {
	param(
		[Parameter(Mandatory, Position=0, ValueFromRemainingArguments)] [string[]] $Path,
		[switch] $Force = $false
	)

	New-Item -ItemType File -Path $Path -Force:$Force
}

function Prompt {
	# Set title
	# Add "[Admin]" to title if the user has admin previledge
	if([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")){
		$admin = "[Admin] "
		$ps = "# "
	}
	else {
		$admin = ""
		$ps = "$ "
	}
	$Host.ui.rawui.WindowTitle = $_TitleString + $admin + $PWD

	# Compose prompt string
	$PromptString = 'PS' + $(if($env:VIMRUNTIME){"(from vim)"}else{""}) + ' ' + $(get-location)
	Write-Host -Object $PromptString -ForegroundColor DarkGreen
	return $ps
}

# The title is set in Prompt
function Set-Title {
	param(
		[Parameter(Mandatory, ValueFromRemainingArguments)] [string] $Title
	)

	Set-Variable -Name _TitleString -Value "$Title - " -Scope Global
}


function poshadmin {
	Start-Process powershell -Verb runas -WindowStyle Maximized
}

function fe {
	param(
		[string] $Path = "."
	)

	if(! (Test-Path -Path $Path)){
		Write-Host -ForegroundColor Red -Object "$Path not found"
		return
	}

	explorer.exe $Path
}

function Get-Size{
	param(
		[string] $Path,
		[ValidateSet('KB', 'MB', 'GB')] [string] $HumanReadable
	)

	$size = (Get-ChildItem -Path $Path -Recurse | Measure-Object -Property Length -Sum).Sum
	if($HumanReadable){
		$size = "{0:n2} {1}" -f ($size / ('1' + $HumanReadable)),$HumanReadable
	}
	$size
}

function todirs{
	param(
		[int] $Index,
		[switch] $List
	)

	$dirarray = (Get-Location -Stack).Path

	if(! $dirarray){
		Write-Host -ForegroundColor DarkCyan -Object "No dirs on the stack"
		return
	}

	if($List -or $PSBoundParameters.Count -eq 0){
		$cnt = 0
		Write-Output -InputObject ""    # just a spacer
		$dirarray | %{ Write-Output -InputObject "${cnt}: $_"; $cnt++}
		Write-Output -InputObject ""    # just a spacer
		return
	}

	if($Index -ge $dirarray.Length){
		Write-Host -ForegroundColor Yellow -Object "The index is out of the bounds"
		return
	}

	Set-Location -Path $dirarray[$Index]
}

function lockfile {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path,
		[switch] $Wait
	)

		$absPath = $(Get-Item -Path $Path -ErrorAction Stop).Fullname

		# Open the file in read only mode, without sharing (I.e., locked as requested)
		# Path's root will be $env:System32 so better use absolute path
		$file = [System.io.File]::Open($absPath, 'Open', 'Read', 'None')
		if (!$file) { return } # error while opening file

		if (!$Wait) {
			# Seems like if this closer is not stored in a variable, file lock will be released.
			Set-Variable -Name unlocker -Value $file.Close -Scope Global
			Write-Host 'Run $unlocker.Invoke() to unlock the flie.' -ForegroundColor Cyan
			return
		}

		#Wait in the above (file locked) state until the user presses a key
		Write-Host "File `"$Path`" has been locked."
		Write-Host "Press any key to unlock file ..."
		[void][System.Console]::ReadKey($true)
		# $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") // this includes modifier keys such as Ctrl

		#Close the file (This releases the current handle and unlocks the file)
		$file.Close()
}

function islocked {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path
	)

		$absPath = $(Get-Item -Path $Path -ErrorAction Stop).Fullname
		try {
			$file = [IO.File]::OpenWrite($absPath)
			if ($file) { $file.Close() }
		} catch {
			return $true
		}
		return $false
}

# Clip files to clipboard
function clip {
	# An error relating to ParameterSetName occurs if 'Mandatory' is not present
	# because powershell has no idea which parameter is bound
	param(
		[Parameter(Position=0, ParameterSetName="Path")] [string[]] $Path,
		[Parameter(Mandatory, ParameterSetName="View")] [switch] $View
	)

	if($PSBoundParameters.Count -eq 0){ $View = $true }
	if($View){
		Get-Clipboard -Format FileDropList
		return
	}

	Set-Clipboard -Path $Path
}

# Paste files from Clipboard
function paste {
	param(
		[Parameter(Position=0)] [string] $Destination = ".",
		[Parameter(Position=1)] [switch] $DeleteSource
	)

	# Exit if destination does not exist
	if(! (Test-Path -Path $Destination -PathType Container)){
		Write-Host -ForegroundColor Red -Object "Directory '$Destination' not found"
		return
	}

	$sourceFiles=(Get-Clipboard -Format FileDropList)

	$fileToCopy = @()
	foreach($sourceFile in $sourceFiles){
		# Check and prompt for overwrite
		$destPath = $Destination + "\" + $sourceFile.Name
		if(Test-Path $destPath){
			Write-Host -ForegroundColor Yellow -Object "$destPath exists. Overwrite? [Y/n]"
			$userInput = Read-Host
			if($userInput -eq 'Y'){
				$fileToCopy += $sourceFile
			}
		} else {
			$fileToCopy += $sourceFile
		}
	}

	if($fileToCopy.Count -eq 0){ return }  # No file to paste

	# Without this, when $fileToCopy is expanded, elements are joined with whitespace
	# so the command thinks it is multiple arguments and complains
	$fileToCopy = $fileToCopy -join ','

	if($DeleteSource){
		$mvcp = "mv -Force"
	} else {
		$mvcp = "cp -Recurse"
	}

	Invoke-Expression -Command "$mvcp -Path $fileToCopy -Destination $Destination"
}

function Get-Function {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Name
	)

	Get-Content function:${Name}
}

#<Start up>

if((Get-Location).Path -eq "$env:System32"){
	cd $HOME
}

# Modules
## PsFzf
if (Get-Module -ListAvailable -Name PsFzf) {
	Remove-PSReadlineKeyHandler -Chord 'Ctrl+r'
	Remove-PSReadlineKeyHandler -Chord 'Ctrl+s'
	Import-Module -Name PsFzf -ArgumentList 'Ctrl+o','Ctrl+r','Alt+o'
}

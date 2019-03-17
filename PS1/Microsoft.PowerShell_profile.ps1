# <Env>
$env:System32 = "$env:SystemRoot\System32"
$env:LC_ALL="C.UTF-8"	# This is to avoid garbled characters in the output of git log

# <PS Profiles>
Set-Variable -Name PROFILE_DIR -Value "$(Split-Path $PROFILE)"
Set-Variable -Name PROFILE_LOCAL -Value "$PROFILE_DIR\Microsoft.PowerShell_profile_local.ps1"
if (Test-Path -PathType Leaf -Path $PROFILE_LOCAL) {
	. $PROFILE_LOCAL
}
Set-Variable -Name PROFILE_KEYBIND -Value "$PROFILE_DIR\Microsoft.PowerShell_profile_keybind.ps1"
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
Set-Alias -Name proj -Value Setup-Project

# Programs
Set-Alias -Name winmerge -Value "${env:ProgramFiles(x86)}\WinMerge\WinMergeU.exe"
Set-Alias -Name npp -Value "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
Set-Alias -Name mysql -Value ${MysqlHome}\bin\mysql.exe
Set-Alias -Name mysqladmin -Value ${MysqlHome}\bin\mysqladmin.exe
Set-Alias -Name mysqlworkbench -Value ${MysqlHome}\mysql-workbench\MySQLWorkbench.exe
Set-Alias -Name mongo -Value ${MongoHome}\bin\mongo.exe
Set-Alias -Name Tomcat-Start -Value $CatalinaHome\bin\startup.bat
Set-Alias -Name Tomcat-Shutdown -Value $CatalinaHome\bin\shutdown.bat
Set-Alias -Name vmware -Value "${env:ProgramFiles(x86)}\VMware\VMware Player\vmplayer.exe"
Set-Alias -Name vmnetcfg -Value "${env:ProgramFiles(x86)}\VMware\VMware Player\vmnetcfg.exe"
Set-Alias -Name 7z -Value ${env:ProgramFiles}\7-Zip\7z.exe
# Set-Alias -Name node -Value ${NodejsHome}\node.exe
# Set-Alias -Name npm -Value ${NodejsHome}\npm.cmd
Set-Alias -Name firefox -Value "${env:ProgramFiles}\Mozilla Firefox\firefox.exe"
Set-Alias -Name browser -Value firefox
Set-Alias -Name git-bash -Value "${env:ProgramFiles}\Git\git-bash.exe"
# Set-Alias -Name python -value "${env:ProgramData}\Anaconda3\python.exe"
Set-Alias -Name cygpath -Value ${CygwinHome}\bin\cygpath.exe

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

# function ll {
	# param(
		# [Parameter(Position=0)] [string] $Path,
		# [string] $Filter,
		# [switch] $Recurce,
		# [switch] $Directory,
		# [switch] $File
	# )
	# $cmd = "Get-ChildItem -Force"
	# # add and escape double quotation for paths that includes spaces
	# if ($PSBoundParameters.ContainsKey("Path")) {$cmd+=" -Path `"$Path`""}
	# if ($PSBoundParameters.ContainsKey("Filter")) {$cmd+=" -Filter $Filter"}
	# if ($Recurce) {$cmd+=" -Recurse"}
	# if ($Directory) {$cmd+=" -Directory"}
	# if ($File) {$cmd+=" -File"}

	# Invoke-Expression -Command $cmd
# }

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

function touch {
	param(
		[Parameter(Mandatory, Position=0, ValueFromRemainingArguments)] [string[]] $Path,
		[switch] $Force = $false
	)

	New-Item -ItemType File -Path $Path -Force:$Force
}

function vim {
	& $VimRtp\vim.exe -p $args
}

function view {
	& $VimRtp\vim.exe -p -R $args
}

function vimdiff {
	& $VimRtp\vim.exe -d $args
}

function gvim {
	& $VimRtp\gvim.exe -p $args
}

function gview {
	& $VimRtp\gvim.exe -Rp $args
}

function gvimdiff {
	& $VimRtp\gvim.exe -dO $args
}

function gvimserver {
	param(
		[Parameter(Mandatory, Position=0)] [string] $ServerName,
		[Parameter(Mandatory, ValueFromRemainingArguments)] [string[]] $File
	)

	& $VimRtp\gvim.exe --servername $ServerName --remote-tab-silent $File
}

function wim {
	param(
		[string[]] $Files,
		[Parameter(ValueFromRemainingArguments)] [string[]] $Other
	)
	$cygbin = "${CygwinHome}\bin"
	if(! (Test-Path -PathType Container -Path $cygbin)){
		Write-Host -ForegroundColor Red -Object "Cygwin's bin directory [$cygbin] does not exist"
		return
	}
	$mintty = "${CygwinHome}\bin\mintty.exe"
	$cygpath = "${CygwinHome}\bin\cygpath.exe"

# Only run cygpath when $Files contain contain something or cygpath emits help message
	if($Files.Count -gt 0){
		$cygFilePath = $(Invoke-Expression -Command "$cygpath $Files")
	}
	$bashArgs = "/usr/bin/stty -ixon; /usr/bin/vim -p $Other -- $cygFilePath"
# wrap bash arguments with single quote or it won't work properly
	$bashArgs = "'" + $bashArgs + "'"

	Start-Process -FilePath $mintty -WindowStyle Maximized -ArgumentList "-t vim","-e","/usr/bin/bash -c $bashArgs"
}

function nvim {
	& $NvimHome\bin\nvim-qt.exe $args
}

# nvim within console
function nvimc {
	& $NvimHome\bin\nvim.exe $args
}

function emacs {
	# default location for init file is $env:APPDATA
	# -q option prevents reading default init file
	# --load option loads custom init file
	# -nw option launches emacs within the console
	& $env:ProgramFiles\emacs\bin\emacs.exe -q --load $HOME\.emacs -nw $args
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

function cygwin {
	Start-Process -FilePath ${CygwinHome}\bin\mintty.exe -ArgumentList "-i /Cygwin-Terminal.ico -" -WindowStyle Maximized
}

function cyg-setup{
	Start-Process -FilePath ${CygwinHome}\setup-x86_64.exe
}

function cyg-renew {
	wget -Uri https://www.cygwin.com/setup-x86_64.exe -OutFile $CygwinHome\setup-x86_64.exe
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
function clip{
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

function plantuml {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path,
		[string] $Charset = 'UTF-8',
		[switch] $Open
	)

	if(! (Test-Path -PathType Leaf -Path $Path)){
		Write-Host -ForegroundColor Red -Object "$Path not found."
		return
	}

	java -jar $PlantumlHome\plantuml.jar $Path -charset $Charset
	$pngFilePath = ($Path -replace '\.[^.]*$','.png')

	if ($Open) {
		Invoke-Expression $pngFilePath
	}
}

function Get-Function {
	param(
		[Parameter(Mandatory, Position=0)] [string] $Name
	)

	Get-Content function:${Name}
}

function javaapi {
	if(! (Test-Path -Path Alias:\browser)){
		Write-Host -ForegroundColor Red -Object "Alias 'browser' must be defined."
		return
	}

	$javaapidoc = "${env:ProgramFiles}\Java\doc\api\index.html"

	if(! (Test-Path -Path $javaapidoc)){
		Write-Host -ForegroundColor Red -Object "$javaapidoc not found"
		return
	}

	browser $javaapidoc
}

function ff {
	param(
		[switch] $PrivateWindow
	)

	# See below for firefox command line options
	# https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options

	if(! (Test-Path -Path Alias:\firefox)){
		Write-Host -ForegroundColor Red -Object "Alias 'firefox' must be defined."
		return
	}

	if($PrivateWindow){
		# Private window only accepts URL so this function ignores arguments
		& firefox -private-window
		return
	}

	& firefox -new-window -search "$args"
}

function mysqld {
	$cmd = 'Start-Process -FilePath "${MysqlHome}\bin\mysqld.exe" -WindowStyle Minimized'
	if ($args.Length -ne 0) {
		$cmd += " -ArgumentList $($args -join ',')"
	}
	Invoke-Expression -Command $cmd
}

function eclipse {
	param(
		[switch] $Clean
	)

	$exe = "$EclipceHome\eclipse.exe"

	if($Clean){
		$arglist = @("'-clean'") + $args
	}
	else{
		$arglist = $args
	}

	$cmd = "Start-Process -FilePath $exe -WorkingDirectory $EclipceHome -WindowStyle Maximized"
	if($arglist.Length -gt 0){
		$cmd +=  " -ArgumentList $($arglist -join ',')"
	}

	Invoke-Expression -Command $cmd

	#if ($Clean) {
	#	Start-Process -FilePath $EclipceHome\eclipse.exe -WorkingDirectory $EclipceHome -ArgumentList "-clean"
	#}
	#else {
	#	Start-Process -FilePath $EclipceHome\eclipse.exe -WorkingDirectory $EclipceHome
	#}
}

function sourcetree {
	& $env:USERPROFILE\AppData\Local\SourceTree\Update.exe --processStart "SourceTree.exe"
}

function gnode {
	param(
		[switch] $NoRC
#		[switch] $NoRC,
#        [switch] $Batch
	)

	$exe = "${NodejsHome}\node.exe"

	if($NoRC){
		$arglist = $args
	}
	else{
		$arglist = @("'-r'", "noderc") + $args
	}
	$arglist = if($arglist){" -ArgumentList $($arglist -join ',')"}else{""}

#    if($Batch){
#        $cmd = "`"$exe`" $arglist"
#    }
#    else{
#        $cmd = "Start-Process -FilePath `"$exe`" -WorkingDirectory `"$NodejsHome`" -WindowStyle Maximized -ArgumentList $($arglist -join ',')"
#    }

	$cmd = "Start-Process -FilePath `"$exe`" -WorkingDirectory `"$NodejsHome`" -WindowStyle Maximized $arglist"

	Invoke-Expression -Command $cmd
}

function mongod{
	& $MongoHome\bin\mongod.exe --config $MongoHome\mongo.conf
}

function mongostop{
	& $MongoHome\bin\mongo.exe admin --eval "db.shutdownServer()"
}

function GoTestAll{
	$failed = $false
	$failedPkgs = [System.Collections.ArrayList]::new()
	$ignore = @('vender')
	$border = '----------------'
	foreach ( $pkg in $(Get-ChildItem -Directory) ) {
		if $ignore.Contains($pkg.Name) { Continue }
		Write-Host -Object $border,$pkg.Name,$border -Separator "`n"
		go test $args $('.\' + $pkg.Name + '\...')
		if ($LASTEXITCODE -gt 0){
			$failed = $true
			$failedPkgs.Add($pkg.Name) > $null
		}
	}

	if ( $failed ) {
		Write-Host -Object $("Failed in packages [{0}]" -f $($failedPkgs -join ", ")) -ForegroundColor Red
	}
	else {
		Write-Host -Object "Everything is OK :)" -ForegroundColor Cyan
	}
}

function Set-VimPJRoot{
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path
	)

	$env:VIMPJROOT = (fullname $Path)
}

function Setup-Project{
	param(
		[Parameter(Mandatory, Position=0)] [string] $Path,
		[Parameter(ValueFromRemainingArguments)] [string] $Title = (basename $Path)
	)

	Set-VimPJRoot -Path $Path
	Set-Title -Title $Title
	Set-Location -Path $Path
}

#<Start up>

if((Get-Location).Path -eq "$env:System32"){
	cd $HOME
}

# Modules
## posh-git
Import-Module -Name posh-git -ErrorAction Ignore
if ($?) {
	# ssh does not work since Windows update to ver 18
	# Start-SshAgent	# password for private key will be saved
}

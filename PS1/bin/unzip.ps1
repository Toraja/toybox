param(
    [Parameter(Mandatory = $true)] [string] $file,
    [string] $destination = "."
)

# prompt user when the destination is not specified
if(! $PSBoundParameters.ContainsKey("destination")){
    $title = "Expand location"
    $message = "Archives will be expanded to the current location. Continue?"
    $ans_yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Archives will be expanded to the current location."
    $ans_no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Cancel unzip."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($ans_yes, $ans_no)
    $result = $Host.UI.PromptForChoice($title, $message, $options, 0)

    if($result -eq 1){
        Write-Host -Object "unzip was cancelled."
        exit
    }
}

$file = (Get-Item $file).FullName
$destination = (Get-Item $destination).FullName

$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
foreach($item in $zip.items())
{
    $shell.Namespace($destination).copyhere($item)
}

# pairs of type and name of variable must be written
# on each line in the file specified.

param([string] $ClassName, [string] $filePath)
$params = ""
$array = @()
foreach($i in cat $filePath){
	$params += ", $i"
	$array += $i.substring($i.IndexOf(" ") + 1)
}
$params = $params.substring(2)
Write-Host "public $ClassName($params){"
for($j = 0; $j -lt $array.length; $j++){
	Write-Host "this." -NoNewLine
	Write-Host $array[$j] -NoNewLine
	Write-Host " = " -NoNewLine
	Write-Host $array[$j] -NoNewLine
	Write-Host ";"
}
Write-Host "}"
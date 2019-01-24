## Tips
### Useful commands
**Export-Csv**  
Output the piped value to a file. Each property of the output becomes the column of csv.  

*Example*  
Grep file (Select-String), limit the information (Select-Object -Property), and output as csv
(Export-Csv)  
```
Select-String -Path file -Pattern pattern | Select-Object -Property Line,LineNumber,Path,Pattern |
Export-Csv ~\Desktop\csv.csv -Encoding utf8 -NoTypeInformation
```

**Netstat Equivalent**  
Get-NetTCPConnection

### Data Type
#### Array
```
# initialisation
$var = @('apple', 'banana', 'coconut')
$var = 'apple', 'banana', 'coconut'
# referencing
$var[1]
$var.Get(1)
# Adding
$var += 'durian'  # $var.Add() does not work because Array IS FIXED SIZE
```

#### Hashtable
```
# initialisation
$var = @{a='apple'; b='banana'; c='coconut'}
# referencing
## single value
$var.b
$var['b']
$var.Item('b')
## Key-Value pair
$var.GetEnumerator() 
# Adding
$var.d = 'durian'
$var['d'] = 'durian'
$var.Add('d', 'durian')
```

#### Custom Object
```
# initialisation
## 1
$o = New-Object -TypeName PSObject -Property @{a='apple'; b='banana'}
## 2
$o = New-Object -TypeName PSObject
Add-Member -InputObject $o -MemberType NoteProperty -Name a -Value apple
Add-Member -InputObject $o -MemberType NoteProperty -Name b -Value banana
## Class
### Refer to the link under Object-Oriented. Method can be added in this way.
```

### Object-Oriented
Static, Inheritence, Enum etc...
[Powershell v5 Classes & Concepts](https://xainey.github.io/2016/powershell-classes-and-concepts/)

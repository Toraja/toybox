# PowerShell Profile

- Open PowerShell as admin  
  Creating symlink requires admin privilege.
- Go to profile directory  
  `cd $(Split-Path $env:PROFILE)`
- Create symlink to profiles  
  `New-Item -ItemType SymbolicLink -Value <link destination> -Path Microsoft.PowerShell_profile.ps1`  
  Repeat for other profiles.

# PowerShell Profile

- Open PowerShell as admin
  - Creating symlink requires admin privilege.
- Go to profile directory
  ```ps1
  cd $(Split-Path $PROFILE)
  ```
- Create symlink to profiles
  ```ps1
  New-Item -ItemType SymbolicLink -Value <link destination> -Path Microsoft.PowerShell_profile.ps1``
  ```
  - Repeat for other profiles.

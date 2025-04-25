# PowerShell Profile

- Clone this repository to home directory
  ```ps1
  git clone https://github.com/Toraja/toybox.git
  ```
- Open `$PROFILE` in nodepad
  ```ps1
  notepad $PROFILE
  ```
- Paste the below code
  ```ps1
  if (Test-Path -PathType Leaf -Path $env:USERPROFILE\toybox\PS1\Microsoft.PowerShell_profile_base.ps1) {
    . $env:USERPROFILE\toybox\PS1\Microsoft.PowerShell_profile_base.ps1
  }

  # --- Add code to localise below ---
  ```
  - Not using symlink here because creating symlink requires admin privilege.

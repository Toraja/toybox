## Configuration
### General
#### Change default to ubuntu
1. Run `uuidgen` and take a note of the output
1. Replace the value of `defaultProfile` in `setting.json` (located at the top).

### Ubuntu
Go to ubuntu section `profiles -> list`

#### Change starting directory
1. add `"startingDirectory": "//wsl$/Ubuntu/<linux path to directory>"` to the
   section.  
   eg. `"//wsl$/Ubuntu/home/user"`

#### Change font
1. add `"fontFace": "Consolas"` to the section

#### Change cursor shape
1. add` "cursorShape": "filledBox"` to the section

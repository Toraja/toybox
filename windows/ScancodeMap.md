## Change Key Location
1. Press *Win+r* >> type *regedit* >> press *Enter*  
2. Go to *HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout*  
3. Create new binary and name it as *Scancode Map*  
4. Modify it as described below  
    1. Must have 8 pairs of leading "00"  
    2. The number of the pair of keys to change + 1 in 2 digit form + 3 pairs of "00"  
      eg. `02 00 00 00`  
    3. Scancode of key to assign on the left, Scancode of key to be assigned on the right  
      Repeat as many as you would like to change  
      eg. `1D 00 3A 00` (<-- assign Control to Caps Lock, or Caps Lock becomes Control)  
    4. Must have 4 pairs of trailing "00"

### Scancodes

| Key       | Scancode |
|:---------:|:--------:|
| Ctrl      | 1D       |
| Caps      | 3A       |
| Left Alt  | 38       |
| Right Alt | E0 38    |
| Space bar | 39       |
| Right Win | E0 5C    |
| 無変換    | 7B       |
| 半角全角  | 29       |
| 変換      | 79       |
| カタカナ  | 70       |

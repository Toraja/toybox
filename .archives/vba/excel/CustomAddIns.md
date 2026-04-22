## How to create
1. Open new excel book and write vba code into "Module" (Or *標準モジュール*).  
   If you don't see it in the project explorer, select *Insert* -> *Module*.  
   If function/sub routine needs to run at start up, add the code below into
   "ThisWorkBook" in the project explorer of your Add-in.  

   ```vb
   Private Sub Workbook_Open()
       Call [function/sub name]
   End Sub
   ```

1. Save the excel file as .xla(m) into default Add-in location.
   ```
   C:\Users\[username]\AppData\Roaming\Microsoft\AddIns
   ```

## Enable Add-in
Select *Developer* tab -> *Add-in* (For Windows 10, *Excel Add-in*) -> check your Add-in -> *OK*

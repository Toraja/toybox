command! -complete=shellcmd -nargs=+ OutputShellCmdToQF call shell#base#ShellCmdToQF(<q-args>, v:false)
command! -complete=shellcmd -nargs=+ AppendShellCmdToQF call shell#base#ShellCmdToQF(<q-args>, v:true)
command! -complete=shellcmd -nargs=+ OutputShellCmdToPreview call shell#base#ShellCmdToPreview(<q-args>, v:false)
command! -complete=shellcmd -nargs=+ AppendShellCmdToPreview call shell#base#ShellCmdToPreview(<q-args>, v:true)

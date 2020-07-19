# Eclipse JDT Language Server

## Initialisation
Refer to `toybox/vim/helper/java-lsp.sh`  
`--data` specifies workspace of jdt.ls and it can be anywhere.  
This is the common workspace of jdt.ls and differs from project specific
settings.  

## Customise
### Formatting
Edit file `.settings/org.eclipse.jdt.core.prefs` under the project root.  
For available options, refer to:  
- [formatter settings under .settings/org.eclipse.jdt.core.prefs](https://gist.github.com/fbricon/30c5971f7e492c8a74ca2b2d7a7bb966)
- [Help - Eclipse Platform](https://help.eclipse.org/2020-06/index.jsp?topic=%2Forg.eclipse.jdt.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fjdt%2Fcore%2Fformatter%2FDefaultCodeFormatterConstants.html)

It might be possible to specify external setting file by providing parameter
`java.formatter.fileName` when initialising server. (not tested)

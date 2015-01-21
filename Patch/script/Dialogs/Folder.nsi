!include "./defines.nsh"

Name "Folder"
OutFile "Folder.exe"
ShowInstDetails show
XPStyle on

Page instfiles


Section "-boo"
DetailPrint "Executing plugin...."
StrCpy $INSTDIR "C:\A\Sample\path"
DetailPrint "Current Install directory: $INSTDIR"
Dialogs::Folder "Cool folder selector" "Choose me a folder:" $EXEDIR ${VAR_INSTDIR}
StrCmp $INSTDIR "" Cancel Ok

Cancel:
DetailPrint "No folder was selected by the user"
goto Exit

Ok:
DetailPrint "User selected install folder: $INSTDIR"
goto Exit

Exit:
SectionEnd

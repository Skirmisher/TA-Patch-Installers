!addincludedir .
!addplugindir .
!include defines.nsh

Name "Open"
OutFile "Open.exe"
ShowInstDetails show
XPStyle on

Page instfiles


Section "-boo"
DetailPrint "Executing plugin...."
Dialogs::Open \
"Nsis Files (*.nsi)|*.nsi|Nsis Headers (*.nsh)|*.nsh|Nsis Language (*.nlf)|*.nlf|Nsis Support files (*.nsi;*.nsh;*.nlf)|*.nsi;*.nsh;*.nlf|" \
"4" \
"Choose a file from the list" \
$EXEDIR \
${VAR_6}
StrCmp $6 "" Cancel Ok

Cancel:
DetailPrint "No file was selected by the user"
Goto Exit

Ok:
DetailPrint "User selected file: $6"
Goto Exit

Exit:
SectionEnd

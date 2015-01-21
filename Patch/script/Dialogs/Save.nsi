!include "./defines.nsh"

Name "Save"
OutFile "Save.exe"
ShowInstDetails show
XPStyle on

Page instfiles


Section "-boo"
DetailPrint "Executing plugin...."
Dialogs::Save \
"HTML Files (*.htm*)|*.htm*|Images (*.gif;*.jp*;*.png)|*.gif;*.jp*;*.png|All Files (*.*)|*.*|" \
"2" \
"Save the file" \
$EXEDIR \
${VAR_5}
StrCmp $5 "" Cancel Ok

Cancel:
DetailPrint "No file was selected by the user"
goto Exit

Ok:
DetailPrint "User selected file to save: $5"
goto Exit

Exit:
SectionEnd

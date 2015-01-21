!include "./defines.nsh"

Name "Other"
OutFile "Other.exe"
ShowInstDetails show
XPStyle on

Page instfiles


Section "-boo"
DetailPrint "Executing plugin...."
Dialogs::Author ${VAR_0}
DetailPrint "Reading Autor: $0"
Dialogs::Ver ${VAR_1}
DetailPrint "Reading Version: $1"
SectionEnd

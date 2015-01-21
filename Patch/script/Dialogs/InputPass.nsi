!include "./defines.nsh"

Name "InputPass"
OutFile "InputPass.exe"
XPStyle on

Function ".onInit"
Loop:
Dialogs::InputBox "My installer title" "I'm sorry, this installer is password-protected.$\r$\nPlease enter the password:" "OK" "Cancel" "1" ${VAR_5}

;nsis is the password:
StrCmp $5 "nsis" OK WRONG

;Is wrong!
WRONG:
Messagebox MB_YESNO|MB_ICONSTOP "Bad password. $\r$\nDo you want to try it again?" IDYES Loop
goto Exit

;Is correct!
OK:
Messagebox MB_OK|MB_ICONINFORMATION "You can enter now. $\r$\nWell...just click the button"

;Quit the installer:
Exit:
Quit
FunctionEnd

Section "-boo"
;
SectionEnd

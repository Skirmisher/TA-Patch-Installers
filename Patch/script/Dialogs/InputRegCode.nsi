; Before compile this, run SerialMaker.exe
; in username, type -> "Lobo Lunar"
; in key, type -> "nsis2.02"
; then "generate"
; It should return something like -> "1C8FD-272130210e240-262240" <- Use this to access good stuff :P

!include "./defines.nsh"

Name "InputRegCode"
OutFile "InputRegCode.exe"
XPStyle on
ShowInstDetails show

Section "-boo"
Dialogs::InputRegCode \
"Registration Code" \
"Type you serial code, if you are a Registered user $\r$\nin our data-base." \
"Username:" \
"Serial:" \
"nsis2.02" \
"OK" \
"Cancel" \
${VAR_5}

StrCmp $5 "0" Good Bad

Good:
StrCpy $0 "User & Serial match"
goto Exit

Bad:
StrCpy $0 "User & Serial don't match"
goto Exit

Exit:
DetailPrint "$5 - ($0)"
SectionEnd

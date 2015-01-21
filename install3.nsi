;
; TA Demo 0.99b2 installerare
;

; Fina globaler
!define VERSION "TA Patch 3.9.2.x Replayer and Launcher"
!define EXENAME "replayer_launcher_392_x.exe"

; Ändrar defaultprylar
Name "${VERSION}"
OutFile "${EXENAME}"
Caption "${VERSION} Installer"
CRCCheck On
WindowIcon off
ShowInstDetails show
ShowUninstDetails show
SetDateSave off

; The default installation directory
InstallDir $PROGRAMFILES\TAPatch

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKCU "SOFTWARE\TA Patch\TA Demo" "Install_Dir"

; The text to prompt the user to enter a directory
ComponentText "This will install ${VERSION} on your computer. Select which optional things you want installed."
; The text to prompt the user to enter a directory
DirText "Choose a directory to install in to:" 

; The stuff to install
Section "TA Patch 3.9.2.x Replayer"

  ; Börja med ett shortcut-entry
  CreateDirectory "$SMPROGRAMS\TAPatch"

  ; Saker som ska in i vanliga demo-katalogen
  SetOutPath $INSTDIR

  File "Replayer\server.exe"
  File "Replayer\maps.txt"
  File "Replayer\unitid.txt"

  CreateShortCut "$SMPROGRAMS\TAPatch\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$SMPROGRAMS\TAPatch\Replayer.lnk" "$INSTDIR\server.exe"

  ; Skriv ner en regkey som denna installer kikar på sen
  WriteRegStr HKLM "SOFTWARE\TAPatch\TA Demo" "Install_Dir" "$INSTDIR"

  ; Skriv uninstaller
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VERSION}" "TA Demo Replayer and Launcher" "TA Demo Replayer and Launcher (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VERSION}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"

  ; Fixa associationer
  WriteRegStr HKCR ".tad" "" "server.Document" 
  WriteRegStr HKCR "server.Document" "" "TA Demo" 
  WriteRegStr HKCR "server.Document\shell\open\command" "" '"$INSTDIR\SERVER.EXE" %1'
  
  done:
SectionEnd

; optional section
Section "TA Launcher 1.0.0.44"

  SetOutPath $INSTDIR
  File "Launcher\Launcher.exe"
  File "Launcher\launcher-license.txt"

  CreateShortCut "$SMPROGRAMS\TAPatch\Launcher.lnk" "$INSTDIR\Launcher.exe" 

SectionEnd

; uninstall stuff

UninstallText "This will uninstall ${VERSION}. Hit next to continue."

; special uninstall section.
Section "Uninstall"
  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${VERSION}"

  ; Ta bort filassociationen
  DeleteRegKey HKCR ".tad"
  DeleteRegKey HKCR "server.Document"

  ; Men i huvudkatalogen känns bäst att specificera
  Delete $INSTDIR\server.exe
  Delete $INSTDIR\maps.txt
  Delete $INSTDIR\unitid.txt

  Delete $INSTDIR\Launcher.exe
  Delete $INSTDIR\launcher-license.txt

  ; Själva installern ska också bort
  Delete $INSTDIR\uninstall.exe

  ; remove shortcuts, if any.
  Delete "$SMPROGRAMS\TAPatch\*.*"

  ; remove directories used.
  RMDir "$SMPROGRAMS\TAPatch"
  RMDir "$INSTDIR"
SectionEnd

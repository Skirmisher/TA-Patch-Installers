; Total Annihilation new unofficial patch project -- resources installer
; by Skirmisher

; Includes
  !addplugindir .
  
  !include MUI2.nsh
  !include Sections.nsh
  !include FileFunc.nsh

; Version
  !define VERSION 2.0
  #!define VERSION_UNDER
  VIProductVersion "2.0.0.0"
  VIAddVersionKey "FileVersion" "2.0"
  VIAddVersionKey "ProductName" "Total Annihilation Unofficial Patch Resources"
  VIAddVersionKey "ProductVersion" "2.0"
  VIAddVersionKey "OriginalFilename" "TA_Patch_Resources_${VERSION}.exe"

; Language files
  !addincludedir .\Language
  !include English.nsh

; OTA file hashes
  !define TOTALA2_MD5 "D6D178081A670CE0CDAB4F8BD035148E"
  !define TOTALA4_MD5 "5C71CDC43F12FF759243C76C39261640"
  !define 1ZRB_MD5 "C36F21A5403F5ADC68EA426A157AC407"

; Variables
  Var need       ; for telling user which files are required from CD
  Var cdskip     ; finish message informs of skipped CD copy
  Var commonMaps ; common maps directory
  Var commonData ; common data directory
    
Name "$(name)"
OutFile "..\bin\TA_Patch_Resources_${VERSION}.exe"
Caption "$(caption)"

RequestExecutionLevel admin

SetCompressor /SOLID lzma

; MUI stuff

  ; Main interface
    #!define MUI_ICON taesc.ico
    !define MUI_ABORTWARNING
      !define MUI_ABORTWARNING_TEXT "$(abortwarning)"
      !define MUI_ABORTWARNING_CANCEL_DEFAULT
      
  ; Pages
    ; Welcome page
      !define MUI_WELCOMEPAGE_TITLE "$(welcome_title)"
      !define MUI_WELCOMEPAGE_TEXT "$(welcome_text)"
      !define MUI_PAGE_CUSTOMFUNCTION_PRE PatchLaunched
      !insertmacro MUI_PAGE_WELCOME
    ; Directory page
      !define MUI_PAGE_HEADER_TEXT "$(directory_header)"
      !define MUI_PAGE_HEADER_SUBTEXT "$(directory_header_sub)"
      !define MUI_DIRECTORYPAGE_TEXT_TOP " "
      !define MUI_DIRECTORYPAGE_TEXT_DESTINATION "$(directory_select)"
      !define MUI_PAGE_CUSTOMFUNCTION_PRE PatchLaunched
      !define MUI_PAGE_CUSTOMFUNCTION_LEAVE CheckDirectory
      !insertmacro MUI_PAGE_DIRECTORY
    ; Instfiles page
      !insertmacro MUI_PAGE_INSTFILES
      !define MUI_PAGE_CUSTOMFUNCTION_LEAVE PatchLaunched
    ; Finish page
      !define MUI_FINISHPAGE_TITLE "$(finish_title)"
      !define MUI_FINISHPAGE_TEXT "$(finish_text)"
      !define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\$(finish_readme).txt"
      !define MUI_FINISHPAGE_SHOWREADME_TEXT "$(finish_showreadme)"
      !define MUI_FINISHPAGE_LINK "$(finish_link)"
      !define MUI_FINISHPAGE_LINK_LOCATION http://tauniverse.com/
      !define MUI_FINISHPAGE_NOREBOOTSUPPORT
      !define MUI_FINISHPAGE_NOAUTOCLOSE #DEBUG
      !insertmacro MUI_PAGE_FINISH

  ; Language
    !insertmacro MUI_LANGUAGE "English"

; Reserve files (for solid compression)
  ReserveFile md5dll.dll

InstallDir "C:\CAVEDOG\TOTALA"
InstallDirRegKey HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Path"
  
; Install sections

Section /o "CD1" section_cd1
  MessageBox MB_OK|MB_ICONINFORMATION "$(insert_disc1)"
  redetect:
  ${GetDrives} "CDROM" "GetDrivesCD1"
  ${IfThen} $R0 == "StopGetDrives" ${|} Goto end ${|}
  .notfound1:
  MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "$(notfound_disc1)" IDRETRY redetect IDIGNORE skip
  StrCpy $R9 1
  Call AbortWarning
  skip:
  DetailPrint "$(cdskip_disc1)"
  StrCpy $cdskip "$(cdskip_finish) [$(cdskip_totala2)]"
  StrCpy $R3 1
  end:
SectionEnd

Section /o "CD2" section_cd2
  MessageBox MB_OK|MB_ICONINFORMATION "$(insert_disc2)"
  redetect:
  ${GetDrives} "CDROM" "GetDrivesCD2"
  ${IfThen} $R0 == "StopGetDrives" ${|} Goto end ${|}
  .notfound2:
  MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "$(notfound_disc2)" IDRETRY redetect IDIGNORE skip
  StrCpy $R9 2
  Call AbortWarning
  skip:
  DetailPrint "$(cdskip_disc2)"
  ${IfNot} $cdskip == ""
    StrCpy $cdskip "$(cdskip_finish) [$(cdskip_totala2), $(cdskip_totala4)]"
    StrCpy $R3 3
  ${Else}
    StrCpy $cdskip "$(cdskip_finish) [$(cdskip_totala4)]"
    StrCpy $R3 2
  ${EndIf}
  end:
SectionEnd

Section /o "Movies" section_movies
  MessageBox MB_OK|MB_ICONINFORMATION "$(insert_movies)"
  redetect:
  ${GetDrives} "CDROM" "GetDrivesMovies"
  ${IfThen} $R0 == "StopGetDrives" ${|} Goto end ${|}
  .notfound3:
  MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "$(notfound_movies)" IDRETRY redetect IDIGNORE skip
  StrCpy $R9 3
  Call AbortWarning
  skip:
  DetailPrint "$(cdskip_movies)"
  ${If} $cdskip == ""
    StrCpy $cdskip "$(cdskip_finish) [$(cdskip_movies)]"
  ${ElseIf} $R3 == 1
    StrCpy $cdskip "$(cdskip_finish) [$(cdskip_totala2), $(cdskip_movies)]"
  ${ElseIf} $R3 == 2
    StrCpy $cdskip "$(cdskip_finish) [$(cdskip_totala4), $(cdskip_movies)]"
  ${ElseIf} $R3 == 3
    StrCpy $cdskip "$(cdskip_finish) [$(cdskip_totala2), $(cdskip_totala4), $(cdskip_movies)]"
  ${EndIf} ; whew
  end:
SectionEnd

Section "Default"
  SetOutPath -
  !cd ..\data
  #ExecShell "mkdir" "$INSTDIR\tamus" SW_HIDE
  SetOutPath "$INSTDIR\tamus"
  #File /a /r "tamus\*"
  SetOutPath -
  #File /a cdmaps.ccx
  #File /a TA_AIs_2013.ccx
  #File /a TA_Features_2013.ccx
  #File /a TA_Map_Weapons_2013.zip
  File /a TA_Map_Weapons_2013_readme.txt
  !cd ..\script
  WriteRegStr HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Path" "$INSTDIR"
  WriteRegStr HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Version" "${VERSION}"
  ${If} $cdskip != ""
    MessageBox MB_OK|MB_ICONEXCLAMATION "$cdskip"
  ${EndIf}
SectionEnd

; Functions

Function ".onInit"
  SetRegView 32 ; this probably isn't necessary
  ${GetParameters} $R6
  ${GetOptions} '$R6' "frisbee" $5
  ${IfNot} ${Errors}
    StrCpy $R5 "frisbee"
    ${GetOptions} '$R6' "/MAPS=" $commonMaps
    ${GetOptions} '$R6' "/DATA=" $commonData
    ${If} ${Errors}
      MessageBox MB_OK|MB_ICONSTOP "One or more required parameters not found. Don't look at me, you know what you did. Go consult the source."
      ; explode
      Abort
    ${EndIf}
    Return
  ${EndIf}
  ReadRegStr $5 HKLM "SOFTWARE\TAUniverse\TA Patch" "Version"
  ${If} ${Errors}
    ${OrIf} $5 < "2.0"
    ClearErrors
    MessageBox MB_YESNOCANCEL "$(patchcheck_fail)" IDYES dl IDNO abort
      # open a local HTML file probably, perhaps with a link to an online resource
    dl:
    # dl stuff
    abort:
    Abort
  ${EndIf}
  ReadRegStr $INSTDIR HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Path"
  ${If} ${Errors}
    ClearErrors
    ReadRegStr $INSTDIR HKLM "SOFTWARE\TAUniverse\TA Patch" "Path"
  ${EndIf}
  ${If} ${Errors}
    ClearErrors
    ReadRegStr $INSTDIR HKLM "SOFTWARE\Microsoft\DirectPlay\Applications\Total Annihilation" "Path"
  ${EndIf}
  ${If} ${Errors}
    ClearErrors
    ReadRegStr $INSTDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Total Annihilation" "Dir"
  ${EndIf}
  ${If} ${Errors}
    ClearErrors
    StrCpy $INSTDIR "C:\CAVEDOG\TOTALA"
  ${EndIf}
FunctionEnd

Function "PatchLaunched"
  ${If} $R7 == 2
    Quit
  ${EndIf}
  ${If} $R7 == 1
    StrCpy $R7 2
    Call CheckDirectory
    Abort
  ${EndIf}
  ${If} $R5 == "frisbee"
    StrCpy $R7 1
    Abort
  ${EndIf}
FunctionEnd

Function "CheckDirectory"
  SetOutPath -
  ${IfNot} ${FileExists} "TotalA.exe"
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(directory_invalid)"
    Abort
  ${EndIf}
  ${IfNot} ${FileExists} "totala2.hpi"
    !insertmacro SelectSection ${section_cd1}
    StrCpy $need "$(skirmish)"
  ${EndIf}
  ${IfNot} ${FileExists} "totala4.hpi"
    !insertmacro SelectSection ${section_cd2}
    StrCpy $need "$(campaign)"
    ${IfThen} ${SectionIsSelected} ${section_cd1} ${|} StrCpy $need "$(skirmish), $(campaign)" ${|}
  ${EndIf}
  ${IfNot} ${FileExists} "Data\*.zrb"
    !insertmacro SelectSection ${section_movies}
    StrCpy $need "$(movies)"
    ${If} ${SectionIsSelected} ${section_cd1}
      ${AndIf} ${SectionIsSelected} ${section_cd2}
      StrCpy $need "$(skirmish), $(campaign), $(movies)"
    ${ElseIf} ${SectionIsSelected} ${section_cd1}
      StrCpy $need "$(skirmish), $(movies)"
    ${ElseIf} ${SectionIsSelected} ${section_cd2}
      StrCpy $need "$(campaign), $(movies)"
    ${EndIf}
  ${EndIf}
  ${If} ${SectionIsSelected} ${section_cd1}
    ${OrIf} ${SectionIsSelected} ${section_cd2}
    ${OrIf} ${SectionIsSelected} ${section_movies}
    MessageBox MB_YESNOCANCEL|MB_ICONINFORMATION|MB_DEFBUTTON1 "$(needcd)$\n$\n$(missing) $need" IDYES proceed IDCANCEL cancel
    !insertmacro UnselectSection ${section_cd1}
    !insertmacro UnselectSection ${section_cd2}
    !insertmacro UnselectSection ${section_movies}
    Return
    cancel:
    !insertmacro UnselectSection ${section_cd1}
    !insertmacro UnselectSection ${section_cd2}
    !insertmacro UnselectSection ${section_movies}
    ${If} $R5 == "frisbee"
      Quit
    ${Else}
      Abort
    ${EndIf}
    proceed:
  ${EndIf}
FunctionEnd

Function "GetDrivesCD1"
  SetOutPath $9 ; drive path
  StrCpy $R0 ""
  ${If} ${FileExists} "$9totala2.hpi" ; why does this require an absolute path
    md5dll::GetMD5File "totala2.hpi"
    Pop $2
    ${If} $2 == ${TOTALA2_MD5}
      DetailPrint "$(copying_disc1)"
      Sleep 500 ; because NSIS is goofy and forgets to print the above on time otherwise
      CopyFiles /SILENT "$9totala2.hpi" "$commonData\totala2.hpi" ; using absolute paths because the docs tell us to
      StrCpy $R0 "StopGetDrives"
    ${Else}
      DetailPrint "$(md5fail_disc1)"
    ${EndIf}
  ${EndIf}
  Push $R0
FunctionEnd

Function "GetDrivesCD2"
  SetOutPath $9
  StrCpy $R0 ""
  ${If} ${FileExists} "$9totala4.hpi"
    md5dll::GetMD5File "totala4.hpi"
    Pop $4
    ${If} $4 == ${TOTALA4_MD5}
      DetailPrint "$(copying_disc2)"
      Sleep 500
      CopyFiles /SILENT "$9totala4.hpi" "$commonData\totala4.hpi"
      StrCpy $R0 "StopGetDrives"
    ${Else}
      DetailPrint "$(md5fail_disc2)"
    ${EndIf}
  ${EndIf}
  Push $R0
FunctionEnd

Function "GetDrivesMovies"
  SetOutPath $9
  StrCpy $R0 ""
  ${If} ${FileExists} "$9Data\1.ZRB"
    md5dll::GetMD5File "Data\1.ZRB" ; just test the first one because we're lazy and it doesn't matter that much
    Pop $3
    ${If} $3 == ${1ZRB_MD5}
      DetailPrint "$(copying_movies)"
      Sleep 500
      CreateDirectory "$INSTDIR\Data"
      CopyFiles /SILENT "$9Data\*.zrb" "$commonData\Data"
      StrCpy $R0 "StopGetDrives"
    ${Else}
      DetailPrint "$(md5fail_movies)"
    ${EndIf}
  ${EndIf}
  Push $R0
FunctionEnd

Function "AbortWarning"
  !ifdef MUI_ABORTWARNING_CANCEL_DEFAULT
    MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "${MUI_ABORTWARNING_TEXT}" IDYES Quit
  !else
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "${MUI_ABORTWARNING_TEXT}" IDYES Quit
  !endif
  
  ${If} $R9 == 1
    Goto .notfound1
  ${ElseIf} $R9 == 2
    Goto .notfound2
  ${ElseIf} $R9 == 3
    Goto .notfound3
  ${EndIf}
  Quit:
  Quit
FunctionEnd
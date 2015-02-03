; Total Annihilation new unofficial patch project -- patch installer
; by Skirmisher

; Includes
  !addplugindir . 
  !include MUI2.nsh
  !include Sections.nsh
  !include FileFunc.nsh
  !include WordFunc.nsh

; Version
  !define VERSION 4.0.0
  !define KNOWN_RES_VER 2.0 ; current resources version as of compile time, suggests to update if user has older version
  !define LAST_COMPAT_VER 2.0 ; will require resources update if resources are older than this
  VIProductVersion "4.0.0.0"
  VIAddVersionKey "FileVersion" "4.0.0.0"
  VIAddVersionKey "ProductName" "Total Annihilation Unofficial Patch"
  VIAddVersionKey "ProductVersion" "4.0.0.0"
  VIAddVersionKey "OriginalFilename" "TA_Patch_${VERSION}.exe"

; Language files
  !insertmacro MUI_LANGUAGE "English"
  !addincludedir .\Language
  !include English.nsh

; Variables
  
  Var commonMaps        ; common maps directory
  Var commonData        ; common data directory
  Var commonDataChanged ; flag if common data directory has been changed by user
  Var mapsDirCreated    ; flag if common maps directory did not exist at install time
  Var dataDirCreated    ; flag if common data directory did not exist at install time

  ; HWNDs
    Var Directories_window
    Var Directories_instdir
      Var Directories_instdir_browse
    Var Directories_commonMaps
      Var Directories_commonMaps_browse
    Var Directories_commonData
      Var Directories_commonData_browse

Name "$(name)"
OutFile "..\bin\TA_Patch_${VERSION}.exe"
Caption "$(caption)"
BrandingText "Total Annihilation Universe"

RequestExecutionLevel admin

SetCompressor /SOLID lzma

; MUI stuff

  ; Main interface
    #!define MUI_ICON taesc.ico
    !define MUI_ABORTWARNING
      !define MUI_ABORTWARNING_TEXT "$(abortwarning)"
      !define MUI_ABORTWARNING_CANCEL_DEFAULT
      
  ; Installer pages
    ; Welcome page
      !define MUI_WELCOMEPAGE_TITLE "$(welcome_title)"
      !define MUI_WELCOMEPAGE_TEXT "$(welcome_text)"
      !insertmacro MUI_PAGE_WELCOME
    ; Directories page
      Page custom Directories Directories_leave
    ; Instfiles page
      !insertmacro MUI_PAGE_INSTFILES
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
  ; Uninstaller pages
    ; Confirm page
      #!define MUI_UNPAGE_CONFIRM

; Language files
  !insertmacro MUI_LANGUAGE "English"
  !addincludedir .\Language
  !include English.nsh

; Reserve files (for solid compression)
  ReserveFile "nsProcess.dll"
  ReserveFile "inetc.dll"
  ReserveFile "${NSISDIR}\Plugins\nsDialogs.dll"
  ReserveFile "..\move_maps_dll\move_maps.dll"
  ReserveFile "${NSISDIR}\Plugins\System.dll"

InstallDir "C:\CAVEDOG\TOTALA"
InstallDirRegKey HKLM "SOFTWARE\TAUniverse\TA Patch" "Path"

; Install sections

Section /o "Resources" section_resources
  DetailPrint "Installing TA Patch Resources..."
  ExecWait '"$R4" frisbee /MAPS="$commonMaps" /DATA="$commonData" /D=$INSTDIR'
  ClearErrors
  ReadRegStr $6 HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Version"
  ${If} ${Errors}
    MessageBox MB_OK|MB_ICONSTOP "$(res_install_fail)"
    ; I couldn't come up with a good way to delete all empty directories *and* keep pre-existing empty directories so
    ; (or maybe I should just delete all empty directories anyway)
    #RMDir "$commonMaps"
    #RMDir "$commonData"
    Quit
  ${EndIf}
  InitPluginsDir
  SetOutPath $PLUGINSDIR
  File "..\move_maps_dll\move_maps.dll"
  StrCpy $3 $INSTDIR
  StrCpy $4 $commonMaps
  maps_dialog:
  System::Call 'move_maps::ShowMoveMapsDialog(t, t) i(r3, r4) .r5'
  ${IfThen} $5 == 2 ${|} MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(move_maps_cancel)" IDNO maps_dialog ${|}
SectionEnd

Section
  ; feel free to comment out files to test
  SetOutPath -
  !cd ..\data
  CreateDirectory "$INSTDIR\Launcher"
  CreateDirectory "$INSTDIR\Replayer"
  SetOutPath "$INSTDIR\Launcher"
  File /r "Launcher\*"
  SetOutPath "$INSTDIR\Replayer"
  File /r "Replayer\*"
  SetOutPath -
  File modstool.exe
  File remove_junk.cmd
  File restore_junk.cmd
  !cd ..\script
  WriteRegStr HKLM "SOFTWARE\TAUniverse\TA Patch" "Path" "$INSTDIR"
  WriteRegStr HKLM "SOFTWARE\TAUniverse\TA Patch" "Version" "${VERSION}"
  WriteRegStr HKLM "SOFTWARE\TAUniverse\TA Patch" "CommonGameDataPath" $commonData
  WriteRegStr HKLM "SOFTWARE\TAUniverse\TA Patch" "CommonMapsPath" $commonMaps
  ExecWait 'modstool.exe -add "-i:0" "-n:Backwards Compatibility" "-p:$INSTDIR\TotalA.exe"'
  ExecWait 'modstool.exe -add "-i:1" "-n:Total Annihilation" "-v:4.0.0" "-p:$INSTDIR\TotalA.exe" "-r:TA Patch"'
SectionEnd

; Installer functions

Function ".onInit"
  totala:
  nsProcess::_FindProcess "TotalA.exe"
  Pop $2
  ${Select} $2
    ${Case} "0"
      MessageBox MB_RETRYCANCEL|MB_ICONSTOP "($totala_running)" IDRETRY totala
      Abort
    ${Case} "603"
      Nop
    ${Default}
      MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "$(findprocess_error)" IDOK continue
      Abort
      continue:
  ${EndSelect}
  nsProcess::_Unload
  SetRegView 32 ; this probably isn't necessary but
  StrCpy $commonDataChanged false
  ReadRegStr $9 HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Version"
  SetErrors #DEBUG
  ${If} ${Errors}
    ${OrIf} $9 == "1.0"
    ClearErrors
    StrCpy $9 "full"
    #MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(rescheck_fail)" IDNO abort
    #ExecShell "open" "http://tauniverse.com/"
    #abort:
    #Abort
    MessageBox MB_YESNOCANCEL|MB_ICONINFORMATION "$(rescheck_fail)" IDYES open IDNO dlres
    Abort
    dlres:
    inetc::get /BANNER "Getting version manifest..." /CONNECTTIMEOUT 5 "http://totalconcat.org/TA/UP/resources.ini" "$TEMP\TAUP_resources.ini"
    Pop $0
    ${If} $0 != "OK"
      MessageBox MB_OK|MB_ICONSTOP "Download error: $0"
      Abort
    ${EndIf}
    ${If} $9 == "full"
      ReadINIStr $1 "$TEMP\TAUP_resources.ini" resources full
    ${Else}
      ReadINIStr $1 "$TEMP\TAUP_resources.ini" resources $9
      ${If} ${Errors}
        ClearErrors
        ReadINIStr $1 "$TEMP\TAUP_resources.ini" resources full
      ${EndIf}
    ${EndIf}
    Delete "$TEMP\TAUP_resources.ini"
    nsDialogs::SelectFileDialog save "$EXEDIR\TA_Patch_Resources_${KNOWN_RES_VER}.exe" "Executable file (*.exe)|*.exe"
    Pop $R4
    ${If} $R4 == ""
      Abort
    ${EndIf}
    inetc::get /POPUP "" /TRANSLATE "$(url)" "$(downloading)" "$(connecting)" "$(file_name)" "$(received)" "$(file_size)" "$(remaining_time)" "$(total_time)" \
      "http://totalconcat.org/TA/UP/resources/$1" "$R4"
    Pop $0
    ${Switch} $0
      ${Case} "OK"
        ${Break}
      ${Default}
        MessageBox MB_OK|MB_ICONSTOP "Download error: $0"
      ${Case} "Cancelled"
        Abort
    ${EndSwitch}
    Goto done
    open:
    nsDialogs::SelectFileDialog open "$EXEDIR\TA_Patch_Resources_${KNOWN_RES_VER}.exe" "TA Patch Resources Installer|TA_Patch_Resources_*.exe"
    Pop $R4
    ${If} $R4 == ""
      Abort
    ${EndIf}
    done:
    !insertmacro SelectSection ${section_resources}
  ${Else}
    ReadRegStr $commonMaps HKLM "SOFTWARE\TAUniverse\TA Patch" "CommonMapsPath"
    ReadRegStr $commonData HKLM "SOFTWARE\TAUniverse\TA Patch" "CommonGameDataPath"
    ${VersionConvert} $9 "" $7 ; future-proof if someone decides to tack letters on (this function converts letters to number system)
    ${VersionCompare} $7 "${KNOWN_RES_VER}" $6
    ${If} $6 == 2 ; if version is older than KNOWN_RES_VER
      ${VersionCompare} $7 "${LAST_COMPAT_VER}" $6
      ${If} $6 == 2 ; if version is older than LAST_COMPAT_VER
        MessageBox MB_YESNOCANCEL|MB_ICONEXCLAMATION "$(rescheck_incompat)" IDYES open IDNO dlres ; this just runs the same code from above
        Abort
      ${Else}
        MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(rescheck_old)" IDYES dlres
      ${EndIf}
    ${EndIf}
  ${EndIf}
  ReadRegStr $INSTDIR HKLM "SOFTWARE\TAUniverse\TA Patch" "Path"
  ${If} ${Errors}
    ClearErrors
    ReadRegStr $INSTDIR HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Path"
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
  ${If} $commonMaps == ""
    StrCpy $commonMaps "$DOCUMENTS\My Games\Total Annihilation\Maps"
    StrCpy $commonData "$INSTDIR\CommonData"
  ${EndIf}
FunctionEnd

Function "Directories"
  StrCpy $R7 false
  
  nsDialogs::Create 1018
  Pop $Directories_window
  
  ${If} $Directories_window == error
    MessageBox MB_OK|MB_ICONSTOP "$(windowcrash)"
    Abort
  ${EndIf}
  
  !insertmacro MUI_HEADER_TEXT "$(directories_header)" "$(directories_header_sub)"
  
  ${NSD_CreateLabel} 0 0 100% 40% "$(directories_desc)"
  ${NSD_CreateLabel} 0 40% 100% 7% "$(directories_TA)"
    ${NSD_CreateDirRequest} 0 47% 249u 10% $INSTDIR
    Pop $Directories_instdir
      ${NSD_CreateBrowseButton} 250u 47% 50u 10% "$(directories_browse)"
      Pop $Directories_instdir_browse
  ${NSD_CreateLabel} 0 60% 100% 7% "$(directories_maps)"
    ${NSD_CreateDirRequest} 0 67% 249u 10% $commonMaps
    Pop $Directories_commonMaps
      ${NSD_CreateBrowseButton} 250u 67% 50u 10% "$(directories_browse)"
      Pop $Directories_commonMaps_browse
  ${NSD_CreateLabel} 0 80% 100% 7% "$(directories_data)"
    ${NSD_CreateDirRequest} 0 87% 249u 10% $commonData
    Pop $Directories_commonData
      ${NSD_CreateBrowseButton} 250u 87% 50u 10% "$(directories_browse)"
      Pop $Directories_commonData_browse
  
  ${NSD_OnChange} $Directories_commonData Directories_commonDataChanged
  ${NSD_OnChange} $Directories_instdir Directories_autoCorrectDataDir
  
  ${NSD_OnClick} $Directories_instdir_browse Directories_browse
  ${NSD_OnClick} $Directories_commonMaps_browse Directories_browse
  ${NSD_OnClick} $Directories_commonData_browse Directories_browse
    
  nsDialogs::Show
FunctionEnd

Function "Directories_commonDataChanged"
  ${If} $R7 == false
    StrCpy $commonDataChanged true
  ${Else}
    StrCpy $R7 false
  ${EndIf}
FunctionEnd

Function "Directories_autoCorrectDataDir"
  ${If} $commonDataChanged == false
    ${NSD_GetText} $Directories_instdir $0
    StrCpy $R7 true
    ${NSD_SetText} $Directories_commonData "$0\CommonData"
  ${EndIf}
FunctionEnd

Function "Directories_browse"
  Pop $1
  ${Select} $1
    ${Case} $Directories_instdir_browse
      StrCpy $9 $(directories_browse_TA)
      StrCpy $0 $Directories_instdir
    ${Case} $Directories_commonMaps_browse
      StrCpy $9 $(directories_browse_maps)
      StrCpy $0 $Directories_commonMaps
    ${Case} $Directories_commonData_browse
      StrCpy $9 $(directories_browse_data)
      StrCpy $0 $Directories_commonData
  ${EndSelect}
  ${NSD_GetText} $0 $8
  ${IfNot} ${FileExists} "$8\." 
    nsDialogs::SelectFolderDialog "$9" "$DESKTOP"
  ${Else}
    nsDialogs::SelectFolderDialog "$9" "$8"
  ${EndIf}
  Pop $2
  ${IfThen} $2 != "error" ${|} ${NSD_SetText} $0 $2 ${|}
FunctionEnd

Function "Directories_leave"
  ${NSD_GetText} $Directories_instdir $INSTDIR
  ${NSD_GetText} $Directories_commonMaps $commonMaps
  ${NSD_GetText} $Directories_commonData $commonData
  SetOutPath -
  ${IfNot} ${FileExists} "TotalA.exe"
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(directory_invalid)"
    Abort
  ${EndIf}
  ${IfNot} ${FileExists} "$commonMaps\."
    CreateDirectory "$commonMaps"
    StrCpy $mapsDirCreated true
  ${EndIf}
  ${IfNot} ${FileExists} "$commonData\."
    CreateDirectory "$commonData"
    StrCpy $dataDirCreated true
  ${EndIf}
FunctionEnd

; Uninstaller functions


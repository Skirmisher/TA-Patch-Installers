; Total Annihilation new unofficial patch project -- patch installer
; by Skirmisher

; Includes
  !include MUI2.nsh
  !include Sections.nsh
  !include FileFunc.nsh

; Version
  !define VERSION 3.9.3
  VIProductVersion "3.9.3.0"
  VIAddVersionKey "FileVersion" "3.9.3.0"
  VIAddVersionKey "ProductName" "Total Annihilation Unofficial Patch"
  VIAddVersionKey "ProductVersion" "3.9.3.0"
  VIAddVersionKey "OriginalFilename" "TA_Patch_${VERSION}.exe"

; Language files
  !addincludedir .\Language
  !include English.nsh

; Variables
  
  Var commonMaps ; common maps directory
  Var commonData ; common data directory
  Var commonDataChanged ; flag if common data directory has been changed by user

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
      !define MUI_FINISHPAGE_NOAUTOCLOSE ; delete later
      !insertmacro MUI_PAGE_FINISH

  ; Language
    !insertmacro MUI_LANGUAGE "English"

; Install sections

Section "Default"
  ; feel free to comment out files to test
  SetOutPath -
  !cd ..\data
  File /r Launcher
  File /r Replayer
  File modstool.exe
  File remove_junk.cmd
  File restore_junk.cmd
  !cd ..\script
  ExecWait 'modstool.exe -add "-i:0" "-n:Backwards Compatibility" "-p:$INSTDIR\TotalA.exe"'
  ExecWait 'modstool.exe -add "-i:1" "-n:Total Annihilation" "-v:3.9.3" "-p:$INSTDIR\TotalA.exe" "-r:TA Patch"'
SectionEnd

; Reserve files (for solid compression)
  ReserveFile NSISdl.dll

; Functions

Function ".onInit"
  SetRegView 32
  StrCpy $commonDataChanged false
  ${If} ${RunningX64}
    ReadRegStr $9 HKLM "SOFTWARE\Wow6432Node\TAUniverse\TA Patch Resources" "Version"
    ${If} ${Errors}
      ClearErrors
      MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(rescheck_fail)" IDNO abort
      ExecShell "open" "http://tauniverse.com/"
      abort:
      Abort
    ${ElseIf} $9 < "2.0"
      MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(rescheck_old)" IDNO skip
      ExecShell "open" "http://tauniverse.com/"
      Abort
      skip:
    ${EndIf}
    ReadRegStr $INSTDIR HKLM "SOFTWARE\Wow6432Node\Microsoft\DirectPlay\Applications\Total Annihilation" "Path"
    ${If} ${Errors}
      ClearErrors
      ReadRegStr $INSTDIR HKLM "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Total Annihilation" "Dir"
    ${EndIf}
  ${Else}
    ReadRegStr $INSTDIR HKLM "SOFTWARE\Microsoft\DirectPlay\Applications\Total Annihilation" "Path"
    ${If} ${Errors}
      ClearErrors
      ReadRegStr $INSTDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Total Annihilation" "Dir"
    ${EndIf}
  ${EndIf}
  ${If} ${Errors}
    ClearErrors
    StrCpy $INSTDIR "C:\CAVEDOG\TOTALA"
  ${EndIf}
  StrCpy $commonMaps "$DOCUMENTS\My Games\Total Annihilation\Maps"
  StrCpy $commonData "$INSTDIR\CommonData"
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
FunctionEnd
; Total Annihilation new unofficial patch project -- mod all-in-one installer
; by Skirmisher

; Edit to suit your mod--edit modinfo.nsh for easy setup, or modify parts of the script to your liking; also see script\Languages\*.nsh files
; (note that you will have to manually merge changes to installer script in the event of an update if you modify this file)

; Includes
  !addplugindir .
  
  !include MUI2.nsh
  !include Sections.nsh
  !include FileFunc.nsh
  !include WordFunc.nsh
  !addincludedir .
  !include modinfo.nsh ; edit this file!

; Version/details [defines moved to modinfo.nsh]
  !ifndef FOLDER
    !define FOLDER_UNDEFINED
    !ifdef FOLDER_NAME
      !define FOLDER "$TADir\${FOLDER_NAME}"
    !else
      !define FOLDER "$TADir\${REG_NAME}"
    !endif
  !endif
  VIProductVersion "${FULL_VERSION}"
  VIAddVersionKey "FileVersion" "${VERSION}"
  VIAddVersionKey "ProductName" "${MOD_NAME}"
  VIAddVersionKey "ProductVersion" "${VERSION}"
  VIAddVersionKey "OriginalFilename" "${FILE_NAME}.exe"

; Variables
  
  Var SMFolder
  Var TADir
  Var need
  Var need_skirmish
  Var need_campaigns
  Var need_movies
  Var no_music          ; flag if music installation is unnecessary
  Var commonMaps        ; common maps directory
  Var commonData        ; common data directory
  Var modDirChanged     ; flag if mod directory has been changed by user
  Var commonDataChanged ; flag if common data directory has been changed by user
  Var mapsDirCreated    ; flag if common maps directory did not exist at install time
  Var dataDirCreated    ; flag if common data directory did not exist at install time

  ; HWNDs
    Var Directories_window
    Var Directories_modDir
      Var Directories_modDir_browse
    Var Directories_commonMaps
      Var Directories_commonMaps_browse
    Var Directories_commonData
      Var Directories_commonData_browse

Name "${MOD_NAME} ${VERSION}"
OutFile "..\bin\${FILE_NAME}_full.exe"
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
      
  ; Pages
    ; Welcome page
      !define MUI_WELCOMEPAGE_TITLE "$(welcome_title)"
      !define MUI_WELCOMEPAGE_TEXT "$(welcome_text)"
      !insertmacro MUI_PAGE_WELCOME
    ; TA directory page
      !define MUI_PAGE_HEADER_TEXT "$(TA_dir_header)"
      !define MUI_PAGE_HEADER_SUBTEXT "$(TA_dir_header_sub)"
      !define MUI_DIRECTORYPAGE_TEXT_TOP " "
      !define MUI_DIRECTORYPAGE_TEXT_DESTINATION "$(TA_dir_box)"
      !define MUI_DIRECTORYPAGE_VARIABLE $TADir
      !define MUI_PAGE_CUSTOMFUNCTION_LEAVE CheckDirectory
      !insertmacro MUI_PAGE_DIRECTORY
    ; Directories page
      Page custom Directories Directories_leave
    ; Start Menu page
      !define MUI_STARTMENUPAGE_TEXT_CHECKBOX "$(smfolder_disable)"
      !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${MOD_NAME}"
      !define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
      !define MUI_STARTMENUPAGE_REGISTRY_KEY "SOFTWARE\TAUniverse\${REG_NAME}"
      !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartMenu"
      !insertmacro MUI_PAGE_STARTMENU startmenu $SMFolder
    ; Instfiles page
      !insertmacro MUI_PAGE_INSTFILES
    ; Finish page
      !define MUI_FINISHPAGE_TITLE "$(finish_title)"
      !define MUI_FINISHPAGE_TEXT "$(finish_text)"
      !define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\$(finish_readme).txt"
      !define MUI_FINISHPAGE_SHOWREADME_TEXT "$(finish_showreadme)"
      !define MUI_FINISHPAGE_LINK "$(finish_link)"
      !define MUI_FINISHPAGE_LINK_LOCATION ${WEBSITE}
      !define MUI_FINISHPAGE_NOREBOOTSUPPORT
      !define MUI_FINISHPAGE_NOAUTOCLOSE #DEBUG
      !insertmacro MUI_PAGE_FINISH

; Language files
  !insertmacro MUI_LANGUAGE "English"
  !addincludedir .\Language
  !include English.nsh

; Sections

Section
  MessageBox MB_OK "uh"
SectionEnd

; Functions

Function ".onInit"
  totala:
  nsProcess::_FindProcess "TotalA.exe"
  Pop $2
  ${Select} $2
    ${Case} "0"
      MessageBox MB_RETRYCANCEL|MB_ICONSTOP "$(totala_running)" IDRETRY totala
      Abort
    ${Case} "603"
      Nop
    ${Default}
      MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "$(findprocess_error)" IDOK continue
      Abort
      continue:
  ${EndSelect}
  nsProcess::_Unload
  !ifdef FOLDER_UNDEFINED
    StrCpy $modDirChanged false
  !else
    StrCpy $modDirChanged true
  !endif
  StrCpy $commonDataChanged false
  StrCpy $need_skirmish false
  StrCpy $need_campaigns false
  StrCpy $need_movies false
  SetRegView 32
  ReadRegStr $TADir HKLM "SOFTWARE\TAUniverse\TA Patch" "Path"
  ${If} ${Errors}
    ClearErrors
    ReadRegStr $TADir HKLM "SOFTWARE\TAUniverse\TA Patch Resources" "Path"
  ${EndIf}
  ${If} ${Errors}
    ClearErrors
    ReadRegStr $TADir HKLM "SOFTWARE\Microsoft\DirectPlay\Applications\Total Annihilation" "Path"
  ${EndIf}
  ${If} ${Errors}
    ClearErrors
    ReadRegStr $TADir HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Total Annihilation" "Dir"
  ${EndIf}
  ${If} ${Errors}
    ClearErrors
    StrCpy $TADir "C:\CAVEDOG\TOTALA"
  ${EndIf}
FunctionEnd

Function "Directories"
  nsDialogs::Create 1018
  Pop $Directories_window
  
  ${If} $Directories_window == error
    MessageBox MB_OK|MB_ICONSTOP "$(windowcrash)"
    Abort
  ${EndIf}
  
  !insertmacro MUI_HEADER_TEXT "$(directories_header)" "$(directories_header_sub)"
  
  ${NSD_CreateLabel} 0 0 100% 45% "$(directories_desc)"
  ${NSD_CreateLabel} 0 45% 100% 7% "$(directories_mod)"
    ${NSD_CreateDirRequest} 0 52% 249u 10% $INSTDIR
    Pop $Directories_modDir
      ${NSD_CreateBrowseButton} 250u 52% 50u 10% "$(directories_browse)"
      Pop $Directories_modDir_browse
  ${NSD_CreateLabel} 0 63% 100% 7% "$(directories_maps)"
    ${NSD_CreateDirRequest} 0 70% 249u 10% $commonMaps
    Pop $Directories_commonMaps
      ${NSD_CreateBrowseButton} 250u 70% 50u 10% "$(directories_browse)"
      Pop $Directories_commonMaps_browse
  ${NSD_CreateLabel} 0 81% 100% 7% "$(directories_data)"
    ${NSD_CreateDirRequest} 0 88% 249u 10% $commonData
    Pop $Directories_commonData
      ${NSD_CreateBrowseButton} 250u 88% 50u 10% "$(directories_browse)"
      Pop $Directories_commonData_browse
  
  ${NSD_OnChange} $Directories_modDir Directories_fieldChanged
  ${NSD_OnChange} $Directories_commonMaps Directories_fieldChanged
  ${NSD_OnChange} $Directories_commonData Directories_fieldChanged
  
  ${NSD_OnClick} $Directories_modDir_browse Directories_browse
  ${NSD_OnClick} $Directories_commonMaps_browse Directories_browse
  ${NSD_OnClick} $Directories_commonData_browse Directories_browse
    
  nsDialogs::Show
FunctionEnd

Function "Directories_fieldChanged"
  Pop $1
  ${Select} $1
    ${Case} $Directories_modDir
      ${NSD_GetText} $1 $INSTDIR
      StrCpy $modDirChanged true
    ${Case} $Directories_commonMaps
      ${NSD_GetText} $1 $commonMaps
    ${Case} $Directories_commonData
      ${NSD_GetText} $1 $commonData
      StrCpy $commonDataChanged true
  ${EndSelect}
FunctionEnd

Function "Directories_browse"
  Pop $1
  ${Select} $1
    ${Case} $Directories_modDir_browse
      StrCpy $9 $(directories_browse_mod)
      StrCpy $0 $Directories_modDir
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
  ${NSD_GetText} $Directories_modDir $INSTDIR
  ${NSD_GetText} $Directories_commonMaps $commonMaps
  ${NSD_GetText} $Directories_commonData $commonData
  ${IfNot} ${FileExists} "$INSTDIR\."
    CreateDirectory "$INSTDIR"
    #StrCpy $modDirCreated true
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

Function "CheckDirectory"
  SetOutPath $TADir
  ${IfNot} ${FileExists} "TotalA.exe"
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(TA_dir_invalid)"
    Abort
  ${EndIf}
  ${IfNot} ${FileExists} "totala1.hpi"
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(TA_dir_broken)" IDYES continue
    Abort
    continue:
  ${EndIf}
  ${IfNotThen} ${FileExists} "ccdata.ccx" ${|} MessageBox MB_OK|MB_ICONINFORMATION "$(TA_dir_no_cc)" ${|}
  ${IfNot} ${FileExists} "totala2.hpi"
    StrCpy $need_skirmish true
    StrCpy $need "$(skirmish)"
  ${EndIf}
  ${IfNot} ${FileExists} "totala4.hpi"
    StrCpy $need_campaigns true
    StrCpy $need "$(campaigns)"
    ${IfThen} $need_skirmish == true ${|} StrCpy $need "$(skirmish), $(campaigns)" ${|}
  ${EndIf}
  ${IfNot} ${FileExists} "Data\*.zrb"
    StrCpy $need_movies true
    StrCpy $need "$(movies)"
    ${If} $need_skirmish == true
      ${AndIf} $need_campaigns == true
      StrCpy $need "$(skirmish), $(campaigns), $(movies)"
    ${ElseIf} $need_skirmish == true
      StrCpy $need "$(skirmish), $(movies)"
    ${ElseIf} $need_campaigns == true
      StrCpy $need "$(campaigns), $(movies)"
    ${EndIf}
  ${EndIf}
  ${If} $need_skirmish == true
    ${OrIf} $need_campaigns == true
    ${OrIf} $need_movies == true
    MessageBox MB_YESNOCANCEL|MB_ICONINFORMATION|MB_DEFBUTTON1 "$(needcd)$\n$\n$(missing) $need" IDYES proceed IDCANCEL cancel
    StrCpy $need_skirmish false
    StrCpy $need_campaigns false
    StrCpy $need_movies false
    Return
    cancel:
    StrCpy $need_skirmish false
    StrCpy $need_campaigns false
    StrCpy $need_movies false
    Abort
    proceed:
  ${EndIf}
  ${If} ${FileExists} "tamus\*"
    ${OrIf} ${FileExists} "tmusi\*"
    StrCpy $no_music true
  ${EndIf}
  # and if not changed
  ${IfThen} $modDirChanged == false ${|} StrCpy $INSTDIR "${FOLDER}" ${|}
  ${IfThen} $commonMaps == "" ${|} StrCpy $commonMaps "$DOCUMENTS\My Games\Total Annihilation\Maps" ${|}
  ${IfThen} $commonDataChanged == false ${|} StrCpy $commonData "$TADir\CommonData" ${|}
FunctionEnd
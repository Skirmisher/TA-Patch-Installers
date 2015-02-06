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
  VIProductVersion "${FULL_VERSION}"
  VIAddVersionKey "FileVersion" "${VERSION}"
  VIAddVersionKey "ProductName" "${MOD_NAME}"
  VIAddVersionKey "ProductVersion" "${VERSION}"
  VIAddVersionKey "OriginalFilename" "${FILE_NAME}.exe"

; Variables
  
  Var SMFolder
  Var TADir
  Var commonMaps        ; common maps directory
  Var commonData        ; common data directory
  Var commonDataChanged ; flag if common data directory has been changed by user
  Var mapsDirCreated    ; flag if common maps directory did not exist at install time
  Var dataDirCreated    ; flag if common data directory did not exist at install time

  ; HWNDs
    Var Directories_window
    Var Directories_instdir
      Var Directories_instdir_browse
    Var Directories_moddir
      Var Directories_moddir_browse
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





; Functions

Function "Directories"
  StrCpy $R7 false
  
  nsDialogs::Create 1018
  Pop $Directories_window
  
  ${If} $Directories_window == error
    MessageBox MB_OK|MB_ICONSTOP "$(windowcrash)"
    Abort
  ${EndIf}
  
  !insertmacro MUI_HEADER_TEXT "$(directories_header)" "$(directories_header_sub)"
  
  ${NSD_CreateLabel} 0 0 100% 20% "$(directories_desc)"
  ${NSD_CreateLabel} 0 20% 100% 7% "$(directories_TA)"
    ${NSD_CreateDirRequest} 0 27% 249u 10% $TADir
    Pop $Directories_moddir
      ${NSD_CreateBrowseButton} 250u 27% 50u 10% "$(directories_browse)"
      Pop $Directories_moddir_browse
  ${NSD_CreateLabel} 0 40% 100% 7% "$(directories_mod)"
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
  ${NSD_OnClick} $Directories_moddir_browse Directories_browse
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
    ${Case} $Directories_moddir_browse
      StrCpy $9 $(directories_browse_mod)
      StrCpy $0 $Directories_moddir
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
  ${NSD_GetText} $Directories_instdir $TADir
  ${NSD_GetText} $Directories_moddir $INSTDIR
  ${NSD_GetText} $Directories_commonMaps $commonMaps
  ${NSD_GetText} $Directories_commonData $commonData
  SetOutPath $TADir
  ${IfNot} ${FileExists} "TotalA.exe"
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(directory_invalid)"
    Abort
  ${EndIf}
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
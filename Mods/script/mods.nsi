; Total Annihilation new unofficial patch project -- mod installer
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

Name "${MOD_NAME} ${VERSION}"
OutFile "..\bin\${FILE_NAME}.exe"
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
    ; Directory page
      !define MUI_PAGE_HEADER_TEXT "$(directory_header)"
      !define MUI_PAGE_HEADER_SUBTEXT "$(directory_header_sub)"
      !define MUI_DIRECTORYPAGE_TEXT_TOP "$(directory_desc)"
      !define MUI_DIRECTORYPAGE_TEXT_DESTINATION "$(directory_box)"
      !insertmacro MUI_PAGE_DIRECTORY
    ; Start Menu page
      #!define MUI_STARTMENUPAGE_TEXT_CHECKBOX "$(smfolder_disable)"
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

; Reserve files (for solid compression)
#  ReserveFile NSISdl.dll
#  ReserveFile Dialogs.dll

InstallDirRegKey HKLM "SOFTWARE\TAUniverse\TA Patch" "Path"

; Install sections

Section
  SetOutPath -
  !cd ..\data
  File /r ".\*"
  File "modinfo.cfg" ; required I guess
  !cd ..\script
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
  SetShellVarContext all
  SetRegView 32
  ReadRegStr $5 HKLM "SOFTWARE\TAUniverse\TA Patch" "Version"
  ${If} ${Errors}
    ${OrIf} $5 == "3.9.01"
    ${OrIf} $5 == "3.9.02"
    ClearErrors
    MessageBox MB_OK|MB_ICONSTOP "$(no_patch)"
    Abort
  ${Else}
    ${VersionConvert} $5 "" $6 ; future-proof if someone decides to tack letters on (this function converts letters to number system)
    ${VersionCompare} $6 "${KNOWN_PATCH_VER}" $7
    ${If} $7 == 2 ; if version is older than KNOWN_PATCH_VER
      ${VersionCompare} $6 "${LAST_COMPAT_VER}" $7
      ${If} $7 == 2 ; if version is older than LAST_COMPAT_VER
        MessageBox MB_YESNO|MB_ICONSTOP "$(incompat_patch)" IDYES dlpatch
        Abort
        dlpatch:
        inetc::get /BANNER "Getting version manifest..." /CONNECTTIMEOUT 5 "http://totalconcat.org/TA/UP/patch.ini" "$TEMP\TAUP_patch.ini"
        Pop $0
        ${If} $0 != "OK"
          MessageBox MB_OK|MB_ICONSTOP "Download error: $0"
          Abort
        ${EndIf}
        ReadINIStr $1 "$TEMP\TAUP_patch.ini" resources $5
        ${If} ${Errors}
          ClearErrors
          ReadINIStr $1 "$TEMP\TAUP_patch.ini" resources full
        ${EndIf}
        Delete "$TEMP\TAUP_patch.ini"
        nsDialogs::SelectFileDialog save "$EXEDIR\TA_Patch_${KNOWN_PATCH_VER}.exe" "Executable file (*.exe)|*.exe"
        Pop $R4
        ${If} $R4 == ""
          Abort
        ${EndIf}
        inetc::get /RESUME "$(resume)" \
          /POPUP "" /TRANSLATE "$(url)" "$(downloading)" "$(connecting)" "$(file_name)" "$(received)" "$(file_size)" "$(remaining_time)" "$(total_time)" \
          "http://totalconcat.org/TA/UP/patch/$1" "$R4"
        Pop $0
        ${Switch} $0
          ${Case} "OK"
            ${Break}
          ${Default}
            MessageBox MB_OK|MB_ICONSTOP "$(dl_error)"
          ${Case} "Cancelled"
            Abort
        ${EndSwitch}
      ${Else}
        MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(old_patch)" IDYES dlpatch
      ${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd
; Total Annihilation new unofficial patch project -- mod installer
; by Skirmisher

; Mod: Development Mod 1.4 by Rime
#(edit to suit your mod--edit version/details section for easy setup, or modify any parts to your liking; also see script/Languages/*.nsh files)#

; Includes
  !addplugindir .
  
  !include MUI2.nsh
  !include Sections.nsh
  !include FileFunc.nsh
  !include WordFunc.nsh

; Version/details
  !define VERSION 1.4
  !define FULL_VERSION 1.4.0.0
  !define MOD_NAME "TA Development Mod"
  !define REG_NAME "TA Dev Mod" ; do not use slashes of any kind!!
  !define FILE_NAME "TA_Dev_Mod_${VERSION}" ; do not specify .exe extension
  !define WEBSITE "http://plobex.pl/devmod/"
  !define KNOWN_PATCH_VER 3.9.3 ; current patch as of compile time, suggests to update if user has older version
  !define LAST_COMPAT_VER 3.9.3 ; will not install if patch is older than this
  VIProductVersion "${FULL_VERSION}"
  VIAddVersionKey "FileVersion" "${FULL_VERSION}"
  VIAddVersionKey "ProductName" "${MOD_NAME}"
  VIAddVersionKey "ProductVersion" "${FULL_VERSION}"
  VIAddVersionKey "OriginalFilename" "${FILE_NAME}.exe"

; Language files
  !addincludedir .\Language
  !include English.nsh

; Variables
  
  

Name "${MOD_NAME} ${VERSION}"
OutFile "..\bin\${FILE_NAME}.exe"
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

  ; Language
    !insertmacro MUI_LANGUAGE "English"

; Reserve files (for solid compression)
#  ReserveFile NSISdl.dll
#  ReserveFile Dialogs.dll

InstallDirRegKey HKLM "SOFTWARE\TAUniverse\TA Patch" "Path"

; Install sections

Section "Default"
  StrCpy $INSTDIR "$INSTDIR\${REG_NAME}"
  !cd ..\data
  File /r ".\*"
  File "modinfo.cfg" ; required I guess
  !cd ..\script
SectionEnd

; Functions

Function ".onInit"
  SetRegView 32
  ReadRegStr $5 "SOFTWARE\TAUniverse\TA Patch" "Version"
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
        MessageBox MB_YESNO|MB_ICONSTOP "$(incompat_patch)" IDNO abort
        # dl stuff
        abort:
        Abort
      ${Else}
        MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(old_patch)" IDNO skip
        # dl stuff
        skip:
      ${EndIf}
  ${EndIf}
FunctionEnd
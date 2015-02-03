; Total Annihilation new unofficial patch project -- mod installer language file: English
; by Skirmisher

; Mod: Development Mod 1.4 by Rime #(edit to suit your mod--don't feel like you have to leave the default text, it's your copy after all ;) )#

; LangStrings
LangString name ${LANG_ENGLISH} "${MOD_NAME} ${VERSION}"
LangString caption ${LANG_ENGLISH} "${MOD_NAME} ${VERSION} Installer"
LangString abortwarning ${LANG_ENGLISH} "Are you sure you want to abort installation? Your TA installation could be damaged!"
LangString welcome_title ${LANG_ENGLISH} "Welcome to the ${MOD_NAME} Installer"
LangString welcome_text ${LANG_ENGLISH} "This will install the TA mod ${MOD_NAME} on your computer.$\n$\nPress Next to begin installation setup."
LangString no_patch ${LANG_ENGLISH} "The TA Unofficial Patch was not detected, is damaged, or is older than 4.0.0. In order to install ${MOD_NAME}, you must first install the patch and its associated resources. If you're not sure what this means, try downloading the $\"all-in-one$\" or $\"new player$\" installer from the mod's site (${WEBSITE})."
LangString old_patch ${LANG_ENGLISH} "The TA Unofficial Patch was detected, but is not the newest version known by this installer. You may proceed with installation; however, it is advised you update your patch installation.$\n$\nWould you like to download the newest version now?"
LangString incompat_patch ${LANG_ENGLISH} "The version of the TA Unofficial Patch installed on your computer is incompatible with this version of ${MOD_NAME}. Would you like to download and install the latest patch now?"
LangString directory_header ${LANG_ENGLISH} "Select Directory"
LangString directory_header_sub ${LANG_ENGLISH} "Select the directory to install ${MOD_NAME} in."
LangString directory_desc ${LANG_ENGLISH} "It is recommended that you install all TA mods as subdirectories of your main TA folder; however, you may install a mod anywhere you wish, and it will work correctly."
LangString directory_box ${LANG_ENGLISH} "${MOD_NAME}"
LangString smfolder_disable ${LANG_ENGLISH} "Don't create a Start Menu folder"

; Language-specific version keys
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Installer for ${MOD_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "TAUP copyright © 2015 Total Annihilation Universe & contributors"
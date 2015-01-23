; Total Annihilation new unofficial patch project -- patch installer language file: English
; by Skirmisher

; LangStrings
LangString name ${LANG_ENGLISH} "TA Unofficial Patch ${VERSION}"
LangString caption ${LANG_ENGLISH} "TA Unofficial Patch ${VERSION} Installer"
LangString abortwarning ${LANG_ENGLISH} "Are you sure you want to abort installation? Your TA installation could be damaged!"
LangString windowcrash ${LANG_ENGLISH} "Failed to initialize window!"
#LangString rescheck_fail ${LANG_ENGLISH} "Total Annihilation Patch Resources not found.$\n$\nWould you like to download it now?"
LangString rescheck_old ${LANG_ENGLISH} "TA Patch Resources found, but are out of date. You may continue, but you may be missing some critical or updated TA resources.$\n$\nWould you like to download the newest version now?"
LangString rescheck_incompat ${LANG_ENGLISH} "This version of the TA Unofficial Patch requires a TA Patch Resources update before it can be installed. Would you like to download and install the latest patch resources now?"
LangString resinst ${LANG_ENGLISH} "The TA Patch Resources (newer than 1.0) are required as part of this installation. Click Yes to select the installer from your computer, or click No to download the resources installer."
LangString res_install_fail ${LANG_ENGLISH} "TA Patch Resources install not detected! Either the installer failed/was canceled, or you selected the wrong EXE. Please restart this installer to continue."
LangString selres ${LANG_ENGLISH} "Select the TA Patch Resources Installer"
LangString welcome_title ${LANG_ENGLISH} "Welcome to the TA Unofficial Patch Installer"
LangString welcome_text ${LANG_ENGLISH} "This will install the unofficial Total Annihilation patch on your computer.$\n$\nPress Next to begin installation setup."
LangString directories_header ${LANG_ENGLISH} "Select TA and Common Directories"
LangString directories_header_sub ${LANG_ENGLISH} "Select the Total Annihilation directory to install the patch into, and folders to move common maps/data into."
LangString directories_desc ${LANG_ENGLISH} "The common maps directory will be used by the game and its mods to read third-party and official maps from, to avoid unnecessary redundancy between mod installs. During the installation, you will be asked which UFO files you wish to move to this directory. In addition, the original TA data files will be moved to a separate common data directory; it is advised you leave this directory at the default value."
LangString directories_TA ${LANG_ENGLISH} "TA directory:"
LangString directories_maps ${LANG_ENGLISH} "Common maps directory:"
LangString directories_data ${LANG_ENGLISH} "Common data directory:"
LangString directories_browse ${LANG_ENGLISH} "Browse..."
LangString directories_browse_TA ${LANG_ENGLISH} "Select TA installation directory:"
LangString directories_browse_maps ${LANG_ENGLISH} "Select folder to place common maps in:"
LangString directories_browse_data ${LANG_ENGLISH} "Select folder to place common game data in:"
LangString directory_invalid ${LANG_ENGLISH} "TotalA.exe was not detected in the TA directory you selected. Verify that you have selected your TA directory."

; Language-specific version keys
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Installer for the TA Unofficial Patch"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copyright � 2015 Total Annihilation Universe & contributors"
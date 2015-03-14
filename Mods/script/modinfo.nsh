; Total Annihilation new unofficial patch project -- mod info header
; Mod: Development Mod 1.4 by Rime
#(edit to suit your mod--also see script/Languages/*.nsh files)#

!define VERSION 1.4
!define FULL_VERSION 1.4.0.0 ; four-segment version for installer version key
!define MOD_NAME "TA Development Mod"
!define REG_NAME "TA Dev Mod" ; do not use slashes of any kind!!
!define FILE_NAME "TA_Dev_Mod_${VERSION}" ; do not specify .exe extension
!define WEBSITE "http://plobex.pl/devmod/"
!define DL_ADDRESS "http://totalconcat.org/TA/devmod" ; location where auto-updater will look for version manifest and installers
!define KNOWN_PATCH_VER 4.0.0 ; current patch as of compile time, suggests to update if user has older version
!define LAST_COMPAT_VER 4.0.0 ; will not install if patch is older than this
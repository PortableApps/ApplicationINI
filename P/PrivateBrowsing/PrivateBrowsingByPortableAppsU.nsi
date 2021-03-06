﻿;Copyright 2010-2017 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/PrivateBrowsing

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define PORTABLEAPPNAME "Private Browsing by PortableApps.com"
!define APPNAME "Firefox"
!define NAME "PrivateBrowsingByPortableApps"
!define VER "4.1.0.0"
!define WEBSITE "PortableApps.com/PrivateBrowsing"
!define DEFAULTEXE "firefox.exe"
!define DEFAULTAPPDIR "firefox"
!define LAUNCHERLANGUAGE "English"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "Firefox is a Registered Trademark of The Mozilla Foundation.  PortableApps.com is a Registered Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
Unicode true
ManifestDPIAware true
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
XPStyle on

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParameters ;Requires NSIS 2.40 or better
!include LogicLib.nsh
!include TextFunc.nsh
!insertmacro GetParent

;(Custom)
!include ReadINIStrWithDefault.nsh


;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;=== Variables
Var DISABLESPLASHSCREEN
Var MISSINGFILEORPATH
Var strPortableAppsPath

Section "Main"
	${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"

	${GetParent} $EXEDIR $strPortableAppsPath

	${If} ${FileExists} `$strPortableAppsPath\FirefoxPortable\FirefoxPortable.exe`
		;Check if already running
		FindProcDLL::FindProc "FirefoxPortable.exe"
		${If} $R0 != "1"		
			;Not Running
			
			;Show Splash
			${If} $DISABLESPLASHSCREEN == "false"
				InitPluginsDir
				File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
				newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L $PLUGINSDIR\splash.jpg
			${EndIf}
			
			;Get current launcher
			Delete "$EXEDIR\Data\FirefoxPortable.exe"
			CreateDirectory "$EXEDIR\Data"
			CopyFiles /SILENT "$strPortableAppsPath\FirefoxPortable\FirefoxPortable.exe" "$EXEDIR\Data"
			
			;Setup INI File
			${IfNot} ${FileExists} `$EXEDIR\FirefoxPortable.ini`
				CopyFiles /SILENT "$EXEDIR\App\DefaultData\FirefoxPortable.ini" "$EXEDIR\Data"
			${EndIf}
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "FirefoxDirectory" "..\..\FirefoxPortable\App\firefox"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "ProfileDirectory" "profile"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "SettingsDirectory" "settings"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "PluginsDirectory" "plugins"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "DisableSplashScreen" "true"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "AdditionalParameters" "-private"
			
			;Check for profile
			${IfNot} ${FileExists} `$EXEDIR\Data\profile\*.*`
				CreateDirectory "$EXEDIR\Data"
				CreateDirectory "$EXEDIR\Data\plugins"
				CreateDirectory "$EXEDIR\Data\profile"
				CreateDirectory "$EXEDIR\Data\settings"
				CopyFiles /SILENT "$EXEDIR\App\DefaultData\plugins\*.*" "$EXEDIR\Data\plugins"
				CopyFiles /SILENT "$EXEDIR\App\DefaultData\profile\*.*" "$EXEDIR\Data\profile"
			${EndIf}
			
			;Replace Firefox Icon
			${If} ${FileExists} `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\main-window.ico`
				Rename `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\main-window.ico` `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\main-window.ico-backup`
			${EndIf}
			${If} ${FileExists} `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\main-window.ico`
				Rename `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\main-window.ico` `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\main-window.ico-backup`
			${EndIf}
			CreateDirectory `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome`
			CreateDirectory `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons`
			CreateDirectory `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default`
			CopyFiles /SILENT `$EXEDIR\App\AppInfo\appicon.ico` `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default`
			Rename `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\appicon.ico` `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\main-window.ico`
			CreateDirectory `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome`
			CreateDirectory `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons`
			CreateDirectory `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default`
			CopyFiles /SILENT `$EXEDIR\App\AppInfo\appicon.ico` `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default`
			Rename `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\appicon.ico` `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\main-window.ico`
			
			;Check command line paramters
			${GetParameters} $0
			${If} $0 == ""
				ExecWait `"$EXEDIR\Data\FirefoxPortable.exe"`
			${Else}
				ExecWait `"$EXEDIR\Data\FirefoxPortable.exe" $0`
			${EndIf}
			
			;Restore Firefox Icon
			Delete `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\main-window.ico`
			Rename `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\main-window.ico-backup` `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default\main-window.ico`
			RMDir `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\default`
			RMDir `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome\icons\`
			RMDir `$strPortableAppsPath\FirefoxPortable\App\Firefox\browser\chrome`
			Delete `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\main-window.ico`
			Rename `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\main-window.ico-backup` `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default\main-window.ico`
			RMDir `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\default`
			RMDir `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome\icons\`
			RMDir `$strPortableAppsPath\FirefoxPortable\App\Firefox64\browser\chrome`
		${Else}
			;Some other copy is already running
			MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		${EndIf}
	${Else}
		;Firefox Portable isn't installed
		StrCpy $MISSINGFILEORPATH "$strPortableAppsPath\FirefoxPortable\FirefoxPortable.exe"
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
	${EndIf}
	newadvsplash::stop /WAIT
SectionEnd
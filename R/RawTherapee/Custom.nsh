${SegmentFile}

${SegmentInit}
    ${If} ${IsWinXP}
	${AndIf} $Bits == 64
		StrCpy $Bits 32
	${EndIf}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\RawTherapee\x64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\RawTherapee\x86
    ${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comDocuments%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		${GetParent} $EXEDIR $3
		${GetParent} $3 $1
		${If} $1 == "" ;Be sure we didn't just GetParent on Root
			StrCpy $1 $3
		${EndIf}
		${If} ${FileExists} "$1\Documents\*.*"
			StrCpy $2 "$1\Documents"
		${Else}
			${GetRoot} $EXEDIR $1
			${If} ${FileExists} "$1\Documents\*.*"
				StrCpy $2 "$1\Documents"
			${Else}
				StrCpy $2 "$1"
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDocuments", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comVideos%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Videos\*.*"
			StrCpy $2 "$1\Videos"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Videos\*.*"
				StrCpy $2 "$1\Videos"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Videos\*.*"
					StrCpy $2 "$1\Videos"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comVideos", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comPictures%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Pictures\*.*"
			StrCpy $2 "$1\Pictures"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Pictures\*.*"
				StrCpy $2 "$1\Pictures"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Pictures\*.*"
					StrCpy $2 "$1\Pictures"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comPictures", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comMusic%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Music\*.*"
			StrCpy $2 "$1\Music"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Music\*.*"
				StrCpy $2 "$1\Music"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Music\*.*"
					StrCpy $2 "$1\Music"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comMusic", "$2").r0'
	${EndIf}
!macroend

${SegmentPrePrimary}
	;=== Temporary hack to see if we're getting the language code from the platform
	ReadEnvStr $0 PortableApps.comLanguageNSIS

    ${If} $0 != ""
		WriteINIStr $EXEDIR\Data\settings\options "General" "LanguageAutoDetect" "false"
    ${EndIf}
!macroend

${SegmentPreExec}
	${If} ${IsWinXP}
		${WordReplace} $ExecString "App\RawTherapee\x64" "App\RawTherapee\x86" "+" $ExecString
	${EndIf}
!macroend
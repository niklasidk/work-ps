@ECHO ON

REM Schnelle Notebooks explizit f r den lokalen Start von P@PPS freigeben
:BEGINN

	
:WIN_7
	C:
	cd \

	SET QUELL=\\DEAR-AP-PPS04\PAPPS_Produktiv
	SET FRONTEND=\\DEAR-AP-PPS04\PAPPS_Produktiv\FRONTEND_74
	SET UMGEBUNG=\\DEAR-AP-PPS04\PAPPS_Produktiv\UMGEBUNG_74
	SET ZIEL=C:\P@PPS
	SET PAPPS_ORDNER=P@PPS
	SET LOKAL_LW=C
	

:PC_PRUEFEN
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD01 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD02 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD03 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD04 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD05 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD06 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD07 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RD99 GOTO WEITER
	REM IF %COMPUTERNAME% EQU DEAR-TS-RDTEST1 GOTO WEITER

	IF %COMPUTERNAME% EQU DEGT-LT-1056 GOTO WEITER
	IF %COMPUTERNAME% GEQ DEAR-TC-0000 GOTO PC_LANGSAM
	
	IF %COMPUTERNAME% GEQ DEAR-LT-1000 GOTO WEITER
	IF %COMPUTERNAME% GEQ DEAR-DP-1000 GOTO WEITER
	IF %COMPUTERNAME% GEQ ARPC5001 GOTO WEITER
	IF %COMPUTERNAME% GEQ ARPC0800 GOTO WEITER
	IF %COMPUTERNAME% GEQ ARLAP055 GOTO WEITER
	IF %COMPUTERNAME% GEQ DENM-LT-1072 GOTO WEITER
	

	REM Alle PCs, die eine kleinere Nummer haben als ARPC0517, sind f r einen lokalen P@PPS-Start zu langsam.
	REM Deshalb werden diese PCs f r einen lokalen Start von P@PPS gesperrt.
	REM IF %COMPUTERNAME% EQU ARPC0600 GOTO PC_LANGSAM

	IF %COMPUTERNAME% LSS ARPC0517 GOTO PC_LANGSAM
	IF %COMPUTERNAME% LSS ARPC0799 IF %COMPUTERNAME% GEQ ARPC0700 GOTO PC_LANGSAM
	REM 	IF %COMPUTERNAME% GEQ ARPC0999 GOTO PC_LANGSAM
	
	GOTO PC_LANGSAM

	
:WEITER
	REM Pr fen, ob mit dem aktuellen PAPPS-Release gearbeitet wird. Falls nicht wird der PAPPS-Ordner gel scht und neu angelegt.

	REM IF EXIST %ZIEL%\papps_4_4_8.txt GOTO INSTALL
	REM IF EXIST %ZIEL%\nul GOTO INSTALL

	REM Abfrage welcher Ordner auf Laufwerk C vorhanden ist.
	IF EXIST C:\P@PPS (
		SET FRONTEND=\\DEAR-AP-PPS04\PAPPS_Produktiv\FRONTEND_74
		SET UMGEBUNG=\\DEAR-AP-PPS04\PAPPS_Produktiv\UMGEBUNG_74
		SET PAPPS_ORDNER=P@PPS
		SET ZIEL=C:\P@PPS
	)
	IF EXIST C:\P@PPS62 (
		SET FRONTEND=\\DEAR-AP-PPS04\PAPPS_Produktiv\FRONTEND_62
		SET UMGEBUNG=\\DEAR-AP-PPS04\PAPPS_Produktiv\UMGEBUNG_62
		SET PAPPS_ORDNER=P@PPS62
		SET ZIEL=C:\P@PPS62
	)
	
	
:LOESCHEN_PAPPS_ORDNER
	%LOKAL_LW%:
	cd \
	RD %PAPPS_ORDNER% /S /Q 
	

	REM Loeschen des PAPPS-Ordners C:\P@PPS_62, falls vorhanden, der zum Test des Release mit TD_62 eingerichtet wurde
	%LOKAL_LW%:
	cd \
	IF EXIST C:\P@PPS_62 RD P@PPS_62 /S /Q


:ANLEGEN_PAPPS_ORDNER
    %LOKAL_LW%:
 	cd\
	md %PAPPS_ORDNER%
	G:
	cd  \DEAR\AR-APPLIKATIONEN\PAPPS
	xcacls.exe %LOKAL_LW%:\%PAPPS_ORDNER% /T /E /G Benutzer:F /Y

:INSTALL

	xcopy %Frontend%\*.* %ZIEL%\*.* /D /E /F /R /Y
	xcopy %Umgebung%\Runtime\*.* %ZIEL%\*.* /D /E /F /R /Y
	xcopy %Umgebung%\Konfig\sql.ini %ZIEL%\*.* /D /E /F /R /Y
	xcopy %Umgebung%\Konfig\kb-mobile.ini %ZIEL%\*.* /D /E /F /R /Y
        xcopy %Umgebung%\Konfig\papps.ini %ZIEL%\*.* /D /E /F /R /Y
	xcopy %Umgebung%\Konfig\papps_fonts.reg %ZIEL%\*.* /D /E /F /R /Y

	if not exist %WINDIR%\esalib.ini copy %Frontend%\esalib.ini %WINDIR%\esalib.ini >nul
	if not exist %WINDIR%\Fonts\code_128.ttf copy %Frontend%\code_128.ttf %WINDIR%\Fonts\code_128.ttf >nul
	if not exist %WINDIR%\Fonts\3of9.ttf copy %Frontend%\3of9.ttf %WINDIR%\Fonts\3of9.ttf >nul
	if not exist %WINDIR%\Fonts\CV30_1.ttf copy %Frontend%\CV30_1.ttf %WINDIR%\Fonts\CV30_1.ttf >nul
	if not exist %WINDIR%\Fonts\CV30_2.ttf copy %Frontend%\CV30_2.ttf %WINDIR%\Fonts\CV30_2.ttf >nul
	if not exist %WINDIR%\Fonts\CV30_3.ttf copy %Frontend%\CV30_3.ttf %WINDIR%\Fonts\CV30_3.ttf >nul
	
	IF EXIST %LOKAL_LW%:\app\ora219\network\ADMIN copy %Umgebung%\Konfig\tnsnames.ora %LOKAL_LW%:\app\ora219\network\ADMIN\*.* /y
	IF EXIST %LOKAL_LW%:\app\ora219\network\ADMIN copy %Umgebung%\Konfig\sqlnet.ora %LOKAL_LW%:\app\ora219\network\ADMIN\*.* /y


	REM call regedit /s %LOKAL_LW%:\%PAPPS_ORDNER%\papps_fonts.reg

	
	REM  berpr fen, ob IT-User
    IF /I %USERNAME% == YAPICILAYA 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == KLUTECH 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == HOFFMANNSE 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == GUNTERMAAN 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == KOESTERHE 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == VELTINDI 	GOTO INSTALL_IT_HILFE
	
	
	
:INSTALL_ANWENDER_HILFE
	REM Hilfedatei f r Normale PAPPS-Anwender kopieren
	IF EXIST %ZIEL%\Help_IT.txt DEL %ZIEL%\Help_IT.txt /F
	IF EXIST %ZIEL%\Help_Anwender.txt xcopy %QUELL%\Help\Anwender\*.* %ZIEL%\*.* /D /E /F /R /Y
	IF NOT EXIST %ZIEL%\Help_Anwender.txt xcopy %QUELL%\Help\Anwender\*.* %ZIEL%\*.* /D /E /F /R /Y
	GOTO PARAM_PRUEFEN 
	
:INSTALL_IT_HILFE
	REM Hilfedatei f r IT-Abteilung kopieren
	IF EXIST %ZIEL%\Help_Anwender.txt DEL %ZIEL%\Help_Anwender.txt /D /E /F /R /Y
	IF EXIST %ZIEL%\Help_IT.txt xcopy %QUELL%\Help\IT\*.* %ZIEL%\*.* /D /E /F /R /Y
	IF NOT EXIST %ZIEL%\Help_IT.txt xcopy %QUELL%\Help\IT\*.* %ZIEL%\*.* /D /E /F /R /Y
	GOTO PARAM_PRUEFEN 
	
:PARAM_PRUEFEN
	IF "%1" == "" GOTO START_PAPPS


:START_KEIN_PAPPS
	%LOKAL_LW%:
	cd \%PAPPS_ORDNER%
	REM start sqlini.exe clientname=%COMPUTERNAME%
	start %1
	
	GOTO ENDE

:START_PAPPS
	%LOKAL_LW%:
	cd \%PAPPS_ORDNER%
REM 	start sqlini.exe clientname=%COMPUTERNAME%
REM	start P@PPS.EXE

	GOTO ENDE


:PC_LANGSAM
	@ECHO OFF
	CLS
	COLOR fc
	MODE CON:cols=85 lines=40

	ECHO **********************************************************************************
	ECHO **********************************************************************************
	ECHO **********************************************************************************
	ECHO **********                                                            ************
	ECHO **********  Ihr PC %COMPUTERNAME% ist zu langsam.                     ************
	ECHO **********                                                            ************
	ECHO **********  Auf diesem PC kann PAPPS nicht                            ************
	ECHO **********                                                            ************
	ECHO **********  LOKAL gestartet werden.                                   ************
	ECHO **********                                                            ************
	ECHO **********************************************************************************
	ECHO **********                                                            ************
	ECHO **********  Wenn auf Ihrem PC CITRIX installiert ist, dann starten    ************
	ECHO **********                                                            ************
	ECHO **********  Sie PAPPS ueber CITRIX.   Die CITRIX-Anmeldung            ************
	ECHO **********                                                            ************
	ECHO **********  ist identisch mit der WINDOWS-Anmeldung                   ************
	ECHO **********                                                            ************
	ECHO **********************************************************************************
	ECHO **********                                                            ************
	ECHO **********  Falls auf Ihrem PC kein CITRIX installiert ist und Sie    ************
	ECHO **********                                                            ************
	ECHO **********  diese Meldung lesen, dann wenden Sie sich bitte an        ************
	ECHO **********                                                            ************
	ECHO **********  H. Yapicilar (269) oder H. Klute (700)                    ************
	ECHO **********                                                            ************
	ECHO **********************************************************************************
	ECHO **********************************************************************************
	ECHO **********************************************************************************


	pause
	GOTO ENDE

:ENDE

exit
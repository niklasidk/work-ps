@ECHO ON

REM Schnelle Notebooks explizit fï¿½r den lokalen Start von P@PPS freigeben
:BEGINN
	GOTO WIN_7
	REM IF %COMPUTERNAME% EQU ARPC0901 GOTO WIN_7
	REM IF %COMPUTERNAME% EQU DEAR-DP-1019 GOTO WIN_7
	REM IF EXIST "C:\Program Files (x86)" GOTO WIN_7
	
:WIN_7
	C:
	cd \

	SET QUELL=\\DEAR-AP-PPS04\PAPPS_Produktiv
	SET FRONTEND=\\DEAR-AP-PPS04\PAPPS_Produktiv\FRONTEND_74
	SET UMGEBUNG=\\DEAR-AP-PPS04\PAPPS_Produktiv\UMGEBUNG_74
	SET ZIEL=C:\P@PPS
	SET PAPPS_ORDNER=P@PPS
	SET LOKAL_LW=C
	SET DUMMY_DATEI=papps_4_5_9.txt
	
:ERSTER_START_NACH_REL
	if not exist C:\TEMP\rel_18.05.23.txt (
		IF EXIST C:\P@PPS rd /s /q C:\P@PPS
		IF EXIST C:\P@PPS_62 rd /s /q C:\P@PPS_62
		IF EXIST C:\P@PPS_74 rd /s /q C:\P@PPS_74
	echo Diese Datei NICHT löschen! > C:\TEMP\rel_18.05.23.txt
	)

:PC_PRUEFEN
	IF %COMPUTERNAME% EQU DEAR-TS-RD01 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RD02 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RD03 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RD04 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RD05 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RD06 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RD07 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RD99 GOTO RDS_SERVER
	IF %COMPUTERNAME% EQU DEAR-TS-RDTEST1 GOTO RDS_SERVER


	
	
:WEITER
	REM Prüfen, ob mit dem aktuellen PAPPS-Release gearbeitet wird. Falls nicht wird der PAPPS-Ordner gelöscht und neu angelegt.
		IF EXIST C:\P@PPS_62 RD C:\P@PPS_62 /S /Q
        IF EXIST %ZIEL%\%DUMMY_DATEI% GOTO INSTALL
	REM IF EXIST %ZIEL%\nul GOTO INSTALL 
	
	
:LOESCHEN_PAPPS_ORDNER
	%LOKAL_LW%:
	cd \
	RD %PAPPS_ORDNER% /S /Q

	REM Loeschen des PAPPS-Ordners C:\P@PPS_62, falls vorhanden, der zum Test des Release mit TD_62 eingerichtet wurde
	%LOKAL_LW%:
	cd \
	REM Wenn %DUMMY_DATEI% nicht vorhanden lösche..
	IF EXIST C:\P@PPS RD C:\P@PPS /S /Q


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
	
	IF EXIST %LOKAL_LW%:\app\ora219\network\ADMIN\NUL copy %Umgebung%\Konfig\tnsnames.ora %LOKAL_LW%:\app\ora219\network\ADMIN\*.* /y
	IF EXIST %LOKAL_LW%:\app\ora219\network\ADMIN\NUL copy %Umgebung%\Konfig\sqlnet.ora %LOKAL_LW%:\app\ora219\network\ADMIN\*.* /y
	

	REM call regedit /s %LOKAL_LW%:\%PAPPS_ORDNER%\papps_fonts.reg

	
	REM ï¿½berprï¿½fen, ob IT-User
    IF /I %USERNAME% == YAPICILAYA 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == KLUTECH 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == HOFFMANNSE 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == GUNTERMAAN 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == KOESTERHE 	GOTO INSTALL_IT_HILFE		
	IF /I %USERNAME% == VELTINDI 	GOTO INSTALL_IT_HILFE
	
	
	
:INSTALL_ANWENDER_HILFE
	REM Hilfedatei fï¿½r Normale PAPPS-Anwender kopieren
	IF EXIST %ZIEL%\Help_IT.txt DEL %ZIEL%\Help_IT.txt /F
	IF EXIST %ZIEL%\Help_Anwender.txt xcopy %QUELL%\Help\Anwender\*.* %ZIEL%\*.* /D /E /F /R /Y
	IF NOT EXIST %ZIEL%\Help_Anwender.txt xcopy %QUELL%\Help\Anwender\*.* %ZIEL%\*.* /D /E /F /R /Y
	GOTO PARAM_PRUEFEN 
	
:INSTALL_IT_HILFE
	REM Hilfedatei fï¿½r IT-Abteilung kopieren
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
	start P@PPS.EXE

	GOTO ENDE


:RDS_SERVER
	@ECHO OFF
	CLS
	COLOR fc
	MODE CON:cols=85 lines=40

	ECHO **********************************************************************************
	ECHO **********************************************************************************
	ECHO **********************************************************************************
	ECHO **********                                                            ************
	ECHO **********  Sie versuchen gerade auf einem RDS-Server                 ************
	ECHO **********                                                            ************
	ECHO **********  PAPPS lokal  zu starten                                   ************
	ECHO **********                                                            ************
	ECHO **********   Das ist leider nicht moeglich                            ************
	ECHO **********                                                            ************
	ECHO **********************************************************************************
	ECHO **********                                                            ************
	ECHO **********  Bitte melden sie sich bei ihrer IT-Abteilung              ************
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
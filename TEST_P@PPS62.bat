@ECHO ON

REM Schnelle Notebooks explizit f�r den lokalen Start von P@PPS freigeben
:BEGINN

:WIN_7
	C:
	cd \

	SET QUELL=\\DEAR-AP-PPS01\PAPPS_TEST
	SET FRONTEND=\\DEAR-AP-PPS01\PAPPS_TEST\FRONTEND_62
	SET UMGEBUNG=\\DEAR-AP-PPS01\PAPPS_TEST\UMGEBUNG_62
	SET ZIEL=C:\P@PPS_TEST62
	SET PAPPS_ORDNER=P@PPS_TEST62
	SET LOKAL_LW=C
	SET DUMMY_DATEI=papps_4_5_9.txt

:ERSTER_START
	if not exist C:\TEMP\test_rel_18.05.23 (
		rd /s /q C:\PAPPS_TEST62
		rd /s /q C:\PAPPS_TEST
		rd /s /q C:\PAPPS_TEST74
	echo > C:\TEMP\test_rel_18.05.23
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
	REM Pr�fen, ob P@PPS schonmal auf diesem Rechner gestartet wurde
        IF EXIST %ZIEL%\%DUMMY_DATEI% GOTO INSTALL
	REM IF EXIST %ZIEL%\ GOTO INSTALL

	
:LOESCHEN_PAPPS_ORDNER
	%LOKAL_LW%:
	cd \
	RD %PAPPS_ORDNER% /S /Q
        REM Loeschen des PAPPS-Ordners C:\P@PPS_TEST62, falls vorhanden, der zum Test des Release mit TD_62 eingerichtet wurde
	%LOKAL_LW%:
	cd \
	IF EXIST C:\P@PPS_TEST62 RD P@PPS_TEST62 /S /Q
	IF EXIST C:\P@PPS_TEST RD P@PPS_TEST /S /Q

:ANLEGEN_PAPPS_ORDNER
    %LOKAL_LW%:
 	cd\
	md %PAPPS_ORDNER%
	G:
	cd DEAR\AR-APPLIKATIONEN\PAPPS
	xcacls.exe %LOKAL_LW%:\%PAPPS_ORDNER% /T /E /G Benutzer:F /Y

:INSTALL

	xcopy %Frontend%\*.* %ZIEL%\*.* /D /R /Y
	xcopy %Umgebung%\Runtime\*.* %ZIEL%\*.* /D /R /Y
	xcopy %Umgebung%\Konfig\sql.ini %ZIEL%\*.* /D /R /Y
	xcopy %Umgebung%\Konfig\kb-mobile.ini %ZIEL%\*.* /D /R /Y
    xcopy %Umgebung%\Konfig\papps.ini %ZIEL%\*.* /D /R /Y
	xcopy %Umgebung%\Konfig\papps_fonts.reg %ZIEL%\*.* /D /R /Y

	if not exist %WINDIR%\esalib.ini copy %Frontend%\esalib.ini %WINDIR%\esalib.ini >nul
	if not exist %WINDIR%\Fonts\code_128.ttf copy %Frontend%\code_128.ttf %WINDIR%\Fonts\code_128.ttf >nul
	if not exist %WINDIR%\Fonts\3of9.ttf copy %Frontend%\3of9.ttf %WINDIR%\Fonts\3of9.ttf >nul
	if not exist %WINDIR%\Fonts\CV30_1.ttf copy %Frontend%\CV30_1.ttf %WINDIR%\Fonts\CV30_1.ttf >nul
	if not exist %WINDIR%\Fonts\CV30_2.ttf copy %Frontend%\CV30_2.ttf %WINDIR%\Fonts\CV30_2.ttf >nul
	if not exist %WINDIR%\Fonts\CV30_3.ttf copy %Frontend%\CV30_3.ttf %WINDIR%\Fonts\CV30_3.ttf >nul


	IF EXIST C:\app\ora219\network\ADMIN\ copy %QUELL%\Umgebung_62\Konfig\tnsnames.ora C:\app\ora219\network\ADMIN\*.* /Y
	IF EXIST C:\app\ora219\network\ADMIN\ copy %QUELL%\Umgebung_62\Konfig\sqlnet.ora C:\app\ora219\network\ADMIN\*.* /Y
	

	REM call regedit /s %LOKAL_LW%:\%PAPPS_ORDNER%\papps_fonts.reg

	REM �berpr�fen, ob IT-User
    IF /I %USERNAME% == YAPICILAYA 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == KLUTECH 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == HOFFMANNSE 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == GUNTERMAAN 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == KOESTERHE 	GOTO INSTALL_IT_HILFE
	IF /I %USERNAME% == VELTINDI 	GOTO INSTALL_IT_HILFE
	
	
:INSTALL_ANWENDER_HILFE
	REM Hilfedatei f�r Normale PAPPS-Anwender kopieren
	IF EXIST %ZIEL%\Help_IT.txt DEL %ZIEL%\Help_IT.txt /F
	IF EXIST %ZIEL%\Help_Anwender.txt xcopy %QUELL%\Help\Anwender\*.* %ZIEL%\*.* /R /Y /D
	IF NOT EXIST %ZIEL%\Help_Anwender.txt xcopy %QUELL%\Help\Anwender\*.* %ZIEL%\*.* /R /Y
	GOTO PARAM_PRUEFEN 
	
:INSTALL_IT_HILFE
	REM Hilfedatei f�r IT-Abteilung kopieren
	IF EXIST %ZIEL%\Help_Anwender.txt DEL %ZIEL%\Help_Anwender.txt /F
	IF EXIST %ZIEL%\Help_IT.txt xcopy %QUELL%\Help\IT\*.* %ZIEL%\*.* /R /Y /D
	IF NOT EXIST %ZIEL%\Help_IT.txt xcopy %QUELL%\Help\IT\*.* %ZIEL%\*.* /R /Y
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
	REM start sqlini.exe clientname=%COMPUTERNAME%
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
	ECHO **********  PAPPS lokal zu starten                                    ************
	ECHO **********                                                            ************
	ECHO **********  Das ist leider nicht moeglich                             ************
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
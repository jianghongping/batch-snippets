@echo on
:start
REM ***********************************************************************
REM **  File Name: AM7OBEHW.CMD
REM **   
REM **  Description:
REM **    AM7OBEHW.CMD is for AM7 model OBE HardWare Check.
REM **         
REM ************************************************************************

echo.
echo ******** Starting Configuration Check *********
echo.
CALL X:\install.bat
x:\windelay 3
copy t:\hwcheck\AM7A00USB\HCSwitch\x86\*.* x:\ /y
copy t:\hwcheck\AM7A00USB\xHCI\x86\*.* x:\ /y
x:\windelay 2
cd x:\windows\system32
drvload.exe x:\iusb3hub.inf
x:\windelay 2
drvload.exe x:\iusb3xhc.inf
x:\windelay 2
drvload.exe x:\iusb3hcs.inf
x:\windelay 10

x:
cd \
CALL X:\response.cmd
SET SEV_CHK=
SET PPID_CHK=

if exist setsev.cmd del setsev.cmd
sdtASSET>setsev.cmd
call setsev.cmd
if "%ServiceTag%"=="%SEVTag%" goto sevpass
set SEV_CHK=FAIL

:sevpass
set SEV_CHK=PASS

if exist EPPID.CMD del EPPID.CMD
sdtEPPID /r>EPPID.CMD
call eppid.cmd
if "%BasePPID%"=="%EPPID%" goto ppidpass
set PPID_CHK=FAIL

:ppidpass
set PPID_CHK=PASS

IF "%SEV_CHK%"=="PASS" IF "%PPID_CHK%"=="PASS"  GOTO START_HWCHK
GOTO SPFAIL

:START_HWCHK
X:
CD\
CALL INSTALL.BAT
call seppid.cmd
REM call HwChkCode.cmd
CALL WCFGSET.CMD
WINDELAY 3
CALL WCFGDAT.CMD

CALL CPUCHK.CMD
CALL HDDCHK.CMD
REM CALL LCDCHK.CMD
CALL ODDCHK.CMD
CALL RAMCHK.CMD
CALL WIRECHK.CMD
CALL BATTCHK.CMD
CALL CAMCHK.CMD

SET CPU_CHK=
SET HDD_CHK=
REM SET LCD_CHK=
SET ODD_CHK=
SET RAM_CHK=
SET WL_CHK=
SET BAT_CHK=
SET CAM_CHK=

IF "%CPU_TP%"=="%CPU_Type%" SET CPU_CHK=PASS
IF "%HDD_SZ%"=="%HDD1_SIZE%" SET HDD_CHK=PASS
REM IF "%LCDSZ%"=="%LCD_Size%" SET LCD_CHK=PASS
IF "%ODD_Type%"=="%ODD_TP1%" SET ODD_CHK=PASS
IF "%RAM_SZ%"=="PASS" SET RAM_CHK=PASS
IF "%WLAN_TP%"=="%WLAN%" SET WL_CHK=PASS
IF "%BATT%"=="%BAT_TP%" SET BAT_CHK=PASS
IF "%CAM_TP%"=="%CCD%" SET CAM_CHK=PASS

IF NOT "%CPU_CHK%"=="PASS"  GOTO CHECK_FAIL
IF NOT "%HDD_CHK%"=="PASS"  GOTO CHECK_FAIL
REM IF NOT "%LCD_CHK%"=="PASS"  GOTO CHECK_FAIL
IF NOT "%ODD_CHK%"=="PASS" GOTO CHECK_FAIL
IF NOT "%RAM_CHK%"=="PASS" GOTO CHECK_FAIL
IF NOT "%WL_CHK%"=="PASS"  GOTO CHECK_FAIL
IF NOT "%BAT_CHK%"=="PASS" GOTO CHECK_FAIL
IF NOT "%CAM_CHK%"=="PASS" GOTO CHECK_FAIL
GOTO PASS

:CHECK_FAIL
SET HWCHK_STATUS=FAIL

cls
windelay 5
echo ******************** Hardware Check FAIL !!! FAIL !!! *******************>x:\error.log
IF NOT "%CPU_CHK%"=="PASS"  ECHO MACHINE:CPU TYPE=%CPU_TP% ( SF : %CPU_Type%)>>x:\error.log
IF NOT "%HDD_CHK%"=="PASS"  ECHO MACHINE:HDD TYPE=%HDD_SZ% ( SF : %HDD1_SIZE%)>>x:\error.log
IF NOT "%LCD_CHK%"=="PASS"  ECHO MACHINE:LCD SIZE=%LCDSZ% ( SF : %LCD_Size%)>>x:\error.log
IF NOT "%ODD_CHK%"=="PASS"  ECHO MACHINE:ODD TYPE=%ODD_Type% ( SF : %ODD_TP1%)>>x:\error.log
IF NOT "%RAM_CHK%"=="PASS"  ECHO MACHINE:RAM SIZE=%RamTotalSizeGB% ( SF : %RAMA_Size%%RAMB_Size%)>>x:\error.log
IF NOT "%WL_CHK%"=="PASS"  ECHO MACHINE:WIRELESS=%WLAN_TP% ( SF : %WLAN%)>>x:\error.log
IF NOT "%BAT_CHK%"=="PASS"  ECHO MACHINE:BATTERY=%BATT% ( SF : %BAT_TP%)>>x:\error.log
IF NOT "%CAM_CHK%"=="PASS"  ECHO MACHINE:CAMERA=%CAM_TP% ( SF : %CCD%)>> x:\error.log
echo **********************************************************************************************>>x:\error.log
echo.                                                                                                                     >>x:\error.log
echo    Please Check Hardware Configuration and Assembly Again, Thanks !!!   >>x:\error.log
echo.                                                                                                                     >>x:\error.log
echo **********************************************************************************************>>x:\error.log

echo ******************** Hardware Check FAIL !!! FAIL !!! *******************
IF NOT "%CPU_CHK%"=="PASS"  ECHO MACHINE:CPU TYPE=%CPU_TP% ( SF : %CPU_Type%)
IF NOT "%HDD_CHK%"=="PASS"  ECHO MACHINE:HDD TYPE=%HDD_SZ% ( SF : %HDD1_SIZE%)
IF NOT "%LCD_CHK%"=="PASS"  ECHO MACHINE:LCD SIZE=%LCDSZ% ( SF : %LCD_Size%)
IF NOT "%ODD_CHK%"=="PASS"  ECHO MACHINE:ODD TYPE=%ODD_Type% ( SF : %ODD_TP1%)
IF NOT "%RAM_CHK%"=="PASS"  ECHO MACHINE:RAM SIZE=%RamTotalSizeGB% ( SF : %RAMA_Size%%RAMB_Size%)
IF NOT "%WL_CHK%"=="PASS"  ECHO MACHINE:WIRELESS=%WLAN_TP% ( SF : %WLAN%)
IF NOT "%BAT_CHK%"=="PASS"  ECHO MACHINE:BATTERY=%BATT% ( SF : %BAT_TP%)
IF NOT "%CAM_CHK%"=="PASS"  ECHO MACHINE:CAMERA=%CAM_TP% ( SF : %CCD%)
echo **********************************************************************************************
echo.                                                                         
echo    Please Check Hardware Configuration and Assembly Again, Thanks !!!    
echo.                                                                         
echo **********************************************************************************************

rem ***************************************************************************************
rem ************************* Collect HW check fail information ***************************
rem ***************************************************************************************
echo The MACID of the failed machine is :%MACID%
windelay 5
goto fail_log

:fail_log
set number=0
>%ID% echo Result=Fail
>>%ID% echo SEVTag=%SEVTag%
>>%ID% echo MACID=%MACID%
>>%ID% echo ERRCODE=HWCF1
>>%ID% echo STATION=FAT

:CHKCPU
if "%CPU_CHK%"=="PASS" goto CHKHDD
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=CPU
>>%ID% ECHO ITEM%NUMBER%DEF=%CPU_Type%
>>%ID% ECHO ITEM%NUMBER%ACT=%CPU_TP%
    
:CHKHDD
if "%HDD_CHK%"=="PASS" goto CHKLCD
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=HDD
>>%ID% ECHO ITEM%NUMBER%DEF=%HDD1_SIZE%
>>%ID% ECHO ITEM%NUMBER%ACT=%HDD_SZ%

:CHKLCD
if "%LCD_CHK%"=="PASS" goto CHKODD
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=LCD>>%ID%
>>%ID% ECHO ITEM%NUMBER%DEF=%LCD_Size%
>>%ID% ECHO ITEM%NUMBER%ACT=%LCD_SZ%

:CHKODD
if "%ODD_CHK%"=="PASS" goto CHKRAM
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=ODD
>>%ID% ECHO ITEM%NUMBER%DEF=%ODD_TP1%
>>%ID% ECHO ITEM%NUMBER%ACT=%ODD_Type%

:CHKRAM
if "%RAM_CHK%"=="PASS" goto CHK_WLAN
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=RAM
>>%ID% ECHO ITEM%NUMBER%DEF=%RAMA_Size%%RAMB_Size%
>>%ID% ECHO ITEM%NUMBER%ACT=%RamTotalSizeGB%

:CHK_WLAN
if "%WL_CHK%"=="PASS" goto CHK_BATT
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=WLAN
>>%ID% ECHO ITEM%NUMBER%DEF=%WLAN%
>>%ID% ECHO ITEM%NUMBER%ACT=%WLAN_TP%

:CHK_BATT
if "%BAT_CHK%"=="PASS" goto CHK_CAM
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=BATTERY
>>%ID% ECHO ITEM%NUMBER%DEF=%BAT_TP%
>>%ID% ECHO ITEM%NUMBER%ACT=%BATT%

:CHK_CAM
if "%CAM_CHK%"=="PASS" goto fail
set /a number+=1
>>%ID% ECHO ITEM%NUMBER%=CAMERA
>>%ID% ECHO ITEM%NUMBER%DEF=%CCD%
>>%ID% ECHO ITEM%NUMBER%ACT=%CAM_TP%
goto fail

:pass
set errlvl=0
call remove.bat
goto end

:fail
color 4e
echo *************************
echo Hardware Check Fail
echo please check HW config
echo *************************
type x:\error.log
pause
pause
copy %ID% m:\HW_FAIL /y
set errlvl=1
goto end

:SPFAIL
ECHO *********************************************************
ECHO *      SEVICETAG OR EPPID WRITE FAILED    *
ECHO *********************************************************
SET ERRLVL=1
GOTO END

:end
cd x:\
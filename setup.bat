@echo off
title CCleaner Portable Download Manager
PUSHD %~dp0
cd /d "%~dp0"

:Permission check
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (set SystemPath = %SystemRoot%\SysWOW64) else (set SystemPath = %SystemRoot%\system32)
::rd "%SystemPath%\Test_Permissions" > nul 2 > nul
::md "%SystemPath%\Test_Permissions" 2 > nul || (echo Require Administrator Permission. && pause > nul && Exit)
::rd "%SystemPath%\Test_Permissions" > nul 2 > nul
del /f /q %SystemPath%\TestPermission.log
echo "Permission check." >> %SystemPath%\TestPermission.log
if not exist %SystemPath%\TestPermission.log (echo Require Administrator Permission. && pause > nul && Exit)
del /f /q %SystemPath%\TestPermission.log

:Ver
Ver|Find /I "5.1" > nul 2>nul 2>nul
If "%ERRORLEVEL%"=="0" (Goto Files check)
Ver|Find /I "5.2" > nul 2>nul 2>nul
If "%ERRORLEVEL%"=="0" (Goto Files check)
Ver|Find /I "6.0" > nul 2>nul 2>nul
If "%ERRORLEVEL%"=="0" (Goto Files check)
Ver|Find /I "6.1" > nul 2>nul 2>nul
If "%ERRORLEVEL%"=="0" (Goto Files check)
Ver|Find /I "6.2" > nul 2>nul 2>nul
If "%ERRORLEVEL%"=="0" (Goto Files check)
Ver|Find /I "6.3" > nul 2>nul 2>nul
If "%ERRORLEVEL%"=="0" (Goto Files check)
Cls 
Echo ��Ǹ��ȡϵͳ�汾������ȷ�����ϵͳ�Ƿ�ΪWindows XP/2003/Vista/2008/7/2008 R2/8/8.1����������˳���
Pause>nul
exit

:Files check
if not exist 7za_x86.exe  echo.&echo.&echo.&echo.&echo.&echo.&echo                                    ȱ�� 7za_x86.exe�����������ء�&echo.&echo.&echo.&echo.&echo
if exist "aria2\aria2c.exe" set aria2c="aria2\aria2c.exe" &goto Main
if exist "D:\�����\��ɫ����\���繤��\�ϴ�����\aria2\x64\aria2c.exe" set aria2c="D:\�����\��ɫ����\���繤��\�ϴ�����\aria2\x64\aria2c.exe"
if not exist "aria2\aria2c.exe" if not exist "D:\�����\��ɫ����\���繤��\�ϴ�����\aria2\x64\aria2c.exe"  echo.&echo.&echo.&echo.&echo.&echo.&echo                                    ȱ�� aria2�����������ء�&echo.&echo.&echo.&echo.&echo

:Main
cls
echo.
echo     ���� ����/��װ CCleaner......
echo.&echo.
echo     ������ %aria2c% ���ء�
echo.&echo.
echo     1)���أ�CCleaner-Portable
echo     2)���ݣ�CCleaner �����ļ�
echo     3)��װ���ͷ�ѹ������
echo.&echo.
echo     4)���ز���װ��CCleaner-Portable
echo.
echo     5)ɾ�������صİ�װ�ļ������ⲻͬ�ļ�����ضϵ�������
echo.
echo.&echo.
echo     ��л��������
echo     1)������32λ�� 7-Zip �����а汾���ڽ�ѹ����
echo     2)7-Zip ������ GNU LGPL Э�飬www.7-zip.org ���ܹ��ҵ���Դ���룻
echo     3)������ aria2 �� HTTP �������������ݡ�
echo.&echo.
echo     �汾��2015/1/27��������Hugo����ϵ��hugox.chan@gmail.com
echo.
echo ---------------------------------------------------------------------------
echo.
SET /P ST=   ���������֣�
echo. 
if /I "%ST%"=="1" goto Download
if /I "%ST%"=="2" goto Backup
if /I "%ST%"=="3" goto Setup
if /I "%ST%"=="4" goto Download-Setup
if /I "%ST%"=="5" goto Delete
echo    ��Чѡ�񣬰�������˳���
pause >nul
exit

:Download
if not exist ccsetup.zip.aria2 if exist ccsetup.zip del ccsetup.zip
rem netstat -an|find "LISTENING"|find ":8087" && set HTTP_PROXY=127.0.0.1:8087
%aria2c% -c -s16 -x16 -k1m --remote-time=true --enable-mmap --file-allocation=falloc --disk-cache=64M -o ccsetup.zip "http://www.piriform.com/ccleaner/download/portable/downloadfile"
echo.&echo    ������ɣ�����������ء�
pause >nul &goto Main

:Backup
if exist "%PROGRAMFILES%\CCleaner\ccleaner.ini" copy /y "%PROGRAMFILES%\CCleaner\ccleaner.ini"
echo.&echo    ������ɣ�����������ء�
pause >nul &goto Main

:Download-Setup
%aria2c% -c -s16 -x16 -k1m --remote-time=true --enable-mmap --file-allocation=falloc --disk-cache=64M -o ccsetup.zip "http://www.piriform.com/ccleaner/download/portable/downloadfile"

:Setup
if not exist ccsetup.zip echo δ�ҵ�ccsetup.zip�������ء� &echo.&pause &goto Main
Tasklist|Find /i "CCleaner.exe">nul&&(taskkill /im CCleaner.exe /f)
Tasklist|Find /i "CCleaner64.exe">nul&&(taskkill /im CCleaner64.exe /f)
7za_x86.exe x -y ccsetup.zip -o"%PROGRAMFILES%\CCleaner"
if not exist "%PROGRAMFILES%\CCleaner\ccleaner.ini" echo off>>"%PROGRAMFILES%\CCleaner\ccleaner.ini" &echo on
if exist ccleaner.ini copy /y ccleaner.ini "%PROGRAMFILES%\CCleaner"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\CCleaner.lnk""):b.TargetPath=""%PROGRAMFILES%\CCleaner\CCleaner.exe"":b.WorkingDirectory=""%PROGRAMFILES%\CCleaner"":b.Save:close")
echo.&echo    ��װ��ɣ���������˳���
pause >nul &exit

:Delete
if exist ccsetup* del ccsetup*
echo.&echo    ������ɣ�����������ء�
pause >nul &goto Main
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
Echo 抱歉读取系统版本出错，请确定你的系统是否为Windows XP/2003/Vista/2008/7/2008 R2/8/8.1，按任意键退出。
Pause>nul
exit

:Files check
if not exist 7za_x86.exe  echo.&echo.&echo.&echo.&echo.&echo.&echo                                    缺少 7za_x86.exe，请重新下载。&echo.&echo.&echo.&echo.&echo
if exist "aria2\aria2c.exe" set aria2c="aria2\aria2c.exe" &goto Main
if exist "D:\软件库\绿色工具\网络工具\上传下载\aria2\x64\aria2c.exe" set aria2c="D:\软件库\绿色工具\网络工具\上传下载\aria2\x64\aria2c.exe"
if not exist "aria2\aria2c.exe" if not exist "D:\软件库\绿色工具\网络工具\上传下载\aria2\x64\aria2c.exe"  echo.&echo.&echo.&echo.&echo.&echo.&echo                                    缺少 aria2，请重新下载。&echo.&echo.&echo.&echo.&echo

:Main
cls
echo.
echo     即将 下载/安装 CCleaner......
echo.&echo.
echo     将调用 %aria2c% 下载。
echo.&echo.
echo     1)下载：CCleaner-Portable
echo     2)备份：CCleaner 配置文件
echo     3)安装：释放压缩档案
echo.&echo.
echo     4)下载并安装：CCleaner-Portable
echo.
echo     5)删除已下载的安装文件（避免不同文件错误地断点续传）
echo.
echo.&echo.
echo     致谢及声明：
echo     1)调用了32位的 7-Zip 命令行版本用于解压缩；
echo     2)7-Zip 发布于 GNU LGPL 协议，www.7-zip.org 的能够找到其源代码；
echo     3)调用了 aria2 从 HTTP 服务器下载数据。
echo.&echo.
echo     版本：2015/1/27；开发：Hugo；联系：hugox.chan@gmail.com
echo.
echo ---------------------------------------------------------------------------
echo.
SET /P ST=   请输入数字：
echo. 
if /I "%ST%"=="1" goto Download
if /I "%ST%"=="2" goto Backup
if /I "%ST%"=="3" goto Setup
if /I "%ST%"=="4" goto Download-Setup
if /I "%ST%"=="5" goto Delete
echo    无效选择，按任意键退出！
pause >nul
exit

:Download
if not exist ccsetup.zip.aria2 if exist ccsetup.zip del ccsetup.zip
rem netstat -an|find "LISTENING"|find ":8087" && set HTTP_PROXY=127.0.0.1:8087
%aria2c% -c -s16 -x16 -k1m --remote-time=true --enable-mmap --file-allocation=falloc --disk-cache=64M -o ccsetup.zip "http://www.piriform.com/ccleaner/download/portable/downloadfile"
echo.&echo    下载完成，按任意键返回。
pause >nul &goto Main

:Backup
if exist "%PROGRAMFILES%\CCleaner\ccleaner.ini" copy /y "%PROGRAMFILES%\CCleaner\ccleaner.ini"
echo.&echo    备份完成，按任意键返回。
pause >nul &goto Main

:Download-Setup
%aria2c% -c -s16 -x16 -k1m --remote-time=true --enable-mmap --file-allocation=falloc --disk-cache=64M -o ccsetup.zip "http://www.piriform.com/ccleaner/download/portable/downloadfile"

:Setup
if not exist ccsetup.zip echo 未找到ccsetup.zip，请下载。 &echo.&pause &goto Main
Tasklist|Find /i "CCleaner.exe">nul&&(taskkill /im CCleaner.exe /f)
Tasklist|Find /i "CCleaner64.exe">nul&&(taskkill /im CCleaner64.exe /f)
7za_x86.exe x -y ccsetup.zip -o"%PROGRAMFILES%\CCleaner"
if not exist "%PROGRAMFILES%\CCleaner\ccleaner.ini" echo off>>"%PROGRAMFILES%\CCleaner\ccleaner.ini" &echo on
if exist ccleaner.ini copy /y ccleaner.ini "%PROGRAMFILES%\CCleaner"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\CCleaner.lnk""):b.TargetPath=""%PROGRAMFILES%\CCleaner\CCleaner.exe"":b.WorkingDirectory=""%PROGRAMFILES%\CCleaner"":b.Save:close")
echo.&echo    安装完成，按任意键退出。
pause >nul &exit

:Delete
if exist ccsetup* del ccsetup*
echo.&echo    处理完成，按任意键返回。
pause >nul &goto Main
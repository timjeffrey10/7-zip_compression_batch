@echo off

set a=c:\program files\7-zip\7z.exe
set count1=0
set count2=0
set format=0

echo [32m---------------------------   
echo     Check file name
echo ---------------------------[0m
Echo %* | findstr "( ) ! %%%" >nul && (
    echo [31mString check fail.[0m
	echo [31mFiles' path or name DO NOT include "( ) ! %%%"[0m
	echo.
	pause
	exit
) || (
	echo [36mString check pass.[0m
	echo.
)

@setlocal enableextensions enabledelayedexpansion

echo [32m---------------------------   
echo     Set format
echo ---------------------------[0m
:ChooseFormat
echo Choose format:
echo 1. 7z
echo 2. zip

set /p format=Enter format: 

if %format%==1 (
	echo [36mSetting format: 7z[0m
	set format=7z
) else if %format%==2 (
	echo [36mSetting format: zip[0m
	set format=zip
) else (
	echo [31mSetting format fail![0m
	echo.
	goto ChooseFormat
)
echo.

echo [32m---------------------------   
echo     Set password
echo ---------------------------[0m
set /p pass=Enter password (if no password, just press enter):

if [%pass%]==[] (
	echo [36mNo password[0m.
) else (
	echo [36mSetting password: %pass%[0m
	set pass=-p%pass%
)
echo.

timeout /t 1 >nul
cls

echo [36mSetting: -t%format% %pass%[0m
echo.

echo [32m---------------------------   
echo     File list
echo ---------------------------[0m
for %%a in (%*) do (
	set /a count1+=1
	echo !count1!:	 %%~a
)
echo [36m!count1! files to compress.[0m
echo.

echo [32m---------------------------   
echo     Start processing
echo ---------------------------[0m
for %%a in (%*) do (
	set /a count2+=1
	echo !count2!/!count1!	 Compressing "%%~nxa"
	
	dir /a %%a|findstr "DIR" >nul 2>nul && (
	"%a%" a -t%format% "%%~a.%format%" "%%~a" -mx9 %pass% > nul
	) || (
	"%a%" a -t%format% "%%~dpa%%~na.%format%" %%a -mx9 %pass% > nul
	)
)
echo [36mCompress finish![0m
echo.

pause
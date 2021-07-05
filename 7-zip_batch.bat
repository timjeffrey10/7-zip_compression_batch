@echo off

set a=c:\program files\7-zip\7z.exe
set count1=0
set count2=0
set format=0
set level=5

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

echo Choose format:
echo 1. 7z
echo 2. zip (default)

:ChooseFormat
set format=2
set /p format=Enter format (To set to the default value, just press enter): 

if %format%==1 (
	echo [36mSetting format: 7z[0m
	set format=7z
) else if %format%==2 (
	echo [36mSetting format: zip[0m
	set format=zip
) else (
	echo [31mInvalid input.[0m
	echo.
	goto ChooseFormat
)
echo.

echo [32m---------------------------   
echo     Set password
echo ---------------------------[0m
set /p pass=Enter password (If no password, just press enter):

if [%pass%]==[] (
	echo [36mNo password[0m.
) else (
	echo [36mSetting password: %pass%[0m
	set pass=-p%pass%
)
echo.

echo [32m---------------------------   
echo     Set compression level
echo ---------------------------[0m

echo Compression level:
echo 0: Store
echo 1: Fastest
echo 3: Fast
echo 5: Normal (default)
echo 7: Maximum
echo 9: Ultra

:CompressionLevel
set level=5
set /p level=Enter level (To set to the default value, just press enter):

if %level%==0 goto valid
if %level%==1 goto valid
if %level%==3 goto valid
if %level%==5 goto valid
if %level%==7 goto valid
if %level%==9 goto valid

echo [31mInvalid input.[0m
echo.
goto CompressionLevel

:valid
echo [36mSetting compression level: %level%[0m

timeout /t 1 >nul
cls

echo [32m---------------------------   
echo     Setting
echo ---------------------------[0m
echo Format: 		%format%
echo Compression Level:	%level%
if [%pass%]==[] (
	echo No Password.
) else (
	echo Password:		%pass:-p=%
)
echo [36mSetting: -t%format% %pass% -mx%level%[0m
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
	"%a%" a -t%format% "%%~a.%format%" "%%~a" -mx%level% %pass% -bso0 -bsp1 
	) || (
	"%a%" a -t%format% "%%~dpa%%~na.%format%" %%a -mx%level% %pass% -bso0 -bsp1 
	)
)
echo [36mCompress finish![0m
echo.

pause

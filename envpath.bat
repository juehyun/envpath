::*********************************************************************
:: COPYRIGHT (C) 2017 Joohyun Lee (juehyun@etri.re.kr)
:: 
:: MIT License
:: 
:: Permission is hereby granted, free of charge, to any person obtaining
:: a copy of this software and associated documentation files (the
:: "Software"), to deal in the Software without restriction, including
:: without limitation the rights to use, copy, modify, merge, publish,
:: distribute, sublicense, and/or sell copies of the Software, and to
:: permit persons to whom the Software is furnished to do so, subject to
:: the following conditions:
:: 
:: The above copyright notice and this permission notice shall be
:: included in all copies or substantial portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
:: EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
:: MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
:: NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
:: LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
:: OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
:: WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
::********************************************************************/

@echo off&cls
setlocal EnableDelayedExpansion

set ESC=

call :initVariables
call :getPathVariable

:MainLoop

call :printCurrent
call :cmdInputExecution

EXIT /B %ERRORLEVEL%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END-OF-SCRIPT-MAIN
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:echoG
    echo %ESC%[92m%*%ESC%[0m
    goto :EOF
:echoR
    echo %ESC%[91m%*%ESC%[0m
    goto :EOF

:cmdInputExecution
    echo :::::::::: Enter Command ::::::::::
    echo :: (a)dd number path : insert path at specified pos
    echo :: (d)el number      : remove the path from specified pos
    echo :: (s)ave            : update the user-level "PATH" environment variable
    echo :: enter             : quit

    set cmd=Nop
    set /p cmd="> "

    if "%cmd%" == "Nop" (
        echo Quit ...
        echo.
        call :echoG Run "refreshenv" to update the env.vars on current session
        echo.
        goto :EOF
    ) else (
        for /f "tokens=1,2,*" %%i in ( "%cmd%" ) do (
            set act=%%i
            set num=%%j
            set dir=%%k
        )
    )

    call :echoG cmd : %cmd%
    set act_char=%act:~0,1%

    call :checkValidAction
    if not %valid% EQU 1 goto :MainLoop

    if /i %act_char% EQU A (
        call :checkValidNumber
        if not %valid% EQU 1 goto :MainLoop

        call :checkValidPath
        if not %valid% EQU 1 goto :MainLoop

        call :addPath %num% %dir%
    )

    if /i %act_char% EQU D (
        call :checkValidNumber
        if not %valid% EQU 1 goto :MainLoop

        call :delPath %num%
    )

    if /i %act_char% EQU S (
        call :savePath
    )
    goto :MainLoop

:savePath
    set syspp=
    set usrpp=
    for /l %%n in (0,1,%searchDirsLastIdx%) do (
        if !searchDirsTag[%%n]! NEQ Del (
            if !searchDirsType[%%n]! EQU SYS (
                if "!syspp!" EQU "" (
                    set syspp=!searchDirs[%%n]!
                ) else (
                    set syspp=!syspp!;!searchDirs[%%n]!
                )
            ) else (
                if "!usrpp!" EQU "" (
                    set usrpp=!searchDirs[%%n]!
                ) else (
                    set usrpp=!usrpp!;!searchDirs[%%n]!
                )

            )
        )
    )
    echo save current search dirs to user PATH environment variable as following
    echo.
    echo ==System PATH==
    call :echoG %syspp%
    call :savePathSystemVariable

    echo ==User   PATH==
    call :echoG %usrpp%
    setx PATH "%usrpp%"

    call :initVariables
    call :getPathVariable
    goto :EOF

:savePathSystemVariable
    echo set UAC = CreateObject^("Shell.Application"^) > "__getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c setx PATH ""%syspp%"" /m", "", "runas", 1 >> "__getadmin.vbs"
    __getadmin.vbs
    del __getadmin.vbs
    goto :EOF

:delPath
    if %1 LEQ %searchDirsLastIdx% if %1 GEQ 0 (
        set ty=!searchDirsType[%1]!
        set searchDirsTag[%1]=Del
    )
    call :echoG remove [%1] [%ty%] !searchDirs[%1]! (total %searchDirsCnt% items)
    goto :EOF

:addPath
    if %1 LEQ %searchDirsLastIdx% if %1 GEQ 0 (
        :: save the env.var is system-wide or user-wide
        set ty=!searchDirsType[%1]!
        :: moving one position
        for /l %%n in (%searchDirsLastIdx%,-1,%1) do (
            set /a nn=%%n+1
            set searchDirs[!nn!]=!searchDirs[%%n]!
            set searchDirsTag[!nn!]=!searchDirsTag[%%n]!
            set searchDirsType[!nn!]=!searchDirsType[%%n]!
        )
        :: adjust index and insert new path
        set /a searchDirsLastIdx=searchDirsLastIdx+1
        set /a searchDirsCnt=searchDirsCnt+1
        set searchDirs[%1]=%2
        set searchDirsTag[%1]=Add
        set searchDirsType[%1]=!ty!
    )
    call :echoG insert [%1] [%ty%] "%2" (total %searchDirsCnt% items)
    goto :EOF


:checkValidAction
    ::echo checkValidAction
    set valid=1
    if /i not %act_char% EQU A if /i not %act_char% EQU D if /i not %act_char% EQU S set valid=0
    
    if %valid% EQU 0 (
        call :echoR Error: invalid command action "%act%"
    )
    goto :EOF

:checkValidNumber
    ::echo checkValidNumber
    set valid=1
    :: use "%num%" to consider in case of %num% is not exist, empty variable
    if "%num%" EQU "" (
        set valid=0
        set num=None
    )
    for /f "tokens=1 delims=0123456789" %%N IN ("%num%") DO set valid=0
    if %num% GTR %searchDirsLastIdx% set valid=0 
    if %num% LSS 0                   set valid=0

    if %valid% EQU 0 (
        call :echoR Error: invalid number "%num%"
    )
    goto :EOF

:checkValidPath
    ::echo checkValidPath
    set valid=1
    if not exist %dir% set valid=0

    if %valid% EQU 0 (
        call :echoR Error: invalid path "%dir%"
    )
    goto :EOF

:printCurrent
    echo ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    echo :::::::::: Search Path ( user PATH environment variable ) ::::::::::
    echo ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    for /l %%n in (0,1,%searchDirsLastIdx%) do (
        if !searchDirsTag[%%n]! == Org (
            echo [!searchDirsTag[%%n]!] [%%n] [!searchDirsType[%%n]!] !searchDirs[%%n]!
        )
        if !searchDirsTag[%%n]! == Add (
            call :echoG [!searchDirsTag[%%n]!] [%%n] [!searchDirsType[%%n]!] !searchDirs[%%n]!
        )
        if !searchDirsTag[%%n]! == Del (
            call :echoR [!searchDirsTag[%%n]!] [%%n] [!searchDirsType[%%n]!] !searchDirs[%%n]!
        )
    )
    call :echoG total %searchDirsCnt% items
    goto :EOF

:getPathVariable
    call :echoG Retrieve PATH environment variable ...
    echo.
    for /f "tokens=1,2,*" %%a in ( 'reg query "HKCU\Environment" /v PATH' ) do set usrpp=%%c
    for /f "tokens=1,2,*" %%a in ( 'reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH' ) do set syspp=%%c

    set usrpp=%usrpp: =#%
    set usrpp=%usrpp:(={%
    set usrpp=%usrpp:)=}%
    set usrpp=%usrpp:;= %

    set syspp=%syspp: =#%
    set syspp=%syspp:(={%
    set syspp=%syspp:)=}%
    set syspp=%syspp:;= %

    set searchDirsLastIdx=0
    set searchDirsCnt=0
    :: to use variables inside for ... statement
    :: solution A
    ::   setlocal EnableDelayedExpansion
    ::   use !variable! instead of %variable%
    ::   use " for set command if there is '(' or ')' character
    :: solution B
    ::   create goto labels 
    for %%a in ( %syspp% ) do (
        ::echo %%a
        set  var=%%a
        set  var=!var:#= !
        set "var=!var:}=)!"
        set "var=!var:{=(!"
        set searchDirs[!searchDirsLastIdx!]=!var!
        set searchDirsTag[!searchDirsLastIdx!]=Org
        set searchDirsType[!searchDirsLastIdx!]=SYS
        set /a searchDirsLastIdx=searchDirsLastIdx+1
    )
    for %%a in ( %usrpp% ) do (
        ::echo %%a
        set  var=%%a
        set  var=!var:#= !
        set "var=!var:}=)!"
        set "var=!var:{=(!"
        set searchDirs[!searchDirsLastIdx!]=!var!
        set searchDirsTag[!searchDirsLastIdx!]=Org
        set searchDirsType[!searchDirsLastIdx!]=usr
        set /a searchDirsLastIdx=searchDirsLastIdx+1
    )
    set /a searchDirsCnt=searchDirsLastIdx
    set /a searchDirsLastIdx=searchDirsLastIdx-1
    goto :EOF

:initVariables
    call :echoG Initialize internal variables
    echo.
    set searchDirs=
    set searchDirsTag=
    set searchDirsLastIdx=
    set searchDirsCnt=
    set searchDirsType=
    set cmd=
    set act=
    set num=
    set dir=
    set valid=
    set act_char=
    goto :EOF

endlocal


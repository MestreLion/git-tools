@ECHO OFF
IF "%1"=="/INIT" GOTO InitializeEnvironment
PUSHD "%~dp0"

ECHO.
ECHO Checking current python.exe location(s)
where python.exe

ECHO.
ECHO Version info for Python/pip/pyinstaller:
python.exe --version
pip.exe --version
pyinstaller.exe --version

ECHO.
ECHO Testing if current git-restore-mtime Python script works...
python.exe ..\git-restore-mtime --help

REM pyinstaller uses upx by default to compress the executable
REM When running the created executable this results in an error:
REM git-restore-mtime.exe - Bad Image: %TEMP%\VCRUNTIME140.dll is either not designed to run on Windows or it contains an error (..)
REM Therefore run pyinstaller with the --noupx parameter
pyinstaller.exe -F --noupx ..\git-restore-mtime

ECHO.
ECHO Testing if git-restore-mtime.exe works...
dist\git-restore-mtime.exe --help

PAUSE
GOTO :EOF

:InitializeEnvironment
ECHO.
ECHO NOTE: This script needs to run as administrator
ECHO Press a key to install Chocolatey, Python and the required Python packages...
PAUSE

ECHO.
ECHO Installing/updating Chocolatey...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

ECHO.
ECHO Installing/updating Python...
choco.exe install -y python

ECHO.
ECHO Upgrading pip and setuptools to latest version...
pip.exe install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org pip setuptools

ECHO.
ECHO Installing latest version of pyinstaller...
pip.exe install --trusted-host pypi.org --trusted-host files.pythonhosted.org https://github.com/pyinstaller/pyinstaller/archive/develop.tar.gz

ECHO.
ECHO Finished!
PAUSE
GOTO :EOF

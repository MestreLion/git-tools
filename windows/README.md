Tools to build a stand-alone Windows executable
===============================================

Windows batch files to build a stand-alone Windows executable that can be distributed without the need to install Python. At this time the batch file only builds an executable for git-restore-mtime: git-restore-mtime.exe.


Requirements
------------

- **Windows**. Tested with Windows 8.1
- **Git**. Tested in v2.17.1 and prior versions since 2010
- **Python**. Tested in Python 3.8.0.
- **Latest pip**. Tested with pip 19.3.1
- **Latest setuptools**. Tested with setuptools 42.0.0
- **Latest version of pyinstaller**. Tested with pyinstaller 4.0.dev0+1eadfa55f2

Automatic installation of requirements
-----------------------------------
You can automatically perform the installation of all requirements by running the following command from an elevated command prompt:

	build_windows_executable.bat /INIT

Manual installation of requirements
-----------------------------------
The easiest way to install Git and Python on Windows is with Chocolatey (https://chocolatey.org).

NOTE: The easiest way to run the install commands below is with 'Run as administrator'. For pip.exe you could use a '--user' parameter to bypass this, but then you have to add the specific user directory to the PATH to make everything work. 

Installing Chocolatey (<https://chocolatey.org/courses/installation/installing?method=installing-chocolatey>):

	@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

Installing latest Git and Python with Chocolatey:

	choco.exe install Git
	choco.exe install Python

Upgrading pip and setuptools to latest version:

	pip.exe install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org pip setuptools

Installing latest version of pyinstaller:

	pip.exe install --trusted-host pypi.org --trusted-host files.pythonhosted.org https://github.com/pyinstaller/pyinstaller/archive/develop.tar.gz



Creating the Windows Executable
-------------------------------

If all depencencies are met, all you have to do is doubleclick (or run from a non-elevated command prompt):

	build_windows_executable.bat

This should result in a 'dist\git-restore-mtime.exe' file.


All other files that are created are temporary files: 'git-restore-mtime.spec' and the 'build'-directory can be discarded.

@echo off
setlocal enabledelayedexpansion

for %%I in (.) do set TEXFILE=%%~nxI
echo TEXFILE is set to: %TEXFILE%

echo Building %TEXFILE%.tex...

echo Building %TEXFILE%.tex...

uplatex -interaction=nonstopmode -file-line-error -halt-on-error -synctex=1 %TEXFILE%.tex
if !errorlevel! neq 0 goto :error

upbibtex %TEXFILE%.aux
if !errorlevel! neq 0 goto :error

uplatex -interaction=nonstopmode -file-line-error -halt-on-error -synctex=1 %TEXFILE%.tex
if !errorlevel! neq 0 goto :error

uplatex -interaction=nonstopmode -file-line-error -halt-on-error -synctex=1 %TEXFILE%.tex
if !errorlevel! neq 0 goto :error

dvipdfmx %TEXFILE%.dvi
if !errorlevel! neq 0 goto :error

echo Cleaning up temporary files...
for %%F in (%TEXFILE%.aux %TEXFILE%.dvi %TEXFILE%.log %TEXFILE%.out %TEXFILE%.synctex.gz %TEXFILE%.toc %TEXFILE%.bbl  %TEXFILE%.blg) do (
    if exist %%F del %%F
)

echo Build process completed successfully.
goto :end

:error
echo An error occurred during the build process.
exit /b 1

:end
exit /b 0
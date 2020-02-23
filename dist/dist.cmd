@echo off
if not exist bin mkdir bin
if not exist demo mkdir demo
if not exist demo\images mkdir demo\images
if not exist demo\mbtext mkdir demo\mbtext
if not exist demo\pngsuite mkdir demo\pngsuite
if not exist demo\rawimage mkdir demo\rawimage
if not exist demo\ttfont mkdir demo\ttfont
if not exist demo\type1 mkdir demo\type1
if not exist include mkdir include
copy /Y ..\..\..\winlibs\libpng\build\libpng16.dll bin\
copy /Y ..\..\..\winlibs\zlib\build\libzlib.dll bin\
copy /Y ..\build\src\libhpdf.dll bin\
copy /Y ..\demo\*.ex demo\
copy /Y ..\demo\images\* demo\images
copy /Y ..\demo\mbtext\* demo\mbtext
copy /Y ..\demo\pngsuite\* demo\pngsuite
copy /Y ..\demo\rawimage\* demo\rawimage
copy /Y ..\demo\ttfont\* demo\ttfont
copy /Y ..\demo\type1\* demo\type1
copy /Y ..\if\euphoria\* include
if not exist demo\eu.cfg (
	echo [all]> demo\eu.cfg
	echo -i ..\include>> demo\eu.cfg
)
"C:\Program Files\7-Zip\7z.exe" a -r libharu.zip bin demo include

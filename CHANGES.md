libHaru news
-------------------------------------------------------------------------------

## Version 2.3.0 RC2 (2011.10.12)

- Changed package naming, no other changes.

## Version 2.3.0 RC1 (2011.09.28)

- Added support for 3dMeasures of subtype PD3 and 3DC, projection annotations, 
  ExData and javascript attached to a U3D model. (Robert Würfel)
- Added support for 1- and 2-byte UTF8 codes. (Clayman)
- Added full PDF/A1-b support. (Petr Pytelka)
- Added support for CCITT compression for B/W images. (Petr Pytelka)
- Add support for TwoPageLeft and TwoPageRight layouts. (Vincent Dupont)
- Const-ified arrays used in the sources. (Ilkka Lehtoranta)
- Fixed build with libpng 1.5.0
- Fixed bug in `HPDF_GetContents()` - isize variable was not initialized. 
  (Vincent Dupont)
- Fixed possible endless loop in PNG handling code.
  (reported by Mathew Waters)
- Fixed several issues based on the warnings generated by clang-analyzer.
  (Daniel Höpfl)
- Fixed quite a number of warnings. (Davide Achilli)
- Added 'd' postfix to debug build, fixed wrong filename. (Wim Dumon)
- Fixed `HPDF_Text_Rect()` not to split words in some obscure cases.

## Version 2.2.0 (2010.10.12)

- Greatly improved U3D support (Nikhil Soman)
    - Markup Annotations
    - Free Text Annotations
    - Line Annotations
    - Circle and Squre Annotations
    - Text Markup Annotations
    - Rubber Stamp Annotations
    - Popup Annotations	
- Added VB.Net bindings. (Matt Underwood) 
- Added CMake build system (experimental). (Werner Smekal) 
- Added preliminary ICC support. (vbrasseur at gmail dot com)
- Added `HPDF_Image_AddSMask()`. (patch by Adam Blokus)
- Added `HPDF_LoadPngImageFromMem()` and `HPDF_LoadJpegImageFromMem()`. 
  (patch by Adam Blokus)
- Added `HPDF_GetContents()`.
- Added `HPDF_Page_SetZoom()`.
- Added support for CMYK in `HPDF_Image_LoadRawImageFromMem()`.
- Applied a bunch of fixes and improvements from bug report #13.
- `HPDF_Page_TextRect()` corrections and improvements. (Ralf Junker)
- Fixed build failure when zlib was not found. (Werner Smekal)
- Fixed build with newer libtool versions.
- Fixed external build. (thanks to Jeremiah Willcock)
- Fixed memleak in `HPDF_EmbeddedFile_New()`. (Ralf Junker) 
- Fixed uninitialized fields in `HPDF_Type1FontDef_New()`. (Ralf Junker)
- Fixed issue with grayscale PNG images. (Ralf Junker)
- Fixed missing parentheses from empty string object. (Ralf Junker)
- Fixed bug #21 (Build fails on Win CE because of errno and errno.h usage).
- Fixed bug #18 (Missing compiler flag -fexceptions)
- Fixed bug #11 (`sqrtf()` is missing on Winblows).
- Fixed bug #10 (missing `HPDF_LoadPngImageFromMem` from `win32/msvc/libhpdf.def`).
- Fixed bug #7 (`HPDF_String_SetValue()` is declared twice).
- Fixed bug #6 (possible `NULL` dereference in `HPDF_LoadPngImageFromFile2()`).
- Fixed bug #5 (possible `NULL` derefernce in `HPDF_LoadRawImageFromFile()`).
- Fixed bug #4 (possible `NULL` dereference in `HPDF_AToI()`).
- Fixed bug #2 (Ruby binding: `hpdf_insert_page` has stray printf).

## Version 2.1.0 (2008.05.27)

- Added initial support for Alpha channel in RGB and palette-based PNG images.
- Added `HPDF_GetTTFontDefFromFile()` function. This closes [FR #1604475] (`HPDF_FONT_EXISTS` not error) 
- Added FreeBasic bindings. (Klaus Siebke)
- Added Python bindings. (Li Jun)
- Added U3D support. (Michail Vidiassov)
- Changed the build system to use autotools.
- Fixed bug #1682456 (`NULL` dereference in `LoadType1FontFromStream()`). 
- Fixed bug #1628096 (`NULL` pointer may be dereferenced).

## Version 2.0.8 (2006.11.25)

- Fixed a problem of `HPDF_Circle()` which causes buffer overflow. 
- Added `HPDF_Ellipse()`.

## Version 2.0.7 (2006.11.05)

- Fixed a bug of `HPDF_Annotation_New()` (the values of bottom and top are set 
  upside down).
- Added `HPDF_Page_GetCurrentPos2()`, `HPDF_Page_GetCurrentTextPos2()` and
  `HPDF_Image_GetSize2()`.

## Version 2.0.6 (2006.10.16)

- Added opacity and blend-mode featurs.
- Added slide-show functions (contributed by Adrian Nelson). 
- Added an interface for VB6 (contributed by Ko, Chi-Chih).
- Fixed a bug that `HPDF_MemStream_Rewrite()` may cause segmentation fault.
- Fixed a bug of error checking of `HPDF_Page_Concat()`.
- Fixed a bug of calculation for the position of text showing.

## Version 2.0.5 (2006.09.20)

- Fixed a bug that an image which loaded by `HPDF_LoadRawImageFromFile()` or 
  `HPDF_LoadRawImageFromMem()` is not compressed.
- Added C# interface.
- Added viewer-preference feature.
- Fixed a bug that `HPDF_SetPassword` does not raise error when `NULL` string set
  to owner-password.
- Fixed a bug that causes program crash when using interlaced PNG images.

## Version 2.0.4 (2006.08.25)

- Fixed a bug of the TrueType font feature related to composit glyph.

## Version 2.0.3 (2006.08.20)
- Fixed a bug that `HPDF_Page_TextRect()` always returns 
  `HPDF_PAGE_INSUFFICIENT_SPACE`.
- Added delayed loading function for a png image (HPDF_LoadPngImageFromFile2).
  * change HPDF_SaveToStream function.
  * correct hpdf_ttfontdef.c to avoid warning from a compiler.

## Version 2.0.2
- Modified `HPDF_Page_ShowTextNextLine()` to invoking `HPDF_Page_MoveToNextLine()`
  if it is invoked with null or zero-length text.
- Fixed a bug in which `HPDF_Page_MeasureText()` returns wrong value when using 
  CID fonts.
- Changed the feature of `HPDF_Page_MeasureText()`.
- Added Japanese word wrap feature to `HPDF_Page_MeasureText()` and 
  `HPDF_Page_TextRect()`.
- Fixed typos of `HPDF_PageLayout` values.
- Modified options of makefile for BCC32 to multi-thread.
  rebuild libz.a, libpng.a for BCC32 with -WM option.

## Version 2.0.1a (2006-08-03)
- Fixed a bug that `HPDFPage::draw_image` does not work correctly. (Ruby module 
  only.)

## Version 2.0.1 (2006-07-29)
- Fixed a bug that `HPDF_TextRect()` does not work correctly when using CID fonts.
- Added `HPDF_Font_GetAscent()`, `HPDF_Font_GetDescent()`, `HPDF_Font_GetXHeight()`,
  `HPDF_Font_GetCapHeight()`.

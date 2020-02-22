
include "std/io.e"
include "std/dll.e"
include "std/math.e"
without warning

include "hpdf.e"

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

procedure show_description( HPDF_Page page, atom x, atom y, sequence text )
	
	sequence buf
	
	HPDF_Page_MoveTo( page, x, y - 10 )
	HPDF_Page_LineTo( page, x, y + 10 )
	HPDF_Page_MoveTo( page, x - 10, y )
	HPDF_Page_LineTo( page, x + 10, y )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_SetFontAndSize( page, HPDF_Page_GetCurrentFont(page), 8 )
	HPDF_Page_SetRGBFill( page, 0, 0, 0 )
	
	HPDF_Page_BeginText( page )
	
	buf = sprintf( "(x=%d,y=%d)", {x,y} )
	
	HPDF_Page_MoveTextPos( page, x - HPDF_Page_TextWidth(page, buf) - 5,
	                y - 10 )
	HPDF_Page_ShowText( page, buf )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x - 20, y - 25 )
	HPDF_Page_ShowText( page, text )
	HPDF_Page_EndText( page )
	
end procedure

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Font font
	HPDF_Page page
	sequence fname
	HPDF_Destination dst
	HPDF_Image image
	HPDF_Image image1
	HPDF_Image image2
	HPDF_Image image3
	
	atom x
	atom y
	atom angle
	atom angle1
	atom angle2
	atom rad
	atom rad1
	atom rad2
	
	atom iw
	atom ih
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	HPDF_SetCompressionMode( pdf, HPDF_COMP_ALL )
	
	/* create default-font */
	font = HPDF_GetFont( pdf, "Helvetica", NULL )
	
	/* add a new page object. */
	page = HPDF_AddPage( pdf )
	
	HPDF_Page_SetWidth( page, 550 )
	HPDF_Page_SetHeight( page, 500 )
	
	dst = HPDF_Page_CreateDestination( page )
	HPDF_Destination_SetXYZ( dst, 0, HPDF_Page_GetHeight(page), 1 )
	HPDF_SetOpenAction( pdf, dst )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_SetFontAndSize( page, font, 20 )
	HPDF_Page_MoveTextPos( page, 220, HPDF_Page_GetHeight(page) - 70 )
	HPDF_Page_ShowText( page, "ImageDemo" )
	HPDF_Page_EndText( page )
	
	/* load image file. */
	ifdef WINDOWS then
	image = HPDF_LoadPngImageFromFile( pdf, "pngsuite/basn3p02.png" )
	elsedef
	image = HPDF_LoadPngImageFromFile( pdf, "pngsuite\\basn3p02.png" )
	end ifdef
	
	/* image1 is masked by image2. */
	ifdef WINDOWS then
	image1 = HPDF_LoadPngImageFromFile( pdf, "pngsuite/basn3p02.png" )
	elsedef
	image1 = HPDF_LoadPngImageFromFile( pdf, "pngsuite\\basn3p02.png" )
	end ifdef
	
	/* image2 is a mask image. */
	ifdef WINDOWS then
	image2 = HPDF_LoadPngImageFromFile( pdf, "pngsuite/basn0g01.png" )
	elsedef
	image2 = HPDF_LoadPngImageFromFile( pdf, "pngsuite\\basn0g01.png" )
	end ifdef
	
	/* image3 is a RGB-color image. we use this image for color-mask
	 * demo.
	 */
	ifdef WINDOWS then
	image3 = HPDF_LoadPngImageFromFile( pdf, "pngsuite/maskimage.png" )
	elsedef
	image3 = HPDF_LoadPngImageFromFile( pdf, "pngsuite\\maskimage.png" )
	end ifdef
	
	iw = HPDF_Image_GetWidth( image )
	ih = HPDF_Image_GetHeight( image )
	
	HPDF_Page_SetLineWidth( page, 0.5 )
	
	x = 100
	y = HPDF_Page_GetHeight( page ) - 150
	
	/* Draw image to the canvas. (normal-mode with actual size.)*/
	HPDF_Page_DrawImage( page, image, x, y, iw, ih )
	
	show_description( page, x, y, "Actual Size" )
	
	x += 150
	
	/* Scalling image (X direction) */
	HPDF_Page_DrawImage( page, image, x, y, iw * 1.5, ih )
	
	show_description( page, x, y, "Scalling image (X direction)" )
	
	x += 150
	
	/* Scalling image (Y direction). */
	HPDF_Page_DrawImage( page, image, x, y, iw, ih * 1.5 )
	show_description( page, x, y, "Scalling image (Y direction)" )
	
	x = 100
	y -= 120
	
	/* Skewing image. */
	angle1 = 10
	angle2 = 20
	rad1 = angle1 / 180 * PI
	rad2 = angle2 / 180 * PI
	
	HPDF_Page_GSave( page )
	
	HPDF_Page_Concat( page, iw, tan(rad1) * iw, tan(rad2) * ih, ih, x, y )
	
	HPDF_Page_ExecuteXObject( page, image )
	HPDF_Page_GRestore( page )
	
	show_description( page, x, y, "Skewing image" )
	
	x += 150
	
	/* Rotating image */
	angle = 30     /* rotation of 30 degrees. */
	rad = angle / 180 * PI /* Calcurate the radian value. */
	
	HPDF_Page_GSave( page )
	
	HPDF_Page_Concat( page, iw * cos(rad),
	                iw * sin(rad),
	                ih * -sin(rad),
	                ih * cos(rad),
	                x, y )
	
	HPDF_Page_ExecuteXObject( page, image )
	HPDF_Page_GRestore( page )
	
	show_description( page, x, y, "Rotating image" )
	
	x += 150
	
	/* draw masked image. */
	
	/* Set image2 to the mask image of image1 */
	HPDF_Image_SetMaskImage( image1, image2 )
	
	HPDF_Page_SetRGBFill( page, 0, 0, 0 )
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x - 6, y + 14 )
	HPDF_Page_ShowText( page, "MASKMASK" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_DrawImage( page, image1, x - 3, y - 3, iw + 6, ih + 6 )
	
	show_description( page, x, y, "masked image" )
	
	x = 100
	y -= 120
	
	/* color mask. */
	HPDF_Page_SetRGBFill( page, 0, 0, 0 )
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x - 6, y + 14 )
	HPDF_Page_ShowText( page, "MASKMASK" )
	HPDF_Page_EndText( page )
	
	HPDF_Image_SetColorMask( image3, 0, 255, 0, 0, 0, 255 )
	HPDF_Page_DrawImage( page, image3, x, y, iw, ih )
	
	show_description( page, x, y, "Color Mask" )
	
	/* save the document to a file */
	HPDF_SaveToFile( pdf, fname )
	
	/* clean up */
	HPDF_Free( pdf )
	
	return 0
end function

sequence cmd = command_line()
if length( cmd ) > 2 then
	abort( main(length(cmd)-2, cmd[3..$]) )
end if


include "std/io.e"
include "std/dll.e"
without warning

include "hpdf.e"

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

constant RAW_IMAGE_DATA = {
	0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFC,
	0xFF, 0xFF, 0xFF, 0xF8, 0xFF, 0xFF, 0xFF, 0xF0,
	0xF3, 0xF3, 0xFF, 0xE0, 0xF3, 0xF3, 0xFF, 0xC0,
	0xF3, 0xF3, 0xFF, 0x80, 0xF3, 0x33, 0xFF, 0x00,
	0xF3, 0x33, 0xFE, 0x00, 0xF3, 0x33, 0xFC, 0x00,
	0xF8, 0x07, 0xF8, 0x00, 0xF8, 0x07, 0xF0, 0x00,
	0xFC, 0xCF, 0xE0, 0x00, 0xFC, 0xCF, 0xC0, 0x00,
	0xFF, 0xFF, 0x80, 0x00, 0xFF, 0xFF, 0x00, 0x00,
	0xFF, 0xFE, 0x00, 0x00, 0xFF, 0xFC, 0x00, 0x00,
	0xFF, 0xF8, 0x0F, 0xE0, 0xFF, 0xF0, 0x0F, 0xE0,
	0xFF, 0xE0, 0x0C, 0x30, 0xFF, 0xC0, 0x0C, 0x30,
	0xFF, 0x80, 0x0F, 0xE0, 0xFF, 0x00, 0x0F, 0xE0,
	0xFE, 0x00, 0x0C, 0x30, 0xFC, 0x00, 0x0C, 0x30,
	0xF8, 0x00, 0x0F, 0xE0, 0xF0, 0x00, 0x0F, 0xE0,
	0xE0, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00,
	0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
}

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Font font
	HPDF_Page page
	sequence fname
	HPDF_Image image
	
	atom x, y
	
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
	
	HPDF_Page_SetWidth( page, 172 )
	HPDF_Page_SetHeight( page, 80 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_SetFontAndSize( page, font, 20 )
	HPDF_Page_MoveTextPos( page, 220, HPDF_Page_GetHeight(page) - 70 )
	HPDF_Page_ShowText( page, "RawImageDemo" )
	HPDF_Page_EndText( page )
	
	/* load RGB raw-image file. */
	ifdef WINDOWS then
	image = HPDF_LoadRawImageFromFile( pdf, "rawimage/32_32_rgb.dat",
			32, 32, HPDF_CS_DEVICE_RGB )
	elsedef
	image = HPDF_LoadRawImageFromFile( pdf, "rawimage\\32_32_rgb.dat",
			32, 32, HPDF_CS_DEVICE_RGB )
	end ifdef
	
	x = 20
	y = 20
	
	/* Draw image to the canvas. (normal-mode with actual size.)*/
	HPDF_Page_DrawImage( page, image, x, y, 32, 32 )
	
	/* load GrayScale raw-image file. */
	ifdef WINDOWS then
	image = HPDF_LoadRawImageFromFile( pdf, "rawimage/32_32_gray.dat",
			32, 32, HPDF_CS_DEVICE_GRAY )
	elsedef
	image = HPDF_LoadRawImageFromFile( pdf, "rawimage\\32_32_gray.dat",
			32, 32, HPDF_CS_DEVICE_GRAY )
	end ifdef
	
	x = 70
	y = 20
	
	/* Draw image to the canvas. (normal-mode with actual size.)*/
	HPDF_Page_DrawImage( page, image, x, y, 32, 32 )
	
	/* load GrayScale raw-image (1bit) file from memory. */
	image = HPDF_LoadRawImageFromMem( pdf, RAW_IMAGE_DATA, 32, 32,
				HPDF_CS_DEVICE_GRAY, 1 )
	
	x = 120
	y = 20
	
	/* Draw image to the canvas. (normal-mode with actual size.)*/
	HPDF_Page_DrawImage( page, image, x, y, 32, 32 )
	
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

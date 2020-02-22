
include "std/io.e"
include "std/dll.e"
without warning

include "hpdf.e"

sequence text = "This is an encrypt document example."
sequence owner_passwd = "owner"
sequence user_passwd = "user"

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Font font
	HPDF_Page page
	sequence fname
	atom tw
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* create default-font */
	font = HPDF_GetFont( pdf, "Helvetica", NULL )
	
	/* add a new page object. */
	page = HPDF_AddPage( pdf )
	
	HPDF_Page_SetSize( page, HPDF_PAGE_SIZE_B5, HPDF_PAGE_LANDSCAPE )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_SetFontAndSize( page, font, 20 )
	tw = HPDF_Page_TextWidth( page, text )
	HPDF_Page_MoveTextPos( page, (HPDF_Page_GetWidth(page) - tw) / 2,
	                (HPDF_Page_GetHeight(page) - 20) / 2 )
	HPDF_Page_ShowText( page, text )
	HPDF_Page_EndText( page )
	
	HPDF_SetPassword( pdf, owner_passwd, user_passwd )
	
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

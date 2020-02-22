
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

constant font_list = {
    "Courier",
    "Courier-Bold",
    "Courier-Oblique",
    "Courier-BoldOblique",
    "Helvetica",
    "Helvetica-Bold",
    "Helvetica-Oblique",
    "Helvetica-BoldOblique",
    "Times-Roman",
    "Times-Bold",
    "Times-Italic",
    "Times-BoldItalic",
    "Symbol",
    "ZapfDingbats"
}

function main( integer argc, sequence argv )
	
	sequence page_title = "Font Demo"
	HPDF_Doc pdf
	sequence fname
	HPDF_Page page
	HPDF_Font def_font
	atom tw
	atom height
	atom width
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* Add a new page object. */
	page = HPDF_AddPage( pdf )
	
	height = HPDF_Page_GetHeight( page )
	width = HPDF_Page_GetWidth( page )
	
	/* Print the lines of the page. */
	HPDF_Page_SetLineWidth( page, 1 )
	HPDF_Page_Rectangle( page, 50, 50, width - 100, height - 110 )
	HPDF_Page_Stroke( page )
	
	/* Print the title of the page (with positioning center). */
	def_font = HPDF_GetFont( pdf, "Helvetica", NULL )
	HPDF_Page_SetFontAndSize( page, def_font, 24 )
	
	tw = HPDF_Page_TextWidth( page, page_title )
	HPDF_Page_BeginText( page )
	HPDF_Page_TextOut( page, (width - tw) / 2, height - 50, page_title )
	HPDF_Page_EndText( page )
	
	/* output subtitle. */
	HPDF_Page_BeginText( page )
	HPDF_Page_SetFontAndSize( page, def_font, 16 )
	HPDF_Page_TextOut( page, 60, height - 80, "<Standerd Type1 fonts samples>" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 60, height - 105 )
	
	for i = 1 to length( font_list ) do
		sequence samp_text = "abcdefgABCDEFG12345!#$%&+-@?"
		HPDF_Font font = HPDF_GetFont( pdf, font_list[i], NULL )
		
		/* print a label of text */
		HPDF_Page_SetFontAndSize( page, def_font, 9 )
		HPDF_Page_ShowText( page, font_list[i] )
		HPDF_Page_MoveTextPos( page, 0, -18 )
		
		/* print a sample text. */
		HPDF_Page_SetFontAndSize( page, font, 20 )
		HPDF_Page_ShowText( page, samp_text )
		HPDF_Page_MoveTextPos( page, 0, -20 )
		
	end for
	
	HPDF_Page_EndText( page )
	
	HPDF_SaveToFile( pdf, fname )
	
	/* clean up */
	HPDF_Free( pdf )
	
	return 0
end function

sequence cmd = command_line()
if length( cmd ) > 2 then
	abort( main(length(cmd)-2, cmd[3..$]) )
end if

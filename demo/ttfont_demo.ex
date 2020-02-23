
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

function main( integer argc, sequence argv )
	
	sequence SAMP_TXT = "The quick brown fox jumps over the lazy dog."
	
	HPDF_Doc pdf
	sequence fname
	HPDF_Page page
	HPDF_Font title_font
	HPDF_Font detail_font
	sequence detail_font_name
	integer embed
	atom page_height
	atom page_width
	atom pw
	
	if argc < 2 then
		printf( STDOUT, "usage: ttfont_demo [path to font file] " &
		            "-E(embedding font).\n" )
		return 1
	end if
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* Add a new page object. */
	page = HPDF_AddPage( pdf )
	
	title_font = HPDF_GetFont( pdf, "Helvetica", NULL )
	
	if argc > 2 and equal( argv[3][1..2], "-E" ) then
		embed = HPDF_TRUE
	else
		embed = HPDF_FALSE
	end if
	
	detail_font_name = HPDF_LoadTTFontFromFile( pdf, argv[2], embed )
	detail_font = HPDF_GetFont( pdf, detail_font_name, NULL )
	
	HPDF_Page_SetFontAndSize( page, title_font, 10 )
	
	HPDF_Page_BeginText( page )
	
	/* Move the position of the text to top of the page. */
	HPDF_Page_MoveTextPos( page, 10, 190 )
	HPDF_Page_ShowText( page, detail_font_name )
	
	if embed then
		HPDF_Page_ShowText( page, "(Embedded Subset)" )
	end if
	
	HPDF_Page_SetFontAndSize( page, detail_font, 15 )
	HPDF_Page_MoveTextPos( page, 10, -20 )
	HPDF_Page_ShowText( page, "abcdefghijklmnopqrstuvwxyz" )
	HPDF_Page_MoveTextPos( page, 0, -20 )
	HPDF_Page_ShowText( page, "ABCDEFGHIJKLMNOPQRSTUVWXYZ" )
	HPDF_Page_MoveTextPos( page, 0, -20 )
	HPDF_Page_ShowText( page, "1234567890" )
	HPDF_Page_MoveTextPos( page, 0, -20 )
	
	HPDF_Page_SetFontAndSize( page, detail_font, 10 )
	HPDF_Page_ShowText( page, SAMP_TXT )
	HPDF_Page_MoveTextPos( page, 0, -18 )
	
	HPDF_Page_SetFontAndSize( page, detail_font, 16 )
	HPDF_Page_ShowText( page, SAMP_TXT )
	HPDF_Page_MoveTextPos( page, 0, -27 )
	
	HPDF_Page_SetFontAndSize( page, detail_font, 23 )
	HPDF_Page_ShowText( page, SAMP_TXT )
	HPDF_Page_MoveTextPos( page, 0, -36 )
	
	HPDF_Page_SetFontAndSize( page, detail_font, 30 )
	HPDF_Page_ShowText( page, SAMP_TXT )
	HPDF_Page_MoveTextPos( page, 0, -36 )
	
	pw = HPDF_Page_TextWidth( page, SAMP_TXT )
	page_height = 210
	page_width = pw + 40
	
	HPDF_Page_SetWidth( page, page_width )
	HPDF_Page_SetHeight( page, page_height )
	
	/* Finish to print text. */
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetLineWidth( page, 0.5 )
	
	HPDF_Page_MoveTo( page, 10, page_height - 25 )
	HPDF_Page_LineTo( page, page_width - 10, page_height - 25 )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_MoveTo( page, 10, page_height - 85 )
	HPDF_Page_LineTo( page, page_width - 10, page_height - 85 )
	HPDF_Page_Stroke( page )
	
	HPDF_SaveToFile( pdf, fname )
	
	/* clean up */
	HPDF_Free( pdf )
	
	return 0
end function

sequence cmd = command_line()
if length( cmd ) > 2 then
	abort( main(length(cmd)-2, cmd[3..$]) )
end if

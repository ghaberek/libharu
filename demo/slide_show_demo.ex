
include "std/io.e"
include "std/dll.e"
include "std/rand.e"
without warning

include "hpdf.e"

enum LEFT, TOP, RIGHT, BOTTOM

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

procedure print_page( HPDF_Page page, sequence caption, HPDF_Font font, HPDF_TransitionStyle style, HPDF_Page prev, HPDF_Page next )
	
	atom r = rnd()
	atom g = rnd()
	atom b = rnd()
	HPDF_Rect rect = {0, 0, 0, 0}
	HPDF_Destination dst
	HPDF_Annotation annot
	
	HPDF_Page_SetWidth( page, 800 )
	HPDF_Page_SetHeight( page, 600 )
	
	HPDF_Page_SetRGBFill( page, r, g, b )
	
	HPDF_Page_Rectangle( page, 0, 0, 800, 600 )
	HPDF_Page_Fill( page )
	
	HPDF_Page_SetRGBFill( page, 1.0 - r, 1.0 - g, 1.0 - b )
	
	HPDF_Page_SetFontAndSize( page, font, 30 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_SetTextMatrix( page, 0.8, 0.0, 0.0, 1.0, 0.0, 0.0 )
	HPDF_Page_TextOut( page, 50, 530, caption )
	
	HPDF_Page_SetTextMatrix( page, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0 )
	HPDF_Page_SetFontAndSize( page, font, 20 )
	HPDF_Page_TextOut( page, 55, 300, 
			"Type F11 or \"Ctrl+L\" in order to return from full screen mode." )
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetSlideShow( page, style, 5.0, 1.0 )
	
	HPDF_Page_SetFontAndSize( page, font, 20 )
	
	if next then
		
		HPDF_Page_BeginText( page )
		HPDF_Page_TextOut( page, 680, 50, "Next=>" )
		HPDF_Page_EndText( page )
		
		rect[LEFT] = 680
		rect[RIGHT] = 750
		rect[TOP] = 70
		rect[BOTTOM] = 50
		dst = HPDF_Page_CreateDestination( next )
		HPDF_Destination_SetFit( dst )
		annot = HPDF_Page_CreateLinkAnnot( page, rect, dst )
		HPDF_LinkAnnot_SetBorderStyle( annot, 0, 0, 0 )
		HPDF_LinkAnnot_SetHighlightMode( annot, HPDF_ANNOT_INVERT_BOX )
		
	end if
	
	if prev then
		
		HPDF_Page_BeginText( page )
		HPDF_Page_TextOut( page, 50, 50, "<=Prev" )
		HPDF_Page_EndText( page )
		
		rect[LEFT] = 50
		rect[RIGHT] = 110
		rect[TOP] = 70
		rect[BOTTOM] = 50
		dst = HPDF_Page_CreateDestination( prev )
		HPDF_Destination_SetFit( dst )
		annot = HPDF_Page_CreateLinkAnnot( page, rect, dst )
		HPDF_LinkAnnot_SetBorderStyle( annot, 0, 0, 0 )
		HPDF_LinkAnnot_SetHighlightMode( annot, HPDF_ANNOT_INVERT_BOX )
		
	end if
	
end procedure

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Font font
	sequence page = repeat( NULL, 17 )
	sequence fname
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* create default-font */
	font = HPDF_GetFont( pdf, "Courier", NULL )
	
	/* Add 17 pages to the document. */
	page[1] = HPDF_AddPage( pdf )
	page[2] = HPDF_AddPage( pdf )
	page[3] = HPDF_AddPage( pdf )
	page[4] = HPDF_AddPage( pdf )
	page[5] = HPDF_AddPage( pdf )
	page[6] = HPDF_AddPage( pdf )
	page[7] = HPDF_AddPage( pdf )
	page[8] = HPDF_AddPage( pdf )
	page[9] = HPDF_AddPage( pdf )
	page[10] = HPDF_AddPage( pdf )
	page[11] = HPDF_AddPage( pdf )
	page[12] = HPDF_AddPage( pdf )
	page[13] = HPDF_AddPage( pdf )
	page[14] = HPDF_AddPage( pdf )
	page[15] = HPDF_AddPage( pdf )
	page[16] = HPDF_AddPage( pdf )
	page[17] = HPDF_AddPage( pdf )
	
	print_page( page[1], "HPDF_TS_WIPE_RIGHT", font, 
	        HPDF_TS_WIPE_RIGHT, NULL, page[2] )
	print_page( page[2], "HPDF_TS_WIPE_UP", font, 
	        HPDF_TS_WIPE_UP, page[1], page[3] )
	print_page( page[3], "HPDF_TS_WIPE_LEFT", font, 
	        HPDF_TS_WIPE_LEFT, page[2], page[4] )
	print_page( page[4], "HPDF_TS_WIPE_DOWN", font, 
	        HPDF_TS_WIPE_DOWN, page[3], page[5] )
	print_page( page[5], "HPDF_TS_BARN_DOORS_HORIZONTAL_OUT", font, 
	        HPDF_TS_BARN_DOORS_HORIZONTAL_OUT, page[4], page[6] )
	print_page( page[6], "HPDF_TS_BARN_DOORS_HORIZONTAL_IN", font, 
	        HPDF_TS_BARN_DOORS_HORIZONTAL_IN, page[5], page[7] )
	print_page( page[7], "HPDF_TS_BARN_DOORS_VERTICAL_OUT", font, 
	        HPDF_TS_BARN_DOORS_VERTICAL_OUT, page[6], page[8] )
	print_page( page[8], "HPDF_TS_BARN_DOORS_VERTICAL_IN", font, 
	        HPDF_TS_BARN_DOORS_VERTICAL_IN, page[7], page[9] )
	print_page( page[9], "HPDF_TS_BOX_OUT", font, 
	        HPDF_TS_BOX_OUT, page[8], page[10] )
	print_page( page[10], "HPDF_TS_BOX_IN", font, 
	        HPDF_TS_BOX_IN, page[9], page[11] )
	print_page( page[11], "HPDF_TS_BLINDS_HORIZONTAL", font, 
	        HPDF_TS_BLINDS_HORIZONTAL, page[10], page[12] )
	print_page( page[12], "HPDF_TS_BLINDS_VERTICAL", font, 
	        HPDF_TS_BLINDS_VERTICAL, page[11], page[13] )
	print_page( page[13], "HPDF_TS_DISSOLVE", font, 
	        HPDF_TS_DISSOLVE, page[12], page[14] )
	print_page( page[14], "HPDF_TS_GLITTER_RIGHT", font, 
	        HPDF_TS_GLITTER_RIGHT, page[13], page[15] )
	print_page( page[15], "HPDF_TS_GLITTER_DOWN", font, 
	        HPDF_TS_GLITTER_DOWN, page[14], page[16] )
	print_page( page[16], "HPDF_TS_GLITTER_TOP_LEFT_TO_BOTTOM_RIGHT", font, 
	        HPDF_TS_GLITTER_TOP_LEFT_TO_BOTTOM_RIGHT, page[15], page[17] )
	print_page( page[17], "HPDF_TS_REPLACE", font, 
	        HPDF_TS_REPLACE, page[16], NULL )
	
	HPDF_SetPageMode( pdf, HPDF_PAGE_MODE_FULL_SCREEN )
	
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


include "std/io.e"
include "std/dll.e"
include "std/sequence.e"
without warning

include "hpdf.e"

enum X,Y
enum LEFT, TOP, RIGHT, BOTTOM

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

procedure print_page( HPDF_Page page, HPDF_Font font, integer page_num )
	
	sequence buf
	
	HPDF_Page_SetWidth( page, 200 )
	HPDF_Page_SetHeight( page, 200 )
	
	HPDF_Page_SetFontAndSize( page, font, 20 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 50, 150 )
	
	buf = sprintf( "Page:%d", page_num )
	
	HPDF_Page_ShowText( page, buf )
	HPDF_Page_EndText( page )
	
end procedure

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Font font
	HPDF_Page index_page
	sequence page = repeat( NULL, 9 )
	HPDF_Destination dst
	sequence fname
	HPDF_Rect rect = {0, 0, 0, 0}
	HPDF_Point tp
	HPDF_Annotation annot
	sequence uri = "http://libharu.org"
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* create default-font */
	font = HPDF_GetFont( pdf, "Helvetica", NULL )
	
	/* create index page */
	index_page = HPDF_AddPage( pdf )
	HPDF_Page_SetWidth( index_page, 300 )
	HPDF_Page_SetHeight( index_page, 220 )
	
	/* Add 7 pages to the document. */
	for i = 1 to 7 do
		page[i] = HPDF_AddPage( pdf )
		print_page( page[i], font, i )
	end for
	
	HPDF_Page_BeginText( index_page )
	HPDF_Page_SetFontAndSize( index_page, font, 10 )
	HPDF_Page_MoveTextPos( index_page, 15, 200 )
	HPDF_Page_ShowText( index_page, "Link Annotation Demo" )
	HPDF_Page_EndText( index_page )
	
	/*
	 * Create Link-Annotation object on index page.
	 */
	HPDF_Page_BeginText( index_page )
	HPDF_Page_SetFontAndSize( index_page, font, 8 )
	HPDF_Page_MoveTextPos( index_page, 20, 180 )
	HPDF_Page_SetTextLeading( index_page, 23 )
	
	/* page1 (HPDF_ANNOT_NO_HIGHTLIGHT) */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "Jump to Page1 (HilightMode=HPDF_ANNOT_NO_HIGHTLIGHT)" )
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_MoveToNextLine( index_page )
	dst = HPDF_Page_CreateDestination( page[1] )
	annot = HPDF_Page_CreateLinkAnnot( index_page, rect, dst )
	HPDF_LinkAnnot_SetHighlightMode( annot, HPDF_ANNOT_NO_HIGHTLIGHT )
	
	/* page2 (HPDF_ANNOT_INVERT_BOX) */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "Jump to Page2 (HilightMode=HPDF_ANNOT_INVERT_BOX)" )
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_MoveToNextLine( index_page )
	dst = HPDF_Page_CreateDestination( page[2] )
	annot = HPDF_Page_CreateLinkAnnot( index_page, rect, dst )
	HPDF_LinkAnnot_SetHighlightMode( annot, HPDF_ANNOT_INVERT_BOX )
	
	/* page3 (HPDF_ANNOT_INVERT_BORDER) */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "Jump to Page3 (HilightMode=HPDF_ANNOT_INVERT_BORDER)" )
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_MoveToNextLine( index_page )
	dst = HPDF_Page_CreateDestination( page[3] )
	annot = HPDF_Page_CreateLinkAnnot( index_page, rect, dst )
	HPDF_LinkAnnot_SetHighlightMode( annot, HPDF_ANNOT_INVERT_BORDER )
	
	/* page4 (HPDF_ANNOT_DOWN_APPEARANCE) */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "Jump to Page4 (HilightMode=HPDF_ANNOT_DOWN_APPEARANCE)" )
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_MoveToNextLine( index_page )
	dst = HPDF_Page_CreateDestination( page[4] )
	annot = HPDF_Page_CreateLinkAnnot( index_page, rect, dst )
	HPDF_LinkAnnot_SetHighlightMode( annot, HPDF_ANNOT_DOWN_APPEARANCE )
	
	/* page5 (dash border) */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "Jump to Page5 (dash border)" )
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_MoveToNextLine( index_page )
	dst = HPDF_Page_CreateDestination( page[5] )
	annot = HPDF_Page_CreateLinkAnnot( index_page, rect, dst )
	HPDF_LinkAnnot_SetBorderStyle( annot, 1, 3, 2 )
	
	/* page6 (no border) */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "Jump to Page6 (no border)" )
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_MoveToNextLine( index_page )
	dst = HPDF_Page_CreateDestination( page[6] )
	annot = HPDF_Page_CreateLinkAnnot( index_page, rect, dst )
	HPDF_LinkAnnot_SetBorderStyle( annot, 0, 0, 0 )
	
	/* page7 (bold border) */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "Jump to Page7 (bold border)" )
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_MoveToNextLine( index_page )
	dst = HPDF_Page_CreateDestination( page[7] )
	annot = HPDF_Page_CreateLinkAnnot( index_page, rect, dst )
	HPDF_LinkAnnot_SetBorderStyle( annot, 2, 0, 0 )
	
	/* URI link */
	tp = HPDF_Page_GetCurrentTextPos( index_page )
	
	HPDF_Page_ShowText( index_page, "URI (" )
	HPDF_Page_ShowText( index_page, uri )
	HPDF_Page_ShowText( index_page, ")" )
	
	rect[LEFT] = tp[X] - 4
	rect[BOTTOM] = tp[Y] - 4
	rect[RIGHT] = fetch(HPDF_Page_GetCurrentTextPos(index_page), {X}) + 4
	rect[TOP] = tp[Y] + 10
	
	HPDF_Page_CreateURILinkAnnot( index_page, rect, uri )
	
	HPDF_Page_EndText( index_page )
	
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

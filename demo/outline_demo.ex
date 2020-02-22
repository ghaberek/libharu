
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

procedure print_page( HPDF_Page page, integer page_num )
	
	sequence buf
	
	HPDF_Page_SetWidth( page, 800 )
	HPDF_Page_SetHeight( page, 800 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 30, 740 )
	
	buf = sprintf( "Page: %d", page_num )
	
	HPDF_Page_ShowText( page, buf )
	HPDF_Page_EndText( page )
	
end procedure

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Font font
	sequence page = repeat( NULL, 4 )
	HPDF_Outline root
	sequence outline = repeat( NULL, 4 )
	HPDF_Destination dst
	sequence fname
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* create default-font */
	font = HPDF_GetFont( pdf, "Helvetica", NULL )
	
	/* Set page mode to use outlines. */
	HPDF_SetPageMode( pdf, HPDF_PAGE_MODE_USE_OUTLINE )
	
	/* Add 3 pages to the document. */
	page[1] = HPDF_AddPage( pdf )
	HPDF_Page_SetFontAndSize( page[1], font, 30 )
	print_page( page[1], 1 )
	
	page[2] = HPDF_AddPage( pdf )
	HPDF_Page_SetFontAndSize( page[2], font, 30 )
	print_page( page[2], 2 )
	
	page[3] = HPDF_AddPage( pdf )
	HPDF_Page_SetFontAndSize( page[3], font, 30 )
	print_page( page[3], 3 )
	
	/* create outline root. */
	root = HPDF_CreateOutline( pdf, NULL, "OutlineRoot", NULL )
	HPDF_Outline_SetOpened( root, HPDF_TRUE )
	
	outline[1] = HPDF_CreateOutline( pdf, root, "page1", NULL )
	outline[2] = HPDF_CreateOutline( pdf, root, "page2", NULL )
	
	/* create outline with test which is ISO8859-2 encoding */
	outline[3] = HPDF_CreateOutline( pdf, root, "ISO8859-2 text гдежзий",
	                HPDF_GetEncoder(pdf, "ISO8859-2") )
	
	/* create destination objects on each pages
	 * and link it to outline items.
	 */
	dst = HPDF_Page_CreateDestination( page[1] )
	HPDF_Destination_SetXYZ( dst, 0, HPDF_Page_GetHeight(page[1]), 1 )
	HPDF_Outline_SetDestination( outline[1], dst )
	-- HPDF_Catalog_SetOpenAction( dst )
	
	dst = HPDF_Page_CreateDestination( page[2] )
	HPDF_Destination_SetXYZ( dst, 0, HPDF_Page_GetHeight(page[2]), 1 )
	HPDF_Outline_SetDestination( outline[2], dst )
	
	dst = HPDF_Page_CreateDestination( page[3] )
	HPDF_Destination_SetXYZ( dst, 0, HPDF_Page_GetHeight(page[3]), 1 )
	HPDF_Outline_SetDestination( outline[3], dst )
	
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

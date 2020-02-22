
include "std/io.e"
include "std/dll.e"
without warning

include "hpdf.e"
include "grid_sheet.e"

enum X,Y

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Page page
	sequence fname
	HPDF_Point pos
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* add a new page object. */
	page = HPDF_AddPage( pdf )
	
	HPDF_Page_SetHeight( page, 220 )
	HPDF_Page_SetWidth( page, 200 )
	
	/* draw grid to the page */
	print_grid( pdf, page )
	
	/* draw pie chart
	 *
	 *   A: 45% Red
	 *   B: 25% Blue
	 *   C: 15% green
	 *   D: other yellow
	 */
	
	/* A */
	HPDF_Page_SetRGBFill( page, 1.0, 0, 0 )
	HPDF_Page_MoveTo( page, 100, 100 )
	HPDF_Page_LineTo( page, 100, 180 )
	HPDF_Page_Arc( page, 100, 100, 80, 0, 360 * 0.45 )
	pos = HPDF_Page_GetCurrentPos( page )
	HPDF_Page_LineTo( page, 100, 100 )
	HPDF_Page_Fill( page )
	
	/* B */
	HPDF_Page_SetRGBFill( page, 0, 0, 1.0 )
	HPDF_Page_MoveTo( page, 100, 100 )
	HPDF_Page_LineTo( page, pos[X], pos[Y] )
	HPDF_Page_Arc( page, 100, 100, 80, 360 * 0.45, 360 * 0.7 )
	pos = HPDF_Page_GetCurrentPos( page )
	HPDF_Page_LineTo( page, 100, 100 )
	HPDF_Page_Fill( page )
	
	/* C */
	HPDF_Page_SetRGBFill( page, 0, 1.0, 0 )
	HPDF_Page_MoveTo( page, 100, 100 )
	HPDF_Page_LineTo( page, pos[X], pos[Y] )
	HPDF_Page_Arc( page, 100, 100, 80, 360 * 0.7, 360 * 0.85 )
	pos = HPDF_Page_GetCurrentPos( page )
	HPDF_Page_LineTo( page, 100, 100 )
	HPDF_Page_Fill( page )
	
	/* D */
	HPDF_Page_SetRGBFill( page, 1.0, 1.0, 0 )
	HPDF_Page_MoveTo( page, 100, 100 )
	HPDF_Page_LineTo( page, pos[X], pos[Y] )
	HPDF_Page_Arc( page, 100, 100, 80, 360 * 0.85, 360 )
	pos = HPDF_Page_GetCurrentPos( page )
	HPDF_Page_LineTo( page, 100, 100 )
	HPDF_Page_Fill( page )
	
	/* draw center circle */
	HPDF_Page_SetGrayStroke( page, 0 )
	HPDF_Page_SetGrayFill( page, 1 )
	HPDF_Page_Circle( page, 100, 100, 30 )
	HPDF_Page_Fill( page )
	
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


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

procedure draw_circles( HPDF_Page page, sequence description, atom x, atom y )
	
	HPDF_Page_SetLineWidth( page, 1.0 )
	HPDF_Page_SetRGBStroke( page, 0.0, 0.0, 0.0 )
	HPDF_Page_SetRGBFill( page, 1.0, 0.0, 0.0 )
	HPDF_Page_Circle( page, x + 40, y + 40, 40 )
	HPDF_Page_ClosePathFillStroke( page )
	HPDF_Page_SetRGBFill( page, 0.0, 1.0, 0.0 )
	HPDF_Page_Circle( page, x + 100, y + 40, 40 )
	HPDF_Page_ClosePathFillStroke( page )
	HPDF_Page_SetRGBFill( page, 0.0, 0.0, 1.0 )
	HPDF_Page_Circle( page, x + 70, y + 74.64, 40 )
	HPDF_Page_ClosePathFillStroke( page )
	
	HPDF_Page_SetRGBFill( page, 0.0, 0.0, 0.0 )
	HPDF_Page_BeginText( page )
	HPDF_Page_TextOut( page, x + 0.0, y + 130.0, description )
	HPDF_Page_EndText( page )
	
end procedure

constant PAGE_WIDTH = 600
constant PAGE_HEIGHT = 900

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Page page
	sequence fname
	HPDF_Font hfont
	HPDF_ExtGState gstate
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	hfont = HPDF_GetFont( pdf, "Helvetica-Bold", NULL )
	
	/* add a new page object. */
	page = HPDF_AddPage( pdf )
	
	HPDF_Page_SetFontAndSize( page, hfont, 10 )
	
	HPDF_Page_SetHeight( page, PAGE_HEIGHT )
	HPDF_Page_SetWidth( page, PAGE_WIDTH )
	
	/* normal */
	HPDF_Page_GSave( page )
	draw_circles( page, "normal", 40.0, PAGE_HEIGHT - 170 )
	HPDF_Page_GRestore( page )
	
	/* transparency (0.8) */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetAlphaFill (gstate, 0.8 )
	HPDF_ExtGState_SetAlphaStroke (gstate, 0.8 )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "alpha fill = 0.8", 230.0, PAGE_HEIGHT - 170 )
	HPDF_Page_GRestore( page )
	
	/* transparency (0.4) */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetAlphaFill (gstate, 0.4 )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "alpha fill = 0.4", 420.0, PAGE_HEIGHT - 170 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_MULTIPLY */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_MULTIPLY )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_MULTIPLY", 40.0, PAGE_HEIGHT - 340 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_SCREEN */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_SCREEN )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_SCREEN", 230.0, PAGE_HEIGHT - 340 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_OVERLAY */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_OVERLAY )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_OVERLAY", 420.0, PAGE_HEIGHT - 340 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_DARKEN */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_DARKEN )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_DARKEN", 40.0, PAGE_HEIGHT - 510 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_LIGHTEN */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_LIGHTEN )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_LIGHTEN", 230.0, PAGE_HEIGHT - 510 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_COLOR_DODGE */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_COLOR_DODGE )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_COLOR_DODGE", 420.0, PAGE_HEIGHT - 510 )
	HPDF_Page_GRestore( page )
	
	
	/* blend-mode=HPDF_BM_COLOR_BUM */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_COLOR_BUM )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_COLOR_BUM", 40.0, PAGE_HEIGHT - 680 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_HARD_LIGHT */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_HARD_LIGHT )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_HARD_LIGHT", 230.0, PAGE_HEIGHT - 680 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_SOFT_LIGHT */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_SOFT_LIGHT )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_SOFT_LIGHT", 420.0, PAGE_HEIGHT - 680 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_DIFFERENCE */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_DIFFERENCE )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_DIFFERENCE", 40.0, PAGE_HEIGHT - 850 )
	HPDF_Page_GRestore( page )
	
	/* blend-mode=HPDF_BM_EXCLUSHON */
	HPDF_Page_GSave( page )
	gstate = HPDF_CreateExtGState( pdf )
	HPDF_ExtGState_SetBlendMode (gstate, HPDF_BM_EXCLUSHON )
	HPDF_Page_SetExtGState( page, gstate )
	draw_circles( page, "HPDF_BM_EXCLUSHON", 230.0, PAGE_HEIGHT - 850 )
	HPDF_Page_GRestore( page )
	
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

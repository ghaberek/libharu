
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

procedure draw_line( HPDF_Page page, atom x, atom y, sequence _label )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x, y - 10 )
	HPDF_Page_ShowText( page, _label )
	HPDF_Page_EndText( page )
	
	HPDF_Page_MoveTo( page, x, y - 15 )
	HPDF_Page_LineTo( page, x + 220, y - 15 )
	HPDF_Page_Stroke( page )
	
end procedure

procedure draw_line2( HPDF_Page page, atom x, atom y, sequence _label )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x, y )
	HPDF_Page_ShowText( page, _label )
	HPDF_Page_EndText( page )
	
	HPDF_Page_MoveTo( page, x + 30, y - 25 )
	HPDF_Page_LineTo( page, x + 160, y - 25 )
	HPDF_Page_Stroke( page )
	
end procedure

procedure draw_rect( HPDF_Page page, atom x, atom y, sequence _label )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x, y - 10 )
	HPDF_Page_ShowText( page, _label )
	HPDF_Page_EndText( page )
	
	HPDF_Page_Rectangle(page, x, y - 40, 220, 25 )
	
end procedure

function main( integer argc, sequence argv )
	
	sequence page_title = "Line Example"
	
	HPDF_Doc pdf
	HPDF_Font font
	HPDF_Page page
	sequence fname
	
	sequence DASH_MODE1 = {3}
	sequence DASH_MODE2 = {3, 7}
	sequence DASH_MODE3 = {8, 7, 2, 7}
	
	atom x
	atom y
	atom x1
	atom y1
	atom x2
	atom y2
	atom x3
	atom y3
	
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
	
	/* print the lines of the page. */
	HPDF_Page_SetLineWidth( page, 1 )
	HPDF_Page_Rectangle( page, 50, 50, HPDF_Page_GetWidth(page) - 100,
				HPDF_Page_GetHeight(page) - 110 )
	HPDF_Page_Stroke( page )
	
	/* print the title of the page (with positioning center). */
	HPDF_Page_SetFontAndSize( page, font, 24 )
	tw = HPDF_Page_TextWidth( page, page_title )
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, (HPDF_Page_GetWidth(page) - tw) / 2,
				HPDF_Page_GetHeight(page) - 50 )
	HPDF_Page_ShowText( page, page_title )
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetFontAndSize( page, font, 10 )
	
	/* Draw verious widths of lines. */
	HPDF_Page_SetLineWidth( page, 0 )
	draw_line( page, 60, 770, "line width = 0" )
	
	HPDF_Page_SetLineWidth( page, 1.0 )
	draw_line( page, 60, 740, "line width = 1.0" )
	
	HPDF_Page_SetLineWidth( page, 2.0 )
	draw_line( page, 60, 710, "line width = 2.0" )
	
	/* Line dash pattern */
	HPDF_Page_SetLineWidth( page, 1.0 )
	
	HPDF_Page_SetDash( page, DASH_MODE1, 1, 1 )
	draw_line( page, 60, 680, "dash_ptn=[3], phase=1 -- " &
	            "2 on, 3 off, 3 on..." )
	
	HPDF_Page_SetDash( page, DASH_MODE2, 2, 2 )
	draw_line( page, 60, 650, "dash_ptn=[7, 3], phase=2 -- " &
	            "5 on 3 off, 7 on,..." )
	
	HPDF_Page_SetDash( page, DASH_MODE3, 4, 0 )
	draw_line( page, 60, 620, "dash_ptn=[8, 7, 2, 7], phase=0" )
	
	HPDF_Page_SetDash( page, NULL, 0, 0 )
	
	HPDF_Page_SetLineWidth( page, 30 )
	HPDF_Page_SetRGBStroke( page, 0.0, 0.5, 0.0 )
	
	/* Line Cap Style */
	HPDF_Page_SetLineCap( page, HPDF_BUTT_END )
	draw_line2( page, 60, 570, "PDF_BUTT_END" )
	
	HPDF_Page_SetLineCap( page, HPDF_ROUND_END )
	draw_line2( page, 60, 505, "PDF_ROUND_END" )
	
	HPDF_Page_SetLineCap( page, HPDF_PROJECTING_SCUARE_END )
	draw_line2( page, 60, 440, "PDF_PROJECTING_SCUARE_END" )
	
	/* Line Join Style */
	HPDF_Page_SetLineWidth( page, 30 )
	HPDF_Page_SetRGBStroke( page, 0.0, 0.0, 0.5 )
	
	HPDF_Page_SetLineJoin( page, HPDF_MITER_JOIN )
	HPDF_Page_MoveTo( page, 120, 300 )
	HPDF_Page_LineTo( page, 160, 340 )
	HPDF_Page_LineTo( page, 200, 300 )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 60, 360 )
	HPDF_Page_ShowText( page, "PDF_MITER_JOIN" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetLineJoin( page, HPDF_ROUND_JOIN )
	HPDF_Page_MoveTo( page, 120, 195 )
	HPDF_Page_LineTo( page, 160, 235 )
	HPDF_Page_LineTo( page, 200, 195 )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 60, 255 )
	HPDF_Page_ShowText( page, "PDF_ROUND_JOIN" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetLineJoin( page, HPDF_BEVEL_JOIN )
	HPDF_Page_MoveTo( page, 120, 90 )
	HPDF_Page_LineTo( page, 160, 130 )
	HPDF_Page_LineTo( page, 200, 90 )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 60, 150 )
	HPDF_Page_ShowText( page, "PDF_BEVEL_JOIN" )
	HPDF_Page_EndText( page )
	
	/* Draw Rectangle */
	HPDF_Page_SetLineWidth( page, 2 )
	HPDF_Page_SetRGBStroke( page, 0, 0, 0 )
	HPDF_Page_SetRGBFill( page, 0.75, 0.0, 0.0 )
	
	draw_rect( page, 300, 770, "Stroke" )
	HPDF_Page_Stroke( page )
	
	draw_rect( page, 300, 720, "Fill" )
	HPDF_Page_Fill( page )
	
	draw_rect( page, 300, 670, "Fill then Stroke" )
	HPDF_Page_FillStroke( page )
	
	/* Clip Rect */
	HPDF_Page_GSave( page )  /* Save the current graphic state */
	draw_rect( page, 300, 620, "Clip Rectangle" )
	HPDF_Page_Clip( page )
	HPDF_Page_Stroke( page )
	HPDF_Page_SetFontAndSize( page, font, 13 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 290, 600 )
	HPDF_Page_SetTextLeading( page, 12 )
	HPDF_Page_ShowText( page,
				"Clip Clip Clip Clip Clip Clipi Clip Clip Clip" )
	HPDF_Page_ShowTextNextLine( page,
				"Clip Clip Clip Clip Clip Clip Clip Clip Clip" )
	HPDF_Page_ShowTextNextLine( page,
				"Clip Clip Clip Clip Clip Clip Clip Clip Clip" )
	HPDF_Page_EndText( page )
	HPDF_Page_GRestore( page )
	
	/* Curve Example(CurveTo2) */
	x = 330
	y = 440
	x1 = 430
	y1 = 530
	x2 = 480
	y2 = 470
	x3 = 480
	y3 = 90
	
	HPDF_Page_SetRGBFill( page, 0, 0, 0 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 300, 540 )
	HPDF_Page_ShowText( page, "CurveTo2(x1, y1, x2. y2)" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x + 5, y - 5 )
	HPDF_Page_ShowText( page, "Current point" )
	HPDF_Page_MoveTextPos( page, x1 - x, y1 - y )
	HPDF_Page_ShowText( page, "(x1, y1)" )
	HPDF_Page_MoveTextPos( page, x2 - x1, y2 - y1 )
	HPDF_Page_ShowText( page, "(x2, y2)" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetDash( page, DASH_MODE1, 1, 0 )
	
	HPDF_Page_SetLineWidth( page, 0.5 )
	HPDF_Page_MoveTo( page, x1, y1 )
	HPDF_Page_LineTo( page, x2, y2 )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_SetDash( page, NULL, 0, 0 )
	
	HPDF_Page_SetLineWidth( page, 1.5 )
	
	HPDF_Page_MoveTo( page, x, y )
	HPDF_Page_CurveTo2( page, x1, y1, x2, y2 )
	HPDF_Page_Stroke( page )
	
	/* Curve Example(CurveTo3) */
	y -= 150
	y1 -= 150
	y2 -= 150
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 300, 390 )
	HPDF_Page_ShowText( page, "CurveTo3(x1, y1, x2. y2)" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x + 5, y - 5 )
	HPDF_Page_ShowText( page, "Current point" )
	HPDF_Page_MoveTextPos( page, x1 - x, y1 - y )
	HPDF_Page_ShowText( page, "(x1, y1)" )
	HPDF_Page_MoveTextPos( page, x2 - x1, y2 - y1 )
	HPDF_Page_ShowText( page, "(x2, y2)" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetDash( page, DASH_MODE1, 1, 0 )
	
	HPDF_Page_SetLineWidth( page, 0.5 )
	HPDF_Page_MoveTo( page, x, y )
	HPDF_Page_LineTo( page, x1, y1 )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_SetDash( page, NULL, 0, 0 )
	
	HPDF_Page_SetLineWidth( page, 1.5 )
	HPDF_Page_MoveTo( page, x, y )
	HPDF_Page_CurveTo3( page, x1, y1, x2, y2 )
	HPDF_Page_Stroke( page )
	
	/* Curve Example(CurveTo) */
	y -= 150
	y1 -= 160
	y2 -= 130
	x2 += 10
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 300, 240 )
	HPDF_Page_ShowText( page, "CurveTo(x1, y1, x2. y2, x3, y3)" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, x + 5, y - 5 )
	HPDF_Page_ShowText( page, "Current point" )
	HPDF_Page_MoveTextPos( page, x1 - x, y1 - y )
	HPDF_Page_ShowText( page, "(x1, y1)" )
	HPDF_Page_MoveTextPos( page, x2 - x1, y2 - y1 )
	HPDF_Page_ShowText( page, "(x2, y2)" )
	HPDF_Page_MoveTextPos( page, x3 - x2, y3 - y2 )
	HPDF_Page_ShowText( page, "(x3, y3)" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_SetDash( page, DASH_MODE1, 1, 0 )
	
	HPDF_Page_SetLineWidth( page, 0.5 )
	HPDF_Page_MoveTo( page, x, y )
	HPDF_Page_LineTo( page, x1, y1 )
	HPDF_Page_Stroke( page )
	HPDF_Page_MoveTo( page, x2, y2 )
	HPDF_Page_LineTo( page, x3, y3 )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_SetDash( page, NULL, 0, 0 )
	
	HPDF_Page_SetLineWidth( page, 1.5 )
	HPDF_Page_MoveTo( page, x, y )
	HPDF_Page_CurveTo( page, x1, y1, x2, y2, x3, y3 )
	HPDF_Page_Stroke( page )
	
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


include "std/io.e"
include "std/dll.e"
include "std/math.e"
without warning

include "hpdf.e"
include "grid_sheet.e"

enum X, Y
enum LEFT, TOP, RIGHT, BOTTOM

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

integer no = 0

procedure PrintText( HPDF_Page page )
	
	sequence buf
	HPDF_Point pos = HPDF_Page_GetCurrentTextPos2( page )
	
	no += 1
	buf = sprintf( ".[%d]%0.2f %0.2f", {no,pos[X],pos[Y]} )
	
	HPDF_Page_ShowText( page, buf )
	
end procedure

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Page page
	sequence fname
	HPDF_Font font
	atom angle1
	atom angle2
	atom rad1
	atom rad2
	atom page_height
	HPDF_Rect rect
	
	sequence SAMP_TXT = "The quick brown fox jumps over the lazy dog. "
	
	fname = argv[1] & ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* add a new page object. */
	page = HPDF_AddPage( pdf )
	HPDF_Page_SetSize( page, HPDF_PAGE_SIZE_A5, HPDF_PAGE_PORTRAIT )
	
	print_grid( pdf, page )
	
	page_height = HPDF_Page_GetHeight( page )
	
	font = HPDF_GetFont( pdf, "Helvetica", NULL )
	HPDF_Page_SetTextLeading( page, 20 )
	
	/* text_rect method */
	
	/* HPDF_TALIGN_LEFT */
	rect = {0,0,0,0}
	rect[LEFT] = 25
	rect[TOP] = 545
	rect[RIGHT] = 200
	rect[BOTTOM] = rect[TOP] - 40
	
	HPDF_Page_Rectangle( page, rect[LEFT], rect[BOTTOM], rect[RIGHT] - rect[LEFT],
	            rect[TOP] - rect[BOTTOM] )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	
	HPDF_Page_SetFontAndSize( page, font, 10 )
	HPDF_Page_TextOut( page, rect[LEFT], rect[TOP] + 3, "HPDF_TALIGN_LEFT" )
	
	HPDF_Page_SetFontAndSize( page, font, 13 )
	HPDF_Page_TextRect( page, rect[LEFT], rect[TOP], rect[RIGHT], rect[BOTTOM],
	            SAMP_TXT, HPDF_TALIGN_LEFT, NULL )
	
	HPDF_Page_EndText( page )
	
	/* HPDF_TALIGN_RIGHT */
	rect[LEFT] = 220
	rect[RIGHT] = 395
	
	HPDF_Page_Rectangle (page, rect[LEFT], rect[BOTTOM], rect[RIGHT] - rect[LEFT],
	            rect[TOP] - rect[BOTTOM])
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	
	HPDF_Page_SetFontAndSize( page, font, 10 )
	HPDF_Page_TextOut( page, rect[LEFT], rect[TOP] + 3, "HPDF_TALIGN_RIGHT" )
	
	HPDF_Page_SetFontAndSize( page, font, 13 )
	HPDF_Page_TextRect( page, rect[LEFT], rect[TOP], rect[RIGHT], rect[BOTTOM],
	            SAMP_TXT, HPDF_TALIGN_RIGHT, NULL )
	
	HPDF_Page_EndText( page )
	
	/* HPDF_TALIGN_CENTER */
	rect[LEFT] = 25
	rect[TOP] = 475
	rect[RIGHT] = 200
	rect[BOTTOM] = rect[TOP] - 40
	
	HPDF_Page_Rectangle( page, rect[LEFT], rect[BOTTOM], rect[RIGHT] - rect[LEFT],
	            rect[TOP] - rect[BOTTOM] )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	
	HPDF_Page_SetFontAndSize( page, font, 10 )
	HPDF_Page_TextOut( page, rect[LEFT], rect[TOP] + 3, "HPDF_TALIGN_CENTER" )
	
	HPDF_Page_SetFontAndSize( page, font, 13 )
	HPDF_Page_TextRect( page, rect[LEFT], rect[TOP], rect[RIGHT], rect[BOTTOM],
	            SAMP_TXT, HPDF_TALIGN_CENTER, NULL )
	
	HPDF_Page_EndText( page )
	
	/* HPDF_TALIGN_JUSTIFY */
	rect[LEFT] = 220
	rect[RIGHT] = 395
	
	HPDF_Page_Rectangle( page, rect[LEFT], rect[BOTTOM], rect[RIGHT] - rect[LEFT],
	            rect[TOP] - rect[BOTTOM] )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	
	HPDF_Page_SetFontAndSize( page, font, 10 )
	HPDF_Page_TextOut( page, rect[LEFT], rect[TOP] + 3, "HPDF_TALIGN_JUSTIFY" )
	
	HPDF_Page_SetFontAndSize( page, font, 13 )
	HPDF_Page_TextRect( page, rect[LEFT], rect[TOP], rect[RIGHT], rect[BOTTOM],
	            SAMP_TXT, HPDF_TALIGN_JUSTIFY, NULL )
	
	HPDF_Page_EndText( page )
	
	/* Skewed coordinate system */
	HPDF_Page_GSave( page )
	
	angle1 = 5
	angle2 = 10
	rad1 = angle1 / 180 * PI
	rad2 = angle2 / 180 * PI
	
	HPDF_Page_Concat( page, 1, tan(rad1), tan(rad2), 1, 25, 350 )
	rect[LEFT] = 0
	rect[TOP] = 40
	rect[RIGHT] = 175
	rect[BOTTOM] = 0
	
	HPDF_Page_Rectangle( page, rect[LEFT], rect[BOTTOM], rect[RIGHT] - rect[LEFT],
	            rect[TOP] - rect[BOTTOM] )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	
	HPDF_Page_SetFontAndSize( page, font, 10 )
	HPDF_Page_TextOut( page, rect[LEFT], rect[TOP] + 3, "Skewed coordinate system" )
	
	HPDF_Page_SetFontAndSize( page, font, 13 )
	HPDF_Page_TextRect( page, rect[LEFT], rect[TOP], rect[RIGHT], rect[BOTTOM],
	            SAMP_TXT, HPDF_TALIGN_LEFT, NULL )
	
	HPDF_Page_EndText( page )
	
	HPDF_Page_GRestore( page )
	
	/* Rotated coordinate system */
	HPDF_Page_GSave( page )
	
	angle1 = 5
	rad1 = angle1 / 180 * PI
	
	HPDF_Page_Concat( page, cos(rad1), sin(rad1), -sin(rad1), cos(rad1), 220, 350 )
	rect[LEFT] = 0
	rect[TOP] = 40
	rect[RIGHT] = 175
	rect[BOTTOM] = 0
	
	HPDF_Page_Rectangle( page, rect[LEFT], rect[BOTTOM], rect[RIGHT] - rect[LEFT],
	            rect[TOP] - rect[BOTTOM] )
	HPDF_Page_Stroke( page )
	
	HPDF_Page_BeginText( page )
	
	HPDF_Page_SetFontAndSize( page, font, 10 )
	HPDF_Page_TextOut( page, rect[LEFT], rect[TOP] + 3, "Rotated coordinate system" )
	
	HPDF_Page_SetFontAndSize( page, font, 13 )
	HPDF_Page_TextRect( page, rect[LEFT], rect[TOP], rect[RIGHT], rect[BOTTOM],
	            SAMP_TXT, HPDF_TALIGN_LEFT, NULL )
	
	HPDF_Page_EndText( page )
	
	HPDF_Page_GRestore( page )
	
	/* text along a circle */
	HPDF_Page_SetGrayStroke( page, 0 )
	HPDF_Page_Circle( page, 210, 190, 145 )
	HPDF_Page_Circle( page, 210, 190, 113 )
	HPDF_Page_Stroke( page )
	
	angle1 = 360 / length(SAMP_TXT)
	angle2 = 180
	
	HPDF_Page_BeginText( page )
	font = HPDF_GetFont( pdf, "Courier-Bold", NULL )
	HPDF_Page_SetFontAndSize( page, font, 30 )
	
	for i = 1 to length( SAMP_TXT ) do
		atom x
		atom y
		
		rad1 = (angle2 - 90) / 180 * PI
		rad2 = angle2 / 180 * PI
		
		x = 210 + cos(rad2) * 122
		y = 190 + sin(rad2) * 122
		
		HPDF_Page_SetTextMatrix( page, cos(rad1), sin(rad1), -sin(rad1), cos(rad1), x, y )
		
		HPDF_Page_ShowText( page, {SAMP_TXT[i]} )
		angle2 -= angle1
		
	end for
	
	HPDF_Page_EndText( page )
	
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

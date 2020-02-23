
include "std/io.e"
include "std/dll.e"
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

function main( integer argc, sequence argv )
	
	HPDF_Rect rect1 = { 50, 350, 150, 400}
	HPDF_Rect rect2 = {210, 350, 350, 400}
	HPDF_Rect rect3 = { 50, 250, 150, 300}
	HPDF_Rect rect4 = {210, 250, 350, 300}
	HPDF_Rect rect5 = { 50, 150, 150, 200}
	HPDF_Rect rect6 = {210, 150, 350, 200}
	HPDF_Rect rect7 = { 50,  50, 150, 100}
	HPDF_Rect rect8 = {210,  50, 350, 100}
	
	HPDF_Doc pdf
	sequence fname
	HPDF_Page page
	HPDF_Font font
	HPDF_Encoder encoding
	HPDF_Annotation annot
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* use Times-Roman font. */
	font = HPDF_GetFont( pdf, "Times-Roman", "WinAnsiEncoding" )
	
	page = HPDF_AddPage( pdf )
	
	HPDF_Page_SetWidth( page, 400 )
	HPDF_Page_SetHeight( page, 500 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_SetFontAndSize( page, font, 16 )
	HPDF_Page_MoveTextPos( page, 130, 450 )
	HPDF_Page_ShowText( page, "Annotation Demo" )
	HPDF_Page_EndText( page )
	
	annot = HPDF_Page_CreateTextAnnot( page, rect1, "Annotation with Comment " &
	                "Icon. \n This annotation set to be opened initially.",
	                NULL )
	
	HPDF_TextAnnot_SetIcon( annot, HPDF_ANNOT_ICON_COMMENT )
	HPDF_TextAnnot_SetOpened( annot, HPDF_TRUE )
	
	annot = HPDF_Page_CreateTextAnnot( page, rect2,
	                "Annotation with Key Icon", NULL )
	HPDF_TextAnnot_SetIcon( annot, HPDF_ANNOT_ICON_PARAGRAPH )
	
	annot = HPDF_Page_CreateTextAnnot( page, rect3,
	                "Annotation with Note Icon", NULL )
	HPDF_TextAnnot_SetIcon( annot, HPDF_ANNOT_ICON_NOTE )
	
	annot = HPDF_Page_CreateTextAnnot( page, rect4,
	                "Annotation with Help Icon", NULL )
	HPDF_TextAnnot_SetIcon( annot, HPDF_ANNOT_ICON_HELP )
	
	annot = HPDF_Page_CreateTextAnnot( page, rect5,
	                "Annotation with NewParagraph Icon", NULL )
	HPDF_TextAnnot_SetIcon( annot, HPDF_ANNOT_ICON_NEW_PARAGRAPH )
	
	annot = HPDF_Page_CreateTextAnnot( page, rect6,
	                "Annotation with Paragraph Icon", NULL )
	HPDF_TextAnnot_SetIcon( annot, HPDF_ANNOT_ICON_PARAGRAPH )
	
	annot = HPDF_Page_CreateTextAnnot( page, rect7,
	                "Annotation with Insert Icon", NULL )
	HPDF_TextAnnot_SetIcon( annot, HPDF_ANNOT_ICON_INSERT )
	
	encoding = HPDF_GetEncoder( pdf, "ISO8859-2" )
	
	HPDF_Page_CreateTextAnnot( page, rect8,
	                "Annotation with ISO8859 text гдежзий", encoding )
	
	HPDF_Page_SetFontAndSize( page, font, 11 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect1[LEFT] + 35, rect1[TOP] - 20 )
	HPDF_Page_ShowText( page, "Comment Icon." )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect2[LEFT] + 35, rect2[TOP] - 20 )
	HPDF_Page_ShowText( page, "Key Icon" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect3[LEFT] + 35, rect3[TOP] - 20 )
	HPDF_Page_ShowText( page, "Note Icon." )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect4[LEFT] + 35, rect4[TOP] - 20 )
	HPDF_Page_ShowText( page, "Help Icon" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect5[LEFT] + 35, rect5[TOP] - 20 )
	HPDF_Page_ShowText( page, "NewParagraph Icon" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect6[LEFT] + 35, rect6[TOP] - 20 )
	HPDF_Page_ShowText( page, "Paragraph Icon" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect7[LEFT] + 35, rect7[TOP] - 20 )
	HPDF_Page_ShowText( page, "Insert Icon" )
	HPDF_Page_EndText( page )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, rect8[LEFT] + 35, rect8[TOP] - 20 )
	HPDF_Page_ShowText( page, "Text Icon(ISO8859-2 text)" )
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

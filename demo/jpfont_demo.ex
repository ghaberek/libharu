
include "std/io.e"
include "std/dll.e"
without warning

include "hpdf.e"

enum X,Y

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

constant PAGE_HEIGHT = 210

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	sequence fname
	HPDF_Font title_font
	sequence detail_font
	sequence samp_text
	HPDF_Outline root
	
ifdef WINDOWS then
	integer fn = open( "mbtext\\sjis.txt", "rb" )
elsedef
	integer fn = open( "mbtext/sjis.txt", "rb" )
end ifdef
	
	if fn = -1 then
		printf( STDOUT, "error: cannot open 'mbtext/sjis.txt'\n" )
		return 1
	end if
	
	samp_text = gets( fn )
	close( fn )
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* configure pdf-document to be compressed. */
	HPDF_SetCompressionMode( pdf, HPDF_COMP_ALL )
	
	/* declaration for using Japanese font, encoding. */
	HPDF_UseJPEncodings( pdf )
	HPDF_UseJPFonts( pdf )
	
	detail_font = repeat( NULL, 16 )
	detail_font[1] = HPDF_GetFont( pdf, "MS-Mincho", "90ms-RKSJ-H" )
	detail_font[2] = HPDF_GetFont( pdf, "MS-Mincho,Bold", "90ms-RKSJ-H" )
	detail_font[3] = HPDF_GetFont( pdf, "MS-Mincho,Italic", "90ms-RKSJ-H" )
	detail_font[4] = HPDF_GetFont( pdf, "MS-Mincho,BoldItalic", "90ms-RKSJ-H" )
	detail_font[5] = HPDF_GetFont( pdf, "MS-PMincho", "90msp-RKSJ-H" )
	detail_font[6] = HPDF_GetFont( pdf, "MS-PMincho,Bold", "90msp-RKSJ-H" )
	detail_font[7] = HPDF_GetFont( pdf, "MS-PMincho,Italic", "90msp-RKSJ-H" )
	detail_font[8] = HPDF_GetFont( pdf, "MS-PMincho,BoldItalic",
	        "90msp-RKSJ-H" )
	detail_font[9] = HPDF_GetFont( pdf, "MS-Gothic", "90ms-RKSJ-H" )
	detail_font[10] = HPDF_GetFont( pdf, "MS-Gothic,Bold", "90ms-RKSJ-H" )
	detail_font[11] = HPDF_GetFont( pdf, "MS-Gothic,Italic", "90ms-RKSJ-H" )
	detail_font[12] = HPDF_GetFont( pdf, "MS-Gothic,BoldItalic", "90ms-RKSJ-H" )
	detail_font[13] = HPDF_GetFont( pdf, "MS-PGothic", "90msp-RKSJ-H" )
	detail_font[14] = HPDF_GetFont( pdf, "MS-PGothic,Bold", "90msp-RKSJ-H" )
	detail_font[15] = HPDF_GetFont( pdf, "MS-PGothic,Italic", "90msp-RKSJ-H" )
	detail_font[16] = HPDF_GetFont( pdf, "MS-PGothic,BoldItalic",
	        "90msp-RKSJ-H" )
	
	/* Set page mode to use outlines. */
	HPDF_SetPageMode( pdf, HPDF_PAGE_MODE_USE_OUTLINE )
	
	/* create outline root. */
	root = HPDF_CreateOutline( pdf, NULL, "JP font demo", NULL )
	HPDF_Outline_SetOpened( root, HPDF_TRUE )
	
	for i = 1 to 16 do
		HPDF_Page page
		HPDF_Outline outline
		HPDF_Destination dst
		atom x_pos
		HPDF_Point p
		
--		if detail_font[i] = NULL then
--			exit
--		end if
		
		/* add a new page object. */
		page = HPDF_AddPage( pdf )
		
		/* create outline entry */
		outline = HPDF_CreateOutline( pdf, root,
		        HPDF_Font_GetFontName(detail_font[i]), NULL )
		dst = HPDF_Page_CreateDestination( page )
		HPDF_Outline_SetDestination( outline, dst )
		
		title_font = HPDF_GetFont( pdf, "Helvetica", NULL )
		HPDF_Page_SetFontAndSize( page, title_font, 10 )
		
		HPDF_Page_BeginText( page )
		
		/* move the position of the text to top of the page. */
		HPDF_Page_MoveTextPos( page, 10, 190 )
		HPDF_Page_ShowText( page, HPDF_Font_GetFontName(detail_font[i]) )
		
		HPDF_Page_SetFontAndSize( page, detail_font[i], 15 )
		HPDF_Page_MoveTextPos( page, 10, -20 )
		HPDF_Page_ShowText( page, "abcdefghijklmnopqrstuvwxyz" )
		HPDF_Page_MoveTextPos( page, 0, -20 )
		HPDF_Page_ShowText( page, "ABCDEFGHIJKLMNOPQRSTUVWXYZ" )
		HPDF_Page_MoveTextPos( page, 0, -20 )
		HPDF_Page_ShowText( page, "1234567890" )
		HPDF_Page_MoveTextPos( page, 0, -20 )
		
		HPDF_Page_SetFontAndSize( page, detail_font[i], 10 )
		HPDF_Page_ShowText( page, samp_text )
		HPDF_Page_MoveTextPos( page, 0, -18 )
		
		HPDF_Page_SetFontAndSize( page, detail_font[i], 16 )
		HPDF_Page_ShowText( page, samp_text )
		HPDF_Page_MoveTextPos( page, 0, -27 )
		
		HPDF_Page_SetFontAndSize( page, detail_font[i], 23 )
		HPDF_Page_ShowText( page, samp_text )
		HPDF_Page_MoveTextPos( page, 0, -36 )
		
		HPDF_Page_SetFontAndSize( page, detail_font[i], 30 )
		HPDF_Page_ShowText( page, samp_text )
		
		p = HPDF_Page_GetCurrentTextPos( page )
		
		/* finish to print text. */
		HPDF_Page_EndText( page )
		
		HPDF_Page_SetLineWidth( page, 0.5 )
		
		x_pos = 20
		for j = 1 to length( samp_text ) / 2 do
			HPDF_Page_MoveTo( page, x_pos, p[Y] - 10 )
			HPDF_Page_LineTo( page, x_pos, p[Y] - 12 )
			HPDF_Page_Stroke( page )
			x_pos = x_pos + 30
		end for
		
		HPDF_Page_SetWidth( page, p[X] + 20 )
		HPDF_Page_SetHeight( page, PAGE_HEIGHT )
		
		HPDF_Page_MoveTo( page, 10, PAGE_HEIGHT - 25 )
		HPDF_Page_LineTo( page, p[X] + 10, PAGE_HEIGHT - 25 )
		HPDF_Page_Stroke( page )
		
		HPDF_Page_MoveTo( page, 10, PAGE_HEIGHT - 85 )
		HPDF_Page_LineTo( page, p[X] + 10, PAGE_HEIGHT - 85 )
		HPDF_Page_Stroke( page )
		
		HPDF_Page_MoveTo( page, 10, p[Y] - 12 )
		HPDF_Page_LineTo( page, p[X] + 10, p[Y] - 12 )
		HPDF_Page_Stroke( page )
		
	end for
	
	HPDF_SaveToFile( pdf, fname )
	
	/* clean up */
	HPDF_Free( pdf )
	
	return 0
end function

sequence cmd = command_line()
if length( cmd ) > 2 then
	abort( main(length(cmd)-2, cmd[3..$]) )
end if

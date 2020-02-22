
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

constant PAGE_WIDTH = 420
constant PAGE_HEIGHT = 400
constant CELL_WIDTH = 20
constant CELL_HEIGHT = 20
constant CELL_HEADER = 10

procedure draw_graph( HPDF_Page page )
	
	sequence buf
	
	/* Draw 16 X 15 cells */
	
	HPDF_Page_SetLineWidth( page, 0.5 )
	
	/* Draw vertical lines. */
	for i = 0 to 17 do
		integer x = i * CELL_WIDTH + 40
		
		HPDF_Page_MoveTo( page, x, PAGE_HEIGHT - 60 )
		HPDF_Page_LineTo( page, x, 40 )
		HPDF_Page_Stroke( page )
		
		if i > 0 and i <= 16 then
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, x + 5, PAGE_HEIGHT - 75 )
			
			buf = sprintf( "%x", i - 1 )
			
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
		end if
		
	end for
	
	/* Draw horizontal lines. */
	for i = 0 to 15 do
		integer y = i * CELL_HEIGHT + 40
		
		HPDF_Page_MoveTo( page, 40, y )
		HPDF_Page_LineTo( page, PAGE_WIDTH - 40, y )
		HPDF_Page_Stroke( page )
		
		if i < 14 then
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, 45, y + 5 )
			
			buf = sprintf( "%x", 15 - i )
			
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
		end if
		
	end for
	
end procedure

procedure draw_fonts( HPDF_Page page )
	
	HPDF_Page_BeginText( page )
	
	for i = 1 to 16 do
		for j = 1 to 16 do
			sequence buf = "  "
			integer y = PAGE_HEIGHT - 55 - ((i - 1) * CELL_HEIGHT)
			integer x = j * CELL_WIDTH + 50
			
			buf[2] = 0
			
			buf[1] = (i - 1) * 16 + (j - 1)
			if buf[1] >= 32 then
				atom d
				
				d = x - HPDF_Page_TextWidth( page, buf ) / 2
				HPDF_Page_TextOut( page, d, y, buf )
			end if
			
		end for
	end for
	
	HPDF_Page_EndText( page )
	
end procedure

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	sequence fname
	HPDF_Font font
	sequence font_name
	HPDF_Outline root
	
	sequence encodings = {
		"StandardEncoding",
		"MacRomanEncoding",
		"WinAnsiEncoding",
		"ISO8859-2",
		"ISO8859-3",
		"ISO8859-4",
		"ISO8859-5",
		"ISO8859-9",
		"ISO8859-10",
		"ISO8859-13",
		"ISO8859-14",
		"ISO8859-15",
		"ISO8859-16",
		"CP1250",
		"CP1251",
		"CP1252",
		"CP1254",
		"CP1257",
		"KOI8-R",
		"Symbol-Set",
		"ZapfDingbats-Set"
	}
	
	pdf = HPDF_NewEx( error_handler_cb, NULL, NULL, 0, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	fname = argv[1]
	fname &= ".pdf"
	
	/* set compression mode */
	HPDF_SetCompressionMode( pdf, HPDF_COMP_ALL )
	
	/* Set page mode to use outlines. */
	HPDF_SetPageMode( pdf, HPDF_PAGE_MODE_USE_OUTLINE )
	
	/* get default font */
	font = HPDF_GetFont( pdf, "Helvetica", NULL )
	
	/* load font object */
	ifdef WINDOWS then
	font_name = HPDF_LoadType1FontFromFile( pdf, "type1\\a010013l.afm",
	                "type1\\a010013l.pfb" )
	elsedef
	font_name = HPDF_LoadType1FontFromFile( pdf, "type1/a010013l.afm",
	                "type1/a010013l.pfb" )
	end ifdef
	
	/* create outline root. */
	root = HPDF_CreateOutline( pdf, NULL, "Encoding list", NULL )
	HPDF_Outline_SetOpened( root, HPDF_TRUE )
	
	for i = 1 to length( encodings ) do
		
		HPDF_Page page = HPDF_AddPage( pdf )
		HPDF_Outline outline
		HPDF_Destination dst
		HPDF_Font font2
	
		HPDF_Page_SetWidth( page, PAGE_WIDTH )
		HPDF_Page_SetHeight( page, PAGE_HEIGHT )
	
		outline = HPDF_CreateOutline( pdf, root, encodings[i], NULL )
		dst = HPDF_Page_CreateDestination( page )
		HPDF_Destination_SetXYZ( dst, 0, HPDF_Page_GetHeight(page), 1 )
		/* HPDF_Destination_SetFitB(dst ) */
		HPDF_Outline_SetDestination( outline, dst )
	
		HPDF_Page_SetFontAndSize( page, font, 15 )
		draw_graph( page )
	
		HPDF_Page_BeginText( page )
		HPDF_Page_SetFontAndSize( page, font, 20 )
		HPDF_Page_MoveTextPos( page, 40, PAGE_HEIGHT - 50 )
		HPDF_Page_ShowText( page, encodings[i] )
		HPDF_Page_ShowText( page, " Encoding" )
		HPDF_Page_EndText( page )
		
		if equal( encodings[i], "Symbol-Set" ) then
			font2 = HPDF_GetFont( pdf, "Symbol", NULL )
		elsif equal( encodings[i], "ZapfDingbats-Set" ) then
			font2 = HPDF_GetFont( pdf, "ZapfDingbats", NULL )
		else
			font2 = HPDF_GetFont( pdf, font_name, encodings[i] )
		end if
		
		HPDF_Page_SetFontAndSize( page, font2, 14 )
		draw_fonts( page )
		
	end for
	
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

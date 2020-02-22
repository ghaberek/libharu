
include "std/io.e"
include "std/dll.e"
without warning

include "hpdf.e"

enum TRUE

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

constant PAGE_WIDTH = 420
constant CELL_HEIGHT = 20
constant CELL_WIDTH = 20

procedure draw_page( HPDF_Doc pdf, HPDF_Page page, HPDF_Font title_font, HPDF_Font font, integer h_byte, integer l_byte )
	
	atom h_count
	integer xpos, ypos
	atom page_height
	
	l_byte = floor(l_byte / 16) * 16
	h_count = 16 - (l_byte / 16)
	page_height = 40 + 40 + (h_count + 1) * CELL_HEIGHT
	
	HPDF_Page_SetHeight( page, page_height )
	HPDF_Page_SetWidth( page, PAGE_WIDTH )
	
	HPDF_Page_SetFontAndSize( page, title_font, 10 )
	
	ypos = h_count + 1
	while TRUE do
		integer y = ypos * CELL_HEIGHT + 40
		
		HPDF_Page_MoveTo( page, 40, y )
		HPDF_Page_LineTo( page, 380, y )
		HPDF_Page_Stroke( page )
		
		if ypos < h_count then
			sequence buf = "  "
			atom w
			
			buf[1] = 16 - ypos - 1
			if buf[1] < 10 then
				buf[1] += '0'
			else
				buf[1] += ('A' - 10)
			end if
			buf[2] = 0
			
			w = HPDF_Page_TextWidth( page, buf )
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, 40 + (20 - w) / 2, y + 5 )
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
			
		end if
		
		if ypos = 0 then
			exit
		end if
		
		ypos -= 1
	end while
	
	xpos = 0
	while xpos <= 17 do
		integer y = (h_count + 1) * CELL_HEIGHT + 40
		integer x = xpos * CELL_WIDTH + 40
		
		HPDF_Page_MoveTo( page, x, 40 )
		HPDF_Page_LineTo( page, x, y )
		HPDF_Page_Stroke( page )
		
		if xpos > 0 and xpos <= 16 then
			sequence buf = "  "
			atom w
			
			buf[1] = xpos - 1
			if buf[1] < 10 then
				buf[1] += '0'
			else
				buf[1] += ('A' - 10)
			end if
			buf[2] = 0
			
			w = HPDF_Page_TextWidth( page, buf )
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, x + (20 - w) / 2,
			                h_count * CELL_HEIGHT + 45 )
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
			
		end if
		
		xpos += 1
	end while
	
	HPDF_Page_SetFontAndSize( page, font, 15 )
	
	ypos = h_count
	while TRUE do
		integer y = (ypos - 1) * CELL_HEIGHT + 45
		
		xpos = 0
		while xpos < 16 do
			sequence buf = "   "
			atom w
			
			integer x = xpos * CELL_HEIGHT + 40 + CELL_WIDTH
			
			buf[1] = h_byte
			buf[2] = (16 - ypos) * 16 + xpos
			buf[3] = 0
			
			w = HPDF_Page_TextWidth( page, buf )
			if w > 0 then
				HPDF_Page_BeginText( page )
				HPDF_Page_MoveTextPos( page, x + (20 - w) / 2, y )
				HPDF_Page_ShowText( page, buf )
				HPDF_Page_EndText( page )
			end if
			
			xpos += 1
		end while
		
		if ypos = 0 then
			exit
		end if
		
		ypos -= 1
	end while
	
end procedure

function main( integer argc, sequence argv )
	
	atom min_l, max_l, min_h, max_h
	sequence fname
	sequence flg
	
	HPDF_Doc pdf
	HPDF_Encoder encoder
	HPDF_Font font
	HPDF_Outline root
	
	fname = argv[1]
	fname &= ".pdf"
	
	if argc < 3 then
		printf( STDOUT, "usage: character_map.ex <encoding-name> <font-name>\n" )
		printf( STDOUT, "for example, character_map.ex GBK-EUC-H SimHei,Bold\n" )
		return 1
	end if
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	/* configure pdf-document (showing outline, compression enabled) */
	HPDF_SetPageMode( pdf, HPDF_PAGE_MODE_USE_OUTLINE )
	HPDF_SetCompressionMode ( pdf, HPDF_COMP_ALL )
	HPDF_SetPagesConfiguration ( pdf, 10 )
	
	HPDF_UseJPEncodings( pdf )
	HPDF_UseJPFonts( pdf )
	HPDF_UseKREncodings( pdf )
	HPDF_UseKRFonts( pdf )
	HPDF_UseCNSEncodings( pdf )
	HPDF_UseCNSFonts( pdf )
	HPDF_UseCNTEncodings( pdf )
	HPDF_UseCNTFonts( pdf )
	
	encoder = HPDF_GetEncoder( pdf, argv[2] )
	if HPDF_Encoder_GetType( encoder ) != HPDF_ENCODER_TYPE_DOUBLE_BYTE then
		printf( STDOUT, "error: %s is not cmap-encoder\n", argv[2] )
		HPDF_Free( pdf )
		return 1
	end if
	
	font = HPDF_GetFont( pdf, argv[3], argv[2] )
	
	min_l = 255
	min_h = 256
	max_l = 0
	max_h = 0
	
	flg = repeat( 0, 256 )
	
	for i = 0 to 255 do
		for j = 20 to 255 do
			sequence buf = "   "
			HPDF_ByteType btype
			atom code = i * 256 + j
			atom unicode
			
			buf[1] = i
			buf[2] = j
			buf[3] = 0
			
			btype = HPDF_Encoder_GetByteType( encoder, buf, 0 )
			unicode = HPDF_Encoder_GetUnicode( encoder, code )
			
			if btype = HPDF_BYTE_TYPE_LEAD
					and unicode != 0x25A1 then
				
				if min_l > j then
					min_l = j
				end if
				
				if max_l < j then
					max_l = j
				end if
				
				if min_h > i then
					min_h = i
				end if
				
				if max_h < i then
					max_h = i
				end if
				
				flg[i+1] = 1
			end if
			
		end for
	end for
	
	printf( STDOUT, "min_h=%04x max_h=%04x min_l=%04x max_l=%04x\n",
	                {min_h,max_h,min_l,max_l} )
	
	/* create outline root. */
	root = HPDF_CreateOutline( pdf, NULL, argv[2], NULL )
	HPDF_Outline_SetOpened( root, HPDF_TRUE )
	
	for i = 0 to 255 do
		if flg[i+1] then
			sequence buf
			HPDF_Page page = HPDF_AddPage( pdf )
			HPDF_Font title_font = HPDF_GetFont( pdf, "Helvetica", NULL )
			HPDF_Outline outline
			HPDF_Destination dst
			
			buf = sprintf( "0x%04x-0x%04x", {i * 256 + min_l,i * 256 + max_l} )
			
			outline = HPDF_CreateOutline( pdf, root, buf, NULL )
			dst = HPDF_Page_CreateDestination( page )
			HPDF_Outline_SetDestination( outline, dst )
			
			draw_page( pdf, page, title_font, font, i, min_l)
			
			buf = sprintf( "%s (%s) 0x%04x-0x%04x", {argv[2],argv[3],i * 256 + min_l,i * 256 + max_l} )
			
			HPDF_Page_SetFontAndSize( page, title_font, 10 )
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, 40, HPDF_Page_GetHeight (page) - 35 )
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
			
		end if
	end for
	
	HPDF_SaveToFile( pdf, fname )
	HPDF_Free( pdf )
	
	return 0
end function

sequence cmd = command_line()
if length( cmd ) > 2 then
	abort( main(length(cmd)-2, cmd[3..$]) )
end if

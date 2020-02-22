
include "std/io.e"
include "std/dll.e"
include "std/convert.e"
without warning

include "hpdf.e"
include "grid_sheet.e"

function error_handler( atom error_no, atom detail_no, atom user_data )
	
	printf( STDOUT, "ERROR: error_no=%04x, detail_no=%d\n", {error_no,detail_no} )
	abort( error_no )
	
	return 0
end function
constant error_handler_id = routine_id( "error_handler" )
constant error_handler_cb = call_back( error_handler_id )

ifdef WINDOWS then
	constant FILE_SEPARATOR = "\\"
elsedef
	constant FILE_SEPARATOR = "/"
end ifdef

function main( integer argc, sequence argv )
	
	HPDF_Doc pdf
	HPDF_Page page
	sequence fname
	object buf
	integer cp932
	integer cp936
	sequence fcp936_name
	sequence fcp932_name
	HPDF_Font fcp936
	HPDF_Font fcp932
	
	if argc < 4 then
		printf( STDOUT, "chfont_demo <cp936-ttc-font-file-name> " &
		    "<cp936-index> <cp932-ttc-font-file-name> <cp932-index>\n" )
		return 1
	end if
	
	fname = "mbtext"
	fname &= FILE_SEPARATOR
	fname &= "cp932.txt"
	cp932 = open( fname, "rb" )
	if cp932 = -1 then
		printf( STDOUT, "error: cannot open cp932.txt\n" )
		return 1
	end if
	
	fname = "mbtext"
	fname &= FILE_SEPARATOR
	fname &= "cp936.txt"
	cp936 = open( fname, "rb" )
	if cp936 = -1 then
		printf( STDOUT, "error: cannot open cp936.txt\n" )
		return 1
	end if
	
	fname = argv[1]
	fname &= ".pdf"
	
	pdf = HPDF_New( error_handler_cb, NULL )
	if not pdf then
		printf( STDOUT, "error: cannot create PdfDoc object\n" )
		return 1
	end if
	
	HPDF_SetCompressionMode( pdf, HPDF_COMP_ALL )
	HPDF_UseJPEncodings( pdf )
	HPDF_UseCNSEncodings( pdf )
	
	fcp936_name = HPDF_LoadTTFontFromFile2( pdf, argv[2], to_integer(argv[3]),
	                HPDF_TRUE )
	fcp932_name = HPDF_LoadTTFontFromFile2( pdf, argv[4], to_integer(argv[5]),
	                HPDF_TRUE )
	
	/* add a new page object. */
	page = HPDF_AddPage( pdf )
	
	HPDF_Page_SetHeight( page, 300 )
	HPDF_Page_SetWidth( page, 550 )
	
	fcp936 = HPDF_GetFont( pdf, fcp936_name, "GBK-EUC-H" )
	fcp932 = HPDF_GetFont( pdf, fcp932_name, "90ms-RKSJ-H" )
	
	print_grid( pdf, page )
	
	HPDF_Page_SetTextLeading( page, 20 )
	
	HPDF_Page_BeginText( page )
	HPDF_Page_MoveTextPos( page, 50, 250 )
	HPDF_Page_SetTextLeading( page, 25 )
	
	while sequence( buf ) with entry do
		HPDF_Page_SetFontAndSize( page, fcp936, 18 )
		HPDF_Page_ShowText( page, buf )
		
		buf = gets( cp932 )
		if sequence( buf ) then
			HPDF_Page_SetFontAndSize( page, fcp932, 18 )
			HPDF_Page_ShowText( page, buf )
		end if
		
		HPDF_Page_MoveToNextLine( page )
		
	entry
		buf = gets( cp936 )
		
	end while
	
	/* save the document to a file */
	HPDF_SaveToFile( pdf, fname )
	
	/* clean up */
	HPDF_Free( pdf )
	
	close( cp936 )
	close( cp932 )
	
	return 0
end function

sequence cmd = command_line()
if length( cmd ) > 2 then
	abort( main(length(cmd)-2, cmd[3..$]) )
end if

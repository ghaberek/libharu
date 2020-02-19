
include "hpdf.e"

constant NULL = 0

public procedure print_grid( HPDF_Doc pdf, HPDF_Page page )
	
	atom height = HPDF_Page_GetHeight( page )
	atom width = HPDF_Page_GetWidth( page )
	HPDF_Font font = HPDF_GetFont( pdf, "Helvetica", NULL )
	
	atom x, y
	
	HPDF_Page_SetFontAndSize( page, font, 5 )
	HPDF_Page_SetGrayFill( page, 0.5 )
	HPDF_Page_SetGrayStroke( page, 0.8 )
	
	/* Draw horizontal lines */
	
	y = 0
	while y < height do
		
		if remainder( y, 10 ) = 0 then
			HPDF_Page_SetLineWidth( page, 0.5 )
		else
			if HPDF_Page_GetLineWidth( page ) != 0.25 then
				HPDF_Page_SetLineWidth( page, 0.25 )
			end if
		end if
		
		HPDF_Page_MoveTo( page, 0, y )
		HPDF_Page_LineTo( page, width, y )
		HPDF_Page_Stroke( page )
		
		if remainder( y, 10 ) = 0 and y > 0 then
			
			HPDF_Page_SetGrayStroke( page, 0.5 )
			
			HPDF_Page_MoveTo( page, 0, y )
			HPDF_Page_LineTo( page, 5, y )
			HPDF_Page_Stroke( page )
			
			HPDF_Page_SetGrayStroke( page, 0.8 )
			
		end if
		
		y += 5
		
	end while
	
	/* Draw virtical lines */
	
	x = 0
	
	while x < width do
		
		if remainder( x, 10 ) = 0 then
			HPDF_Page_SetLineWidth( page, 0.5 )
		else
			if HPDF_Page_GetLineWidth( page ) != 0.25 then
				HPDF_Page_SetLineWidth( page, 0.25 )
			end if
		end if
		
		HPDF_Page_MoveTo( page, x, 0 )
		HPDF_Page_LineTo( page, x, height )
		HPDF_Page_Stroke( page )
		
		if remainder( x, 50 ) = 0 and x > 0 then
			
			HPDF_Page_SetGrayStroke( page, 0.5 )
			
			HPDF_Page_MoveTo( page, x, 0 )
			HPDF_Page_LineTo( page, x, 5 )
			HPDF_Page_Stroke( page )
			
			HPDF_Page_MoveTo( page, x, height )
			HPDF_Page_LineTo( page, x, height - 5 )
			HPDF_Page_Stroke( page )
			
			HPDF_Page_SetGrayStroke( page, 0.8 )
			
		end if
		
		x += 5
		
	end while
	
	/* Draw horizontal text */
	
	y = 0
	while y < height do
		
		if remainder( y, 10 ) = 0 and y > 0 then
			sequence buf
			
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, 5, y - 2 )
			
			buf = sprintf( "%d", y )
			
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
			
		end if
		
		y += 5
		
	end while
	
	/* Draw virtical text */
	
	x = 0
	while x < width do
		
		if remainder( x, 50 ) = 0 and x > 0 then
			sequence buf
			
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, x, 5 )
			
			buf = sprintf( "%d", x )
			
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
			
			HPDF_Page_BeginText( page )
			HPDF_Page_MoveTextPos( page, x, height - 10 )
			HPDF_Page_ShowText( page, buf )
			HPDF_Page_EndText( page )
			
		end if
		
		x += 5
		
	end while
	
	HPDF_Page_SetGrayFill( page, 0 )
	HPDF_Page_SetGrayStroke( page, 0 )
	
end procedure

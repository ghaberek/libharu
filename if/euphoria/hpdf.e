
namespace hpdf

include std/dll.e
include std/machine.e
include std/convert.e
include std/types.e

public include hpdf_consts.e
public include hpdf_error.e
public include hpdf_types.e

constant 
	C_STRING    = C_POINTER,
	C_PVOID     = C_POINTER,
$

constant
	HPDF_PBYTE  = C_POINTER,
$

constant
	HPDF_HANDLE         = C_POINTER,
	HPDF_DOC            = HPDF_HANDLE,
	HPDF_PAGE           = HPDF_HANDLE,
	HPDF_PAGES          = HPDF_HANDLE,
	HPDF_STREAM         = HPDF_HANDLE,
	HPDF_IMAGE          = HPDF_HANDLE,
	HPDF_FONT           = HPDF_HANDLE,
	HPDF_OUTLINE        = HPDF_HANDLE,
	HPDF_ENCODER        = HPDF_HANDLE,
	HPDF_3DMEASURE      = HPDF_HANDLE,
	HPDF_EXDATA         = HPDF_HANDLE,
	HPDF_DESTINATION    = HPDF_HANDLE,
	HPDF_XOBJECT        = HPDF_HANDLE,
	HPDF_ANNOTATION     = HPDF_HANDLE,
	HPDF_EXTGSTATE      = HPDF_HANDLE,
	HPDF_FONTDEF        = HPDF_HANDLE,
	HPDF_U3D            = HPDF_HANDLE,
	HPDF_JAVASCRIPT     = HPDF_HANDLE,
	HPDF_ERROR          = HPDF_HANDLE,
	HPDF_MMGR           = HPDF_HANDLE,
	HPDF_DICT           = HPDF_HANDLE,
	HPDF_EMBEDDEDFILE   = HPDF_HANDLE,
	HPDF_OUTPUTINTENT   = HPDF_HANDLE,
	HPDF_XREF           = HPDF_HANDLE,
$

function _( sequence string, integer cleanup = TRUE )
	return allocate_string( string, cleanup )
end function

function peek_float32( object addr_n_length )
	
	if atom( addr_n_length ) then
		return float32_to_atom( peek({addr_n_length,sizeof(C_FLOAT)}) )
	end if
	
	sequence data = repeat( 0, addr_n_length[2] )
	
	for i = 1 to length( data ) do
		data[i] = peek_float32( addr_n_length[1] )
		addr_n_length[1] += sizeof( C_FLOAT )
	end for
	
	return data
end function

ifdef DEBUG then
	
	function open_dll( sequence name )
		atom handle = dll:open_dll( name )
		printf( 1, "0x%08x %s\n", {handle,name} )
		if handle = NULL then abort(1) end if
		return handle
	end function
	
	function define_c_func( atom lib, sequence name, sequence params, atom ret )
		integer id = dll:define_c_func( lib, name, params, ret )
		printf( 1, "%3d %s\n", {id,name} )
		if id = -1 then abort(1) end if
		return id
	end function
	
	function define_c_proc( atom lib, sequence name, sequence params )
		integer id = dll:define_c_proc( lib, name, params )
		printf( 1, "%3d %s\n", {id,name} )
		if id = -1 then abort(1) end if
		return id
	end function
	
end ifdef

ifdef WINDOWS then
	atom libhpdf = open_dll( "libhpdf.dll" )

elsifdef LINUX then
	atom libhpdf = open_dll( "libhpdf.so" )

end ifdef

constant
	xHPDF_GetVersion                            = define_c_func( libhpdf, "HPDF_GetVersion", {}, C_STRING ),
	xHPDF_NewEx                                 = define_c_func( libhpdf, "HPDF_NewEx", {HPDF_ERROR_HANDLER,HPDF_ALLOC_FUNC,HPDF_FREE_FUNC,HPDF_UINT,C_PVOID}, HPDF_DOC ),
	xHPDF_New                                   = define_c_func( libhpdf, "HPDF_New", {HPDF_ERROR_HANDLER,C_PVOID}, HPDF_DOC ),
	xHPDF_SetErrorHandler                       = define_c_func( libhpdf, "HPDF_SetErrorHandler", {HPDF_DOC,HPDF_ERROR_HANDLER}, HPDF_STATUS ),
	xHPDF_Free                                  = define_c_proc( libhpdf, "HPDF_Free", {HPDF_DOC} ),
	xHPDF_NewDoc                                = define_c_func( libhpdf, "HPDF_NewDoc", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_FreeDoc                               = define_c_proc( libhpdf, "HPDF_FreeDoc", {HPDF_DOC} ),
	xHPDF_HasDoc                                = define_c_func( libhpdf, "HPDF_HasDoc", {HPDF_DOC}, HPDF_BOOL ),
	xHPDF_FreeDocAll                            = define_c_proc( libhpdf, "HPDF_FreeDocAll", {HPDF_DOC} ),
	xHPDF_SaveToStream                          = define_c_func( libhpdf, "HPDF_SaveToStream", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_GetContents                           = define_c_func( libhpdf, "HPDF_GetContents", {HPDF_DOC,HPDF_PBYTE,HPDF_UINT32}, HPDF_STATUS ),
	xHPDF_GetStreamSize                         = define_c_func( libhpdf, "HPDF_GetStreamSize", {HPDF_DOC}, HPDF_UINT32 ),
	xHPDF_ReadFromStream                        = define_c_func( libhpdf, "HPDF_ReadFromStream", {HPDF_DOC,HPDF_PBYTE,HPDF_UINT32}, HPDF_STATUS ),
	xHPDF_ResetStream                           = define_c_func( libhpdf, "HPDF_ResetStream", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_SaveToFile                            = define_c_func( libhpdf, "HPDF_SaveToFile", {HPDF_DOC,C_STRING}, HPDF_STATUS ),
	xHPDF_GetError                              = define_c_func( libhpdf, "HPDF_GetError", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_GetErrorDetail                        = define_c_func( libhpdf, "HPDF_GetErrorDetail", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_ResetError                            = define_c_proc( libhpdf, "HPDF_ResetError", {HPDF_DOC} ),
	xHPDF_CheckError                            = define_c_func( libhpdf, "HPDF_CheckError", {HPDF_ERROR}, HPDF_STATUS ),
	xHPDF_SetPagesConfiguration                 = define_c_func( libhpdf, "HPDF_SetPagesConfiguration", {HPDF_DOC,HPDF_UINT}, HPDF_STATUS ),
	xHPDF_GetPageByIndex                        = define_c_func( libhpdf, "HPDF_GetPageByIndex", {HPDF_DOC,HPDF_UINT}, HPDF_PAGE ),
	-- -----------------------------------------
	xHPDF_GetPageMMgr                           = define_c_func( libhpdf, "HPDF_GetPageMMgr", {HPDF_PAGE}, HPDF_MMGR ),
	xHPDF_GetPageLayout                         = define_c_func( libhpdf, "HPDF_GetPageLayout", {HPDF_DOC}, HPDF_PAGELAYOUT ),
	xHPDF_SetPageLayout                         = define_c_func( libhpdf, "HPDF_SetPageLayout", {HPDF_DOC,HPDF_PAGELAYOUT}, HPDF_STATUS ),
	xHPDF_GetPageMode                           = define_c_func( libhpdf, "HPDF_GetPageMode", {HPDF_DOC}, HPDF_PAGEMODE ),
	xHPDF_SetPageMode                           = define_c_func( libhpdf, "HPDF_SetPageMode", {HPDF_DOC,HPDF_PAGEMODE}, HPDF_STATUS ),
	xHPDF_GetViewerPreference                   = define_c_func( libhpdf, "HPDF_GetViewerPreference", {HPDF_DOC}, HPDF_UINT ),
	xHPDF_SetViewerPreference                   = define_c_func( libhpdf, "HPDF_SetViewerPreference", {HPDF_DOC,HPDF_UINT}, HPDF_STATUS ),
	xHPDF_SetOpenAction                         = define_c_func( libhpdf, "HPDF_SetOpenAction", {HPDF_DOC,HPDF_DESTINATION}, HPDF_STATUS ),
	-- page handling ---------------------------
	xHPDF_GetCurrentPage                        = define_c_func( libhpdf, "HPDF_GetCurrentPage", {HPDF_DOC}, HPDF_PAGE ),
	xHPDF_AddPage                               = define_c_func( libhpdf, "HPDF_AddPage", {HPDF_DOC}, HPDF_PAGE ),
	xHPDF_InsertPage                            = define_c_func( libhpdf, "HPDF_InsertPage", {HPDF_DOC,HPDF_PAGE}, HPDF_PAGE ),
	xHPDF_Page_SetWidth                         = define_c_func( libhpdf, "HPDF_Page_SetWidth", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetHeight                        = define_c_func( libhpdf, "HPDF_Page_SetHeight", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetSize                          = define_c_func( libhpdf, "HPDF_Page_SetSize", {HPDF_PAGE,HPDF_PAGESIZES,HPDF_PAGEDIRECTION}, HPDF_STATUS ),
	xHPDF_Page_SetRotate                        = define_c_func( libhpdf, "HPDF_Page_SetRotate", {HPDF_PAGE,HPDF_UINT16}, HPDF_STATUS ),
	xHPDF_Page_SetZoom                          = define_c_func( libhpdf, "HPDF_Page_SetZoom", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	-- font handling ---------------------------
	xHPDF_GetFont                               = define_c_func( libhpdf, "HPDF_GetFont", {HPDF_DOC,C_STRING,C_STRING}, HPDF_FONT ),
	xHPDF_LoadType1FontFromFile                 = define_c_func( libhpdf, "HPDF_LoadType1FontFromFile", {HPDF_DOC,C_STRING,C_STRING}, C_STRING ),
	xHPDF_GetTTFontDefFromFile                  = define_c_func( libhpdf, "HPDF_GetTTFontDefFromFile", {HPDF_DOC,C_STRING,HPDF_BOOL}, HPDF_FONTDEF ),
	xHPDF_LoadTTFontFromFile                    = define_c_func( libhpdf, "HPDF_LoadTTFontFromFile", {HPDF_DOC,C_STRING,HPDF_BOOL}, C_STRING ),
	xHPDF_LoadTTFontFromFile2                   = define_c_func( libhpdf, "HPDF_LoadTTFontFromFile2", {HPDF_DOC,C_STRING,HPDF_UINT,HPDF_BOOL}, C_STRING ),
	xHPDF_AddPageLabel                          = define_c_func( libhpdf, "HPDF_AddPageLabel", {HPDF_DOC,HPDF_UINT,HPDF_PAGENUMSTYLE,HPDF_UINT,C_STRING}, HPDF_STATUS ),
	xHPDF_UseJPFonts                            = define_c_func( libhpdf, "HPDF_UseJPFonts", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_UseKRFonts                            = define_c_func( libhpdf, "HPDF_UseKRFonts", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_UseCNSFonts                           = define_c_func( libhpdf, "HPDF_UseCNSFonts", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_UseCNTFonts                           = define_c_func( libhpdf, "HPDF_UseCNTFonts", {HPDF_DOC}, HPDF_STATUS ),
	-- outline ---------------------------------
	xHPDF_CreateOutline                         = define_c_func( libhpdf, "HPDF_CreateOutline", {HPDF_DOC,HPDF_OUTLINE,C_STRING,HPDF_ENCODER}, HPDF_OUTLINE ),
	xHPDF_Outline_SetOpened                     = define_c_func( libhpdf, "HPDF_Outline_SetOpened", {HPDF_OUTLINE,HPDF_BOOL}, HPDF_STATUS ),
	xHPDF_Outline_SetDestination                = define_c_func( libhpdf, "HPDF_Outline_SetDestination", {HPDF_OUTLINE,HPDF_DESTINATION}, HPDF_STATUS ),
	-- destination -----------------------------
	xHPDF_Page_CreateDestination                = define_c_func( libhpdf, "HPDF_Page_CreateDestination", {HPDF_PAGE}, HPDF_DESTINATION ),
	xHPDF_Destination_SetXYZ                    = define_c_func( libhpdf, "HPDF_Destination_SetXYZ", {HPDF_DESTINATION,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Destination_SetFit                    = define_c_func( libhpdf, "HPDF_Destination_SetFit", {HPDF_DESTINATION}, HPDF_STATUS ),
	xHPDF_Destination_SetFitH                   = define_c_func( libhpdf, "HPDF_Destination_SetFitH", {HPDF_DESTINATION,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Destination_SetFitV                   = define_c_func( libhpdf, "HPDF_Destination_SetFitV", {HPDF_DESTINATION,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Destination_SetFitR                   = define_c_func( libhpdf, "HPDF_Destination_SetFitR", {HPDF_DESTINATION,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Destination_SetFitB                   = define_c_func( libhpdf, "HPDF_Destination_SetFitB", {HPDF_DESTINATION}, HPDF_STATUS ),
	xHPDF_Destination_SetFitBH                  = define_c_func( libhpdf, "HPDF_Destination_SetFitBH", {HPDF_DESTINATION,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Destination_SetFitBV                  = define_c_func( libhpdf, "HPDF_Destination_SetFitBV", {HPDF_DESTINATION,HPDF_REAL}, HPDF_STATUS ),
	-- encoder ---------------------------------
	xHPDF_GetEncoder                            = define_c_func( libhpdf, "HPDF_GetEncoder", {HPDF_DOC,C_STRING}, HPDF_ENCODER ),
	xHPDF_GetCurrentEncoder                     = define_c_func( libhpdf, "HPDF_GetCurrentEncoder", {HPDF_DOC}, HPDF_ENCODER ),
	xHPDF_SetCurrentEncoder                     = define_c_func( libhpdf, "HPDF_SetCurrentEncoder", {HPDF_DOC,C_STRING}, HPDF_STATUS ),
	xHPDF_Encoder_GetType                       = define_c_func( libhpdf, "HPDF_Encoder_GetType", {HPDF_ENCODER}, HPDF_ENCODERTYPE ),
	xHPDF_Encoder_GetByteType                   = define_c_func( libhpdf, "HPDF_Encoder_GetByteType", {HPDF_ENCODER,C_STRING,HPDF_UINT}, HPDF_BYTETYPE ),
	xHPDF_Encoder_GetUnicode                    = define_c_func( libhpdf, "HPDF_Encoder_GetUnicode", {HPDF_ENCODER,HPDF_UINT16}, HPDF_UNICODE ),
	xHPDF_Encoder_GetWritingMode                = define_c_func( libhpdf, "HPDF_Encoder_GetWritingMode", {HPDF_ENCODER}, HPDF_WRITINGMODE ),
	xHPDF_UseJPEncodings                        = define_c_func( libhpdf, "HPDF_UseJPEncodings", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_UseKREncodings                        = define_c_func( libhpdf, "HPDF_UseKREncodings", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_UseCNSEncodings                       = define_c_func( libhpdf, "HPDF_UseCNSEncodings", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_UseCNTEncodings                       = define_c_func( libhpdf, "HPDF_UseCNTEncodings", {HPDF_DOC}, HPDF_STATUS ),
	xHPDF_UseUTFEncodings                       = define_c_func( libhpdf, "HPDF_UseUTFEncodings", {HPDF_DOC}, HPDF_STATUS ),
	-- XObject ---------------------------------
	xHPDF_Page_CreateXObjectFromImage           = define_c_func( libhpdf, "HPDF_Page_CreateXObjectFromImage", {HPDF_DOC,HPDF_PAGE} & HPDF_RECT & {HPDF_IMAGE,HPDF_BOOL}, HPDF_XOBJECT ),
	xHPDF_Page_CreateXObjectAsWhiteRect         = define_c_func( libhpdf, "HPDF_Page_CreateXObjectAsWhiteRect", {HPDF_DOC,HPDF_PAGE} & HPDF_RECT, HPDF_XOBJECT ),
	-- annotation ------------------------------
	xHPDF_Page_Create3DAnnot                    = define_c_func( libhpdf, "HPDF_Page_Create3DAnnot", {HPDF_PAGE} & HPDF_RECT & {HPDF_BOOL,HPDF_BOOL,HPDF_U3D,HPDF_IMAGE}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateTextAnnot                  = define_c_func( libhpdf, "HPDF_Page_CreateTextAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateFreeTextAnnot              = define_c_func( libhpdf, "HPDF_Page_CreateFreeTextAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateLineAnnot                  = define_c_func( libhpdf, "HPDF_Page_CreateLineAnnot", {HPDF_PAGE,C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateWidgetAnnot_WhiteOnlyWhilePrint = define_c_func( libhpdf, "HPDF_Page_CreateWidgetAnnot_WhiteOnlyWhilePrint", {HPDF_DOC,HPDF_PAGE} & HPDF_RECT, HPDF_ANNOTATION ),
	xHPDF_Page_CreateWidgetAnnot                = define_c_func( libhpdf, "HPDF_Page_CreateWidgetAnnot", {HPDF_PAGE} & HPDF_RECT, HPDF_ANNOTATION ),
	xHPDF_Page_CreateLinkAnnot                  = define_c_func( libhpdf, "HPDF_Page_CreateLinkAnnot", {HPDF_PAGE} & HPDF_RECT & {HPDF_DESTINATION}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateURILinkAnnot               = define_c_func( libhpdf, "HPDF_Page_CreateURILinkAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateTextMarkupAnnot            = define_c_func( libhpdf, "HPDF_Page_CreateTextMarkupAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER,HPDF_ANNOTTYPE}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateHighlightAnnot             = define_c_func( libhpdf, "HPDF_Page_CreateHighlightAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateUnderlineAnnot             = define_c_func( libhpdf, "HPDF_Page_CreateUnderlineAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateSquigglyAnnot              = define_c_func( libhpdf, "HPDF_Page_CreateSquigglyAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateStrikeOutAnnot             = define_c_func( libhpdf, "HPDF_Page_CreateStrikeOutAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreatePopupAnnot                 = define_c_func( libhpdf, "HPDF_Page_CreatePopupAnnot", {HPDF_PAGE} & HPDF_RECT & {HPDF_ANNOTATION}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateStampAnnot                 = define_c_func( libhpdf, "HPDF_Page_CreateStampAnnot", {HPDF_PAGE} & HPDF_RECT & {HPDF_STAMPANNOTNAME,C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateProjectionAnnot            = define_c_func( libhpdf, "HPDF_Page_CreateProjectionAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateSquareAnnot                = define_c_func( libhpdf, "HPDF_Page_CreateSquareAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_Page_CreateCircleAnnot                = define_c_func( libhpdf, "HPDF_Page_CreateCircleAnnot", {HPDF_PAGE} & HPDF_RECT & {C_STRING,HPDF_ENCODER}, HPDF_ANNOTATION ),
	xHPDF_LinkAnnot_SetHighlightMode            = define_c_func( libhpdf, "HPDF_LinkAnnot_SetHighlightMode", {HPDF_ANNOTATION,HPDF_ANNOTHIGHLIGHTMODE}, HPDF_STATUS ),
	xHPDF_LinkAnnot_SetJavaScript               = define_c_func( libhpdf, "HPDF_LinkAnnot_SetJavaScript", {HPDF_ANNOTATION,HPDF_JAVASCRIPT}, HPDF_STATUS ),
	xHPDF_LinkAnnot_SetBorderStyle              = define_c_func( libhpdf, "HPDF_LinkAnnot_SetBorderStyle", {HPDF_ANNOTATION,HPDF_REAL,HPDF_UINT16,HPDF_UINT16}, HPDF_STATUS ),
	xHPDF_TextAnnot_SetIcon                     = define_c_func( libhpdf, "HPDF_TextAnnot_SetIcon", {HPDF_ANNOTATION,HPDF_ANNOTICON}, HPDF_STATUS ),
	xHPDF_TextAnnot_SetOpened                   = define_c_func( libhpdf, "HPDF_TextAnnot_SetOpened", {HPDF_ANNOTATION,HPDF_BOOL}, HPDF_STATUS ),
	xHPDF_Annot_SetRGBColor                     = define_c_func( libhpdf, "HPDF_Annot_SetRGBColor", {HPDF_ANNOTATION} & HPDF_RGBCOLOR, HPDF_STATUS ),
	xHPDF_Annot_SetCMYKColor                    = define_c_func( libhpdf, "HPDF_Annot_SetCMYKColor", {HPDF_ANNOTATION} & HPDF_CMYKCOLOR, HPDF_STATUS ), 
	xHPDF_Annot_SetGrayColor                    = define_c_func( libhpdf, "HPDF_Annot_SetGrayColor", {HPDF_ANNOTATION,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Annot_SetNoColor                      = define_c_func( libhpdf, "HPDF_Annot_SetNoColor", {HPDF_ANNOTATION}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetTitle                  = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetTitle", {HPDF_ANNOTATION,C_STRING}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetSubject                = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetSubject", {HPDF_ANNOTATION,C_STRING}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetCreationDate           = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetCreationDate", {HPDF_ANNOTATION} & HPDF_DATE, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetTransparency           = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetTransparency", {HPDF_ANNOTATION,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetIntent                 = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetIntent", {HPDF_ANNOTATION,HPDF_ANNOTINTENT}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetPopup                  = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetPopup", {HPDF_ANNOTATION,HPDF_ANNOTATION}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetRectDiff               = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetRectDiff", {HPDF_ANNOTATION} & HPDF_RECT, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetCloudEffect            = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetCloudEffect", {HPDF_ANNOTATION,HPDF_INT}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetInteriorRGBColor       = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetInteriorRGBColor", {HPDF_ANNOTATION} & HPDF_RGBCOLOR, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetInteriorCMYKColor      = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetInteriorCMYKColor", {HPDF_ANNOTATION} & HPDF_CMYKCOLOR, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetInteriorGrayColor      = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetInteriorGrayColor", {HPDF_ANNOTATION,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_MarkupAnnot_SetInteriorTransparent    = define_c_func( libhpdf, "HPDF_MarkupAnnot_SetInteriorTransparent", {HPDF_ANNOTATION}, HPDF_STATUS ),
	xHPDF_TextMarkupAnnot_SetQuadPoints         = define_c_func( libhpdf, "HPDF_TextMarkupAnnot_SetQuadPoints", {HPDF_ANNOTATION} & HPDF_POINT & HPDF_POINT & HPDF_POINT & HPDF_POINT, HPDF_STATUS ),
	xHPDF_Annot_Set3DView                       = define_c_func( libhpdf, "HPDF_Annot_Set3DView", {HPDF_MMGR,HPDF_ANNOTATION,HPDF_ANNOTATION,HPDF_DICT}, HPDF_STATUS ),
	xHPDF_PopupAnnot_SetOpened                  = define_c_func( libhpdf, "HPDF_PopupAnnot_SetOpened", {HPDF_ANNOTATION,HPDF_BOOL}, HPDF_STATUS ),
	xHPDF_FreeTextAnnot_SetLineEndingStyle      = define_c_func( libhpdf, "HPDF_FreeTextAnnot_SetLineEndingStyle", {HPDF_ANNOTATION,HPDF_LINEANNOTENDINGSTYLE,HPDF_LINEANNOTENDINGSTYLE}, HPDF_STATUS ),
	xHPDF_FreeTextAnnot_Set3PointCalloutLine    = define_c_func( libhpdf, "HPDF_FreeTextAnnot_Set3PointCalloutLine", {HPDF_ANNOTATION} & HPDF_POINT & HPDF_POINT & HPDF_POINT, HPDF_STATUS ),
	xHPDF_FreeTextAnnot_Set2PointCalloutLine    = define_c_func( libhpdf, "HPDF_FreeTextAnnot_Set2PointCalloutLine", {HPDF_ANNOTATION} & HPDF_POINT & HPDF_POINT, HPDF_STATUS ),
	xHPDF_FreeTextAnnot_SetDefaultStyle         = define_c_func( libhpdf, "HPDF_FreeTextAnnot_SetDefaultStyle", {HPDF_ANNOTATION,C_STRING}, HPDF_STATUS ),
	xHPDF_LineAnnot_SetPosition                 = define_c_func( libhpdf, "HPDF_LineAnnot_SetPosition", {HPDF_ANNOTATION} & HPDF_POINT & {HPDF_LINEANNOTENDINGSTYLE} & HPDF_POINT & {HPDF_LINEANNOTENDINGSTYLE}, HPDF_STATUS ),
	xHPDF_LineAnnot_SetLeader                   = define_c_func( libhpdf, "HPDF_LineAnnot_SetLeader", {HPDF_ANNOTATION,HPDF_INT,HPDF_INT,HPDF_INT}, HPDF_STATUS ),
	xHPDF_LineAnnot_SetCaption                  = define_c_func( libhpdf, "HPDF_LineAnnot_SetCaption", {HPDF_ANNOTATION,HPDF_BOOL,HPDF_LINEANNOTCAPPOSITION,HPDF_INT,HPDF_INT}, HPDF_STATUS ),
	xHPDF_Annotation_SetBorderStyle             = define_c_func( libhpdf, "HPDF_Annotation_SetBorderStyle", {HPDF_ANNOTATION,HPDF_BSSUBTYPE,HPDF_REAL,HPDF_UINT16,HPDF_UINT16,HPDF_UINT16}, HPDF_STATUS ),
	xHPDF_ProjectionAnnot_SetExData             = define_c_func( libhpdf, "HPDF_ProjectionAnnot_SetExData", {HPDF_ANNOTATION,HPDF_EXDATA}, HPDF_STATUS ),
	-- 3D Measure ------------------------------
	xHPDF_Page_Create3DC3DMeasure               = define_c_func( libhpdf, "HPDF_Page_Create3DC3DMeasure", {HPDF_PAGE} & HPDF_POINT3D & HPDF_POINT3D, HPDF_3DMEASURE ),
	xHPDF_Page_CreatePD33DMeasure               = define_c_func( libhpdf, "HPDF_Page_CreatePD33DMeasure", {HPDF_PAGE} & HPDF_POINT3D & HPDF_POINT3D & HPDF_POINT3D & HPDF_POINT3D & HPDF_POINT3D & HPDF_POINT3D & {HPDF_REAL,C_STRING}, HPDF_3DMEASURE ),
	xHPDF_3DMeasure_SetName                     = define_c_func( libhpdf, "HPDF_3DMeasure_SetName", {HPDF_3DMEASURE,C_STRING}, HPDF_STATUS ),
	xHPDF_3DMeasure_SetColor                    = define_c_func( libhpdf, "HPDF_3DMeasure_SetColor" ,{HPDF_3DMEASURE} & HPDF_RGBCOLOR, HPDF_STATUS ),
	xHPDF_3DMeasure_SetTextSize                 = define_c_func( libhpdf, "HPDF_3DMeasure_SetTextSize", {HPDF_3DMEASURE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_3DC3DMeasure_SetTextBoxSize           = define_c_func( libhpdf, "HPDF_3DC3DMeasure_SetTextBoxSize", {HPDF_3DMEASURE,HPDF_INT32,HPDF_INT32}, HPDF_STATUS ),
	xHPDF_3DC3DMeasure_SetText                  = define_c_func( libhpdf, "HPDF_3DC3DMeasure_SetText", {HPDF_3DMEASURE,C_STRING,HPDF_ENCODER}, HPDF_STATUS ),
	xHPDF_3DC3DMeasure_SetProjectionAnotation   = define_c_func( libhpdf, "HPDF_3DC3DMeasure_SetProjectionAnotation", {HPDF_3DMEASURE,HPDF_ANNOTATION}, HPDF_STATUS ),
	-- External Data ---------------------------
	xHPDF_Page_Create3DAnnotExData              = define_c_func( libhpdf, "HPDF_Page_Create3DAnnotExData", {HPDF_PAGE}, HPDF_EXDATA ),
	xHPDF_3DAnnotExData_Set3DMeasurement        = define_c_func( libhpdf, "HPDF_3DAnnotExData_Set3DMeasurement", {HPDF_EXDATA,HPDF_3DMEASURE}, HPDF_STATUS ),
	-- 3D View ---------------------------------
	xHPDF_Page_Create3DView                     = define_c_func( libhpdf, "HPDF_Page_Create3DView", {HPDF_PAGE,HPDF_U3D,HPDF_ANNOTATION,C_STRING}, HPDF_DICT ),
	xHPDF_3DView_Add3DC3DMeasure                = define_c_func( libhpdf, "HPDF_3DView_Add3DC3DMeasure", {HPDF_DICT,HPDF_3DMEASURE}, HPDF_STATUS ),
	-- image data ------------------------------
	xHPDF_LoadPngImageFromMem                   = define_c_func( libhpdf, "HPDF_LoadPngImageFromMem", {HPDF_DOC,HPDF_PBYTE,HPDF_UINT}, HPDF_IMAGE ),
	xHPDF_LoadPngImageFromFile                  = define_c_func( libhpdf, "HPDF_LoadPngImageFromFile", {HPDF_DOC,C_STRING}, HPDF_IMAGE ),
	xHPDF_LoadPngImageFromFile2                 = define_c_func( libhpdf, "HPDF_LoadPngImageFromFile2", {HPDF_DOC,C_STRING}, HPDF_IMAGE ),
	xHPDF_LoadJpegImageFromFile                 = define_c_func( libhpdf, "HPDF_LoadJpegImageFromFile", {HPDF_DOC,C_STRING}, HPDF_IMAGE ),
	xHPDF_LoadJpegImageFromMem                  = define_c_func( libhpdf, "HPDF_LoadJpegImageFromMem", {HPDF_DOC,HPDF_PBYTE,HPDF_UINT}, HPDF_IMAGE ),
	xHPDF_LoadU3DFromFile                       = define_c_func( libhpdf, "HPDF_LoadU3DFromFile", {HPDF_DOC,C_STRING}, HPDF_IMAGE ),
	xHPDF_LoadU3DFromMem                        = define_c_func( libhpdf, "HPDF_LoadU3DFromMem", {HPDF_DOC,HPDF_PBYTE,HPDF_UINT}, HPDF_IMAGE ),
	xHPDF_Image_LoadRaw1BitImageFromMem         = define_c_func( libhpdf, "HPDF_Image_LoadRaw1BitImageFromMem", {HPDF_DOC,HPDF_PBYTE,HPDF_UINT,HPDF_UINT,HPDF_UINT,HPDF_BOOL,HPDF_BOOL}, HPDF_IMAGE ),
	xHPDF_LoadRawImageFromFile                  = define_c_func( libhpdf, "HPDF_LoadRawImageFromFile", {HPDF_DOC,C_STRING,HPDF_UINT,HPDF_UINT,HPDF_COLORSPACE}, HPDF_IMAGE ),
	xHPDF_LoadRawImageFromMem                   = define_c_func( libhpdf, "HPDF_LoadRawImageFromMem", {HPDF_DOC,HPDF_PBYTE,HPDF_UINT,HPDF_UINT,HPDF_COLORSPACE,HPDF_UINT}, HPDF_IMAGE ),
	xHPDF_Image_AddSMask                        = define_c_func( libhpdf, "HPDF_Image_AddSMask", {HPDF_IMAGE,HPDF_IMAGE}, HPDF_STATUS ),
--	xHPDF_Image_GetSize                         = define_c_func( libhpdf, "HPDF_Image_GetSize", {HPDF_IMAGE}, HPDF_POINT ),
	xHPDF_Image_GetSize2                        = define_c_func( libhpdf, "HPDF_Image_GetSize2", {HPDF_IMAGE,C_POINTER}, HPDF_STATUS ),
	xHPDF_Image_GetWidth                        = define_c_func( libhpdf, "HPDF_Image_GetWidth", {HPDF_IMAGE}, HPDF_UINT ),
	xHPDF_Image_GetHeight                       = define_c_func( libhpdf, "HPDF_Image_GetHeight", {HPDF_IMAGE}, HPDF_UINT ),
	xHPDF_Image_GetBitsPerComponent             = define_c_func( libhpdf, "HPDF_Image_GetBitsPerComponent", {HPDF_IMAGE}, HPDF_UINT ),
	xHPDF_Image_GetColorSpace                   = define_c_func( libhpdf, "HPDF_Image_GetColorSpace", {HPDF_IMAGE}, C_STRING ),
	xHPDF_Image_SetColorMask                    = define_c_func( libhpdf, "HPDF_Image_SetColorMask", {HPDF_IMAGE,HPDF_UINT,HPDF_UINT,HPDF_UINT,HPDF_UINT,HPDF_UINT,HPDF_UINT}, HPDF_STATUS ),
	xHPDF_Image_SetMaskImage                    = define_c_func( libhpdf, "HPDF_Image_SetMaskImage", {HPDF_IMAGE,HPDF_IMAGE}, HPDF_STATUS ),
	-- info dictionary -------------------------
	xHPDF_SetInfoAttr                           = define_c_func( libhpdf, "HPDF_SetInfoAttr", {HPDF_DOC,HPDF_INFOTYPE,C_STRING}, HPDF_STATUS ),
	xHPDF_GetInfoAttr                           = define_c_func( libhpdf, "HPDF_GetInfoAttr", {HPDF_DOC,HPDF_INFOTYPE}, C_STRING ),
	xHPDF_SetInfoDateAttr                       = define_c_func( libhpdf, "HPDF_SetInfoDateAttr", {HPDF_DOC,HPDF_INFOTYPE} & HPDF_DATE, HPDF_STATUS ),
	-- encryption ------------------------------
	xHPDF_SetPassword                           = define_c_func( libhpdf, "HPDF_SetPassword", {HPDF_DOC,C_STRING,C_STRING}, HPDF_STATUS ),
	xHPDF_SetPermission                         = define_c_func( libhpdf, "HPDF_SetPermission", {HPDF_DOC,HPDF_UINT}, HPDF_STATUS ),
	xHPDF_SetEncryptionMode                     = define_c_func( libhpdf, "HPDF_SetEncryptionMode", {HPDF_DOC,HPDF_ENCRYPTMODE,HPDF_UINT}, HPDF_STATUS ),
	-- compression -----------------------------
	xHPDF_SetCompressionMode                    = define_c_func( libhpdf, "HPDF_SetCompressionMode", {HPDF_DOC,HPDF_UINT}, HPDF_STATUS ),
	-- font ------------------------------------
	xHPDF_Font_GetFontName                      = define_c_func( libhpdf, "HPDF_Font_GetFontName", {HPDF_FONT}, C_STRING ),
	xHPDF_Font_GetEncodingName                  = define_c_func( libhpdf, "HPDF_Font_GetEncodingName", {HPDF_FONT}, C_STRING ),
	xHPDF_Font_GetUnicodeWidth                  = define_c_func( libhpdf, "HPDF_Font_GetUnicodeWidth", {HPDF_FONT,HPDF_UNICODE}, HPDF_INT ),
--	xHPDF_Font_GetBBox                          = define_c_func( libhpdf, "HPDF_Font_GetBBox", {HPDF_FONT}, HPDF_BOX ),
	xHPDF_Font_GetBBox2                         = define_c_func( libhpdf, "HPDF_Font_GetBBox2", {HPDF_FONT,C_POINTER}, HPDF_STATUS ),
	xHPDF_Font_GetAscent                        = define_c_func( libhpdf, "HPDF_Font_GetAscent", {HPDF_FONT}, HPDF_INT ),
	xHPDF_Font_GetDescent                       = define_c_func( libhpdf, "HPDF_Font_GetDescent", {HPDF_FONT}, HPDF_INT ),
	xHPDF_Font_GetXHeight                       = define_c_func( libhpdf, "HPDF_Font_GetXHeight", {HPDF_FONT}, HPDF_UINT ),
	xHPDF_Font_GetCapHeight                     = define_c_func( libhpdf, "HPDF_Font_GetCapHeight", {HPDF_FONT}, HPDF_UINT ),
--	xHPDF_Font_TextWidth                        = define_c_func( libhpdf, "HPDF_Font_TextWidth", {HPDF_FONT,C_STRING,HPDF_UINT}, HPDF_TEXTWIDTH ),
	xHPDF_Font_TextWidth2                       = define_c_func( libhpdf, "HPDF_Font_TextWidth2", {HPDF_FONT,C_STRING,HPDF_UINT,C_POINTER}, HPDF_STATUS ),
	xHPDF_Font_MeasureText                      = define_c_func( libhpdf, "HPDF_Font_MeasureText", {HPDF_FONT,C_STRING,HPDF_UINT,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_BOOL,C_POINTER}, HPDF_UINT ),
	-- attachements ----------------------------
	xHPDF_AttachFile                            = define_c_func( libhpdf, "HPDF_AttachFile", {HPDF_DOC,C_STRING}, HPDF_EMBEDDEDFILE ),
	-- extended graphics state -----------------
	xHPDF_CreateExtGState                       = define_c_func( libhpdf, "HPDF_CreateExtGState", {HPDF_DOC}, HPDF_EXTGSTATE ),
	xHPDF_ExtGState_SetAlphaStroke              = define_c_func( libhpdf, "HPDF_ExtGState_SetAlphaStroke", {HPDF_EXTGSTATE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_ExtGState_SetAlphaFill                = define_c_func( libhpdf, "HPDF_ExtGState_SetAlphaFill", {HPDF_EXTGSTATE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_ExtGState_SetBlendMode                = define_c_func( libhpdf, "HPDF_ExtGState_SetBlendMode", {HPDF_EXTGSTATE,HPDF_BLENDMODE}, HPDF_STATUS ),
	--------------------------------------------
	xHPDF_Page_TextWidth                        = define_c_func( libhpdf, "HPDF_Page_TextWidth", {HPDF_PAGE,C_STRING}, HPDF_REAL ),
	xHPDF_Page_MeasureText                      = define_c_func( libhpdf, "HPDF_Page_MeasureText", {HPDF_PAGE,C_STRING,HPDF_REAL,HPDF_BOOL,C_POINTER}, HPDF_UINT ),
	xHPDF_Page_GetWidth                         = define_c_func( libhpdf, "HPDF_Page_GetWidth", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetHeight                        = define_c_func( libhpdf, "HPDF_Page_GetHeight", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetGMode                         = define_c_func( libhpdf, "HPDF_Page_GetGMode", {HPDF_PAGE}, HPDF_UINT16 ),
--	xHPDF_Page_GetCurrentPos                    = define_c_func( libhpdf, "HPDF_Page_GetCurrentPos", {HPDF_PAGE}, HPDF_POINT ),
	xHPDF_Page_GetCurrentPos2                   = define_c_func( libhpdf, "HPDF_Page_GetCurrentPos2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
--	xHPDF_Page_GetCurrentTextPos                = define_c_func( libhpdf, "HPDF_Page_GetCurrentTextPos", {HPDF_PAGE}, HPDF_POINT ),
	xHPDF_Page_GetCurrentTextPos2               = define_c_func( libhpdf, "HPDF_Page_GetCurrentTextPos2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
	xHPDF_Page_GetCurrentFont                   = define_c_func( libhpdf, "HPDF_Page_GetCurrentFont", {HPDF_PAGE}, HPDF_FONT ),
	xHPDF_Page_GetCurrentFontSize               = define_c_func( libhpdf, "HPDF_Page_GetCurrentFontSize", {HPDF_PAGE}, HPDF_REAL ),
--	xHPDF_Page_GetTransMatrix                   = define_c_func( libhpdf, "HPDF_Page_GetTransMatrix", {HPDF_PAGE}, HPDF_TRANSMATRIX ),
	xHPDF_Page_GetTransMatrix2                  = define_c_func( libhpdf, "HPDF_Page_GetTransMatrix2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
	xHPDF_Page_GetLineWidth                     = define_c_func( libhpdf, "HPDF_Page_GetLineWidth", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetLineCap                       = define_c_func( libhpdf, "HPDF_Page_GetLineCap", {HPDF_PAGE}, HPDF_LINECAP ),
	xHPDF_Page_GetLineJoin                      = define_c_func( libhpdf, "HPDF_Page_GetLineJoin", {HPDF_PAGE}, HPDF_LINEJOIN ),
	xHPDF_Page_GetMiterLimit                    = define_c_func( libhpdf, "HPDF_Page_GetMiterLimit", {HPDF_PAGE}, HPDF_REAL ),
--	xHPDF_Page_GetDash                          = define_c_func( libhpdf, "HPDF_Page_GetDash", {HPDF_PAGE}, HPDF_DASHMODE ),
	xHPDF_Page_GetDash2                         = define_c_func( libhpdf, "HPDF_Page_GetDash2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
	xHPDF_Page_GetFlat                          = define_c_func( libhpdf, "HPDF_Page_GetFlat", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetCharSpace                     = define_c_func( libhpdf, "HPDF_Page_GetCharSpace", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetWordSpace                     = define_c_func( libhpdf, "HPDF_Page_GetWordSpace", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetHorizontalScalling            = define_c_func( libhpdf, "HPDF_Page_GetHorizontalScalling", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetTextLeading                   = define_c_func( libhpdf, "HPDF_Page_GetTextLeading", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetTextRenderingMode             = define_c_func( libhpdf, "HPDF_Page_GetTextRenderingMode", {HPDF_PAGE}, HPDF_TEXTRENDERINGMODE ),
	xHPDF_Page_GetTextRaise                     = define_c_func( libhpdf, "HPDF_Page_GetTextRaise", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetTextRise                      = define_c_func( libhpdf, "HPDF_Page_GetTextRise", {HPDF_PAGE}, HPDF_REAL ),
--	xHPDF_Page_GetRGBFill                       = define_c_func( libhpdf, "HPDF_Page_GetRGBFill", {HPDF_PAGE}, HPDF_RGBCOLOR ),
	xHPDF_Page_GetRGBFill2                      = define_c_func( libhpdf, "HPDF_Page_GetRGBFill2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
--	xHPDF_Page_GetRGBStroke                     = define_c_func( libhpdf, "HPDF_Page_GetRGBStroke", {HPDF_PAGE}, HPDF_RGBCOLOR ),
	xHPDF_Page_GetRGBStroke2                    = define_c_func( libhpdf, "HPDF_Page_GetRGBStroke2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
--	xHPDF_Page_GetCMYKFill                      = define_c_func( libhpdf, "HPDF_Page_GetCMYKFill", {HPDF_PAGE}, HPDF_RGBCOLOR ),
	xHPDF_Page_GetCMYKFill2                     = define_c_func( libhpdf, "HPDF_Page_GetCMYKFill2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
--	xHPDF_Page_GetCMYKStroke                    = define_c_func( libhpdf, "HPDF_Page_GetCMYKStroke", {HPDF_PAGE}, HPDF_RGBCOLOR ),
	xHPDF_Page_GetCMYKStroke2                   = define_c_func( libhpdf, "HPDF_Page_GetCMYKStroke", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
	xHPDF_Page_GetGrayFill                      = define_c_func( libhpdf, "HPDF_Page_GetGrayFill", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetGrayStroke                    = define_c_func( libhpdf, "HPDF_Page_GetGrayStroke", {HPDF_PAGE}, HPDF_REAL ),
	xHPDF_Page_GetStrokingColorSpace            = define_c_func( libhpdf, "HPDF_Page_GetStrokingColorSpace", {HPDF_PAGE}, HPDF_COLORSPACE ),
	xHPDF_Page_GetFillingColorSpace             = define_c_func( libhpdf, "HPDF_Page_GetFillingColorSpace", {HPDF_PAGE}, HPDF_COLORSPACE ),
--	xHPDF_Page_GetTextMatrix                    = define_c_func( libhpdf, "HPDF_Page_GetTextMatrix", {HPDF_PAGE}, HPDF_TRANSMATRIX ),
	xHPDF_Page_GetTextMatrix2                   = define_c_func( libhpdf, "HPDF_Page_GetTextMatrix2", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
	xHPDF_Page_GetGStateDepth                   = define_c_func( libhpdf, "HPDF_Page_GetGStateDepth", {HPDF_PAGE}, HPDF_UINT ),
	-- General graphics state ------------------
	xHPDF_Page_SetLineWidth                     = define_c_func( libhpdf, "HPDF_Page_SetLineWidth", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetLineCap                       = define_c_func( libhpdf, "HPDF_Page_SetLineCap", {HPDF_PAGE,HPDF_LINECAP}, HPDF_STATUS ),
	xHPDF_Page_SetLineJoin                      = define_c_func( libhpdf, "HPDF_Page_SetLineJoin", {HPDF_PAGE,HPDF_LINEJOIN}, HPDF_STATUS ),
	xHPDF_Page_SetMiterLimit                    = define_c_func( libhpdf, "HPDF_Page_SetMiterLimit", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetDash                          = define_c_func( libhpdf, "HPDF_Page_SetDash", {HPDF_PAGE,C_POINTER,HPDF_UINT,HPDF_UINT}, HPDF_STATUS ),
	xHPDF_Page_SetFlat                          = define_c_func( libhpdf, "HPDF_Page_SetFlat", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetExtGState                     = define_c_func( libhpdf, "HPDF_Page_SetExtGState", {HPDF_PAGE,HPDF_EXTGSTATE}, HPDF_STATUS ),
	-- Special graphic state operator ----------
	xHPDF_Page_GSave                            = define_c_func( libhpdf, "HPDF_Page_GSave", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_GRestore                         = define_c_func( libhpdf, "HPDF_Page_GRestore", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_Concat                           = define_c_func( libhpdf, "HPDF_Page_Concat", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	-- Path construction operator --------------
	xHPDF_Page_MoveTo                           = define_c_func( libhpdf, "HPDF_Page_MoveTo", {HPDF_PAGE,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_LineTo                           = define_c_func( libhpdf, "HPDF_Page_LineTo", {HPDF_PAGE,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_CurveTo                          = define_c_func( libhpdf, "HPDF_Page_CurveTo", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_CurveTo2                         = define_c_func( libhpdf, "HPDF_Page_CurveTo2", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_CurveTo3                         = define_c_func( libhpdf, "HPDF_Page_CurveTo3", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_ClosePath                        = define_c_func( libhpdf, "HPDF_Page_ClosePath", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_Rectangle                        = define_c_func( libhpdf, "HPDF_Page_Rectangle", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	-- Path painting operator ------------------
	xHPDF_Page_Stroke                           = define_c_func( libhpdf, "HPDF_Page_Stroke", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_ClosePathStroke                  = define_c_func( libhpdf, "HPDF_Page_ClosePathStroke", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_Fill                             = define_c_func( libhpdf, "HPDF_Page_Fill", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_Eofill                           = define_c_func( libhpdf, "HPDF_Page_Eofill", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_FillStroke                       = define_c_func( libhpdf, "HPDF_Page_FillStroke", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_EofillStroke                     = define_c_func( libhpdf, "HPDF_Page_EofillStroke", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_ClosePathFillStroke              = define_c_func( libhpdf, "HPDF_Page_ClosePathFillStroke", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_ClosePathEofillStroke            = define_c_func( libhpdf, "HPDF_Page_ClosePathEofillStroke", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_EndPath                          = define_c_func( libhpdf, "HPDF_Page_EndPath", {HPDF_PAGE}, HPDF_STATUS ),
	-- Clipping paths operator -----------------
	xHPDF_Page_Clip                             = define_c_func( libhpdf, "HPDF_Page_Clip", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_Eoclip                           = define_c_func( libhpdf, "HPDF_Page_Eoclip", {HPDF_PAGE}, HPDF_STATUS ),
	-- Text object operator --------------------
	xHPDF_Page_BeginText                        = define_c_func( libhpdf, "HPDF_Page_BeginText", {HPDF_PAGE}, HPDF_STATUS ),
	xHPDF_Page_EndText                          = define_c_func( libhpdf, "HPDF_Page_EndText", {HPDF_PAGE}, HPDF_STATUS ),
	-- Text state ------------------------------
	xHPDF_Page_SetCharSpace                     = define_c_func( libhpdf, "HPDF_Page_SetCharSpace", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetWordSpace                     = define_c_func( libhpdf, "HPDF_Page_SetWordSpace", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetHorizontalScalling            = define_c_func( libhpdf, "HPDF_Page_SetHorizontalScalling", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetTextLeading                   = define_c_func( libhpdf, "HPDF_Page_SetTextLeading", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetFontAndSize                   = define_c_func( libhpdf, "HPDF_Page_SetFontAndSize", {HPDF_PAGE,HPDF_FONT,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetTextRenderingMode             = define_c_func( libhpdf, "HPDF_Page_SetTextRenderingMode", {HPDF_PAGE,HPDF_TEXTRENDERINGMODE}, HPDF_STATUS ),
	xHPDF_Page_SetTextRise                      = define_c_func( libhpdf, "HPDF_Page_SetTextRise", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetTextRaise                     = define_c_func( libhpdf, "HPDF_Page_SetTextRaise", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	-- Text positioning ------------------------
	xHPDF_Page_MoveTextPos                      = define_c_func( libhpdf, "HPDF_Page_MoveTextPos", {HPDF_PAGE,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_MoveTextPos2                     = define_c_func( libhpdf, "HPDF_Page_MoveTextPos2", {HPDF_PAGE,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetTextMatrix                    = define_c_func( libhpdf, "HPDF_Page_SetTextMatrix", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_MoveToNextLine                   = define_c_func( libhpdf, "HPDF_Page_MoveToNextLine", {HPDF_PAGE}, HPDF_STATUS ),
	-- Text showing ----------------------------
	xHPDF_Page_ShowText                         = define_c_func( libhpdf, "HPDF_Page_ShowText", {HPDF_PAGE,C_STRING}, HPDF_STATUS ),
	xHPDF_Page_ShowTextNextLine                 = define_c_func( libhpdf, "HPDF_Page_ShowTextNextLine", {HPDF_PAGE,C_STRING}, HPDF_STATUS ),
	xHPDF_Page_ShowTextNextLineEx               = define_c_func( libhpdf, "HPDF_Page_ShowTextNextLine", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,C_STRING}, HPDF_STATUS ),
	-- Color showing ---------------------------
	xHPDF_Page_SetGrayFill                      = define_c_func( libhpdf, "HPDF_Page_SetGrayFill", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetGrayStroke                    = define_c_func( libhpdf, "HPDF_Page_SetGrayStroke", {HPDF_PAGE,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetRGBFill                       = define_c_func( libhpdf, "HPDF_Page_SetRGBFill", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetRGBStroke                     = define_c_func( libhpdf, "HPDF_Page_SetRGBStroke", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetCMYKFill                      = define_c_func( libhpdf, "HPDF_Page_SetCMYKFill", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_SetCMYKStroke                    = define_c_func( libhpdf, "HPDF_Page_SetCMYKStroke", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	-- XObjects --------------------------------
	xHPDF_Page_ExecuteXObject                   = define_c_func( libhpdf, "HPDF_Page_ExecuteXObject", {HPDF_PAGE,HPDF_XOBJECT}, HPDF_STATUS ),
	-- Content streams -------------------------
	xHPDF_Page_New_Content_Stream               = define_c_func( libhpdf, "HPDF_Page_New_Content_Stream", {HPDF_PAGE,C_POINTER}, HPDF_STATUS ),
	xHPDF_Page_Insert_Shared_Content_Stream     = define_c_func( libhpdf, "HPDF_Page_Insert_Shared_Content_Stream", {HPDF_PAGE,HPDF_DICT}, HPDF_STATUS ),
	-- Compatibility ---------------------------
	xHPDF_Page_DrawImage                        = define_c_func( libhpdf, "HPDF_Page_DrawImage", {HPDF_PAGE,HPDF_IMAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_Circle                           = define_c_func( libhpdf, "HPDF_Page_Circle", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_Ellipse                          = define_c_func( libhpdf, "HPDF_Page_Ellipse", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_Arc                              = define_c_func( libhpdf, "HPDF_Page_Arc", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_Page_TextOut                          = define_c_func( libhpdf, "HPDF_Page_TextOut", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,C_STRING}, HPDF_STATUS ),
	xHPDF_Page_TextRect                         = define_c_func( libhpdf, "HPDF_Page_TextRect", {HPDF_PAGE,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,C_STRING,HPDF_TEXTALIGNMENT,C_POINTER}, HPDF_STATUS ),
	xHPDF_Page_SetSlideShow                     = define_c_func( libhpdf, "HPDF_Page_SetSlideShow", {HPDF_PAGE,HPDF_TRANSITIONSTYLE,HPDF_REAL,HPDF_REAL}, HPDF_STATUS ),
	xHPDF_ICC_LoadIccFromMem                    = define_c_func( libhpdf, "HPDF_ICC_LoadIccFromMem", {HPDF_DOC,HPDF_MMGR,HPDF_STREAM,HPDF_XREF,C_INT}, HPDF_OUTPUTINTENT ),
	xHPDF_LoadIccProfileFromFile                = define_c_func( libhpdf, "HPDF_LoadIccProfileFromFile", {HPDF_DOC,C_STRING,C_INT}, HPDF_OUTPUTINTENT ),
$

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

public type HPDF_Error_Handler( atom x )
	return TRUE
end type

public type HPDF_Alloc_Func( atom x )
	return TRUE
end type

public type HPDF_Free_Func( atom x )
	return TRUE
end type

public type HPDF_Doc( atom x )
	return TRUE
end type

public type HPDF_Page( atom x )
	return TRUE
end type

public type HPDF_Pages( atom x )
	return TRUE
end type

public type HPDF_Stream( atom x )
	return TRUE
end type

public type HPDF_Image( atom x )
	return TRUE
end type

public type HPDF_Font( atom x )
	return TRUE
end type

public type HPDF_Outline( atom x )
	return TRUE
end type

public type HPDF_Encoder( atom x )
	return TRUE
end type

public type HPDF_3DMeasure( atom x )
	return TRUE
end type

public type HPDF_ExData( atom x )
	return TRUE
end type

public type HPDF_Destination( atom x )
	return TRUE
end type

public type HPDF_XObject( atom x )
	return TRUE
end type

public type HPDF_Annotation( atom x )
	return TRUE
end type

public type HPDF_ExtGState( atom x )
	return TRUE
end type

public type HPDF_FontDef( atom x )
	return TRUE
end type

public type HPDF_U3d( atom x )
	return TRUE
end type

public type HPDF_JavaScript( atom x )
	return TRUE
end type

public type HPDF_Error( atom x )
	return TRUE
end type

public type HPDF_MMgr( atom x )
	return TRUE
end type

public type HPDF_Dict( atom x )
	return TRUE
end type

public type HPDF_EmbeddedFile( atom x )
	return TRUE
end type

public type HPDF_OutputIntent( atom x )
	return TRUE
end type

public type HPDF_Xref( atom x )
	return TRUE
end type

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

public function HPDF_GetVersion()
	return peek_string( c_func(xHPDF_GetVersion,{}) )
end function

public function HPDF_NewEx( HPDF_Error_Handler user_error_fn, HPDF_Alloc_Func user_alloc_fn,
		HPDF_Free_Func user_free_fn, atom mem_pool_buf_size, atom user_data )
	return c_func( xHPDF_NewEx, {user_error_fn,user_alloc_fn,user_free_fn,mem_pool_buf_size,user_data} )
end function

public function HPDF_New( HPDF_Error_Handler user_error_fn, atom user_data )
	return c_func( xHPDF_New, {user_error_fn,user_data} )
end function

public procedure HPDF_Free( HPDF_Doc pdf )
	c_proc( xHPDF_Free, {pdf} )
end procedure

public function HPDF_NewDoc( HPDF_Doc pdf )
	return c_func( xHPDF_NewDoc, {pdf} )
end function

public procedure HPDF_FreeDoc( HPDF_Doc pdf )
	c_proc( xHPDF_FreeDoc, {pdf} )
end procedure

public function HPDF_HasDoc( HPDF_Doc pdf )
	return c_func( xHPDF_HasDoc, {pdf} )
end function

public procedure HPDF_FreeDocAll( HPDF_Doc pdf )
	c_proc( xHPDF_FreeDocAll, {pdf} )
end procedure

public function HPDF_SaveToStream( HPDF_Doc pdf )
	return c_func( xHPDF_SaveToStream, {pdf} )
end function

public function HPDF_GetContents( HPDF_Doc pdf, atom buf, atom size )
	return c_func( xHPDF_GetContents, {pdf,buf,size} )
end function

public function HPDF_GetStreamSize( HPDF_Doc pdf )
	return c_func( xHPDF_GetStreamSize, {pdf} )
end function

public function HPDF_ReadFromStream( HPDF_Doc pdf, atom buf, atom size )
	return c_func( xHPDF_ReadFromStream, {pdf,buf,size} )
end function

public function HPDF_ResetStream( HPDF_Doc pdf )
	return c_func( xHPDF_ResetStream, {pdf} )
end function

public function HPDF_SaveToFile( HPDF_Doc pdf, sequence file_name )
	return c_func( xHPDF_SaveToFile, {pdf,_(file_name)} )
end function

public function HPDF_GetError( HPDF_Doc pdf )
	return c_func( xHPDF_GetError, {pdf} )
end function

public function HPDF_GetErrorDetail( HPDF_Doc pdf )
	return c_func( xHPDF_GetErrorDetail, {pdf} )
end function

public procedure HPDF_ResetError( HPDF_Doc pdf )
	c_proc( xHPDF_ResetError, {pdf} )
end procedure

public function HPDF_CheckError( HPDF_Error error )
	return c_func( xHPDF_CheckError, {error} )
end function

public function HPDF_SetPagesConfiguration( HPDF_Doc pdf, atom page_per_pages )
	return c_func( xHPDF_SetPagesConfiguration, {pdf,page_per_pages} )
end function

public function HPDF_GetPageByIndex( HPDF_Doc pdf, atom index )
	return c_func( xHPDF_GetPageByIndex, {pdf,index} )
end function

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

public function HPDF_GetPageMMgr( HPDF_Page page )
	return c_func( xHPDF_GetPageMMgr, {page} )
end function

public function HPDF_GetPageLayout( HPDF_Doc pdf )
	return c_func( xHPDF_GetPageLayout, {pdf} )
end function

public function HPDF_SetPageLayout( HPDF_Doc pdf, HPDF_PageLayout layout )
	return c_func( xHPDF_SetPageLayout, {pdf,layout} )
end function

public function HPDF_GetPageMode( HPDF_Doc pdf )
	return c_func( xHPDF_GetPageMode, {pdf} )
end function

public function HPDF_SetPageMode( HPDF_Doc pdf, HPDF_PageMode mode )
	return c_func( xHPDF_SetPageMode, {pdf,mode} )
end function

public function HPDF_GetViewerPreference( HPDF_Doc pdf )
	return c_func( xHPDF_GetViewerPreference, {pdf} )
end function

public function HPDF_SetViewerPreference( HPDF_Doc pdf, atom value )
	return c_func( xHPDF_SetViewerPreference, {pdf,value} )
end function

public function HPDF_SetOpenAction( HPDF_Doc pdf, HPDF_Destination open_action )
	return c_func( xHPDF_SetOpenAction, {pdf,open_action} )
end function

/*---------------------------------------------------------------------------*/
/*----- page handling -------------------------------------------------------*/

public function HPDF_GetCurrentPage( HPDF_Doc pdf )
	return c_func( xHPDF_GetCurrentPage, {pdf} )
end function

public function HPDF_AddPage( HPDF_Doc pdf )
	return c_func( xHPDF_AddPage, {pdf} )
end function

public function HPDF_InsertPage( HPDF_Doc pdf, HPDF_Page page )
	return c_func( xHPDF_InsertPage, {pdf,page} )
end function

public function HPDF_Page_SetWidth( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetWidth, {page,value} )
end function

public function HPDF_Page_SetHeight( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetHeight, {page,value} )
end function

public function HPDF_Page_SetSize( HPDF_Page page, HPDF_PageSizes size, HPDF_PageDirection direction )
	return c_func( xHPDF_Page_SetSize, {page,size,direction} )
end function

public function HPDF_Page_SetRotate( HPDF_Page page, atom angle )
	return c_func( xHPDF_Page_SetRotate, {page,angle} )
end function

public function HPDF_Page_SetZoom( HPDF_Page page, atom zoom )
	return c_func( xHPDF_Page_SetZoom, {page,zoom} )
end function

/*---------------------------------------------------------------------------*/
/*----- font handling -------------------------------------------------------*/

public function HPDF_GetFont( HPDF_Doc pdf, sequence file_name, object encoding_name = NULL )
	if sequence( encoding_name ) then encoding_name = _( encoding_name ) end if
	return c_func( xHPDF_GetFont, {pdf,_(file_name),encoding_name} )
end function

public function HPDF_LoadType1FontFromFile( HPDF_Doc pdf, sequence afm_file_name, sequence data_file_name )
	return c_func( xHPDF_LoadType1FontFromFile, {pdf,_(afm_file_name),_(data_file_name)} )
end function

public function HPDF_GetTTFontDefFromFile( HPDF_Doc pdf, sequence file_name, integer embedding )
	return c_func( xHPDF_GetTTFontDefFromFile, {pdf,_(file_name),embedding} )
end function

public function HPDF_LoadTTFontFromFile( HPDF_Doc pdf, sequence file_name, integer embedding )
	return c_func( xHPDF_LoadTTFontFromFile, {pdf,_(file_name),embedding} )
end function

public function HPDF_LoadTTFontFromFile2( HPDF_Doc pdf, sequence file_name, atom index, integer embedding )
	return c_func( xHPDF_LoadTTFontFromFile2, {pdf,_(file_name),index,embedding} )
end function

public function HPDF_AddPageLabel( HPDF_Doc pdf, atom page_num, HPDF_PageNumStyle style, atom first_page, sequence prefix )
	return c_func( xHPDF_AddPageLabel, {pdf,page_num,style,first_page,_(prefix)} )
end function

public function HPDF_UseJPFonts( HPDF_Doc pdf )
	return c_func( xHPDF_UseJPFonts, {pdf} )
end function

public function HPDF_UseKRFonts( HPDF_Doc pdf )
	return c_func( xHPDF_UseKRFonts, {pdf} )
end function

public function HPDF_UseCNSFonts( HPDF_Doc pdf )
	return c_func( xHPDF_UseCNSFonts, {pdf} )
end function

public function HPDF_UseCNTFonts( HPDF_Doc pdf )
	return c_func( xHPDF_UseCNTFonts, {pdf} )
end function

/*--------------------------------------------------------------------------*/
/*----- outline ------------------------------------------------------------*/

public function HPDF_CreateOutline( HPDF_Doc pdf, HPDF_Outline parent, sequence title, HPDF_Encoder encoder )
	return c_func( xHPDF_CreateOutline, {pdf,parent,_(title),encoder} )
end function

public function HPDF_Outline_SetOpened( HPDF_Outline outline, integer opened )
	return c_func( xHPDF_Outline_SetOpened, {outline,opened} )
end function

public function HPDF_Outline_SetDestination( HPDF_Outline outline, HPDF_Destination dst )
	return c_func( xHPDF_Outline_SetDestination, {outline,dst} )
end function

/*--------------------------------------------------------------------------*/
/*----- destination --------------------------------------------------------*/

public function HPDF_Page_CreateDestination( HPDF_Page page )
	return c_func( xHPDF_Page_CreateDestination, {page} )
end function

public function HPDF_Destination_SetXYZ( HPDF_Destination dst, atom left, atom top, atom zoom )
	return c_func( xHPDF_Destination_SetXYZ, {dst,left,top,zoom} )
end function

public function HPDF_Destination_SetFit( HPDF_Destination dst )
	return c_func( xHPDF_Destination_SetFit, {dst} )
end function

public function HPDF_Destination_SetFitH( HPDF_Destination dst, atom top )
	return c_func( xHPDF_Destination_SetFitH, {dst,top} )
end function

public function HPDF_Destination_SetFitV( HPDF_Destination dst, atom left )
	return c_func( xHPDF_Destination_SetFitV, {dst,left} )
end function

public function HPDF_Destination_SetFitR( HPDF_Destination dst, atom left, atom bottom, atom right, atom top )
	return c_func( xHPDF_Destination_SetFitR, {dst,left,bottom,right,top} )
end function

public function HPDF_Destination_SetFitB( HPDF_Destination dst )
	return c_func( xHPDF_Destination_SetFitB, {dst} )
end function

public function HPDF_Destination_SetFitBH( HPDF_Destination dst, atom top )
	return c_func( xHPDF_Destination_SetFitBH, {dst,top} )
end function

public function HPDF_Destination_SetFitBV( HPDF_Destination dst, atom left )
	return c_func( xHPDF_Destination_SetFitBV, {dst,left} )
end function

/*--------------------------------------------------------------------------*/
/*----- encoder ------------------------------------------------------------*/

public function HPDF_GetEncoder( HPDF_Doc pdf, sequence encoding_name )
	return c_func( xHPDF_GetEncoder, {pdf,_(encoding_name)} )
end function

public function HPDF_GetCurrentEncoder( HPDF_Doc pdf )
	return c_func( xHPDF_GetCurrentEncoder, {pdf} )
end function

public function HPDF_SetCurrentEncoder( HPDF_Doc pdf, sequence encoding_name )
	return c_func( xHPDF_SetCurrentEncoder, {pdf,_(encoding_name)} )
end function

public function HPDF_Encoder_GetType( HPDF_Encoder encoder )
	return c_func( xHPDF_Encoder_GetType, {encoder} )
end function

public function HPDF_Encoder_GetByteType( HPDF_Encoder encoder, sequence text, atom index )
	return c_func( xHPDF_Encoder_GetByteType, {encoder,_(text),index} )
end function

public function HPDF_Encoder_GetUnicode( HPDF_Encoder encoder, atom code )
	return c_func( xHPDF_Encoder_GetUnicode, {encoder,code} )
end function

public function HPDF_Encoder_GetWritingMode( HPDF_Encoder encoder )
	return c_func( xHPDF_Encoder_GetWritingMode, {encoder} )
end function

public function HPDF_UseJPEncodings( HPDF_Doc pdf )
	return c_func( xHPDF_UseJPEncodings, {pdf} )
end function

public function HPDF_UseKREncodings( HPDF_Doc pdf )
	return c_func( xHPDF_UseKREncodings, {pdf} )
end function

public function HPDF_UseCNSEncodings( HPDF_Doc pdf )
	return c_func( xHPDF_UseCNSEncodings, {pdf} )
end function

public function HPDF_UseCNTEncodings( HPDF_Doc pdf )
	return c_func( xHPDF_UseCNTEncodings, {pdf} )
end function

public function HPDF_UseUTFEncodings( HPDF_Doc pdf )
	return c_func( xHPDF_UseUTFEncodings, {pdf} )
end function

/*--------------------------------------------------------------------------*/
/*----- XObject ------------------------------------------------------------*/

public function HPDF_Page_CreateXObjectFromImage( HPDF_Doc pdf, HPDF_Page page, HPDF_Rect rect, HPDF_Image image, integer zoom )
	return c_func( xHPDF_Page_CreateXObjectFromImage, {pdf,page} & rect & {image,zoom} )
end function

public function HPDF_Page_CreateXObjectAsWhiteRect( HPDF_Doc pdf, HPDF_Page page, HPDF_Rect rect )
	return c_func( xHPDF_Page_CreateXObjectAsWhiteRect, {pdf,page} & rect )
end function

/*--------------------------------------------------------------------------*/
/*----- annotation ---------------------------------------------------------*/

public function HPDF_Page_Create3DAnnot( HPDF_Page page, HPDF_Rect rect, integer tb, integer np, HPDF_U3d u3d, HPDF_Image ap )
	return c_func( xHPDF_Page_Create3DAnnot, {page} & rect & {tb,np,u3d,ap} )
end function

public function HPDF_Page_CreateTextAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateTextAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreateFreeTextAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateFreeTextAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreateLineAnnot( HPDF_Page page, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateLineAnnot, {page,_(text),encoder} )
end function

public function HPDF_Page_CreateWidgetAnnot_WhiteOnlyWhilePrint( HPDF_Doc pdf, HPDF_Page page, HPDF_Rect rect )
	return c_func( xHPDF_Page_CreateWidgetAnnot_WhiteOnlyWhilePrint, {pdf,page} & rect )
end function

public function HPDF_Page_CreateWidgetAnnot( HPDF_Page page, HPDF_Rect rect )
	return c_func( xHPDF_Page_CreateWidgetAnnot, {page} & rect )
end function

public function HPDF_Page_CreateLinkAnnot( HPDF_Page page, HPDF_Rect rect, HPDF_Destination dst )
	return c_func( xHPDF_Page_CreateLinkAnnot, {page} & rect & {dst} )
end function

public function HPDF_Page_CreateURILinkAnnot( HPDF_Page page, HPDF_Rect rect, sequence uri )
	return c_func( xHPDF_Page_CreateURILinkAnnot, {page} & rect & {_(uri)} )
end function

public function HPDF_Page_CreateTextMarkupAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder, HPDF_AnnotType subType )
	return c_func( xHPDF_Page_CreateTextMarkupAnnot, {page} & rect & {_(text),encoder,subType} )
end function

public function HPDF_Page_CreateHighlightAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateHighlightAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreateUnderlineAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateUnderlineAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreateSquigglyAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateSquigglyAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreateStrikeOutAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateStrikeOutAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreatePopupAnnot( HPDF_Page page, HPDF_Rect rect, HPDF_Annotation parent )
	return c_func( xHPDF_Page_CreatePopupAnnot, {page} & rect & {parent} )
end function

public function HPDF_Page_CreateStampAnnot( HPDF_Page page, HPDF_Rect rect, HPDF_StampAnnotName name, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateStampAnnot, {page} & rect & {name,_(text),encoder} )
end function

public function HPDF_Page_CreateProjectionAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateProjectionAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreateSquareAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateSquareAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_Page_CreateCircleAnnot( HPDF_Page page, HPDF_Rect rect, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_Page_CreateCircleAnnot, {page} & rect & {_(text),encoder} )
end function

public function HPDF_LinkAnnot_SetHighlightMode( HPDF_Annotation annot, HPDF_AnnotHighlightMode mode )
	return c_func( xHPDF_LinkAnnot_SetHighlightMode, {annot,mode} )
end function

public function HPDF_LinkAnnot_SetJavaScript( HPDF_Annotation annot, HPDF_JavaScript javascript )
	return c_func( xHPDF_LinkAnnot_SetJavaScript, {annot,javascript} )
end function

public function HPDF_LinkAnnot_SetBorderStyle( HPDF_Annotation annot, atom width, integer dash_on, integer dash_off )
	return c_func( xHPDF_LinkAnnot_SetBorderStyle, {annot,width,dash_on,dash_off} )
end function

public function HPDF_TextAnnot_SetIcon( HPDF_Annotation annot, HPDF_AnnotIcon icon )
	return c_func( xHPDF_TextAnnot_SetIcon, {annot,icon} )
end function

public function HPDF_TextAnnot_SetOpened( HPDF_Annotation annot, integer opened )
	return c_func( xHPDF_TextAnnot_SetOpened, {annot,opened} )
end function

public function HPDF_Annot_SetRGBColor( HPDF_Annotation annot, HPDF_RGBColor color )
	return c_func( xHPDF_Annot_SetRGBColor, {annot} & color )
end function

public function HPDF_Annot_SetCMYKColor( HPDF_Annotation annot, HPDF_CMYKColor color )
	return c_func( xHPDF_Annot_SetCMYKColor, {annot} & color )
end function

public function HPDF_Annot_SetGrayColor( HPDF_Annotation annot, atom color )
	return c_func( xHPDF_Annot_SetGrayColor, {annot,color} )
end function

public function HPDF_Annot_SetNoColor( HPDF_Annotation annot )
	return c_func( xHPDF_Annot_SetNoColor, {annot} )
end function

public function HPDF_MarkupAnnot_SetTitle( HPDF_Annotation annot, sequence name )
	return c_func( xHPDF_MarkupAnnot_SetTitle, {annot,_(name)} )
end function

public function HPDF_MarkupAnnot_SetSubject( HPDF_Annotation annot, sequence name )
	return c_func( xHPDF_MarkupAnnot_SetSubject, {annot,_(name)} )
end function

public function HPDF_MarkupAnnot_SetCreationDate( HPDF_Annotation annot, HPDF_Date value )
	return c_func( xHPDF_MarkupAnnot_SetCreationDate, {annot,value} )
end function

public function HPDF_MarkupAnnot_SetTransparency( HPDF_Annotation annot, atom value )
	return c_func( xHPDF_MarkupAnnot_SetTransparency, {annot,value} )
end function

public function HPDF_MarkupAnnot_SetIntent( HPDF_Annotation annot, HPDF_AnnotIntent intent )
	return c_func( xHPDF_MarkupAnnot_SetIntent, {annot,intent} )
end function

public function HPDF_MarkupAnnot_SetPopup( HPDF_Annotation annot, HPDF_Annotation popup )
	return c_func( xHPDF_MarkupAnnot_SetPopup, {annot,popup} )
end function

public function HPDF_MarkupAnnot_SetRectDiff( HPDF_Annotation annot, HPDF_Rect rect )
	return c_func( xHPDF_MarkupAnnot_SetRectDiff, {annot} & rect )
end function

public function HPDF_MarkupAnnot_SetCloudEffect( HPDF_Annotation annot, integer cloudIntensity )
	return c_func( xHPDF_MarkupAnnot_SetCloudEffect, {annot,cloudIntensity} )
end function

public function HPDF_MarkupAnnot_SetInteriorRGBColor( HPDF_Annotation annot, HPDF_RGBColor color )
	return c_func( xHPDF_MarkupAnnot_SetInteriorRGBColor, {annot} & color )
end function

public function HPDF_MarkupAnnot_SetInteriorCMYKColor( HPDF_Annotation annot, HPDF_CMYKColor color )
	return c_func( xHPDF_MarkupAnnot_SetInteriorCMYKColor, {annot} & color )
end function

public function HPDF_MarkupAnnot_SetInteriorGrayColor( HPDF_Annotation annot, atom color )
	return c_func( xHPDF_MarkupAnnot_SetInteriorGrayColor, {annot,color} )
end function

public function HPDF_MarkupAnnot_SetInteriorTransparent( HPDF_Annotation annot )
	return c_func( xHPDF_MarkupAnnot_SetInteriorTransparent, {annot} )
end function

public function HPDF_TextMarkupAnnot_SetQuadPoints( HPDF_Annotation annot, HPDF_Point lb, HPDF_Point rb, HPDF_Point rt, HPDF_Point lt )
	return c_func( xHPDF_TextMarkupAnnot_SetQuadPoints, {annot} & lb & rb & rt & lt )
end function

public function HPDF_Annot_Set3DView( HPDF_MMgr mmgr, HPDF_Annotation annot, HPDF_Annotation annot3d, HPDF_Dict view )
	return c_func( xHPDF_Annot_Set3DView, {mmgr,annot,annot3d,view} )
end function

public function HPDF_PopupAnnot_SetOpened( HPDF_Annotation annot, integer opened )
	return c_func( xHPDF_PopupAnnot_SetOpened, {annot,opened} )
end function

public function HPDF_FreeTextAnnot_SetLineEndingStyle( HPDF_Annotation annot, HPDF_LineAnnotEndingStyle startStyle, HPDF_LineAnnotEndingStyle endStyle )
	return c_func( xHPDF_FreeTextAnnot_SetLineEndingStyle, {annot,startStyle,endStyle} )
end function

public function HPDF_FreeTextAnnot_Set3PointCalloutLine( HPDF_Annotation annot, HPDF_Point startPoint, HPDF_Point kneePoint, HPDF_Point endPoint )
	return c_func( xHPDF_FreeTextAnnot_Set3PointCalloutLine, {annot} & startPoint & kneePoint & endPoint )
end function

public function HPDF_FreeTextAnnot_Set2PointCalloutLine( HPDF_Annotation annot, HPDF_Point startPoint, HPDF_Point endPoint )
	return c_func( xHPDF_FreeTextAnnot_Set2PointCalloutLine, {annot} & startPoint & endPoint )
end function

public function HPDF_FreeTextAnnot_SetDefaultStyle( HPDF_Annotation annot, sequence style )
	return c_func( xHPDF_FreeTextAnnot_SetDefaultStyle, {annot,_(style)} )
end function

public function HPDF_LineAnnot_SetPosition( HPDF_Annotation annot, HPDF_Point startPoint, HPDF_LineAnnotEndingStyle startStyle, HPDF_Point endPoint, HPDF_LineAnnotEndingStyle endStyle )
	return c_func( xHPDF_LineAnnot_SetPosition, {annot} & startPoint & {startStyle} & endPoint & {endStyle} )
end function

public function HPDF_LineAnnot_SetLeader( HPDF_Annotation annot, integer leaderLen, integer leaderExtLen, integer leaderOffsetLen )
	return c_func( xHPDF_LineAnnot_SetLeader, {annot,leaderLen,leaderExtLen,leaderOffsetLen} )
end function

public function HPDF_LineAnnot_SetCaption( HPDF_Annotation annot, integer showCaption, HPDF_LineAnnotCapPosition _position, atom horzOffset, atom vertOffset )
	return c_func( xHPDF_LineAnnot_SetCaption, {annot,showCaption,_position,horzOffset,vertOffset} )
end function

public function HPDF_Annotation_SetBorderStyle( HPDF_Annotation annot, HPDF_BSSubtype subtype, atom width, integer dash_on, integer dash_off, integer dash_phase )
	return c_func( xHPDF_Annotation_SetBorderStyle, {annot,subtype,width,dash_on,dash_off,dash_phase} )
end function

public function HPDF_ProjectionAnnot_SetExData( HPDF_Annotation annot, HPDF_ExData exdata )
	return c_func( xHPDF_ProjectionAnnot_SetExData, {annot,exdata} )
end function

/*--------------------------------------------------------------------------*/
/*----- 3D Measure ---------------------------------------------------------*/

public function HPDF_Page_Create3DC3DMeasure( HPDF_Page page, HPDF_Point3D firstAnchorPoint, HPDF_Point3D textAnchorPoint )
	return c_func( xHPDF_Page_Create3DC3DMeasure, {page,firstAnchorPoint,textAnchorPoint })
end function

public function HPDF_Page_CreatePD33DMeasure(
		HPDF_Page page,
		HPDF_Point3D annotationPlaneNormal,
		HPDF_Point3D firstAnchorPoint,
		HPDF_Point3D secondAnchorPoint,
		HPDF_Point3D leaderLinesDirection,
		HPDF_Point3D measurementValuePoint,
		HPDF_Point3D textYDirection,
		atom value, sequence unitsString
	)
	
	return c_func( xHPDF_Page_CreatePD33DMeasure,
		{page}
		& annotationPlaneNormal
		& firstAnchorPoint
		& secondAnchorPoint
		& leaderLinesDirection
		& measurementValuePoint
		& textYDirection
		& {value}
		& {_(unitsString)}
	)
end function

public function HPDF_3DMeasure_SetName( HPDF_3DMeasure measure, sequence name )
	return c_func( xHPDF_3DMeasure_SetName, {measure,_(name)} )
end function

public function HPDF_3DMeasure_SetColor( HPDF_3DMeasure measure, HPDF_RGBColor color )
	return c_func( xHPDF_3DMeasure_SetColor, {measure} & color )
end function

public function HPDF_3DMeasure_SetTextSize( HPDF_3DMeasure measure, atom textSize )
	return c_func( xHPDF_3DMeasure_SetTextSize, {measure,textSize} )
end function

public function HPDF_3DC3DMeasure_SetTextBoxSize( HPDF_3DMeasure measure, integer x, integer y )
	return c_func( xHPDF_3DC3DMeasure_SetTextBoxSize, {measure,x,y} )
end function

public function HPDF_3DC3DMeasure_SetText( HPDF_3DMeasure measure, sequence text, HPDF_Encoder encoder )
	return c_func( xHPDF_3DC3DMeasure_SetText, {measure,_(text),encoder} )
end function

public function HPDF_3DC3DMeasure_SetProjectionAnotation( HPDF_3DMeasure measure, HPDF_Annotation projectionAnnotation )
	return c_func( xHPDF_3DC3DMeasure_SetProjectionAnotation, {measure,projectionAnnotation} )
end function

/*-----------------------------------------------------------------------------*/
/*----- External Data ---------------------------------------------------------*/

public function HPDF_Page_Create3DAnnotExData( HPDF_Page page )
	return c_func( xHPDF_Page_Create3DAnnotExData, {page} )
end function

public function HPDF_3DAnnotExData_Set3DMeasurement( HPDF_ExData exdata, HPDF_3DMeasure measure )
	return c_func( xHPDF_3DAnnotExData_Set3DMeasurement, {exdata,measure} )
end function

/*--------------------------------------------------------------------------*/
/*----- 3D View ------------------------------------------------------------*/

public function HPDF_Page_Create3DView( HPDF_Page page, HPDF_U3d u3d, HPDF_Annotation annot3d, sequence name )
	return c_func( xHPDF_Page_Create3DView, {page,u3d,annot3d,_(name)} )
end function

public function HPDF_3DView_Add3DC3DMeasure( HPDF_Dict view, HPDF_3DMeasure measure )
	return c_func( xHPDF_3DView_Add3DC3DMeasure, {view,measure} )
end function

/*--------------------------------------------------------------------------*/
/*----- image data ---------------------------------------------------------*/

public function HPDF_LoadPngImageFromMem( HPDF_Doc pdf, atom buffer, atom size )
	return c_func( xHPDF_LoadPngImageFromMem, {pdf,buffer,size} )
end function

public function HPDF_LoadPngImageFromFile( HPDF_Doc pdf, sequence filename )
	return c_func( xHPDF_LoadPngImageFromFile, {pdf,_(filename)} )
end function

public function HPDF_LoadPngImageFromFile2( HPDF_Doc pdf, sequence filename )
	return c_func( xHPDF_LoadPngImageFromFile2, {pdf,_(filename)} )
end function

public function HPDF_LoadJpegImageFromFile( HPDF_Doc pdf, sequence filename )
	return c_func( xHPDF_LoadJpegImageFromFile, {pdf,_(filename)} )
end function

public function HPDF_LoadJpegImageFromMem( HPDF_Doc pdf, atom buffer, atom size )
	return c_func( xHPDF_LoadJpegImageFromMem, {pdf,buffer,size} )
end function

public function HPDF_LoadU3DFromFile( HPDF_Doc pdf, sequence filename )
	return c_func( xHPDF_LoadU3DFromFile, {pdf,_(filename)} )
end function

public function HPDF_LoadU3DFromMem( HPDF_Doc pdf, atom buffer, atom size )
	return c_func( xHPDF_LoadU3DFromMem, {pdf,buffer,size} )
end function

public function HPDF_Image_LoadRaw1BitImageFromMem( HPDF_Doc pdf, atom buffer, integer width, integer height, integer line_width, integer black_is1, integer top_is_first )
	return c_func( xHPDF_Image_LoadRaw1BitImageFromMem, {pdf,buffer,width,height,line_width,black_is1,top_is_first} )
end function

public function HPDF_LoadRawImageFromFile( HPDF_Doc pdf, sequence filename, integer width, integer height, HPDF_ColorSpace color_space )
	return c_func( xHPDF_LoadRawImageFromFile, {pdf,_(filename),width,height,color_space} )
end function

public function HPDF_LoadRawImageFromMem( HPDF_Doc pdf, atom buffer, integer width, integer height, HPDF_ColorSpace color_space, integer bits_per_component )
	return c_func( xHPDF_LoadRawImageFromMem, {buffer,width,height,color_space,bits_per_component} )
end function

public function HPDF_Image_AddSMask( HPDF_Image image, HPDF_Image smask )
	return c_func( xHPDF_Image_AddSMask, {image,smask} )
end function

/*
-- GetSize returns HPDF_Point which is two floats
public function HPDF_Image_GetSize( HPDF_Image image )
	return c_func( xHPDF_Image_GetSize, {image} )
end function
*/

public function HPDF_Image_GetSize2( HPDF_Image image )
	
	atom size = allocate_data( SIZEOF_HPDF_POINT, TRUE )
	integer status = c_func( xHPDF_Image_GetSize2, {image,size} )
	
	if status != HPDF_OK then
		return status
	end if
	
	return peek_float32({ size, length(HPDF_POINT) })
end function

public function HPDF_Image_GetWidth( HPDF_Image image )
	return c_func( xHPDF_Image_GetWidth, {image} )
end function

public function HPDF_Image_GetHeight( HPDF_Image image )
	return c_func( xHPDF_Image_GetHeight, {image} )
end function

public function HPDF_Image_GetBitsPerComponent( HPDF_Image image )
	return c_func( xHPDF_Image_GetBitsPerComponent, {image} )
end function

public function HPDF_Image_GetColorSpace( HPDF_Image image )
	return peek_string( c_func(xHPDF_Image_GetColorSpace,{image}) )
end function

public function HPDF_Image_SetColorMask( HPDF_Image image, integer rmin, integer rmax, integer gmin, integer gmax, integer bmin, integer bmax )
	return c_func( xHPDF_Image_SetColorMask, {image,rmin,rmax,gmin,gmax,bmin,bmax} )
end function

public function HPDF_Image_SetMaskImage( HPDF_Image image, HPDF_Image mask_image )
	return c_func( xHPDF_Image_SetMaskImage, {image,mask_image} )
end function

/*--------------------------------------------------------------------------*/
/*----- info dictionary ----------------------------------------------------*/

public function HPDF_SetInfoAttr( HPDF_Doc pdf, HPDF_InfoType infoType, sequence value )
	return c_func( xHPDF_SetInfoAttr, {pdf,infoType,_(value)} )
end function

public function HPDF_GetInfoAttr( HPDF_Doc pdf, HPDF_InfoType infoType )
	return peek_string( c_func(xHPDF_GetInfoAttr,{pdf,infoType}) )
end function

public function HPDF_SetInfoDateAttr( HPDF_Doc pdf, HPDF_InfoType infoType, HPDF_Date value )
	return c_func( xHPDF_SetInfoDateAttr, {pdf,infoType} & value )
end function

/*--------------------------------------------------------------------------*/
/*----- encryption ---------------------------------------------------------*/

public function HPDF_SetPassword( HPDF_Doc pdf, sequence owner_passwd, sequence user_passwd )
	return c_func( xHPDF_SetPassword, {pdf,_(owner_passwd),_(user_passwd)} )
end function

public function HPDF_SetPermission( HPDF_Doc pdf, integer permission )
	return c_func( xHPDF_SetPermission, {pdf,permission} )
end function

public function HPDF_SetEncryptionMode( HPDF_Doc pdf, HPDF_EncryptMode mode, integer key_len )
	return c_func( xHPDF_SetEncryptionMode, {pdf,mode,key_len} )
end function

/*--------------------------------------------------------------------------*/
/*----- compression --------------------------------------------------------*/

public function HPDF_SetCompressionMode( HPDF_Doc pdf, integer mode )
	return c_func( xHPDF_SetCompressionMode, {pdf,mode} )
end function

/*--------------------------------------------------------------------------*/
/*----- font ---------------------------------------------------------------*/

public function HPDF_Font_GetFontName( HPDF_Font font )
	return peek_string( c_func(xHPDF_Font_GetFontName,{font}) )
end function

public function HPDF_Font_GetEncodingName( HPDF_Font font )
	return peek_string( c_func(xHPDF_Font_GetEncodingName,{font}) )
end function

public function HPDF_Font_GetUnicodeWidth( HPDF_Font font, atom code )
	return c_func( xHPDF_Font_GetUnicodeWidth, {font,code} )
end function

/*
-- GetBBox returns HPDF_Box which is four floats
public function HPDF_Font_GetBBox( HPDF_Font font )
	return c_func( xHPDF_Font_GetBBox, {font} )
end function
*/

public function HPDF_Font_GetBBox2( HPDF_Font font )
	
	atom box = allocate_data( SIZEOF_HPDF_BOX, TRUE )
	integer status = c_func( xHPDF_Font_GetBBox2, {font,box} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32({ box, length(HPDF_BOX) })
end function

public function HPDF_Font_GetAscent( HPDF_Font font )
	return c_func( xHPDF_Font_GetAscent, {font} )
end function

public function HPDF_Font_GetDescent( HPDF_Font font )
	return c_func( xHPDF_Font_GetDescent, {font} )
end function

public function HPDF_Font_GetXHeight( HPDF_Font font )
	return c_func( xHPDF_Font_GetXHeight, {font} )
end function

public function HPDF_Font_GetCapHeight( HPDF_Font font )
	return c_func( xHPDF_Font_GetCapHeight, {font} )
end function

/*
-- TextWidth returns HPDF_TextWidth which is three unsigned ints
public function HPDF_Font_TextWidth( HPDF_Font font, sequence text, atom len )
	return c_func( xHPDF_Font_TextWidth, {font,_(text),len} )
end function
*/

public function HPDF_Font_TextWidth2( HPDF_Font font, sequence text, atom len )
	
	atom text_width = allocate_data( SIZEOF_HPDF_TEXTWIDTH, TRUE )
	integer status = c_func( xHPDF_Font_TextWidth2, {font,_(text),len,text_width} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek4u({ text_width, length(HPDF_TEXTWIDTH) })
end function

public function HPDF_Font_MeasureText( HPDF_Font font, sequence text, atom len, atom width, atom font_size, atom char_space, atom word_space, integer wordwrap )
	
	atom real_width = allocate_data( sizeof(HPDF_REAL), TRUE )
	integer status = c_func( xHPDF_Font_MeasureText, {font,_(text),len,width,font_size,char_space,word_space,wordwrap,real_width} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32( real_width )
end function

/*--------------------------------------------------------------------------*/
/*----- attachements -------------------------------------------------------*/

public function HPDF_AttachFile( HPDF_Doc pdf, sequence file )
	return c_func( xHPDF_AttachFile, {pdf,_(file)} )
end function

/*--------------------------------------------------------------------------*/
/*----- extended graphics state --------------------------------------------*/

public function HPDF_CreateExtGState( HPDF_Doc pdf )
	return c_func( xHPDF_CreateExtGState, {pdf} )
end function

public function HPDF_ExtGState_SetAlphaStroke( HPDF_ExtGState ext_gstate, atom value )
	return c_func( xHPDF_ExtGState_SetAlphaStroke, {ext_gstate,value} )
end function

public function HPDF_ExtGState_SetAlphaFill( HPDF_ExtGState ext_gstate, atom value )
	return c_func( xHPDF_ExtGState_SetAlphaFill, {ext_gstate,value} )
end function

public function HPDF_ExtGState_SetBlendMode( HPDF_ExtGState ext_gstate, HPDF_BlendMode mode )
	return c_func( xHPDF_ExtGState_SetBlendMode, {ext_gstate,mode} )
end function

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/

public function HPDF_Page_TextWidth( HPDF_Page page, sequence text )
	return c_func( xHPDF_Page_TextWidth, {page,_(text)} )
end function

public function HPDF_Page_MeasureText( HPDF_Page page, sequence text, atom width, integer wordwrap, integer return_real_width = FALSE )
	
	atom real_width = NULL
	
	if return_real_width then
		real_width = allocate_data( sizeof(HPDF_REAL), TRUE )
	end if
	
	integer len = c_func( xHPDF_Page_MeasureText, {page,_(text),width,wordwrap,real_width} )
	
	if return_real_width then
		return len & peek_float32( real_width )
	end if
	
	return len
end function

public function HPDF_Page_GetWidth( HPDF_Page page )
	return c_func( xHPDF_Page_GetWidth, {page} )
end function

public function HPDF_Page_GetHeight( HPDF_Page page )
	return c_func( xHPDF_Page_GetHeight, {page} )
end function

public function HPDF_Page_GetGMode( HPDF_Page page )
	return c_func( xHPDF_Page_GetGMode, {page} )
end function

/*
-- GetCurrentPos returns HPDF_Point which is two floats
public function HPDF_Page_GetCurrentPos( HPDF_Page page )
	return c_func( xHPDF_Page_GetCurrentPos, {page} )
end function
*/

public function HPDF_Page_GetCurrentPos2( HPDF_Page page )
	
	atom pos = allocate_data( SIZEOF_HPDF_POINT, TRUE )
	integer status = c_func( xHPDF_Page_GetCurrentPos2, {page,pos} )
	
	if status != HPDF_OK then
		return status
	end if
	
	return peek_float32({ pos, length(HPDF_POINT) })
end function

/*
-- GetCurrentTextPos returns HPDF_Point which is two floats
public function HPDF_Page_GetCurrentTextPos( HPDF_Page page )
	return c_func( xHPDF_Page_GetCurrentTextPos, {page} )
end function
*/

public function HPDF_Page_GetCurrentTextPos2( HPDF_Page page )
	
	atom pos = allocate_data( SIZEOF_HPDF_POINT, TRUE )
	integer status = c_func( xHPDF_Page_GetCurrentTextPos2, {page,pos} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32({ pos, length(HPDF_POINT) })
end function

public function HPDF_Page_GetCurrentFont( HPDF_Page page )
	return c_func( xHPDF_Page_GetCurrentFont, {page} )
end function

public function HPDF_Page_GetCurrentFontSize( HPDF_Page page )
	return c_func( xHPDF_Page_GetCurrentFontSize, {page} )
end function

/*
-- GetTransMatrix returns HPDF_TransMatrix which is six floats
public function HPDF_Page_GetTransMatrix( HPDF_Page page )
	return c_func( xHPDF_Page_GetTransMatrix, {page} )
end function
*/

public function HPDF_Page_GetTransMatrix2( HPDF_Page page )
	
	atom matrix = allocate_data( SIZEOF_HPDF_TRANSMATRIX, TRUE )
	integer status = c_func( xHPDF_Page_GetTransMatrix2, {page,matrix} )
	
	if status != HPDF_OK then
		return status
	end if
	
	return peek_float32({ matrix, length(HPDF_TRANSMATRIX) })
end function

public function HPDF_Page_GetLineWidth( HPDF_Page page )
	return c_func( xHPDF_Page_GetLineWidth, {page} )
end function

public function HPDF_Page_GetLineCap( HPDF_Page page )
	return c_func( xHPDF_Page_GetLineCap, {page} )
end function

public function HPDF_Page_GetLineJoin( HPDF_Page page )
	return c_func( xHPDF_Page_GetLineJoin, {page} )
end function

public function HPDF_Page_GetMiterLimit( HPDF_Page page )
	return c_func( xHPDF_Page_GetMiterLimit, {page} )
end function

/*
-- GetDash returns HPDF_DashMode which is an array and a couple unsigned ints
public function HPDF_Page_GetDash( HPDF_Page page )
	return c_func( xHPDF_Page_GetDash, {page} )
end function
*/

public function HPDF_Page_GetDash2( HPDF_Page page )
	
	atom dashmode = allocate_data( SIZEOF_HPDF_DASHMODE, TRUE )
	integer status = c_func( xHPDF_Page_GetDash2, {page,dashmode} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	integer offset = sizeof(HPDF_UINT16) * 8
	integer num_ptn = peek4u( dashmode + offset )
	
	offset += sizeof(HPDF_UINT)
	
	return { peek2u({ dashmode, num_ptn }) } &
	    peek4u( dashmode + offset )
end function

public function HPDF_Page_GetFlat( HPDF_Page page )
	return c_func( xHPDF_Page_GetFlat, {page} )
end function

public function HPDF_Page_GetCharSpace( HPDF_Page page )
	return c_func( xHPDF_Page_GetCharSpace, {page} )
end function

public function HPDF_Page_GetWordSpace( HPDF_Page page )
	return c_func( xHPDF_Page_GetWordSpace, {page} )
end function

public function HPDF_Page_GetHorizontalScalling( HPDF_Page page )
	return c_func( xHPDF_Page_GetHorizontalScalling, {page} )
end function

public function HPDF_Page_GetTextLeading( HPDF_Page page )
	return c_func( xHPDF_Page_GetTextLeading, {page} )
end function

public function HPDF_Page_GetTextRenderingMode( HPDF_Page page )
	return c_func( xHPDF_Page_GetTextRenderingMode, {page} )
end function

deprecate
public function HPDF_Page_GetTextRaise( HPDF_Page page )
	return c_func( xHPDF_Page_GetTextRaise, {page} )
end function

public function HPDF_Page_GetTextRise( HPDF_Page page )
	return c_func( xHPDF_Page_GetTextRise, {page} )
end function

/*
-- GetRGBFill returns HPDF_RGBColor which is three floats
public function HPDF_Page_GetRGBFill( HPDF_Page page )
	return c_func( xHPDF_Page_GetRGBFill, {page} )
end function
*/

public function HPDF_Page_GetRGBFill2( HPDF_Page page )
	
	atom color = allocate_data( SIZEOF_HPDF_RGBCOLOR, TRUE )
	integer status = c_func( xHPDF_Page_GetRGBFill2, {page,color} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32({ color, length(HPDF_RGBCOLOR) })
end function

/*
-- GetRGBStroke returns HPDF_RGBColor which is three floats
public function HPDF_Page_GetRGBStroke( HPDF_Page page )
	return c_func( xHPDF_Page_GetRGBStroke, {page} )
end function
*/

public function HPDF_Page_GetRGBStroke2( HPDF_Page page )
	
	atom color = allocate_data( SIZEOF_HPDF_RGBCOLOR, TRUE )
	integer status = c_func( xHPDF_Page_GetRGBStroke2, {page,color} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32({ color, length(HPDF_RGBCOLOR) })
end function

/*
-- GetCMYKFill returns HPDF_CMYKColor which is four floats
public function HPDF_Page_GetCMYKFill( HPDF_Page page )
	return c_func( xHPDF_Page_GetCMYKFill, {page} )
end function
*/

public function HPDF_Page_GetCMYKFill2( HPDF_Page page )
	
	atom color = allocate_data( SIZEOF_HPDF_CMYKCOLOR, TRUE )
	integer status = c_func( xHPDF_Page_GetCMYKFill2, {page,color} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32({ color, length(HPDF_CMYKCOLOR) })
end function

/*
-- GetCMYKStroke returns HPDF_CMYKColor which is four floats
public function HPDF_Page_GetCMYKStroke( HPDF_Page page )
	return c_func( xHPDF_Page_GetCMYKStroke, {page} )
end function
*/

public function HPDF_Page_GetCMYKStroke2( HPDF_Page page )
	
	atom color = allocate_data( SIZEOF_HPDF_CMYKCOLOR, TRUE )
	integer status = c_func( xHPDF_Page_GetCMYKStroke2, {page,color} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32({ color, length(HPDF_CMYKCOLOR) })
end function

public function HPDF_Page_GetGrayFill( HPDF_Page page )
	return c_func( xHPDF_Page_GetGrayFill, {page} )
end function

public function HPDF_Page_GetGrayStroke( HPDF_Page page )
	return c_func( xHPDF_Page_GetGrayStroke, {page} )
end function

public function HPDF_Page_GetStrokingColorSpace( HPDF_Page page )
	return c_func( xHPDF_Page_GetStrokingColorSpace, {page} )
end function

public function HPDF_Page_GetFillingColorSpace( HPDF_Page page )
	return c_func( xHPDF_Page_GetFillingColorSpace, {page} )
end function

/*
-- GetTextMatrix returns HPDF_TransMatrix which is six floats
public function HPDF_Page_GetTextMatrix( HPDF_Page page )
	return c_func( xHPDF_Page_GetTextMatrix, {page} )
end function
*/

public function HPDF_Page_GetTextMatrix2( HPDF_Page page )
	
	atom matrix = allocate_data( SIZEOF_HPDF_TRANSMATRIX, TRUE )
	integer status = c_func( xHPDF_Page_GetTextMatrix2, {page,matrix} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_float32({ matrix, length(HPDF_TRANSMATRIX) })
end function

public function HPDF_Page_GetGStateDepth( HPDF_Page page )
	return c_func( xHPDF_Page_GetGStateDepth, {page} )
end function

/*--------------------------------------------------------------------------*/
/*----- GRAPHICS OPERATORS -------------------------------------------------*/

/*--- General graphics state ---------------------------------------------*/

public function HPDF_Page_SetLineWidth( HPDF_Page page, atom line_width )
	return c_func( xHPDF_Page_SetLineWidth, {page,line_width} )
end function

public function HPDF_Page_SetLineCap( HPDF_Page page, HPDF_LineCap line_cap )
	return c_func( xHPDF_Page_SetLineCap, {page,line_cap} )
end function

public function HPDF_Page_SetLineJoin( HPDF_Page page, HPDF_LineJoin line_join )
	return c_func( xHPDF_Page_SetLineJoin, {page,line_join} )
end function

public function HPDF_Page_SetMiterLimit( HPDF_Page page, atom miter_limit )
	return c_func( xHPDF_Page_SetMiterLimit, {page,miter_limit} )
end function

public function HPDF_Page_SetDash( HPDF_Page page, sequence dash_ptn, atom num_param, atom phase )
	
	atom pdash_ptn = allocate_data( sizeof(HPDF_UINT)*num_param, TRUE )
	poke4( pdash_ptn, dash_ptn )
	
	return c_func( xHPDF_Page_SetDash, {page,pdash_ptn,num_param,phase} )
end function

public function HPDF_Page_SetFlat( HPDF_Page page, atom flatness )
	return c_func( xHPDF_Page_SetFlat, {page,flatness} )
end function

public function HPDF_Page_SetExtGState( HPDF_Page page, HPDF_ExtGState ext_gstate )
	return c_func( xHPDF_Page_SetExtGState, {page,ext_gstate} )
end function

/*--- Special graphic state operator --------------------------------------*/

public function HPDF_Page_GSave( HPDF_Page page )
	return c_func( xHPDF_Page_GSave, {page} )
end function

public function HPDF_Page_GRestore( HPDF_Page page )
	return c_func( xHPDF_Page_GRestore, {page} )
end function

public function HPDF_Page_Concat( HPDF_Page page, atom a, atom b, atom c, atom d, atom x, atom y )
	return c_func( xHPDF_Page_Concat, {page,a,b,c,d,x,y} )
end function

/*--- Path construction operator ------------------------------------------*/

public function HPDF_Page_MoveTo( HPDF_Page page, atom x, atom y )
	return c_func( xHPDF_Page_MoveTo, {page,x,y} )
end function

public function HPDF_Page_LineTo( HPDF_Page page, atom x, atom y )
	return c_func( xHPDF_Page_LineTo, {page,x,y} )
end function

public function HPDF_Page_CurveTo( HPDF_Page page, atom x1, atom y1, atom x2, atom y2, atom x3, atom y3 )
	return c_func( xHPDF_Page_CurveTo, {page,x1,y1,x2,y2,x3,y3} )
end function

public function HPDF_Page_CurveTo2( HPDF_Page page, atom x2, atom y2, atom x3, atom y3 )
	return c_func( xHPDF_Page_CurveTo2, {page,x2,y2,x3,y3} )
end function

public function HPDF_Page_CurveTo3( HPDF_Page page, atom x1, atom y1, atom x3, atom y3 )
	return c_func( xHPDF_Page_CurveTo3, {page,x1,y1,x3,y3} )
end function

public function HPDF_Page_ClosePath( HPDF_Page page )
	return c_func( xHPDF_Page_ClosePath, {page} )
end function

public function HPDF_Page_Rectangle( HPDF_Page page, atom x, atom y, atom width, atom height )
	return c_func( xHPDF_Page_Rectangle, {page,x,y,width,height} )
end function

/*--- Path painting operator ---------------------------------------------*/

public function HPDF_Page_Stroke( HPDF_Page page )
	return c_func( xHPDF_Page_Stroke, {page} )
end function

public function HPDF_Page_ClosePathStroke( HPDF_Page page )
	return c_func( xHPDF_Page_ClosePathStroke, {page} )
end function

public function HPDF_Page_Fill( HPDF_Page page )
	return c_func( xHPDF_Page_Fill, {page} )
end function

public function HPDF_Page_Eofill( HPDF_Page page )
	return c_func( xHPDF_Page_Eofill, {page} )
end function

public function HPDF_Page_FillStroke( HPDF_Page page )
	return c_func( xHPDF_Page_FillStroke, {page} )
end function

public function HPDF_Page_EofillStroke( HPDF_Page page )
	return c_func( xHPDF_Page_EofillStroke, {page} )
end function

public function HPDF_Page_ClosePathFillStroke( HPDF_Page page )
	return c_func( xHPDF_Page_ClosePathFillStroke, {page} )
end function

public function HPDF_Page_ClosePathEofillStroke( HPDF_Page page )
	return c_func( xHPDF_Page_ClosePathEofillStroke, {page} )
end function

public function HPDF_Page_EndPath( HPDF_Page page )
	return c_func( xHPDF_Page_EndPath, {page} )
end function

/*--- Clipping paths operator --------------------------------------------*/

public function HPDF_Page_Clip( HPDF_Page page )
	return c_func( xHPDF_Page_Clip, {page} )
end function

public function HPDF_Page_Eoclip( HPDF_Page page )
	return c_func( xHPDF_Page_Eoclip, {page} )
end function

/*--- Text object operator -----------------------------------------------*/

public function HPDF_Page_BeginText( HPDF_Page page )
	return c_func( xHPDF_Page_BeginText, {page} )
end function

public function HPDF_Page_EndText( HPDF_Page page )
	return c_func( xHPDF_Page_EndText, {page} )
end function

/*--- Text state ---------------------------------------------------------*/

public function HPDF_Page_SetCharSpace( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetCharSpace, {page,value} )
end function

public function HPDF_Page_SetWordSpace( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetWordSpace, {page,value} )
end function

public function HPDF_Page_SetHorizontalScalling( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetHorizontalScalling, {page,value} )
end function

public function HPDF_Page_SetTextLeading( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetTextLeading, {page,value} )
end function

public function HPDF_Page_SetFontAndSize( HPDF_Page page, HPDF_Font font, atom value )
	return c_func( xHPDF_Page_SetFontAndSize, {page,font,value} )
end function

public function HPDF_Page_SetTextRenderingMode( HPDF_Page page, HPDF_TextRenderingMode mode )
	return c_func( xHPDF_Page_SetTextRenderingMode, {page,mode} )
end function

public function HPDF_Page_SetTextRise( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetTextRise, {page,value} )
end function

deprecate
public function HPDF_Page_SetTextRaise( HPDF_Page page, atom value )
	return c_func( xHPDF_Page_SetTextRaise, {page,value} )
end function

/*--- Text positioning ---------------------------------------------------*/

public function HPDF_Page_MoveTextPos( HPDF_Page page, atom x, atom y )
	return c_func( xHPDF_Page_MoveTextPos, {page,x,y} )
end function

public function HPDF_Page_MoveTextPos2( HPDF_Page page, atom x, atom y )
	return c_func( xHPDF_Page_MoveTextPos2, {page,x,y} )
end function

public function HPDF_Page_SetTextMatrix( HPDF_Page page, atom a, atom b, atom c, atom d, atom x, atom y )
	return c_func( xHPDF_Page_SetTextMatrix, {page,a,b,c,d,x,y} )
end function

public function HPDF_Page_MoveToNextLine( HPDF_Page page )
	return c_func( xHPDF_Page_MoveToNextLine, {page} )
end function

/*--- Text showing -------------------------------------------------------*/

public function HPDF_Page_ShowText( HPDF_Page page, sequence text )
	return c_func( xHPDF_Page_ShowText, {page,_(text)} )
end function

public function HPDF_Page_ShowTextNextLine( HPDF_Page page, sequence text )
	return c_func( xHPDF_Page_ShowTextNextLine, {page,_(text)} )
end function

public function HPDF_Page_ShowTextNextLineEx( HPDF_Page page, atom word_space, atom char_space, sequence text )
	return c_func( xHPDF_Page_ShowTextNextLineEx, {page,word_space,char_space,_(text)} )
end function

/*--- Color showing ------------------------------------------------------*/

public function HPDF_Page_SetGrayFill( HPDF_Page page, atom gray )
	return c_func( xHPDF_Page_SetGrayFill, {page,gray} )
end function

public function HPDF_Page_SetGrayStroke( HPDF_Page page, atom gray )
	return c_func( xHPDF_Page_SetGrayStroke, {page,gray} )
end function

public function HPDF_Page_SetRGBFill( HPDF_Page page, atom r, atom g, atom b )
	return c_func( xHPDF_Page_SetRGBFill, {page,r,g,b} )
end function

public function HPDF_Page_SetRGBStroke( HPDF_Page page, atom r, atom g, atom b )
	return c_func( xHPDF_Page_SetRGBStroke, {page,r,g,b} )
end function

public function HPDF_Page_SetCMYKFill( HPDF_Page page, atom c, atom m, atom y, atom k )
	return c_func( xHPDF_Page_SetCMYKFill, {page,c,m,y,k} )
end function

public function HPDF_Page_SetCMYKStroke( HPDF_Page page, atom c, atom m, atom y, atom k )
	return c_func( xHPDF_Page_SetCMYKStroke, {page,c,m,y,k} )
end function

/*--- XObjects -----------------------------------------------------------*/

public function HPDF_Page_ExecuteXObject( HPDF_Page page, HPDF_XObject obj )
	return c_func( xHPDF_Page_ExecuteXObject, {page,obj} )
end function

/*--- Content streams ----------------------------------------------------*/

public function HPDF_Page_New_Content_Stream( HPDF_Page page )
	
	atom new_stream = allocate_data( sizeof(C_POINTER), TRUE )
	integer status = c_func( xHPDF_Page_New_Content_Stream, {page,new_stream} )
	
	if status != HPDF_OK then
		return NULL
	end if
	
	return peek_pointer( new_stream )
end function

public function HPDF_Page_Insert_Shared_Content_Stream( HPDF_Page page, HPDF_Dict shared_stream )
	return c_func( xHPDF_Page_Insert_Shared_Content_Stream, {page,shared_stream} )
end function

/*--- Compatibility ------------------------------------------------------*/

public function HPDF_Page_DrawImage( HPDF_Page page, HPDF_Image image, atom x, atom y, atom width, atom height )
	return c_func( xHPDF_Page_DrawImage, {page,image,x,y,width,height} )
end function

public function HPDF_Page_Circle( HPDF_Page page, atom x, atom y, atom radius )
	return c_func( xHPDF_Page_Circle, {page,x,y,radius} )
end function

public function HPDF_Page_Ellipse( HPDF_Page page, atom x, atom y, atom xradius, atom yradius )
	return c_func( xHPDF_Page_Ellipse, {page,x,y,xradius,yradius} )
end function

public function HPDF_Page_Arc( HPDF_Page page, atom x, atom y, atom radius, atom angle1, atom angle2 )
	return c_func( xHPDF_Page_Arc, {page,x,y,radius,angle1,angle2} )
end function

public function HPDF_Page_TextOut( HPDF_Page page, atom xpos, atom ypos, sequence text )
	return c_func( xHPDF_Page_TextOut, {page,xpos,ypos,_(text)} )
end function

public function HPDF_Page_TextRect( HPDF_Page page, atom left, atom top, atom right, atom bottom, sequence text, HPDF_TextAlignment align, integer return_len = FALSE )
	
	atom len = allocate_data( sizeof(HPDF_UINT), TRUE )
	mem_set( len, sizeof(HPDF_UINT), NULL )
	
	integer status = c_func( xHPDF_Page_TextRect, {page,left,top,right,bottom,_(text),align,len} )
	
	if return_len then
		return status & peek4u( len )
	end if
	
	return status
end function

public function HPDF_Page_SetSlideShow( HPDF_Page page, HPDF_TransitionStyle style, atom disp_time, atom trans_time )
	return c_func( xHPDF_Page_SetSlideShow, {page,style,disp_time,trans_time} )
end function

public function HPDF_ICC_LoadIccFromMem( HPDF_Doc pdf, HPDF_MMgr mmgr, HPDF_Stream iccdata, HPDF_Xref xref, integer numcomponent )
	return c_func( xHPDF_ICC_LoadIccFromMem, {pdf,mmgr,iccdata,xref,numcomponent} )
end function

public function HPDF_LoadIccProfileFromFile( HPDF_Doc pdf, sequence icc_file_name, integer numcomponent )
	return c_func( xHPDF_LoadIccProfileFromFile, {pdf,_(icc_file_name),numcomponent} )
end function

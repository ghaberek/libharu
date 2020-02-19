
include std/dll.e

/*----------------------------------------------------------------------------*/
/*----- type definition ------------------------------------------------------*/

/*  native OS integer types */
export constant HPDF_INT        = C_INT
export constant HPDF_UINT       = C_UINT

/*  32bit integer types
 */
export constant HPDF_INT32      = C_INT
export constant HPDF_UINT32     = C_UINT

/*  16bit integer types
 */
export constant HPDF_INT16      = C_SHORT
export constant HPDF_UINT16     = C_USHORT

/*  8bit integer types
 */
export constant HPDF_INT8       = C_CHAR
export constant HPDF_UINT8      = C_UCHAR

/*  8bit binary types
 */
export constant HPDF_BYTE       = C_UCHAR

/*  float type (32bit IEEE754)
 */
export constant HPDF_REAL       = C_FLOAT

/*  double type (64bit IEEE754)
 */
export constant HPDF_DOUBLE     = C_DOUBLE

/*  boolean type (0: False, !0: True)
 */
export constant HPDF_BOOL       = C_INT

/*  error-no type (32bit unsigned integer)
 */
export constant HPDF_STATUS     = C_ULONG

/*  charactor-code type (16bit)
 */
export constant HPDF_CID        = HPDF_UINT16
export constant HPDF_UNICODE    = HPDF_UINT16

/*  HPDF_Point struct
 */
--typedef  struct  _HPDF_Point {
--    HPDF_REAL  x;
--    HPDF_REAL  y;
--} HPDF_Point;

export constant HPDF_POINT = {HPDF_REAL,HPDF_REAL}

export constant SIZEOF_HPDF_POINT = sizeof(HPDF_REAL) * length(HPDF_POINT)

public type HPDF_Point( sequence x )
	return length( x ) = 2
	   and atom( x[1] ) -- x
	   and atom( x[2] ) -- y
end type

export constant HPDF_RECT = {HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}

export constant SIZEOF_HPDF_RECT = sizeof(HPDF_REAL) * length(HPDF_RECT)

public type HPDF_Rect( sequence x )
	return length( x ) = 4
	   and atom( x[1] ) -- left
	   and atom( x[2] ) -- bottom
	   and atom( x[3] ) -- right
	   and atom( x[4] ) -- top
end type

export constant HPDF_POINT3D = {HPDF_REAL,HPDF_REAL,HPDF_REAL}

public type HPDF_Point3D( sequence x )
	return length( x ) = 3
	   and atom( x[1] ) -- x
	   and atom( x[2] ) -- y
	   and atom( x[3] ) -- z
end type

export constant HPDF_BOX = HPDF_RECT

export constant SIZEOF_HPDF_BOX = SIZEOF_HPDF_RECT

public type HPDF_Box( sequence x )
	return HPDF_Rect( x )
end type

export constant HPDF_DATE = {HPDF_INT,HPDF_INT,HPDF_INT,HPDF_INT,HPDF_INT,HPDF_INT,C_CHAR,HPDF_INT,HPDF_INT}

public type HPDF_Date( sequence x )
	return length( x ) = 9
	   and integer( x[1] ) -- year
	   and integer( x[2] ) -- month
	   and integer( x[3] ) -- day
	   and integer( x[4] ) -- hour
	   and integer( x[5] ) -- minutes
	   and integer( x[6] ) -- seconds
	   and integer( x[7] ) -- ind
	   and integer( x[8] ) -- off_hour
	   and integer( x[9] ) -- off_minutes
end type

export constant HPDF_INFOTYPE = C_INT

public enum type HPDF_InfoType
	
	/* date-time type parameters */
	HPDF_INFO_CREATION_DATE = 0,
	HPDF_INFO_MOD_DATE,
	
	/* string type parameters */
	HPDF_INFO_AUTHOR,
	HPDF_INFO_CREATOR,
	HPDF_INFO_PRODUCER,
	HPDF_INFO_TITLE,
	HPDF_INFO_SUBJECT,
	HPDF_INFO_KEYWORDS,
	HPDF_INFO_TRAPPED,
	HPDF_INFO_GTS_PDFX,
	HPDF_INFO_EOF
	
end type

/* PDF-A Types */

export constant HPDF_PDFATYPE = C_INT

public enum type HPDF_PDFAType
	
	HPDF_PDFA_1A = 0,
	HPDF_PDFA_1B = 1
	
end type

export constant HPDF_PDFVER = C_INT

public enum type HPDF_PDFVer
	
	HPDF_VER_12 = 0,
	HPDF_VER_13,
	HPDF_VER_14,
	HPDF_VER_15,
	HPDF_VER_16,
	HPDF_VER_17,
	HPDF_VER_EOF
	
end type

export constant HPDF_ENCRYPTMODE = C_INT

public enum type HPDF_EncryptMode
	
	HPDF_ENCRYPT_R2    = 2,
	HPDF_ENCRYPT_R3    = 3
	
end type


export constant HPDF_ERROR_HANDLER = C_POINTER

export constant HPDF_ALLOC_FUNC = C_POINTER

export constant HPDF_FREE_FUNC = C_POINTER

/*---------------------------------------------------------------------------*/
/*------ text width struct --------------------------------------------------*/

export constant HPDF_TEXTWIDTH = {HPDF_UINT,HPDF_UINT,HPDF_UINT}

export constant SIZEOF_HPDF_TEXTWIDTH = sizeof(HPDF_UINT) * length(HPDF_TEXTWIDTH)

public type HPDF_TextWidth( sequence x )
	return length( x ) = 3
	   and atom( x[1] ) -- numwords
	   and atom( x[2] ) -- width
	   and atom( x[3] ) -- numspace
end type


/*---------------------------------------------------------------------------*/
/*------ dash mode ----------------------------------------------------------*/

export constant HPDF_DASHMODE = {HPDF_UINT16,HPDF_UINT16,HPDF_UINT16,HPDF_UINT16,
	HPDF_UINT16,HPDF_UINT16,HPDF_UINT16,HPDF_UINT16,HPDF_UINT,HPDF_UINT}

export constant SIZEOF_HPDF_DASHMODE = sizeof(HPDF_UINT16) * 8 + sizeof(HPDF_UINT) * 2

public type HPDF_DashMode( sequence x )
	return length( x ) = 3
	   and length( x[1] ) = 8
	   and sequence( x[1] ) -- ptn
	   and atom( x[2] ) -- num_ptn
	   and atom( x[3] ) -- phase
end type

/*---------------------------------------------------------------------------*/
/*----- HPDF_TransMatrix struct ---------------------------------------------*/

export constant HPDF_TRANSMATRIX = {HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}

export constant SIZEOF_HPDF_TRANSMATRIX = sizeof(HPDF_REAL) * length(HPDF_TRANSMATRIX)

public type HPDF_TransMatrix( sequence x )
	return length( x ) = 6
	   and atom( x[1] ) -- a
	   and atom( x[2] ) -- b
	   and atom( x[3] ) -- c
	   and atom( x[4] ) -- d
	   and atom( x[5] ) -- x
	   and atom( x[6] ) -- y
end type

/*---------------------------------------------------------------------------*/
/*----- HPDF_3DMatrix struct ------------------------------------------------*/

export constant HPDF_3DMATRIX = {HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,
	HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}

public type HPDF_3DMatrix( sequence x )
	return length( x ) = 12
	   and atom( x[ 1] ) -- a
	   and atom( x[ 2] ) -- b
	   and atom( x[ 3] ) -- c
	   and atom( x[ 4] ) -- d
	   and atom( x[ 5] ) -- e
	   and atom( x[ 6] ) -- f
	   and atom( x[ 7] ) -- g
	   and atom( x[ 8] ) -- h
	   and atom( x[ 9] ) -- i
	   and atom( x[10] ) -- tx
	   and atom( x[11] ) -- ty
	   and atom( x[12] ) -- tz
end type

/*---------------------------------------------------------------------------*/

export constant HPDF_COLORSPACE = C_INT

public enum type HPDF_ColorSpace
	
	HPDF_CS_DEVICE_GRAY = 0,
	HPDF_CS_DEVICE_RGB,
	HPDF_CS_DEVICE_CMYK,
	HPDF_CS_CAL_GRAY,
	HPDF_CS_CAL_RGB,
	HPDF_CS_LAB,
	HPDF_CS_ICC_BASED,
	HPDF_CS_SEPARATION,
	HPDF_CS_DEVICE_N,
	HPDF_CS_INDEXED,
	HPDF_CS_PATTERN,
	HPDF_CS_EOF
	
end type

/*---------------------------------------------------------------------------*/
/*----- HPDF_RGBColor struct ------------------------------------------------*/

export constant HPDF_RGBCOLOR = {HPDF_REAL,HPDF_REAL,HPDF_REAL}

export constant SIZEOF_HPDF_RGBCOLOR = sizeof(HPDF_REAL) * length(HPDF_RGBCOLOR)

public type HPDF_RGBColor( sequence x )
	return length( x ) = 3
	   and atom( x[1] ) -- r
	   and atom( x[2] ) -- g
	   and atom( x[3] ) -- b
end type

/*---------------------------------------------------------------------------*/
/*----- HPDF_CMYKColor struct -----------------------------------------------*/

export constant HPDF_CMYKCOLOR = {HPDF_REAL,HPDF_REAL,HPDF_REAL,HPDF_REAL}

export constant SIZEOF_HPDF_CMYKCOLOR = sizeof(HPDF_REAL) * length(HPDF_CMYKCOLOR)

public type HPDF_CMYKColor( sequence x )
	return length( x ) = 4
	   and atom( x[1] ) -- c
	   and atom( x[2] ) -- m
	   and atom( x[3] ) -- y
	   and atom( x[4] ) -- k
end type

/*---------------------------------------------------------------------------*/
/*------ The line cap style -------------------------------------------------*/

export constant HPDF_LINECAP = C_INT

public enum type HPDF_LineCap
	
	HPDF_BUTT_END = 0,
	HPDF_ROUND_END,
	HPDF_PROJECTING_SCUARE_END,
	HPDF_LINECAP_EOF
	
end type

/*----------------------------------------------------------------------------*/
/*------ The line join style -------------------------------------------------*/

export constant HPDF_LINEJOIN = C_INT

public enum type HPDF_LineJoin
	
	HPDF_MITER_JOIN = 0,
	HPDF_ROUND_JOIN,
	HPDF_BEVEL_JOIN,
	HPDF_LINEJOIN_EOF
	
end type

/*----------------------------------------------------------------------------*/
/*------ The text rendering mode ---------------------------------------------*/

export constant HPDF_TEXTRENDERINGMODE = C_INT

public enum type HPDF_TextRenderingMode
	
	HPDF_FILL = 0,
	HPDF_STROKE,
	HPDF_FILL_THEN_STROKE,
	HPDF_INVISIBLE,
	HPDF_FILL_CLIPPING,
	HPDF_STROKE_CLIPPING,
	HPDF_FILL_STROKE_CLIPPING,
	HPDF_CLIPPING,
	HPDF_RENDERING_MODE_EOF
	
end type

export constant HPDF_WRITINGMODE = C_INT

public enum type HPDF_WritingMode
	
	HPDF_WMODE_HORIZONTAL = 0,
	HPDF_WMODE_VERTICAL,
	HPDF_WMODE_EOF
	
end type

export constant HPDF_PAGELAYOUT = C_INT

public enum type HPDF_PageLayout
	
	HPDF_PAGE_LAYOUT_SINGLE = 0,
	HPDF_PAGE_LAYOUT_ONE_COLUMN,
	HPDF_PAGE_LAYOUT_TWO_COLUMN_LEFT,
	HPDF_PAGE_LAYOUT_TWO_COLUMN_RIGHT,
	HPDF_PAGE_LAYOUT_TWO_PAGE_LEFT,
	HPDF_PAGE_LAYOUT_TWO_PAGE_RIGHT,
	HPDF_PAGE_LAYOUT_EOF
	
end type

export constant HPDF_PAGEMODE = C_INT

public enum type HPDF_PageMode
	
	HPDF_PAGE_MODE_USE_NONE = 0,
	HPDF_PAGE_MODE_USE_OUTLINE,
	HPDF_PAGE_MODE_USE_THUMBS,
	HPDF_PAGE_MODE_FULL_SCREEN,
/*  HPDF_PAGE_MODE_USE_OC,
    HPDF_PAGE_MODE_USE_ATTACHMENTS,
 */
	HPDF_PAGE_MODE_EOF
	
end type

export constant HPDF_PAGENUMSTYLE = C_INT

public enum type HPDF_PageNumStyle
	
	HPDF_PAGE_NUM_STYLE_DECIMAL = 0,
	HPDF_PAGE_NUM_STYLE_UPPER_ROMAN,
	HPDF_PAGE_NUM_STYLE_LOWER_ROMAN,
	HPDF_PAGE_NUM_STYLE_UPPER_LETTERS,
	HPDF_PAGE_NUM_STYLE_LOWER_LETTERS,
	HPDF_PAGE_NUM_STYLE_EOF
	
end type

export constant HPDF_DESTINATIONTYPE = C_INT

public enum type HPDF_DestinationType
	
	HPDF_XYZ = 0,
	HPDF_FIT,
	HPDF_FIT_H,
	HPDF_FIT_V,
	HPDF_FIT_R,
	HPDF_FIT_B,
	HPDF_FIT_BH,
	HPDF_FIT_BV,
	HPDF_DST_EOF
	
end type

export constant HPDF_ANNOTTYPE = C_INT

public enum type HPDF_AnnotType
	
	HPDF_ANNOT_TEXT_NOTES = 0,
	HPDF_ANNOT_LINK,
	HPDF_ANNOT_SOUND,
	HPDF_ANNOT_FREE_TEXT,
	HPDF_ANNOT_STAMP,
	HPDF_ANNOT_SQUARE,
	HPDF_ANNOT_CIRCLE,
	HPDF_ANNOT_STRIKE_OUT,
	HPDF_ANNOT_HIGHTLIGHT,
	HPDF_ANNOT_UNDERLINE,
	HPDF_ANNOT_INK,
	HPDF_ANNOT_FILE_ATTACHMENT,
	HPDF_ANNOT_POPUP,
	HPDF_ANNOT_3D,
	HPDF_ANNOT_SQUIGGLY,
	HPDF_ANNOT_LINE,
	HPDF_ANNOT_PROJECTION,
	HPDF_ANNOT_WIDGET
	
end type

export constant HPDF_ANNOTFLGS = C_INT

public enum type HPDF_AnnotFlgs
	
	HPDF_ANNOT_INVISIBLE = 0,
	HPDF_ANNOT_HIDDEN,
	HPDF_ANNOT_PRINT,
	HPDF_ANNOT_NOZOOM,
	HPDF_ANNOT_NOROTATE,
	HPDF_ANNOT_NOVIEW,
	HPDF_ANNOT_READONLY
	
end type

export constant HPDF_ANNOTHIGHLIGHTMODE = C_INT

public enum type HPDF_AnnotHighlightMode
	
	HPDF_ANNOT_NO_HIGHTLIGHT = 0,
	HPDF_ANNOT_INVERT_BOX,
	HPDF_ANNOT_INVERT_BORDER,
	HPDF_ANNOT_DOWN_APPEARANCE,
	HPDF_ANNOT_HIGHTLIGHT_MODE_EOF
	
end type

export constant HPDF_ANNOTICON = C_INT

public enum type HPDF_AnnotIcon
	
	HPDF_ANNOT_ICON_COMMENT = 0,
	HPDF_ANNOT_ICON_KEY,
	HPDF_ANNOT_ICON_NOTE,
	HPDF_ANNOT_ICON_HELP,
	HPDF_ANNOT_ICON_NEW_PARAGRAPH,
	HPDF_ANNOT_ICON_PARAGRAPH,
	HPDF_ANNOT_ICON_INSERT,
	HPDF_ANNOT_ICON_EOF
	
end type

export constant HPDF_ANNOTINTENT = C_INT

public enum type HPDF_AnnotIntent
	
	HPDF_ANNOT_INTENT_FREETEXTCALLOUT = 0,
	HPDF_ANNOT_INTENT_FREETEXTTYPEWRITER,
	HPDF_ANNOT_INTENT_LINEARROW,
	HPDF_ANNOT_INTENT_LINEDIMENSION,
	HPDF_ANNOT_INTENT_POLYGONCLOUD,
	HPDF_ANNOT_INTENT_POLYLINEDIMENSION,
	HPDF_ANNOT_INTENT_POLYGONDIMENSION
	
end type

export constant HPDF_LINEANNOTENDINGSTYLE = C_INT

public enum type HPDF_LineAnnotEndingStyle
	
	HPDF_LINE_ANNOT_NONE = 0,
	HPDF_LINE_ANNOT_SQUARE,
	HPDF_LINE_ANNOT_CIRCLE,
	HPDF_LINE_ANNOT_DIAMOND,
	HPDF_LINE_ANNOT_OPENARROW,
	HPDF_LINE_ANNOT_CLOSEDARROW,
	HPDF_LINE_ANNOT_BUTT,
	HPDF_LINE_ANNOT_ROPENARROW,
	HPDF_LINE_ANNOT_RCLOSEDARROW,
	HPDF_LINE_ANNOT_SLASH
	
end type

export constant HPDF_LINEANNOTCAPPOSITION = C_INT

public enum type HPDF_LineAnnotCapPosition
	
	HPDF_LINE_ANNOT_CAP_INLINE = 0,
	HPDF_LINE_ANNOT_CAP_TOP
	
end type

export constant HPDF_STAMPANNOTNAME = C_INT

public enum type HPDF_StampAnnotName
	
	HPDF_STAMP_ANNOT_APPROVED = 0,
	HPDF_STAMP_ANNOT_EXPERIMENTAL,
	HPDF_STAMP_ANNOT_NOTAPPROVED,
	HPDF_STAMP_ANNOT_ASIS,
	HPDF_STAMP_ANNOT_EXPIRED,
	HPDF_STAMP_ANNOT_NOTFORPUBLICRELEASE,
	HPDF_STAMP_ANNOT_CONFIDENTIAL,
	HPDF_STAMP_ANNOT_FINAL,
	HPDF_STAMP_ANNOT_SOLD,
	HPDF_STAMP_ANNOT_DEPARTMENTAL,
	HPDF_STAMP_ANNOT_FORCOMMENT,
	HPDF_STAMP_ANNOT_TOPSECRET,
	HPDF_STAMP_ANNOT_DRAFT,
	HPDF_STAMP_ANNOT_FORPUBLICRELEASE
	
end type

/*----------------------------------------------------------------------------*/
/*------ border stype --------------------------------------------------------*/

export constant HPDF_BSSUBTYPE = C_INT

public enum type HPDF_BSSubtype
	
	HPDF_BS_SOLID = 0,
	HPDF_BS_DASHED,
	HPDF_BS_BEVELED,
	HPDF_BS_INSET,
	HPDF_BS_UNDERLINED
	
end type


/*----- blend modes ----------------------------------------------------------*/

export constant HPDF_BLENDMODE = C_INT

public enum type HPDF_BlendMode
	
	HPDF_BM_NORMAL = 0,
	HPDF_BM_MULTIPLY,
	HPDF_BM_SCREEN,
	HPDF_BM_OVERLAY,
	HPDF_BM_DARKEN,
	HPDF_BM_LIGHTEN,
	HPDF_BM_COLOR_DODGE,
	HPDF_BM_COLOR_BUM,
	HPDF_BM_HARD_LIGHT,
	HPDF_BM_SOFT_LIGHT,
	HPDF_BM_DIFFERENCE,
	HPDF_BM_EXCLUSHON,
	HPDF_BM_EOF
	
end type

/*----- slide show -----------------------------------------------------------*/

export constant HPDF_TRANSITIONSTYLE = C_INT

public enum type HPDF_TransitionStyle
	
	HPDF_TS_WIPE_RIGHT = 0,
	HPDF_TS_WIPE_UP,
	HPDF_TS_WIPE_LEFT,
	HPDF_TS_WIPE_DOWN,
	HPDF_TS_BARN_DOORS_HORIZONTAL_OUT,
	HPDF_TS_BARN_DOORS_HORIZONTAL_IN,
	HPDF_TS_BARN_DOORS_VERTICAL_OUT,
	HPDF_TS_BARN_DOORS_VERTICAL_IN,
	HPDF_TS_BOX_OUT,
	HPDF_TS_BOX_IN,
	HPDF_TS_BLINDS_HORIZONTAL,
	HPDF_TS_BLINDS_VERTICAL,
	HPDF_TS_DISSOLVE,
	HPDF_TS_GLITTER_RIGHT,
	HPDF_TS_GLITTER_DOWN,
	HPDF_TS_GLITTER_TOP_LEFT_TO_BOTTOM_RIGHT,
	HPDF_TS_REPLACE,
	HPDF_TS_EOF
	
end type

/*----------------------------------------------------------------------------*/

export constant HPDF_PAGESIZES = C_INT

public enum type HPDF_PageSizes
	
	HPDF_PAGE_SIZE_LETTER = 0,
	HPDF_PAGE_SIZE_LEGAL,
	HPDF_PAGE_SIZE_A3,
	HPDF_PAGE_SIZE_A4,
	HPDF_PAGE_SIZE_A5,
	HPDF_PAGE_SIZE_B4,
	HPDF_PAGE_SIZE_B5,
	HPDF_PAGE_SIZE_EXECUTIVE,
	HPDF_PAGE_SIZE_US4x6,
	HPDF_PAGE_SIZE_US4x8,
	HPDF_PAGE_SIZE_US5x7,
	HPDF_PAGE_SIZE_COMM10,
	HPDF_PAGE_SIZE_EOF
	
end type

export constant HPDF_PAGEDIRECTION = C_INT

public enum type HPDF_PageDirection
	
	HPDF_PAGE_PORTRAIT = 0,
	HPDF_PAGE_LANDSCAPE
	
end type

export constant HPDF_ENCODERTYPE = C_INT

public enum type HPDF_EncoderType
	
	HPDF_ENCODER_TYPE_SINGLE_BYTE = 0,
	HPDF_ENCODER_TYPE_DOUBLE_BYTE,
	HPDF_ENCODER_TYPE_UNINITIALIZED,
	HPDF_ENCODER_UNKNOWN
	
end type

export constant HPDF_BYTETYPE = C_INT

public enum type HPDF_ByteType
	
	HPDF_BYTE_TYPE_SINGLE = 0,
	HPDF_BYTE_TYPE_LEAD,
	HPDF_BYTE_TYPE_TRIAL,
	HPDF_BYTE_TYPE_UNKNOWN
	
end type

export constant HPDF_TEXTALIGNMENT = C_INT

public enum type HPDF_TextAlignment
	
	HPDF_TALIGN_LEFT = 0,
	HPDF_TALIGN_RIGHT,
	HPDF_TALIGN_CENTER,
	HPDF_TALIGN_JUSTIFY
	
end type

/*----------------------------------------------------------------------------*/

export constant HPDF_NAMEDICTKEY = C_INT

/* Name Dictionary values -- see PDF reference section 7.7.4 */
public enum type HPDF_NameDictKey
	
	HPDF_NAME_EMBEDDED_FILES = 0,    /* TODO the rest */
	HPDF_NAME_EOF
	
end type

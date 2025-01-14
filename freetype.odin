package freetype

import "core:c"

when ODIN_OS == .Windows 
{
    foreign import freetype "lib/freetype.lib"
} 
else when ODIN_OS == .Linux 
{
    foreign import freetype "lib/libfreetype.a"
}

Library       :: distinct rawptr;

Bool          :: distinct c.uchar;
F26Dot6       :: distinct c.long;
Fixed         :: distinct c.long;
Pos           :: distinct c.long;



Error :: enum c.int 
{
    Ok                            = 0x00,
    CannotOpenResource          = 0x01,
    UnknownFileFormat           = 0x02,
    InvalidFileFormat           = 0x03,
    InvalidVersion               = 0x04,
    LowerModuleVersion          = 0x05,
    InvalidArgument              = 0x06,
    UnimplementedFeature         = 0x07,
    InvalidTable                 = 0x08,
    InvalidOffset                = 0x09,
    ArrayTooLarge               = 0x0A,
    MissingModule                = 0x0B,
    MissingProperty              = 0x0C,
    InvalidGlyphIndex           = 0x10,
    InvalidCharacterCode        = 0x11,
    InvalidGlyphFormat          = 0x12,
    CannotRenderGlyph           = 0x13,
    InvalidOutline               = 0x14,
    InvalidComposite             = 0x15,
    TooManyHints                = 0x16,
    InvalidPixelSize            = 0x17,
    InvalidSVGDocument          = 0x18,
    InvalidHandle                = 0x20,
    InvalidLibraryHandle        = 0x21,
    InvalidDriverHandle         = 0x22,
    InvalidFaceHandle           = 0x23,
    InvalidSizeHandle           = 0x24,
    InvalidSlotHandle           = 0x25,
    InvalidCharMapHandle        = 0x26,
    InvalidCacheHandle          = 0x27,
    InvalidStreamHandle         = 0x28,
    TooManyDrivers              = 0x30,
    TooManyExtensions           = 0x31,
    OutOfMemory                 = 0x40,
    UnlistedObject               = 0x41,
    CannotOpenStream            = 0x51,
    InvalidStreamSeek           = 0x52,
    InvalidStreamSkip           = 0x53,
    InvalidStreamRead           = 0x54,
    InvalidStreamOperation      = 0x55,
    InvalidFrameOperation       = 0x56,
    NestedFrameAccess           = 0x57,
    InvalidFrameRead            = 0x58,
    RasterUninitialized          = 0x60,
    RasterCorrupted              = 0x61,
    RasterOverflow               = 0x62,
    RasterNegativeHeight        = 0x63,
    TooManyCaches               = 0x70,
    InvalidOpcode                = 0x80,
    TooFewArguments             = 0x81,
    StackOverflow                = 0x82,
    CodeOverflow                 = 0x83,
    BadArgument                  = 0x84,
    DivideByZero                = 0x85,
    InvalidReference             = 0x86,
    DebugOpCode                  = 0x87,
    ENDFInExecStream           = 0x88,
    NestedDEFS                   = 0x89,
    InvalidCodeRange             = 0x8A,
    ExecutionTooLong            = 0x8B,
    TooManyFunctionDefs        = 0x8C,
    TooManyInstructionDefs     = 0x8D,
    TableMissing                 = 0x8E,
    HorizHeaderMissing          = 0x8F,
    LocationsMissing             = 0x90,
    NameTableMissing            = 0x91,
    CMapTableMissing            = 0x92,
    HmtxTableMissing            = 0x93,
    PostTableMissing            = 0x94,
    InvalidHorizMetrics         = 0x95,
    InvalidCharMapFormat        = 0x96,
    InvalidPPem                  = 0x97,
    InvalidVertMetrics          = 0x98,
    CouldNotFindContext        = 0x99,
    InvalidPostTableFormat     = 0x9A,
    InvalidPostTable            = 0x9B,
    DEFInGlyfBytecode          = 0x9C,
    MissingBitmap                = 0x9D,
    MissingSVGHooks             = 0x9E,
    SyntaxError                  = 0xA0,
    StackUnderflow               = 0xA1,
    Ignore                        = 0xA2,
    NoUnicodeGlyphName         = 0xA3,
    GlyphTooBig                 = 0xA4,
    MissingStartfontField       = 0xB0,
    MissingFontField            = 0xB1,
    MissingSizeField            = 0xB2,
    MissingFontboundingboxField = 0xB3,
    MissingCharsField           = 0xB4,
    MissingStartcharField       = 0xB5,
    MissingEncodingField        = 0xB6,
    MissingBbxField             = 0xB7,
    BbxTooBig                   = 0xB8,
    CorruptedFontHeader         = 0xB9,
    CorruptedFontGlyphs         = 0xBA,
}

PixelMode :: enum c.char 
{
    None,
    Mono,
    Gray,
    Gray2,
    Gray4,
    LCD,
    LCDV,
    BGRA,
}

CharMap      :: ^CharMapRec
Driver        :: ^DriverRec
DriverClass  :: ^DriverClassRec
Face          :: ^FaceRec
GlyphLoader  :: ^GlyphLoaderRec
GlyphSlot    :: ^GlyphSlotRec
ListNode     :: ^ListNodeRec
Memory        :: ^MemoryRec
Module        :: ^ModuleRec
Size          :: ^SizeRec
SizeRequest  :: ^SizeRequestRec
Stream        :: ^StreamRec
SubGlyph     :: ^SubGlyphRec

// Keeping internals rawptr for now.

FaceInternal :: rawptr
SizeInternal :: rawptr
SlotInternal :: rawptr

AllocFunc :: #type proc "c" (memory: Memory, size: c.long) -> rawptr
FreeFunc :: #type proc "c" (memory: Memory, block: rawptr)
ReallocFunc :: #type proc "c" (memory: Memory, curSize, newSize: c.long, block: rawptr) -> rawptr

GenericFinalizer :: #type proc "c" (object: rawptr)

FaceAttachFunc :: #type proc "c" (face: Face, stream: Stream) -> Error
FaceInitFunc :: #type proc "c" (stream: Stream, face: Face, typefaceIndex, numParams: c.int, parameters: ^Parameter) -> Error
FaceDoneFunc :: #type proc "c" (face: Face)
FaceGetAdvancesFunc :: #type proc "c" (face: Face, first, count: c.uint, flags: i32, advances: ^Fixed) -> Error
FaceGetKerningFunc :: #type proc "c" (face: Face, leftGlyph, rightGlyph: c.uint, kerning: ^Vector) -> Error

ModuleConstructor :: #type proc "c" (module: Module) -> Error
ModuleDestructor :: #type proc "c" (module: Module)
ModuleRequester :: #type proc "c" (module: Module, name: cstring) -> rawptr

SizeInitFunc :: #type proc "c" (size: Size) -> Error
SizeDoneFunc :: #type proc "c" (size: Size)
SizeRequestFunc :: #type proc "c" (size: Size, req: SizeRequest) -> Error
SizeSelectFunc :: #type proc "c" (size: Size, size_index: c.ulong) -> Error

SlotInitFunc :: #type proc "c" (slot: GlyphSlot) -> Error
SlotDoneFunc :: #type proc "c" (slot: GlyphSlot)
SlotLoadFunc :: #type proc "c" (slot: GlyphSlot, size: Size, glyphIndex: c.uint, loadFlags: i32) -> Error

StreamIOFunc :: #type proc "c" (stream: Stream, offset: c.ulong, buffer: ^c.uchar, count: c.ulong) -> c.ulong
StreamCloseFunc :: #type proc "c" (stream: Stream)

BBox :: struct 
{
    x_min, y_min, x_max, y_max : Pos,
}

Bitmap :: struct 
{
    Rows: c.uint,
    Width: c.uint,
    Pitch: c.int,
    Buffer: [^]c.uchar,
    NumGrays: c.ushort,
    PixelMode: PixelMode,
    PaletteMode: c.uchar,
    Palette: rawptr,
}

BitmapSize :: struct 
{
    Height: i16,
    Width: i16,

    Size: Pos,

    XPpem: Pos,
    YPpem: Pos,
}

CharMapRec :: struct 
{
    Face: Face,
    Encoding: Encoding,
    PlatformId: c.ushort,
    EncodingId: c.ushort,
}

DriverClassRec :: struct 
{
    Root:ModuleClass,

    FaceObjectSize: c.long,
    SizeObjectSize: c.long,
    SlotObjectSize: c.long,

    InitFace: FaceInitFunc,
    DoneFace: FaceDoneFunc,

    InitSize: SizeInitFunc,
    DoneSize: SizeDoneFunc,

    InitSlot: SlotInitFunc,
    DoneSlot: SlotDoneFunc,

    LoadGlyph: SlotLoadFunc,

    GetKerning: FaceGetKerningFunc,
    AttachFile: FaceAttachFunc,
    GetAdvances: FaceGetAdvancesFunc,

    RequestSize: SizeRequestFunc,
    SelectSize: SizeSelectFunc,
}

DriverRec :: struct 
{
    Root: ModuleRec,
    Clazz: DriverClass,
    FaceList: ListRec,
GlyphLoader: GlyphLoader,
}

Encoding :: enum c.int 
{
    None            = 0,

    MSSymbol       = c.int('s')<<24 | c.int('y')<<16 | c.int('m')<<8 | c.int('b')<<0,
    Unicode         = c.int('u')<<24 | c.int('n')<<16 | c.int('i')<<8 | c.int('c')<<0,

    Sjis            = c.int('s')<<24 | c.int('j')<<16 | c.int('i')<<8 | c.int('s')<<0,
    Prc             = c.int('g')<<24 | c.int('b')<<16 | c.int(' ')<<8 | c.int(' ')<<0,
    Big5            = c.int('b')<<24 | c.int('i')<<16 | c.int('g')<<8 | c.int('5')<<0,
    Wansung         = c.int('w')<<24 | c.int('a')<<16 | c.int('n')<<8 | c.int('s')<<0,
    Johab           = c.int('j')<<24 | c.int('o')<<16 | c.int('h')<<8 | c.int('a')<<0,

    AdobeStandard  = c.int('A')<<24 | c.int('D')<<16 | c.int('O')<<8 | c.int('B')<<0,
    AdobeExpert    = c.int('A')<<24 | c.int('D')<<16 | c.int('B')<<8 | c.int('E')<<0,
    AdobeCustom    = c.int('A')<<24 | c.int('D')<<16 | c.int('B')<<8 | c.int('C')<<0,
    AdobeLatin1   = c.int('l')<<24 | c.int('a')<<16 | c.int('t')<<8 | c.int('1')<<0,

    OldLatin2     = c.int('l')<<24 | c.int('a')<<16 | c.int('t')<<8 | c.int('2')<<0,

    AppleRoman     = c.int('a')<<24 | c.int('r')<<16 | c.int('m')<<8 | c.int('n')<<0,
}

FaceRec :: struct 
{
    NumFaces : c.long,
    FaceIndex : c.long,

    FaceFlags : c.long,
    StyleFlags : c.long,

    NumGlyphs : c.long,

    FamilyName : cstring,
    StyleName : cstring,

    NumFixedSizes : c.int,
    AvailableSizes : [^]BitmapSize,

    NumCharmaps : c.int,
    Charmaps : [^]CharMap,

    Generi : Generic,

    Bbox : BBox,

    UnitsPerEm : c.ushort,
    Ascender : c.short,
    Descender : c.short,
    Height : c.short,

    MaxAdvanceWidth : c.short,
    MaxAdvanceHeight : c.short,

    UnderlinePosition : c.short,
    UnderlineThickness : c.short,

    Glyph : GlyphSlot,
    Size : Size,
    Charmap : CharMap,

    Driver : Driver,
    Memory : Memory,
    Stream : Stream,

    SizesList : ListRec,

    AutoHint : Generic,
    Extensions : rawptr,

    Internal : FaceInternal,
}

Generic :: struct 
{
    data      : rawptr,
    finalizer : GenericFinalizer,
}

GlyphFormat :: enum c.int 
{
    None       = 0,
    Composite  = c.int('c')<<24 | c.int('o')<<16 | c.int('m')<<8 | c.int('p')<<0,
    Bitmap     = c.int('b')<<24 | c.int('i')<<16 | c.int('t')<<8 | c.int('s')<<0,
    Outline    = c.int('o')<<24 | c.int('u')<<16 | c.int('t')<<8 | c.int('l')<<0,
    Plotter    = c.int('p')<<24 | c.int('l')<<16 | c.int('o')<<8 | c.int('t')<<0,
    Svg        = c.int('S')<<24 | c.int('V')<<16 | c.int('G')<<8 | c.int(' ')<<0,
}

GlyphLoadRec :: struct 
{
    Outline : Outline,
    ExtraPoints : ^Vector,
    ExtraPoints2 : ^Vector,
    NumSubglyphs : c.uint,
    Subglyphs : SubGlyph,
}

GlyphLoaderRec :: struct 
{
    Memory : Memory,
    Points : c.uint,
    Contours : c.uint,
    Subglyphs : c.uint,
    Extra : Bool,

    Base : GlyphLoadRec,
    Current : GlyphLoadRec,

    Other : rawptr,
}

GlyphMetrics :: struct 
{
    Width: Pos,
    Height: Pos,

    HoriBearingX: Pos,
    HoriBearingY: Pos,
    HoriAdvance: Pos,

    VertBearingX: Pos,
    VertBearingY: Pos,
    VertAdvance: Pos,
}

GlyphSlotRec :: struct 
{
    Library: Library,
    Face: Face,
    Next: GlyphSlot,
    GlyphIndex: c.uint,
    Generic: Generic,

    Metrics: GlyphMetrics,
    LinearHoriAdvance: Fixed,
    LinearVertAdvance: Fixed,
    Advance: Vector,

    Format: GlyphFormat,

    Bitmap: Bitmap,
    BitmapLeft: c.int,
    BitmapTop: c.int,

    Outline: Outline,

    NumSubglyphs: c.uint,
    Subglyphs: SubGlyph,

    ControlData: rawptr,
    ControlLen: c.long,

    LsbDelta: Pos,
    RsbDelta: Pos,

    Other: rawptr,

    Internal: SlotInternal,
}

ListNodeRec :: struct 
{
    Prev, Next: ListNode,
    Data: rawptr,
}

ListRec :: struct 
{
    Head, Tail: ListNode,
}

LoadFlag :: enum i32 
{
    NoScale=0,
    NoHinting=1,
    Render=2,
    NoBitmap=3,
    VerticalLayout=4,
    ForceAutohint=5,
    CropBitmap=6,
    Pedantic=7,
    IgnoreGlobalAdvanceWidth=9,
    NoRecurse=10,
    IgnoreTransform=11,
    Monochrome=12,
    LinearDesign=13,
    SBitsOnly=14,
    NoAutohint=15,
    Color=20,
    ComputeMetrics=21,
    BitmapMetricsOnly=22,
    NoSVG=24,

}

LoadFlags :: distinct bit_set[LoadFlag; i32]

Matrix :: struct 
{
    xx, xy, yx, yy : Fixed,
}

MemoryRec :: struct 
{
    User : rawptr,
    Alloc : AllocFunc,
    Free : FreeFunc,
    Realloc : ReallocFunc,
}

ModuleClass :: struct 
{
    ModuleFlags: c.ulong,
    ModuleSize: c.long,
    ModuleName: cstring,
    ModuleVersion: Fixed,
    ModuleRequires: Fixed,

    ModuleInterface: rawptr,

    ModuleInit: ModuleConstructor,
    ModuleDone: ModuleDestructor,
    GetInterface: ModuleRequester,
}

ModuleRec :: struct 
{
    Clazz: ^ModuleClass,
    Library: Library,
    Memory: Memory,
}

Outline :: struct 
{
    NContours : c.short,
    NPoints : c.short,

    Points : ^Vector,
    Tags : ^c.char,
    Contours : ^c.short,

    Flags : c.int,
}

Parameter :: struct 
{
    Tag : c.ulong,
    Data : rawptr,
}

RenderMode :: enum 
{
    Normal = 0,
    Light  = 1,
    Mono   = 2,
    LCD    = 3,
    LCDV  = 4,

    Max    = 5,
}

SizeMetrics :: struct 
{
   XPpem : c.ushort,
   YPpem : c.ushort,

   XScale : Fixed,
   YScale : Fixed,

   Ascender : Pos,
   Descender : Pos,
   Height : Pos,
   MaxAdvance : Pos,
}

SizeRec :: struct 
{
    Face     : Face,
    Generic  : Generic,
    Metrics  : SizeMetrics,
    Internal : SizeInternal,
}

SizeRequestRec :: struct 
{
    Type : SizeRequestType,
    Width : c.long,
    Height : c.long,
    HoriResolution : c.uint,
    VertResolution : c.uint,
}

SizeRequestType :: enum {
    Normal   = 0,
    Real_Dim = 1,
    BBox    = 2,
    Cell     = 3,
    Scale    = 4,

    Max      = 5,
}

StreamDesc :: struct 
{
    Value : c.long,
    Ponter : rawptr,
}

StreamRec :: struct 
{
    Base   : ^c.uchar,
    Size   : c.ulong,
    Pos   : c.ulong,

    Descriptor : StreamDesc,
    Pathname   : StreamDesc,
    Read   : StreamIOFunc,
    Close   : StreamCloseFunc,

    Memory   : Memory,
    Cursor   : ^c.uchar,
    Limit   : ^c.uchar,
}

SubGlyphRec :: struct 
{
    Index : c.int,
    Flags : c.ushort,
    Arg1 : c.int,
    Arg2 : c.int,
    Transform : Matrix,
}

Vector :: struct 
{
    x, y: Pos,
}

@(default_calling_convention="c")
foreign freetype 
{
    @(link_name="FT_Init_FreeType") InitFreeType :: proc(library: ^Library) -> Error ---
    @(link_name="FT_Done_FreeType") DoneFreeType :: proc(library: Library) -> Error ---

    @(link_name="FT_New_Face")        NewFace        :: proc(library: Library, filePathName: cstring, faceIndex: c.long, face: ^Face) -> Error ---
    @(link_name="FT_New_Memory_Face") NewMemoryFace :: proc(library: Library, fileBase: ^byte, fileSize, faceIndex: c.long, face: ^Face) -> Error ---
    @(link_name="FT_Done_Face")       DoneFace       :: proc(face: Face) -> Error ---

    @(link_name="FT_Load_Char")      LoadChar      :: proc(face: Face, charCode: c.ulong, loadFlags: LoadFlags) -> Error ---
    @(link_name="FT_Set_Char_Size")  SetCharSize  :: proc(face: Face, charWidth, charHeight: F26Dot6, horzizontalResolution, verticalResolution: c.uint) -> Error ---
    @(link_name="FT_Get_Char_Index") GetCharIndex :: proc(face: Face, code: c.ulong) -> c.uint ---
    
    @(link_name="FT_Load_Glyph")   LoadGlyph   :: proc(face: Face, index: c.uint, flags: LoadFlags) -> Error ---
    @(link_name="FT_Render_Glyph") RenderGlyph :: proc(slot: GlyphSlot, renderMode: RenderMode) -> Error ---

    @(link_name="FT_Set_Pixel_Sizes") SetPixelSizes :: proc(face: Face, pixelWidth, pixelHeight: u32) -> Error ---
    @(link_name="FT_Request_Size")    RequestSize    :: proc(face: Face, req: SizeRequest) -> Error ---
    @(link_name="FT_Select_Size")     SelectSize     :: proc(face: Face, strikeIndex: i32) -> Error ---

    @(link_name="FT_Set_Transform") SetTransform   :: proc(face: Face, _matrix: ^Matrix, delta: ^Vector) ---
    @(link_name="FT_Get_Transform") GetTransform   :: proc(face: Face, _matrix: ^Matrix, delta: ^Vector) ---
}
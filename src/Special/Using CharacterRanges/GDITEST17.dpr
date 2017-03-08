program GDITEST17;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;


// The following example defines three ranges of character positions within a
// string and sets those ranges in a StringFormat object. Next, the
// TGraphics.MeasureCharacterRanges method is used to get the three regions of
// the display that are occupied by the characters that are specified by the
// ranges. This is done for three different layout rectangles to show how the
// regions change according to the layout of the string. Also, on the third
// repetition, the string format flags are changed so that the regions measured
// will include trailing spaces.

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  blackPen: TGPPen;

  blueBrush: TGPSolidBrush;
  redBrush: TGPSolidBrush;

  layoutRect_A: TGPRectF;
  layoutRect_B: TGPRectF;
  layoutRect_C: TGPRectF;

  charRanges: array[0..2] of TCharacterRange;
  myFont: TGPFont;
  strFormat: TGPStringFormat;

  // Other variables
  pCharRangeRegions : array of TGPRegion; // pointer to CharacterRange regions
  i: Integer;                           // loop counter
  count: Integer;                       // number of character ranges set
  string_: string;

begin
  graphics := TGPGraphics.Create(dc);

   // Brushes and pens used for drawing and painting
  blueBrush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 255));
  redBrush:= TGPSolidBrush.Create(MakeColor(100, 255, 0, 0));
  blackPen := TGPPen.Create(MakeColor(255, 0, 0, 0));

   // Layout rectangles used for drawing strings
  layoutRect_A := MakeRect(20.0, 20.0, 130.0, 130.0);
  layoutRect_B := MakeRect(160.0, 20.0, 165.0, 130.0);
  layoutRect_C := MakeRect(335.0, 20.0, 165.0, 130.0);

   // Three different ranges of character positions within the string
   charRanges[0] := MakeCharacterRange(3, 5);
   charRanges[1] := MakeCharacterRange(15, 2);
   charRanges[2] := MakeCharacterRange(30, 15);

   // Font and string format to apply to string when drawing
   myFont := TGPFont.Create('Times New Roman', 16.0);
   strFormat:= TGPStringFormat.Create;

   string_ := 'The quick, brown fox easily jumps over the lazy dog.';

   // Set three ranges of character positions.
   strFormat.SetMeasurableCharacterRanges(3, @charRanges);

   // Get the number of ranges that have been set, and allocate memory to 
   // store the regions that correspond to the ranges.
   count := strFormat.GetMeasurableCharacterRangeCount;
   //pCharRangeRegions = new Region[count];
   SetLength(pCharRangeRegions,count);
   if count > 0 then
   for i := 0 to count-1 do pCharRangeRegions[i] := TGPRegion.Create;


   // Get the regions that correspond to the ranges within the string when
   // layout rectangle A is used. Then draw the string, and show the regions.
   graphics.MeasureCharacterRanges(string_, -1,
      myFont, layoutRect_A, strFormat, count, pCharRangeRegions);
   graphics.DrawString(string_, -1,
      myFont, layoutRect_A, strFormat, blueBrush);
   graphics.DrawRectangle(blackPen, layoutRect_A);
   for  i := 0 to count - 1 do
     graphics.FillRegion(redBrush, pCharRangeRegions[i]);

   // Get the regions that correspond to the ranges within the string when
   // layout rectangle B is used. Then draw the string, and show the regions.
   graphics.MeasureCharacterRanges(string_, -1,
      myFont, layoutRect_B, strFormat, count, pCharRangeRegions);
   graphics.DrawString(string_, -1,
      myFont, layoutRect_B, strFormat, blueBrush);
   graphics.DrawRectangle(blackPen, layoutRect_B);
   for  i := 0 to count - 1 do
      graphics.FillRegion(redBrush, pCharRangeRegions[i]);

   // Get the regions that correspond to the ranges within the string when
   // layout rectangle C is used. Set trailing spaces to be included in the
   // regions. Then draw the string, and show the regions.
   strFormat.SetFormatFlags(Integer(StringFormatFlagsMeasureTrailingSpaces));
   graphics.MeasureCharacterRanges(string_, -1,
      myFont, layoutRect_C, strFormat, count, pCharRangeRegions);
   graphics.DrawString(string_, -1,
      myFont, layoutRect_C, strFormat, blueBrush);
   graphics.DrawRectangle(blackPen, layoutRect_C);
   for  i := 0 to count - 1 do
      graphics.FillRegion(redBrush, pCharRangeRegions[i]);

  if count > 0 then
    for i := 0 to count-1 do pCharRangeRegions[i].Free;
  SetLength(pCharRangeRegions, 0);
  Finalize(pCharRangeRegions);

  graphics.Free;
  blueBrush.free;
  redBrush.Free;
  blackPen.Free;
  myFont.free;
end;



function WndProc(Wnd : HWND; message : UINT; wParam : Integer; lParam: Integer) : Integer; stdcall;
var
  Handle: HDC;
  ps: PAINTSTRUCT;
begin
  case message of
    WM_PAINT:
      begin
        Handle := BeginPaint(Wnd, ps);
        OnPaint(Handle);
        EndPaint(Wnd, ps);
        result := 0;
      end;

    WM_DESTROY:
      begin
        PostQuitMessage(0);
        result := 0;
      end;

   else
      result := DefWindowProc(Wnd, message, wParam, lParam);
   end;
end;

var
  hWnd     : THandle;
  Msg      : TMsg;
  wndClass : TWndClass;
begin
   wndClass.style          := CS_HREDRAW or CS_VREDRAW;
   wndClass.lpfnWndProc    := @WndProc;
   wndClass.cbClsExtra     := 0;
   wndClass.cbWndExtra     := 0;
   wndClass.hInstance      := hInstance;
   wndClass.hIcon          := LoadIcon(0, IDI_APPLICATION);
   wndClass.hCursor        := LoadCursor(0, IDC_ARROW);
   wndClass.hbrBackground  := HBRUSH(GetStockObject(WHITE_BRUSH));
   wndClass.lpszMenuName   := nil;
   wndClass.lpszClassName  := 'GettingStarted';

   RegisterClass(wndClass);

   hWnd := CreateWindow(
      'GettingStarted',       // window class name
      'Using CharacterRanges',// window caption
      WS_OVERLAPPEDWINDOW,    // window style
      Integer(CW_USEDEFAULT), // initial x position
      Integer(CW_USEDEFAULT), // initial y position
      Integer(CW_USEDEFAULT), // initial x size
      Integer(CW_USEDEFAULT), // initial y size
      0,                      // parent window handle
      0,                      // window menu handle
      hInstance,              // program instance handle
      nil);                   // creation parameters

   ShowWindow(hWnd, SW_SHOW);
   UpdateWindow(hWnd);

   while(GetMessage(msg, 0, 0, 0)) do
   begin
      TranslateMessage(msg);
      DispatchMessage(msg);
   end;
end.

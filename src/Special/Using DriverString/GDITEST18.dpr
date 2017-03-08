program GDITEST18;

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
  Pen: TGPPen;
  Font: TGPFont;
  brush: TGPSolidBrush;
  Bound: TGPRECTF;
const positions: array[0..3] of TGPPointF =
  ((x: 100.0; y: 150.0),
   (x: 150.0; y: 200.0),
   (x: 300.0; y: 150.0),
   (x: 150.0; y: 100.0));
begin
  graphics := TGPGraphics.Create(dc);
  brush:= TGPSolidBrush.Create(aclBlack);
  Pen:= TGPPen.Create(brush);
  Font:= TGPFont.Create('Arial',16);

  graphics.MeasureDriverString(PUINT16(StringToOleStr('ABCD')), -1, Font, @positions, DriverStringOptionsCmapLookup, nil, Bound);
  graphics.DrawRectangle(pen,bound);
  graphics.DrawDriverString(PUINT16(StringToOleStr('ABCD')), -1, Font, brush, @positions, DriverStringOptionsCmapLookup, nil);

  brush.Free;
  Font.Free;
  Pen.Free;
  graphics.Free;
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
      'Using DriverString',// window caption
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

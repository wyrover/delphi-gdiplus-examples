program GDITEST48;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;


// One of the properties of the Graphics class is the clipping region.
// All drawing done by a given Graphics object is restricted to the clipping
// region of that Graphics object. You can set the clipping region by
// calling the SetClip method.

// The following example constructs a path that consists of a single polygon.
// Then the code constructs a region based on that path. The address of the
// region is passed to the SetClip method of a Graphics object, and then two
// strings are drawn.

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  path: TGPGraphicsPath;
  region: TGPRegion;
  Pen: TGPPen;
  fontFamily: TGPFontFamily;
  font: TGPFont;
  solidBrush: TGPSolidBrush;
const
  polyPoints : array[0..3] of TGPPoint =
   ((x: 10 ; y: 10 ),
    (x: 150; y: 10 ),
    (x: 100; y: 75 ),
    (x: 100; y: 150));
begin
  graphics := TGPGraphics.Create(DC);
  path:= TGPGraphicsPath.Create;
  path.AddPolygon(PGPPoint(@polyPoints), 4);

  // Construct a region based on the path.
  region := TGPRegion.Create(path);

  // Draw the outline of the region.
  pen:= TGPPen.Create(MakeColor(255, 0, 0, 0));
  graphics.DrawPath(pen, path);

  // Set the clipping region of the Graphics object.
  graphics.SetClip(region);

  // Draw some clipped strings.
  fontFamily:= TGPFontFamily.Create('Arial');
  font:= TGPFont.Create(fontFamily, 36, FontStyleBold, UnitPixel);
  solidBrush:= TGPSolidBrush.Create(MakeColor(255, 255, 0, 0));

  graphics.DrawString('A Clipping Region', 20, font,
    MakePoint(15.0, 25.0), solidBrush);

  graphics.DrawString('A Clipping Region', 20, font,
    MakePoint(15.0, 68.0), solidBrush);

  graphics.Free;
  path.Free;
  region.Free;
  Pen.Free;
  fontFamily.Free;
  font.Free;
  solidBrush.Free;
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
      'Clipping with a Region',       // window caption
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

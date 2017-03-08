program GDITEST81;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

// The following example constructs a path gradient brush from a star-shaped
// path. The code calls the SetCenterColor method to set the color at the
// centroid of the star to red. Then the code calls the SetSurroundColors method
// to specify various colors (stored in the colors array) at the individual
// points in the points array. The final code statement fills the star-shaped
// path with the path gradient brush.

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  path: TGPGraphicsPath;
  pthGrBrush: TGPPathGradientBrush;
  colors: array[0..9] of TGPColor;
  count: Integer;
const
  // Put the points of a polygon in an array.
  points : array[0..9] of TGPPoint =
    ((x: 75 ; y: 0  ), (x: 100; y: 50 ),
     (x: 150; y: 50 ), (x: 112; y: 75 ),
     (x: 150; y: 150), (x: 75 ; y: 100),
     (x: 0  ; y: 150), (x: 37 ; y: 75 ),
     (x: 0  ; y: 50 ), (x: 50 ; y: 50 ));
begin
  graphics := TGPGraphics.Create(DC);

  // Use the array of points to construct a path.
  path:= TGPGraphicsPath.Create;
  path.AddLines(PGPPoint(@points), 10);

  // Use the path to construct a path gradient brush.
  pthGrBrush:= TGPPathGradientBrush.Create(path);

  // Set the color at the center of the path to red.
  pthGrBrush.SetCenterColor(MakeColor(255, 255, 0, 0));

  // Set the colors of the points in the array.
  colors[0] := MakeColor(255, 0, 0, 0);
  colors[1] := MakeColor(255, 0, 255, 0);
  colors[2] := MakeColor(255, 0, 0, 255);
  colors[3] := MakeColor(255, 255, 255, 255);
  colors[4] := MakeColor(255, 0, 0, 0);
  colors[5] := MakeColor(255, 0, 255, 0);
  colors[6] := MakeColor(255, 0, 0, 255);
  colors[7] := MakeColor(255, 255, 255, 255);
  colors[8] := MakeColor(255, 0, 0, 0);
  colors[9] := MakeColor(255, 0, 255, 0);

  count := 10;
  pthGrBrush.SetSurroundColors(@colors, count);

  // Fill the path with the path gradient brush.
  graphics.FillPath(pthGrBrush, path);

  // Gamma correction
  pthGrBrush.SetGammaCorrection(TRUE);
  graphics.TranslateTransform(200.0, 0.0);
  graphics.FillPath(pthGrBrush, path);

  path.Free;
  pthGrBrush.Free;
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
      'Specifying Points on the Boundary',       // window caption
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

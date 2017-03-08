program GDITEST82;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;


// The following example constructs a path gradient brush based on an array of
// points. A color is assigned to each of the five points in the array. If you
// were to connect the five points by straight lines, you would get a five-sided
// polygon. A color is also assigned to the center (centroid) of that polygon —
// in this example, the center (80, 75) is set to white. The final code statement
// in the example fills a rectangle with the path gradient brush.

// The color used to fill the rectangle is white at (80, 75) and changes
// gradually as you move away from (80, 75) toward the points in the array. For
// example, as you move from (80, 75) to (0, 0), the color changes gradually
// from white to red, and as you move from (80, 75) to (160, 0), the color
// changes gradually from white to green.

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  Brush: TGPPathGradientBrush;
  colors: array[0..4] of TGPColor;
  count: Integer;
const
  ptsF: array[0..4] of TGPPointF =
   ((x: 0.0  ; y: 0.0),
    (x: 160.0; y: 0.0),
    (x: 160.0; y: 200.0),
    (x: 80.0 ; y: 150.0),
    (x: 0.0  ; y: 200.0));

begin
  graphics := TGPGraphics.Create(DC);

  // Construct a path gradient brush based on an array of points.
  Brush:= TGPPathGradientBrush.Create(PGPPointF(@ptsF), 5);

  // An array of five points was used to construct the path gradient
  // brush. Set the color of each point in that array.
  colors[0] := MakeColor(255, 255, 0, 0); // (0, 0) red
  colors[1] := MakeColor(255, 0, 255, 0); // (160, 0) green
  colors[2] := MakeColor(255, 0, 255, 0); // (160, 200) green
  colors[3] := MakeColor(255, 0, 0, 255); // (80, 150) blue
  colors[4] := MakeColor(255, 255, 0, 0); // (0, 200) red

  count := 5;
  Brush.SetSurroundColors(@colors, count);

  // Set the center color to white.
  Brush.SetCenterColor(MakeColor(255, 255, 255, 255));

  // Use the path gradient brush to fill a rectangle.
  graphics.FillRectangle(Brush, MakeRect(0, 0, 180, 220));

  Brush.Free;
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

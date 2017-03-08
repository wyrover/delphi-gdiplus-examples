program GDITEST79;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  path: TGPGraphicsPath;
  pthGrBrush: TGPPathGradientBrush;
  num: Integer;
const
  colors: array[0..0] of TGPColor = (aclBlue);
begin
  graphics := TGPGraphics.Create(DC);

  // Create a path that consists of a single ellipse.
  path:= TGPGraphicsPath.Create;
  path.AddEllipse(0, 0, 200, 100);

  // Create a path gradient brush based on the elliptical path.
  pthGrBrush:= TGPPathGradientBrush.Create(path);
  pthGrBrush.SetGammaCorrection(TRUE);

  // Set the color along the entire boundary to blue.
  num := 1;
  pthGrBrush.SetSurroundColors(@colors, num);

  // Set the center color to aqua.
  pthGrBrush.SetCenterColor(aclAqua);

  // Use the path gradient brush to fill the ellipse.
  graphics.FillPath(pthGrBrush, path);

  // Set the focus scales for the path gradient brush.
  pthGrBrush.SetFocusScales(0.3, 0.8);

  // Use the path gradient brush to fill the ellipse again.
  // Show this filled ellipse to the right of the first filled ellipse.
  graphics.TranslateTransform(220.0, 0.0);
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
      'Customizing a Path Gradient',       // window caption
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

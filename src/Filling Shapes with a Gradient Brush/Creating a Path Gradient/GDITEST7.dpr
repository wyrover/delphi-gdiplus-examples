program GDITEST7;

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
  count: Integer;
const
  colors: array[0..0] of TGPColor = (aclAqua);
begin
  graphics := TGPGraphics.Create(DC);

  // Create a path that consists of a single ellipse.
  path:= TGPGraphicsPath.Create;
  path.AddEllipse(0, 0, 140, 70);

  // Use the path to construct a brush.
  pthGrBrush := TGPPathGradientBrush.Create(path);

  // Set the color at the center of the path to blue.
  pthGrBrush.SetCenterColor(MakeColor(255, 0, 0, 255));

  count := 1;
  pthGrBrush.SetSurroundColors(@colors, count);

  graphics.FillEllipse(pthGrBrush, 0, 0, 140, 70);

  // By default, a path gradient brush does not extend outside the boundary of
  // the path. If you use the path gradient brush to fill a shape that extends
  // beyond the boundary of the path, the area of the screen outside the path
  // will not be filled. The following illustration shows what happens if you
  // change the FillEllipse call in the preceding code to
  // graphics.FillRectangle(pthGrBrush, 0, 10, 200, 40);

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
      'Creating a Path Gradient',       // window caption
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

program GDITEST19;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  Rect: TGPRect;
  Pen: TGPPen;
begin
  graphics := TGPGraphics.Create(DC);

  // We start by creating a 50 by 50 rectangle and locating it at the origin
  // (0, 0). The origin is at the upper-left corner of the client area.

  Rect := MakeRect(50, 50, 50, 50);
  Pen := TGPPen.Create(MakeColor(255, 255, 0, 0), 0);
  graphics.DrawRectangle(pen, rect);


  // The following code applies a scaling transformation that expands the
  // rectangle by a factor of 1.75 in the x direction and shrinks the rectangle
  // by a factor of 0.5 in the y direction:

  graphics.ScaleTransform(1.75, 0.5);
  graphics.DrawRectangle(pen, rect);
  graphics.ResetTransform;
  // The result is a rectangle that is longer in the x direction and shorter
  // in the y direction than the original.

  // To rotate the rectangle instead of scaling it, use the following code
  // instead of the preceding code:

  graphics.RotateTransform(28.0);
  graphics.DrawRectangle(pen, rect);
  graphics.ResetTransform;
  //To translate the rectangle, use the following code:

  graphics.TranslateTransform(150.0, 150.0);
  graphics.DrawRectangle(pen, rect);
  graphics.ResetTransform;

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
      'Using the World Transformation',      // window caption
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

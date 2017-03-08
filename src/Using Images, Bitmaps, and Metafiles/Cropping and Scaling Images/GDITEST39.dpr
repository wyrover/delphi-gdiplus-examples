program GDITEST39;

uses
  Classes,
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  Image: TGPImage;
  width, height: UINT;
  destinationRect: TGPRectF;
begin
  graphics := TGPGraphics.Create(DC);
  Image:= TGPImage.Create('..\..\Media\Apple.gif');
  width := image.GetWidth;
  height := image.GetHeight;

  // Make the destination rectangle 30 percent wider and
  // 30 percent taller than the original image.
  // Put the upper-left corner of the destination
  // rectangle at (150, 20).
  destinationRect := MakeRect(150, 20, 1.3 * width, 1.3 * height);

  // Draw the image unaltered with its upper-left corner at (0, 0).
  graphics.DrawImage(image, 0, 0);

  // Draw a portion of the image. Scale that portion of the image
  // so that it fills the destination rectangle.
  graphics.DrawImage(
    image,
    destinationRect,
    0, 0,              // upper-left corner of source rectangle
    0.75 * width,      // width of source rectangle
    0.75 * height,     // height of source rectangle
    UnitPixel);

  Image.Free;  
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
      'Cropping and Scaling Images',       // window caption
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

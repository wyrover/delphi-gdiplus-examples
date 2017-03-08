program GDITEST46;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  image: TGPImage;
  width, height: UINT;
begin
  graphics := TGPGraphics.Create(DC);

  image:= TGPImage.Create('..\..\Media\GrapeBunch.bmp');
  width  := image.GetWidth;
  height := image.GetHeight;

  // Draw the image with no shrinking or stretching.
  graphics.DrawImage(
    image,
    MakeRect(10, 10, width, height),  // destination rectangle
    0, 0,        // upper-left corner of source rectangle
    width,       // width of source rectangle
    height,      // height of source rectangle
    UnitPixel);

  // Shrink the image using low-quality interpolation.
  graphics.SetInterpolationMode(InterpolationModeNearestNeighbor);
  graphics.DrawImage(
    image,
    MakeRect(10, 250, 0.6*width, 0.6*height),  // destination rectangle
    0, 0,        // upper-left corner of source rectangle
    width,       // width of source rectangle
    height,      // height of source rectangle
    UnitPixel);

  // Shrink the image using medium-quality interpolation.
  graphics.SetInterpolationMode(InterpolationModeHighQualityBilinear);
  graphics.DrawImage(
    image,
    MakeRect(150, 250, 0.6 * width, 0.6 * height),  // destination rectangle
    0, 0,        // upper-left corner of source rectangle
    width,       // width of source rectangle
    height,      // height of source rectangle
    UnitPixel);

  // Shrink the image using high-quality interpolation.
  graphics.SetInterpolationMode(InterpolationModeHighQualityBicubic);
  graphics.DrawImage(
    image,
    MakeRect(290, 250, 0.6 * width, 0.6 * height),  // destination rectangle
    0, 0,        // upper-left corner of source rectangle
    width,       // width of source rectangle
    height,      // height of source rectangle
    UnitPixel);

  image.Free;
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
      'Using Interpolation Mode to Control Image Quality During Scaling',      // window caption
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

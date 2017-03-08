program GDITEST11;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ,
  Math;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  Image: TGPImage;
  ImageAttributes: TGPImageAttributes;
  width, height: UINT;
  degrees, r: Single;
  ColorMatrix : TColorMatrix;
begin
  graphics := TGPGraphics.Create(DC);
  Image           := TGPImage.Create('..\..\Media\RotationInput.png');
  ImageAttributes := TGPImageAttributes.Create;
  width           := image.GetWidth();
  height          := image.GetHeight();
  degrees         := 60;
  r               := degrees * pi / 180;  // degrees to radians

  zeromemory(@ColorMatrix, Sizeof(TColorMatrix));
  ColorMatrix[0,0] := cos(r);
  ColorMatrix[1,0] := -sin(r);
  ColorMatrix[0,1] := sin(r);
  ColorMatrix[1,1] := cos(r);
  ColorMatrix[2,2] := 1.0;
  ColorMatrix[3,3] := 1.0;
  ColorMatrix[4,4] := 1.0;


  imageAttributes.SetColorMatrix(
     colorMatrix,
     ColorMatrixFlagsDefault,
     ColorAdjustTypeBitmap);

  graphics.DrawImage(image, 10, 10, width, height);

  graphics.DrawImage(
     image,
     MakeRect(130, 10, width, height),  // destination rectangle
     0, 0,        // upper-left corner of source rectangle
     width,       // width of source rectangle
     height,      // height of source rectangle
     UnitPixel,
     imageAttributes);

  Image.Free;
  ImageAttributes.Free;
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
      'Rotating Colors',      // window caption
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

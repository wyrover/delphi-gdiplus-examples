program GDITEST3;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  Bitmap: TGPBitmap;
  Pen: TGPPen;
  imageAtt: TGPImageAttributes;
  Width, Height: Integer;
const
  // Initialize the color matrix.
  // Notice the value 0.8 in row 4, column 4.
  ColorMatrix: TColorMatrix =
   ((1.0, 0.0, 0.0, 0.0, 0.0),
    (0.0, 1.0, 0.0, 0.0, 0.0),
    (0.0, 0.0, 1.0, 0.0, 0.0),
    (0.0, 0.0, 0.0, 0.8, 0.0),
    (0.0, 0.0, 0.0, 0.0, 1.0));
begin
  graphics := TGPGraphics.Create(DC);

  // Create a Bitmap object and load it with the texture image.
  Bitmap := TGPBitmap.Create('..\..\Media\Texture1.jpg');
  Pen    := TGPPen.Create(MakeColor(255, 0, 0, 0), 25);

  // First draw a wide black line.
  graphics.DrawLine(pen, MakePoint(10, 35), MakePoint(200, 35));

  // Now draw an image that covers part of the black line.
  graphics.DrawImage(bitmap, MakeRect(30, 0, bitmap.GetWidth, bitmap.GetHeight));

  // Create an ImageAttributes object and set its color matrix.
  imageAtt := TGPImageAttributes.Create;
  imageAtt.SetColorMatrix(colorMatrix, ColorMatrixFlagsDefault,
    ColorAdjustTypeBitmap);

  // First draw a wide black line.
  Width  := bitmap.GetWidth;
  Height := bitmap.GetHeight;

  graphics.DrawLine(pen, MakePoint(10, 35 + Height), MakePoint(200, 35 + Height));

  // Now draw the semitransparent bitmap image.
  graphics.DrawImage(
    bitmap,
    MakeRect(30, Height, Width, Height), // Destination rectangle
    0,                                   // Source rectangle X
    0,                                   // Source rectangle Y
    Width,                               // Source rectangle width
    Height,                              // Source rectangle height
    UnitPixel,
    imageAtt);

  imageAtt.Free;
  Bitmap.Free;
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
      'Using a Color Matrix to Set Alpha Values in Images',       // window caption
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

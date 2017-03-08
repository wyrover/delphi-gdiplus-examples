program GDITEST4;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  bitmapGraphics, Graphics : TGPGraphics;
  Bitmap: TGPBitmap;
  redBrush, greenBrush, brush: TGPSolidBrush;
begin

  // Create a blank bitmap.
  Bitmap := TGPBitmap.Create(180, 100, PixelFormat32bppARGB);

  // Create a Graphics object that we can use to draw on the bitmap.
  bitmapGraphics := TGPGraphics.Create(bitmap);

  // Create a red brush and a green brush, each with an alpha value of 160.
  redBrush := TGPSolidBrush.Create(MakeColor(210, 255, 0, 0));
  greenBrush := TGPSolidBrush.Create(MakeColor(210, 0, 255, 0));

  // Set the compositing mode so that when we draw overlapping ellipses,
  // the colors of the ellipses are not blended.
  bitmapGraphics.SetCompositingMode(CompositingModeSourceCopy);

  // Fill an ellipse using a red brush that has an alpha value of 160.
  bitmapGraphics.FillEllipse(redBrush, 0, 0, 150, 70);

  // Fill a second ellipse using green brush that has an alpha value of 160.
  // The green ellipse overlaps the red ellipse, but the green is not
  // blended with the red.
  bitmapGraphics.FillEllipse(greenBrush, 30, 30, 150, 70);

  Graphics := TGPGraphics.Create(DC);

  Graphics.SetCompositingQuality(CompositingQualityGammaCorrected);

  // Draw a multicolored background.
  brush := TGPSolidBrush.Create(aclAqua);
  Graphics.FillRectangle(brush, 200, 0, 60, 100);
  brush.SetColor(aclYellow);
  Graphics.FillRectangle(brush, 260, 0, 60, 100);
  brush.SetColor(aclFuchsia);
  Graphics.FillRectangle(brush, 320, 0, 60, 100);

  // Display the bitmap on a white background.
  Graphics.DrawImage(bitmap, 0, 0);

  // Display the bitmap on a multicolored background.
  Graphics.DrawImage(bitmap, 200, 0);

  bitmapGraphics.Free;
  Bitmap.Free;
  redBrush.Free;
  greenBrush.Free;
  brush.Free;
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
      'Using Compositing Mode to Control Alpha Blending',       // window caption
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

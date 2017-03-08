program GDITEST1;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  Image: TGPImage;
  opaqueBrush, semiTransBrush: TGPSolidBrush;
begin
  graphics := TGPGraphics.Create(DC);

  Image := TGPImage.Create('..\..\Media\Texture1.jpg');
  graphics.DrawImage(image, 50, 50, image.GetWidth(), image.GetHeight());

  opaqueBrush := TGPSolidBrush.Create(MakeColor(255, 0, 0, 255));
  semiTransBrush := TGPSolidBrush.Create(MakeColor(128, 0, 0, 255));

  graphics.FillEllipse(opaqueBrush, 35, 45, 45, 30);
  graphics.FillEllipse(semiTransBrush, 86, 45, 45, 30);

  graphics.SetCompositingQuality(CompositingQualityGammaCorrected);
  graphics.FillEllipse(semiTransBrush, 40, 90, 86, 30);

  Image.Free;
  opaqueBrush.Free;
  semiTransBrush.Free;
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
      'Drawing with Opaque and Semitransparent Brushes',       // window caption
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

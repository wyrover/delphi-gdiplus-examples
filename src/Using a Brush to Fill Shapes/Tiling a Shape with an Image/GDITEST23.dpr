program GDITEST23;

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
  tBrush : TGPTextureBrush;
  blackPen: TGPPen;
begin
  graphics := TGPGraphics.Create(DC);

  Image := TGPImage.Create('..\..\Media\Tile1.gif');
  tBrush := TGPTextureBrush.Create(image);
  blackPen := TGPPen.Create(MakeColor(255, 0, 0, 0));

  tBrush.SetWrapMode(WrapModeTile);
  graphics.FillRectangle(tBrush, MakeRect(0, 0, 200, 200));
  graphics.DrawRectangle(blackPen, MakeRect(0, 0, 200, 200));

  tBrush.SetWrapMode(WrapModeTileFlipX);
  graphics.FillRectangle(tBrush, MakeRect(200, 0, 200, 200));
  graphics.DrawRectangle(blackPen, MakeRect(200, 0, 200, 200));

  tBrush.SetWrapMode(WrapModeTileFlipY);
  graphics.FillRectangle(tBrush, MakeRect(0, 200, 200, 200));
  graphics.DrawRectangle(blackPen, MakeRect(0, 200, 200, 200));

  tBrush.SetWrapMode(WrapModeTileFlipXY);
  graphics.FillRectangle(tBrush, MakeRect(200, 200, 200, 200));
  graphics.DrawRectangle(blackPen, MakeRect(200, 200, 200, 200));

  Image.Free;
  tBrush.Free;
  blackPen.Free;
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
      'Tiling a Shape with an Image',       // window caption
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

program GDITEST68;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  innerContainer, outerContainer: GraphicsContainer;
  brush: TGPSolidBrush;
  FontFamily: TGPFontFamily;
  Font: TGPFont;
begin
  graphics := TGPGraphics.Create(DC);

  brush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 255));
  FontFamily := TGPFontFamily.Create('Times New Roman');
  Font := TGPFont.Create(fontFamily, 36, FontStyleRegular, UnitPixel);

  graphics.SetTextRenderingHint(TextRenderingHintAntiAlias);

  outerContainer := graphics.BeginContainer();

     graphics.SetTextRenderingHint(TextRenderingHintSingleBitPerPixel);

     innerContainer := graphics.BeginContainer();
        graphics.SetTextRenderingHint(TextRenderingHintAntiAlias);
        graphics.DrawString('Inner Container', 15, font,
           MakePoint(20.0, 10.0), brush);
     graphics.EndContainer(innerContainer);

     graphics.DrawString('Outer Container', 15, font, MakePoint(20.0, 50.0), brush);

  graphics.EndContainer(outerContainer);

  graphics.DrawString('Graphics Object', 15, font, MakePoint(20.0, 90.0), brush);

  Font.Free;
  brush.Free;
  FontFamily.Free;
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
      'Several Layers of Nested Containers',      // window caption
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

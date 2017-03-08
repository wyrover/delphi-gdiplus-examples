program GDITEST43;

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
  metafile : TGPMetafile;
  greenPen: TGPPen;
  SolidBrush: TGPSolidBrush;
  FontFamily: TGPFontFamily;
  Font: TGPFont;
  playbackGraphics: TGPGraphics;
begin
  metafile := TGPMetaFile.Create('SampleMetafile.emf', dc);
  graphics := TGPGraphics.Create(metafile);
  greenPen := TGPPen.Create(MakeColor(255, 0, 255, 0));
  SolidBrush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 255));

   // Add a rectangle and an ellipse to the metafile.
   graphics.DrawRectangle(greenPen, MakeRect(50, 10, 25, 75));
   graphics.DrawEllipse(greenPen, MakeRect(100, 10, 25, 75));

   // Add an ellipse (drawn with antialiasing) to the metafile.
   graphics.SetSmoothingMode(SmoothingModeHighQuality);
   graphics.DrawEllipse(greenPen, MakeRect(150, 10, 25, 75));

   // Add some text (drawn with antialiasing) to the metafile.
   FontFamily:= TGPFontFamily.Create('Arial');
   Font:= TGPFont.Create(fontFamily, 24, FontStyleRegular, UnitPixel);

   graphics.SetTextRenderingHint(TextRenderingHintAntiAlias);
   graphics.RotateTransform(30.0);
   graphics.DrawString('Smooth Text', 11, Font,
      MakePoint(50.0, 50.0), solidBrush);
   // End of recording metafile.
  graphics.Free; // free hdc

  // Play back the metafile.
  playbackGraphics:= TGPGraphics.Create(dc);
  playbackGraphics.DrawImage(metafile, 200, 100);

  greenPen.Free;
  SolidBrush.Free;
  FontFamily.Free;
  Font.Free;
  metafile.Free;
  playbackGraphics.Free;
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
      'Recording Metafiles',       // window caption
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

program GDITEST55;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;


Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  infoString: String;       // enough space for one line of output
  ascent: UINT;             // font family ascent in design units
  ascentPixel: Single;      // ascent converted to pixels
  descent: UINT;            // font family descent in design units
  descentPixel: Single;     // descent converted to pixels
  lineSpacing: UINT;        // font family line spacing in design units
  lineSpacingPixel: Single; // line spacing converted to pixels

  fontFamily: TGPFontFamily;
  font: TGPFont;
  pointF: TGPPointF;
  solidBrush: TGPSolidBrush;
begin
  graphics := TGPGraphics.Create(DC);
  fontFamily:= TGPFontFamily.Create('Arial');
  font:= TGPFont.Create(fontFamily, 16, FontStyleRegular, UnitPixel);
  pointF:= MakePoint(10.0, 10.0);
  solidBrush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 0));

  // Display the font size in pixels.
  infoString := format('font.GetSize returns %f.', [font.GetSize]);
  graphics.DrawString(infoString, Length(infoString), font, pointF, solidBrush);

  // Move down one line.
  pointF.Y := pointF.Y + font.GetHeight(0.0);

  // Display the font family em height in design units.
  infoString := format('fontFamily.GetEmHeight returns %d.',
    [fontFamily.GetEmHeight(FontStyleRegular)]);
  graphics.DrawString(infoString, -1, font, pointF, solidBrush);

  // Move down two lines.
  pointF.Y := pointF.Y + 2.0 * font.GetHeight(0.0);

  // Display the ascent in design units and pixels.
  ascent := fontFamily.GetCellAscent(FontStyleRegular);

  // 14.484375 = 16.0 * 1854 / 2048
  ascentPixel := font.GetSize * ascent / fontFamily.GetEmHeight(FontStyleRegular);
  infoString := format('The ascent is %d design units, %f pixels.', [ascent, ascentPixel]);
  graphics.DrawString(infoString, -1, font, pointF, solidBrush);

  // Move down one line.
  pointF.Y := pointF.Y + font.GetHeight(0.0);

  // Display the descent in design units and pixels.
  descent := fontFamily.GetCellDescent(FontStyleRegular);

  // 3.390625 = 16.0 * 434 / 2048
  descentPixel := font.GetSize * descent / fontFamily.GetEmHeight(FontStyleRegular);
  infoString := format('The descent is %d design units, %f pixels.', [descent, descentPixel]);
  graphics.DrawString(infoString, -1, font, pointF, solidBrush);

  // Move down one line.
  pointF.Y := pointF.Y + font.GetHeight(0.0);

  // Display the line spacing in design units and pixels.
  lineSpacing := fontFamily.GetLineSpacing(FontStyleRegular);

  // 18.398438 = 16.0 * 2355 / 2048
  lineSpacingPixel := font.GetSize * lineSpacing / fontFamily.GetEmHeight(FontStyleRegular);
  infoString := format('The line spacing is %d design units, %f pixels.',
    [lineSpacing, lineSpacingPixel]);
  graphics.DrawString(infoString, -1, font, pointF, solidBrush);

  fontFamily.Free;
  font.Free;
  solidBrush.Free;
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
      'Obtaining Font Metrics',       // window caption
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

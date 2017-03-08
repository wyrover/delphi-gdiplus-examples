program GDITEST51;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;

  pointF: TGPPointF;
  solidBrush: TGPSolidBrush;

  count: Integer;
  found: Integer;
  familyName: String;
  familyNameAndStyle: String;
  pFontFamily: array of TGPFontFamily;
  privateFontCollection: TGPPrivateFontCollection;

  j: Integer;
  Font: TGPFont;
begin
  graphics := TGPGraphics.Create(DC);

  PointF := MakePoint(10.0, 0.0);
  solidBrush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 0));

  found := 0;
  privateFontCollection := TGPPrivateFontCollection.Create;

  // Add three font files to the private collection.
  privateFontCollection.AddFontFile('c:\Windows\Fonts\Arial.ttf');
  privateFontCollection.AddFontFile('c:\Windows\Fonts\CourBI.ttf');
  privateFontCollection.AddFontFile('c:\Windows\Fonts\TimesBd.ttf');

  // How many font families are in the private collection?
  count := privateFontCollection.GetFamilyCount;

  // Allocate a buffer to hold the array of FontFamily
  // objects returned by GetFamilies.
  SetLength(pFontFamily, count);
  for j := 0 to count - 1 do
    pFontFamily[j] := TGPFontFamily.Create;

  // Get the array of FontFamily objects.
  privateFontCollection.GetFamilies(count, pFontFamily, found);

  // Display the name of each font family in the private collection
  // along with the available styles for that font family.
  for j := 0 to count - 1 do
  begin
    // Get the font family name.
    pFontFamily[j].GetFamilyName(familyName);

    // Is the regular style available?
    if (pFontFamily[j].IsStyleAvailable(FontStyleRegular)) then
    begin
      familyNameAndStyle := familyName + ' Regular';
      Font:= TGPFont.Create(familyName, 16, FontStyleRegular, UnitPixel, privateFontCollection);
      graphics.DrawString(familyNameAndStyle, -1, Font, pointF, solidBrush);
      pointF.Y := pointF.Y + Font.GetHeight(0.0);
      Font.Free;
    end;

    // Is the bold style available?
    if(pFontFamily[j].IsStyleAvailable(FontStyleBold)) then
    begin
      familyNameAndStyle := familyName + ' Bold';
      Font := TGPFont.Create(familyName, 16, FontStyleBold, UnitPixel, privateFontCollection);
      graphics.DrawString(familyNameAndStyle, -1, Font, pointF, solidBrush);
      pointF.Y := pointF.Y + Font.GetHeight(0.0);
      Font.Free;
    end;

    // Is the italic style available?
    if(pFontFamily[j].IsStyleAvailable(FontStyleItalic)) then
    begin
      familyNameAndStyle := familyName + ' Italic';
      Font := TGPFont.Create(familyName, 16, FontStyleItalic, UnitPixel, privateFontCollection);
      graphics.DrawString(familyNameAndStyle, -1, Font, pointF, solidBrush);
      pointF.Y := pointF.Y + Font.GetHeight(0.0);
      Font.Free;
    end;

    // Is the bold italic style available?
    if(pFontFamily[j].IsStyleAvailable(FontStyleBoldItalic)) then
    begin
      familyNameAndStyle := familyName + ' BoldItalic';
      Font := TGPFont.Create(familyName, 16, FontStyleBoldItalic, UnitPixel, privateFontCollection);
      graphics.DrawString(familyNameAndStyle, -1, Font, pointF, solidBrush);
      pointF.Y := pointF.Y + Font.GetHeight(0.0);
      Font.Free;
    end;

    // Is the underline style available?
    if(pFontFamily[j].IsStyleAvailable(FontStyleUnderline)) then
    begin
      familyNameAndStyle := familyName + ' Underline';
      Font := TGPFont.Create(familyName, 16, FontStyleUnderline, UnitPixel, privateFontCollection);
      graphics.DrawString(familyNameAndStyle, -1, Font, pointF, solidBrush);
      pointF.Y := pointF.Y + Font.GetHeight(0.0);
      Font.Free;
    end;

   // Is the strikeout style available?
    if(pFontFamily[j].IsStyleAvailable(FontStyleStrikeout)) then
    begin
      familyNameAndStyle := familyName + ' Strikeout';
      Font := TGPFont.Create(familyName, 16, FontStyleStrikeout, UnitPixel, privateFontCollection);
      graphics.DrawString(familyNameAndStyle, -1, Font, pointF, solidBrush);
      pointF.Y := pointF.Y + Font.GetHeight(0.0);
      Font.Free;
    end;

    // Separate the families with white space.
    pointF.Y := pointF.Y + 10.0;
  end;
  for j := 0 to count - 1 do
    pFontFamily[j].Free;
  Finalize(pFontFamily);

  solidBrush.Free;
  privateFontCollection.Free;
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
      'Creating a Private Font Collection',       // window caption
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

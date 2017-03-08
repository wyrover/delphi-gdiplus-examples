program GDITEST53;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;


Procedure OnPaint(DC: HDC);
var
  i: Integer;
  graphics : TGPGraphics;

  fontFamily: TGPFontFamily;
  font: TGPFont;
  rectF: TGPRectF;
  solidBrush: TGPSolidBrush;

  count: Integer;
  found: Integer;
  familyName: String;
  familyList: string;
  pFontFamily: array of TGPFontFamily;

  installedFontCollection: TGPInstalledFontCollection ;
begin
  graphics := TGPGraphics.Create(DC);

  fontFamily:= TGPFontFamily.Create('Arial');
  font:= TGPFont.Create(fontFamily, 10, FontStyleRegular, UnitPoint);;
  rectF:= MakeRect(10.0, 10.0, 500.0, 500.0);
  solidBrush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 0));

  found:= 0;

  InstalledFontCollection := TGPinstalledFontCollection.Create;

  // How many font families are installed?
  count := installedFontCollection.GetFamilyCount;

  // Allocate a buffer to hold the array of FontFamily
  // objects returned by GetFamilies.
  setLength(pFontFamily, count);
  for i := 0 to count - 1 do
    pFontFamily[i] := TGPFontFamily.Create;

  // Get the array of FontFamily objects.
  installedFontCollection.GetFamilies(count, pFontFamily, found);

  // The loop below creates a large string that is a comma-separated
  // list of all font family names.

  for i := 0 to count - 1 do
  begin
   pFontFamily[i].GetFamilyName(familyName);
   familyList := familyList + familyName + ', ';
   pFontFamily[i].Free;
  end;

  // Draw the large string (list of all families) in a rectangle.
  graphics.DrawString(familyList, -1, font, rectF, nil, solidBrush);


  Finalize(pFontFamily);
  fontFamily.Free;
  font.Free;
  solidBrush.Free;
  installedFontCollection.Free;
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
      'Enumerating Installed Fonts',       // window caption
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

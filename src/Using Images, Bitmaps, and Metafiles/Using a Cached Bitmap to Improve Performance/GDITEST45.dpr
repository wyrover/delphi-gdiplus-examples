program GDITEST45;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  bitmap   : TGPBitmap;
  Font: TGPFont;
  Brush: TGPSolidBrush;
  width, height: Integer;
  cBitmap: TGPCachedBitmap;
  j: integer;
  T1, T2: TDateTime;
  h,m,s, ms: word;
begin
  graphics := TGPGraphics.Create(DC);

  bitmap := TGPBitmap.Create('..\..\Media\Fruit.JPG');
  width  := bitmap.GetWidth;
  height := bitmap.GetHeight;
  cBitmap:= TGPCachedBitmap.Create(bitmap, graphics);
  Font:= TGPFont.Create('Arial',16);
  Brush:= TGPSolidBrush.Create(aclBlack);

  j := 0;
  T1 := now;
  While j < 300 do
  begin
    graphics.DrawImage(bitmap, j, j div 2, width, height);
    inc(j,10)
  end;
  T2 := now;
  DecodeTime(T2-T1,h,m,s,ms);
  graphics.DrawString(IntTostr(s) +':'+ IntTostr(ms),-1,Font,MakePoint(j+width,(j/2)),Brush);

  j := 0;
  T1 := now;
  While j < 300 do
  begin
    graphics.DrawCachedBitmap(cBitmap, j, 150 + j div 2 );
    inc(j,10);
  end;
  T2 := now;
  DecodeTime(T2-T1,h,m,s,ms);
  graphics.DrawString(IntTostr(s) +':'+ IntTostr(ms),-1,Font,MakePoint(j+width,(j/2)+150),Brush);

  Brush.Free;
  Font.Free;
  graphics.Free;
  bitmap.Free;
  cBitmap.Free;
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
      'Using a Cached Bitmap to Improve Performance',       // window caption
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

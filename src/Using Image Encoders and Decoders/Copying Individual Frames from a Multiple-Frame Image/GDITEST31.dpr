program GDITEST31;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ,
  GDIPUTIL;

Procedure OnPaint(DC: HDC);
var
  pageGuid: TGUID;
  encoderClsid: TGUID;
  multi: TGPImage;
  graphic: TGPgraphics;
begin
  graphic:= TGPgraphics.Create(dc);

  pageGuid := FrameDimensionPage;
  multi := TGPImage.Create('..\..\Media\Multiframe.tif');

  // Get the CLSID of the PNG encoder.
  GetEncoderClsid('image/png', encoderClsid);

  // Display and save the first page (index 0).
  multi.SelectActiveFrame(pageGuid, 0);
  graphic.DrawImage(multi, 10, 10);
  multi.Save('Page0.png', encoderClsid, nil);

  // Display and save the second page.
  multi.SelectActiveFrame(pageGuid, 1);
  graphic.DrawImage(multi, 220, 10);
  multi.Save('Page1.png', encoderClsid, nil);

  // Display and save the third page.
  multi.SelectActiveFrame(pageGuid, 2);
  graphic.DrawImage(multi, 10, 240);
  multi.Save('Page2.png', encoderClsid, nil);

  // Display and save the fourth page.
  multi.SelectActiveFrame(pageGuid, 3);
  graphic.DrawImage(multi, 220, 150);
  multi.Save('Page3.png', encoderClsid, nil);

  multi.Free;
  graphic.Free;
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
      'Copying Individual Frames from a Multiple-Frame Image',       // window caption
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

program GDITEST16;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

function metaCallback(recordType  : TEmfPlusRecordType;
                       flags       : UINT;
                       dataSize    : UINT;
                       data        : PBYTE;
                       callbackData: pointer
                       ): BOOL; stdcall;
begin
   // Play only EmfPlusRecordTypeFillEllipse records.
   if (recordType = EmfPlusRecordTypeFillEllipse) then
   begin
   // Explicitly cast callbackData as a metafile pointer, and use it to call
   // the PlayRecord method.
     TGPMetafile(callbackData).PlayRecord(recordType, flags, dataSize, Data);
   end;
   result := TRUE;
end;


Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  pMeta: TGPMetafile;
  metaGraphics: TGPGraphics;
  blackBrush: TGPSolidBrush;
  redBrush: TGPSolidBrush;
begin
  graphics := TGPGraphics.Create(DC);
  // Create a Metafile object from an existing disk metafile.
  pMeta := TGPMetaFile.Create('..\..\Media\SampleMetafile.emf');
    // Fill a rectangle and an ellipse in pMeta.
    metaGraphics := TGPGraphics.Create(pMeta);
    blackBrush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 0));
    redBrush:= TGPSolidBrush.Create(MakeColor(255, 255, 0, 0));
    metaGraphics.FillRectangle(blackBrush, 0, 0, 100, 100);
    metaGraphics.FillEllipse(redBrush, 100, 0, 200, 100);

  // Enumerate pMeta, passing pMeta as the callback data.
  graphics.EnumerateMetafile(pMeta, MakePoint(0, 0), metaCallback, pMeta);
  graphics.DrawImage(pMeta, MakePoint(0, 150));

  pMeta.free;
  metaGraphics.free;
  blackBrush.free;
  redBrush.free;
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
      'EnumerateMetafile',       // window caption
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

program GDITEST67;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  GContainer: GraphicsContainer;
  redPen, bluePen : TGPPen;
  aquaBrush, greenBrush : TGPSolidBrush;
  path: TGPGraphicsPath;
  Region: TGPRegion;
begin
  graphics := TGPGraphics.Create(DC);

  redPen     := TGPPen.Create(MakeColor(255, 255, 0, 0), 2);
  bluePen    := TGPPen.Create(MakeColor(255, 0, 0, 255), 2);
  aquaBrush  := TGPSolidBrush.Create(MakeColor(255, 180, 255, 255));
  greenBrush := TGPSolidBrush.Create(MakeColor(255, 150, 250, 130));

  graphics.SetClip(MakeRect(50, 65, 150, 120));
  graphics.FillRectangle(aquaBrush, 50, 65, 150, 120);

  GContainer := graphics.BeginContainer();
     // Create a path that consists of a single ellipse.
     path := TGPGraphicsPath.Create;
     path.AddEllipse(75, 50, 100, 150);

    // Construct a region based on the path.
     Region := TGPRegion.Create(path);
     graphics.FillRegion(greenBrush, region);

     graphics.SetClip(region);
     graphics.DrawLine(redPen, 50, 0, 350, 300);
  graphics.EndContainer(GContainer);

  graphics.DrawLine(bluePen, 70, 0, 370, 300);

  redPen.Free;
  bluePen.Free;
  aquaBrush.Free;
  greenBrush.Free;
  path.Free;
  Region.Free;
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
      'Clipping in Nested Containers',      // window caption
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

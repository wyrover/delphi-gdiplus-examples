program GDITEST5;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  Pen : TGPPen;
  path : TGPGraphicsPath;
  brush: TGPSolidBrush;
const
  points : array[0..2] of TGPPoint =
    ((x: 40; y: 60),
     (x: 50; y: 70),
     (x: 30; y: 90));
begin
  graphics := TGPGraphics.Create(DC);

  // To create a path, construct a GraphicsPath object, and then call methods,
  // such as AddLine and AddCurve, to add primitives to the path.

  // The following example creates a path that has a single arc. The arc has a
  // sweep angle of –180 degrees, which is counterclockwise in the default
  // coordinate system.

    Pen := TGPPen.Create(MakeColor(255, 255, 0, 0));
    path := TGPGraphicsPath.Create;
    path.AddArc(175, 50, 50, 50, 0, -180);
    graphics.DrawPath(pen, path);

  // The following example creates a path that has two figures. The first figure
  // is an arc followed by a line. The second figure is a line followed by a
  // curve, followed by a line. The first figure is left open, and the second
  // figure is closed.

    Pen.SetWidth(2);

    // The first figure is started automatically, so there is
    // no need to call StartFigure here.
    path.Reset;
    path.AddArc(175, 50, 50, 50, 0.0, -180.0);
    path.AddLine(100, 0, 250, 20);

    path.StartFigure();
    path.AddLine(50, 20, 5, 90);
    path.AddCurve(PGPPoint(@points), 3);
    path.AddLine(50, 150, 150, 180);
    path.CloseFigure();

    graphics.DrawPath(pen, path);

  // In addition to adding lines and curves to paths, you can add closed shapes:
  // rectangles, ellipses, pies, and polygons. The following example creates a
  // path that has two lines, a rectangle, and an ellipse. The code uses a pen
  // to draw the path and a brush to fill the path.

    brush := TGPSolidBrush.Create(MakeColor(255, 0, 0, 200));
    path.Reset;
    path.AddLine(210, 210, 300, 240);
    path.AddLine(300, 260, 230, 260);
    path.AddRectangle(MakeRect(250, 235, 20, 40));
    path.AddEllipse(210, 275, 40, 30);

    graphics.DrawPath(pen, path);
    graphics.FillPath(brush, path);

  // The path in the preceding example has three figures. The first figure
  // consists of the two lines, the second figure consists of the rectangle,
  // and the third figure consists of the ellipse. Even when there are no calls
  // to CloseFigure or StartFigure, intrinsically closed shapes, such as
  // rectangles and ellipses, are considered separate figures.

  Pen.Free;
  path.Free;
  brush.Free;
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
      'Creating Figures from Lines, Curves, and Shapes',       // window caption
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

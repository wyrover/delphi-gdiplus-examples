program GDITEST10;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  GDIPAPI,
  GDIPOBJ;

var
  hdcPrint: HDC;
  docInfo: TDOCINFO;
  graphics: TGPGraphics;
  Pen: TGPPen;
begin
   // Get a device context for the printer.
   hdcPrint := CreateDC(nil, PChar('Canon Bubble-Jet BJ-10e'), nil, nil);

   ZeroMemory(@docInfo, sizeof(DOCINFO));
   docInfo.cbSize := sizeof(DOCINFO);
   docInfo.lpszDocName := 'GdiplusPrint';

   StartDoc(hdcPrint, docInfo);
   StartPage(hdcPrint);
      graphics := TGPGraphics.Create(hdcPrint);
      pen := TGPPen.Create(MakeColor(255, 0, 0, 0));
      graphics.DrawLine(pen, 50, 50, 350, 550);
      graphics.DrawRectangle(pen, 50, 50, 300, 500);
      graphics.DrawEllipse(pen, 50, 50, 300, 500);
      pen.Free;
      graphics.Free;
   EndPage(hdcPrint);
   EndDoc(hdcPrint);

   DeleteDC(hdcPrint);

end.

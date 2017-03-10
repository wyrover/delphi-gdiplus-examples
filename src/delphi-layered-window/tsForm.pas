//一句（关键）代码实现全透明 by diystar.cnblogs.com
//改进版0.2：减少拖动闪烁
//改进版0.3：改进Win7兼容性
//改进版0.4：提高性能
//改进版0.5：完美版，进一步提高性能，彻底解决Win7兼容性
//改进版0.6：gdi+版，果然强大易用，压轴！与前面版本虽形式不同，内里是一致的
//0.6版 主要贡献者 Aric Green http://www.codeproject.com/KB/GDI-plus/DesktopLyrics.aspx
//以及 无幻 http://blog.csdn.net/akof1314/archive/2011/05/18/6430583.aspx
//期待你的改进，别忘了发我一份wang_zm@163.com

unit tsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, ExtCtrls, gdipapi, gdipobj;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure UpdateDisplay(r: TRect);
    procedure ShadowText(Bk: TGPGraphics; f: TGPFont; c, Shadow: TGPColor; l, t, w, h: Single; Text: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  hdcScreen, m_hdcMemory: HDC;
  g: TGPGraphics;

procedure TForm1.FormCreate(Sender: TObject);
var
  hdcTemp: HDC;
  hBitMap: Windows.HBITMAP;
begin
  Self.BorderStyle := bsNone;
  SetWindowLong(Self.Handle, GWL_EXSTYLE, GetWindowLong(Self.Handle, GWL_EXSTYLE) or WS_EX_LAYERED); //层次窗口

  hdcTemp := GetDC(Self.Handle);
  m_hdcMemory := CreateCompatibleDC(hdcTemp);
  hBitMap := CreateCompatibleBitmap(hdcTemp, ClientWidth, ClientHeight);
  SelectObject(m_hdcMemory, hBitMap);
  hdcScreen := GetDC(Self.Handle);
  g := TGPGraphics.Create(m_hdcMemory);
  if Win32MajorVersion > 5 then
    g.SetTextRenderingHint(TextRenderingHintAntiAliasGridFit);
  ReleaseDC(Self.Handle, hdcTemp);
  DeleteObject(hBitMap);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ReleaseDC(Self.Handle, hdcScreen);
  DeleteDC(m_hdcMemory);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Self.Refresh;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  UpdateDisplay(ClientRect);
end;

procedure TForm1.UpdateDisplay(r: TRect);
var
  brush: TGPSolidBrush;
  pen: TGPPen;
  f: TGPFont;
  GPRectF: TGPRectF;
  r2: TRect;
  blend: BLENDFUNCTION;
  ptWinPos, ptSrc: TPoint;
  sizeWindow: SIZE;
begin
  //处理边框和文字
  g.SetCompositingMode(CompositingModeSourceCopy);
  brush := TGPSolidBrush.Create(MakeColor(1, 255, 255, 255));
  g.SetClip(MakeRect(r));
  g.FillRectangle(brush, MakeRect(r));
  g.SetCompositingMode(CompositingModeSourceOver);

  r2 := ClientRect;
  r2.Bottom := r2.Bottom - 1;
  r2.Right := r2.Right - 1;
  pen := TGPPen.Create(MakeColor(64, 0, 0, 0), 1);
  g.DrawRectangle(pen, MakeRect(r2));
  InflateRect(r2, -1, -1);
  pen.SetColor(MakeColor(96, 255, 255, 255));
  g.DrawRectangle(pen, MakeRect(r2));

  f := TGPFont.Create(Self.Font.Name, Self.Font.Size);
  GPRectF := MakeRect(0.0, 0, ClientWidth, ClientHeight);
  g.MeasureString('透明之窗', -1, f, GPRectF, GPRectF);
  ShadowText(g, f, MakeColor(254, 255, 255, 255), MakeColor(58, 0, 0, 0), 10, 10, GPRectF.Width, GPRectF.Height, '透明之窗');

  brush.Free;
  pen.Free;
  f.Free;
  //

  with blend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    AlphaFormat := AC_SRC_ALPHA;
    SourceConstantAlpha := 255;
  end;
  ptWinPos := Point(Self.Left, Self.Top);
  sizeWindow.cx := ClientWidth;
  sizeWindow.cy := ClientHeight;
  ptSrc := Point(0, 0);

  //关键的一句
  UpdateLayeredWindow(Self.Handle, hdcScreen, @ptWinPos, @sizeWindow, m_hdcMemory, @ptSrc, 0, @blend, ULW_ALPHA);
end;

procedure TForm1.ShadowText(Bk: TGPGraphics; f: TGPFont; c, Shadow: TGPColor; l, t, w, h: Single; Text: string);
var
  strFormat: TGPStringFormat;
  brush: TGPSolidBrush;
  pen: TGPPen;
  i, j: Single;

  procedure DrawText;
  begin
    g.DrawString(Text, -1, f, MakeRect(i, j, w, h), strFormat, brush);
  end;

begin
  strFormat := TGPStringFormat.Create();
  brush := TGPSolidBrush.Create(Shadow);
  pen := TGPPen.Create(Shadow);

  i := l + 1;
  j := t + 1;
  DrawText;
  i := l - 1;
  j := t - 1;
  DrawText;
  i := l + 1;
  j := t - 1;
  DrawText;
  i := l - 1;
  j := t + 1;
  DrawText;
  i := l;
  j := t + 1;
  DrawText;
  i := l;
  j := t - 1;
  DrawText;
  i := l + 1;
  j := t;
  DrawText;
  i := l - 1;
  j := t;
  DrawText;

  brush.SetColor(c);
  pen.SetColor(c);
  i := l;
  j := t;
  DrawText;

  strFormat.Free;
  brush.Free;
  pen.Free;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $f017, 0);
end;

end.


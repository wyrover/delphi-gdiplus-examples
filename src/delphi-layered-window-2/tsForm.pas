//一句（关键）代码实现全透明 by diystar.cnblogs.com
//改进版0.2：减少拖动闪烁
//改进版0.3：改进Win7兼容性
//改进版0.4：提高性能
//改进版0.5：完美版，进一步提高性能，彻底解决Win7兼容性
//改进版0.6：gdi+版，果然强大易用，压轴！与前面版本虽形式不同，内里是一致的
             {0.6版 主要贡献者 Aric Green http://www.codeproject.com/KB/GDI-plus/DesktopLyrics.aspx
             以及 无幻 http://blog.csdn.net/akof1314/archive/2011/05/18/6430583.aspx}
//改进版0.7：修正内存泄漏问题（更换为IGDI+即可解决，但编译体积较大）
//期待你的改进，别忘了发我一份wang_zm@163.com


//Transparen Form Code, by diystar.cnblogs.com
//Improved version 0.2: to reduce the drag flicker
//Improved version 0.3: improved compatibility Win7
//Improved version 0.4: improving performance
//Improved version 0.5: a perfect version, to further improve performance, solve the compatibility Win7
//Improved version 0.6: gdi+ version, the finale! Although different forms of the previous version, and there is the same
                        {the main contributors: Aric Green http://www.codeproject.com/KB/GDI-plus/DesktopLyrics.aspx
                        and Wuhuan http://blog.csdn.net/akof1314/archive/2011/05/18/6430583.aspx}
//Improved version 0.7: fixed memory leaks (replaced with IGDI+ can be resolved, but compile larger)
//Look forward to your improvements, do not forget to send to wang_zm@163.com


unit tsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, ExtCtrls, IGDIPlus;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure InitBg;
    procedure UpdateDisplay(r: TRect);
    procedure ShadowText(Bk: IGPGraphics; f: IGPFont; c, Shadow: TGPColor; l, t, w, h: Single; Text: string);
    procedure SetFont;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  hdcScreen, m_hdcMemory: HDC;
  g: IGPGraphics;
  iscn: Boolean;
  Fon: Integer;

procedure TForm1.FormCreate(Sender: TObject);
var
  IdiomaID: LangID;
begin
  Self.BorderStyle := bsNone;
  IdiomaID := GetSystemDefaultLangID;
  iscn := (IdiomaID = $0804) or (IdiomaID = $1004);
  if iscn then
    SetFont;

  SetWindowLong(Self.Handle, GWL_EXSTYLE, GetWindowLong(Self.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  hdcScreen := GetDC(Self.Handle);
  InitBg;
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

procedure TForm1.InitBg;
var
  hdcTemp: HDC;
  hBitMap: Windows.HBITMAP;
begin
  hdcTemp := GetDC(Self.Handle);
  m_hdcMemory := CreateCompatibleDC(hdcTemp);
  hBitMap := CreateCompatibleBitmap(hdcTemp, ClientWidth, ClientHeight);
  SelectObject(m_hdcMemory, hBitMap);
  g := TGPGraphics.Create(m_hdcMemory);
  g.SetTextRenderingHint(TextRenderingHintAntiAliasGridFit);
  ReleaseDC(Self.Handle, hdcTemp);
  DeleteObject(hBitMap);
end;

procedure TForm1.UpdateDisplay(r: TRect);
var
  brush: IGPSolidBrush;
  pen: IGPPen;
  f: IGPFont;
  GPRectF: TGPRectF;
  r2: TRect;
  blend: BLENDFUNCTION;
  ptWinPos, ptSrc: TPoint;
  sizeWindow: SIZE;
  s: string;
begin
  g.SetCompositingMode(CompositingModeSourceCopy);
  brush := TGPSolidBrush.Create(MakeColor(1, 255, 255, 255));
  g.SetClip(MakeRect(r));
  g.FillRectangle(brush, MakeRect(r));

  //处理边框和文字 Dealing with borders and text
  g.SetCompositingMode(CompositingModeSourceOver);
  r2 := ClientRect;
  r2.Bottom := r2.Bottom - 1;
  r2.Right := r2.Right - 1;
  pen := TGPPen.Create(MakeColor(64, 0, 0, 0), 1);
  g.DrawRectangle(pen, MakeRect(r2));
  InflateRect(r2, -1, -1);
  pen.SetColor(MakeColor(96, 255, 255, 255));
  g.DrawRectangle(pen, MakeRect(r2));

  if iscn then
    s := '透明之窗'
  else
    s := 'Transparent Window';
  f := TGPFont.Create(Self.Canvas.Handle);
  GPRectF := MakeRectF(0, 0, ClientWidth, ClientHeight);
  GPRectF := g.MeasureStringF(s, f, GPRectF);
  ShadowText(g, f, MakeColor(254, 255, 255, 255), MakeColor(58, 0, 0, 0), 10, 10, GPRectF.Width, GPRectF.Height, s);
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

  //关键的一句 A key line of code
  UpdateLayeredWindow(Self.Handle, hdcScreen, @ptWinPos, @sizeWindow, m_hdcMemory, @ptSrc, 0, @blend, ULW_ALPHA);
end;

procedure TForm1.ShadowText(Bk: IGPGraphics; f: IGPFont; c, Shadow: TGPColor; l, t, w, h: Single; Text: string);
var
  strFormat: IGPStringFormat;
  brush: IGPSolidBrush;
  pen: IGPPen;
  i, j: Single;
  b: Boolean;

  procedure DrawText;
  begin
    g.DrawStringF(Text, f, MakeRectF(i, j, w, h), strFormat, brush);
  end;

begin
  strFormat := TGPStringFormat.Create();
  brush := TGPSolidBrush.Create(Shadow);
  pen := TGPPen.Create(Shadow);
  b := (Fon = 2);

  if b then
    brush.SetColor(MakeColor(68, 0, 0, 0));
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
  if b then
  begin
    brush.SetColor(MakeColor(32, 255, 255, 255));
    DrawText;
  end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $f017, 0);
end;

procedure TForm1.SetFont;
var
  sz: array[0..255] of WideChar;
  s: string;
begin
  Self.Font.Height := -12;
  GetWindowsDirectory(@sz, 256);
  s := StrPas(sz) + '\Fonts\';

  if Win32MajorVersion < 6 then
  begin
    if FileExists(s + 'simsun.ttc') then
    begin
      Self.Font.Name := 'SimSun';
      Fon := 1;
    end;
  end
  else if FileExists(s + 'msyh.ttf') then
  begin
    Self.Font.Name := 'Microsoft YaHei';
    Fon := 2;
  end;
end;

end.


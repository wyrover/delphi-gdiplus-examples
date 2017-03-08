unit fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  GDIPAPI, GDIPOBJ, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    tmr1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    flag: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Self.flag := -1;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //ShowMessage(IntToHex(Key, 2));
  case Key of
    $31: Self.flag := 1;
    $32: Self.flag := 2;
    $33: Self.flag := 3;
    $34: Self.flag := 4;
    $35: Self.flag := 5;
    $36: Self.flag := 6;
    $37: Self.flag := 7;
    $38: Self.flag := 8;
  end;

  Self.FormPaint(nil);

  //ShowMessage(IntToStr(Self.flag));
  if Key = VK_ESCAPE then
    Self.Close;


end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  g: TGPGraphics;
  hBrush: TGPHatchBrush;
  pen: TGPPen;
  linGrBrush: TGPLinearGradientBrush;
begin
  g := TGPGraphics.Create(Self.Canvas.Handle);
  try
    case Self.flag of
      1:
         g.Clear(MakeColor(255, 0, 0, 0));
      2:

         g.Clear(MakeColor(255, 255, 255, 255));
      3:
        g.Clear(MakeColor(255, 255, 0, 0));
      4:
        g.Clear(MakeColor(255, 0, 255, 0));
      5:
        g.Clear(MakeColor(255, 0, 0, 255));
      6:
        begin
           hBrush := TGPHatchBrush.Create(HatchStyleLightHorizontal, MakeColor(255, 255, 0, 0),
            MakeColor(255, 128, 255, 255));
            g.FillRectangle(hBrush, 0, 0, Self.Width, Self.Height);
            if hBrush <> nil then
            begin
             hBrush.Free;
             hBrush := nil;
            end;
        end;
      7:
        begin
           hBrush := TGPHatchBrush.Create(HatchStyleLightVertical, MakeColor(255, 255, 0, 0),
            MakeColor(255, 128, 255, 255));
            g.FillRectangle(hBrush, 0, 0, Self.Width, Self.Height);
            if hBrush <> nil then
            begin
             hBrush.Free;
             hBrush := nil;
            end;
        end;
        8:
        begin
           linGrBrush := TGPLinearGradientBrush.Create(
   MakePoint(0, 0),
   MakePoint(Self.Width, Self.Height),
   MakeColor(255, 0, 0, 255),  // blue
   MakeColor(255, 255, 0, 0)   // red
   );
            g.FillRectangle(linGrBrush, 0, 0, Self.Width, Self.Height);
            if linGrBrush <> nil then
            begin
             linGrBrush.Free;
             linGrBrush := nil;
            end;
        end;
    end;

  finally

    
    g.Free;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);

begin

   BorderStyle := bsNone;
  WindowState := wsMaximized;
end;

procedure TMainForm.tmr1Timer(Sender: TObject);
begin
  Inc(Self.flag);
  if self.flag > 5 then
  begin
    Self.flag := 1;
  end;
  Self.FormPaint(nil);
end;

end.


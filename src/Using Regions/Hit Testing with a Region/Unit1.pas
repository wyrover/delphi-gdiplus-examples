unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPOBJ, GDIPAPI;

type
  TForm1 = class(TForm)
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  IsIn: boolean;
implementation

{$R *.dfm}

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  graphic: TGPGraphics;
  Point: TGPPoint;
  solidBrush: TGPsolidBrush;
  WhiteBrush : TGPsolidBrush;
  region1, region2: TGPRegion;
  b: boolean;
begin
  graphic := TGPGraphics.Create(canvas.handle);
  point := MakePoint(x, y);
  // Assume that the variable "point" contains the location
  // of the most recent click.
  // To simulate a hit, assign (60, 10) to point.
  // To simulate a miss, assign (0, 0) to point.

  solidBrush:= TGPsolidBrush.Create(aclBlack);
  region1:= TGPRegion.Create(MakeRect(50, 0, 50, 150));
  region2:= TGPRegion.Create(MakeRect(0, 50, 150, 50));

  // Create a plus-shaped region by forming the union of region1 and region2.
  // The union replaces region1.
  region1.Union(region2);

  if(region1.IsVisible(point, graphic)) then
  begin
    // The point is in the region. Use an opaque brush.
    solidBrush.SetColor(MakeColor(255, 255, 0, 0));
    b := true;
  end
  else
  begin
    // The point is not in the region. Use a semitransparent brush.
    solidBrush.SetColor(MakeColor(64, 255, 0, 0));
    b:=false;
  end;

  if b <> isIn then
  begin
    WhiteBrush := TGPsolidBrush.Create(aclwhite);
    graphic.FillRegion(WhiteBrush, region1);
    graphic.FillRegion(solidBrush, region1);
    WhiteBrush.Free;
    isIn := not isIn;
  end;

  solidBrush.Free;
  region1.Free;
  graphic.Free;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IsIn:= false;
end;

end.

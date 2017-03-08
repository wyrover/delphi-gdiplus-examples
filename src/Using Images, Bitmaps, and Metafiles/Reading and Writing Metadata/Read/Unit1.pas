unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPAPI, GDIPOBJ, GDIPUTIL, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
type
  ArrItems = array of TPROPERTYITEM;
  ac = array of char;
var
  bitmap: TGPBitmap;
  size, count: UINT;
  strPropertyType: String;
  pPropBuffer: PPROPERTYITEM;
  j: Integer;
begin
  bitmap:= TGPBitmap.Create('..\untitled.JPG');
  bitmap.GetPropertySize(size, count);
  memo1.Clear;
  memo1.Lines.Add(format('There are %d pieces of metadata in the file.',[count]));
  memo1.Lines.Add(format('The total size of the metadata is %d bytes.',[size]));
  memo1.Lines.Add('');

  // GetAllPropertyItems returns an array of PropertyItem objects.
  // Allocate a buffer large enough to receive that array.
  //SetLength(pPropBuffer, count);
  Getmem(pPropBuffer, Size);
  ZeroMemory(pPropBuffer, Size);

  // Get the array of PropertyItem objects.
  bitmap.GetAllPropertyItems(size, count, pPropBuffer);

  // For each PropertyItem in the array, display the id, type, and length.
  for j := 0 to count - 1 do
  begin
    // Convert the property type from a WORD to a string.
    strPropertyType := ValueTypeFromULONG(ArrItems(pPropBuffer)[j].type_);
    memo1.Lines.Add(format('Property Item %d', [j]));
    memo1.Lines.Add(format('  id: %s ($%x)', [GetMetaDataIDString(ArrItems(pPropBuffer)[j].id),ArrItems(pPropBuffer)[j].id]));
    memo1.Lines.Add(format('  type: %s (%d)', [strPropertyType, j]));
    memo1.Lines.Add(format('  length: %d bytes', [ArrItems(pPropBuffer)[j].length]));
    memo1.Lines.Add('');
  end;

  FreeMem(pPropBuffer, Size);
  bitmap.Free;
end;



end.

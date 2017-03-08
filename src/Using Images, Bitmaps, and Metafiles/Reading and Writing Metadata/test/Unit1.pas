unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPAPI, GDIPOBJ, StdCtrls;

type
  TForm1 = class(TForm)
    Read: TButton;
    Memo1: TMemo;
    procedure ReadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ReadClick(Sender: TObject);
var
  Image: TGPImage;
  size: UINT;
  propertyItem: PPropertyItem;
  x: array[0..31] of byte;
  i:integer;
  Str: String;
type
  ac= array of byte;
begin
  Image:= TGPImage.Create('..\untitled.JPG');

  // Assume that the image has a property item of type PropertyItemEquipMake.
  // Get the size of that property item.
  size := image.GetPropertyItemSize(PropertyTagImageTitle);

  // Allocate a buffer to receive the property item.
  //propertyItem = (PropertyItem*)malloc(size);
  GetMem(propertyItem ,Size);

  // Get the property item.
  image.GetPropertyItem(PropertyTagImageTitle, size, propertyItem);

  // Display the members of the retrieved PropertyItem object.
  memo1.Lines.Add(format('The length of the property item is %u.', [propertyItem.length]));
  memo1.Lines.Add(format('The data type of the property item is %u.', [propertyItem.type_]));
  for i := 0 to 31 do x[i] := ac(propertyItem)[i];
  if(propertyItem.type_ = PropertyTagTypeASCII) then
  begin
    Str := PChar(propertyItem.value);
    memo1.Lines.Add(format('The value of the property item is %s.', [str]));
  end;
   freemem(propertyItem);
   image.Free;
end;

end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPAPI, GDIPOBJ, GDIPUTIL, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  stat : TStatus;
  clsid: TGUID;
  propertyValue: PChar;
  Bitmap: TGPBitmap;
  propertyItem: TPropertyItem;
begin
   propertyValue := PChar('Fake Photograph');

   Bitmap:= TGPBitmap.Create('..\untitled.JPG');

   // Get the CLSID of the JPEG encoder.
   GetEncoderClsid('image/jpeg', clsid);
   propertyItem.id := PropertyTagImageTitle;
   propertyItem.length := 16;  // string length including NULL terminator
   propertyItem.type_ := PropertyTagTypeASCII;
   propertyItem.value := propertyValue;

   bitmap.SetPropertyItem(propertyItem);
   stat := bitmap.Save('untitled2.JPG', clsid, nil);
   if(stat = Ok) then
     memo1.Lines.Add('untitled2.JPG saved successfully.');

  Bitmap.Free;

end;



end.

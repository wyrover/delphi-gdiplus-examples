unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComObj;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses GDIPAPI, GDIPOBJ, GDIPUTIL;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Bitmap: TGPBitmap;
  encoderClsid: TGUID;
  listSize: UINT;
  EncoderParameters: PEncoderParameters;
  strGuid: String;
  j: Integer;
type
  ArrEncParam = array of TEncoderParameter;
  ArrULONG = array of ULONG;
begin
   // Create a Bitmap (inherited from Image) object so that we can call
   // GetParameterListSize and GetParameterList.
   Bitmap:= TGPBitmap.Create(1,1, PixelFormat32bppARGB);

   // Get the JPEG encoder CLSID.
   GetEncoderClsid('image/jpeg', encoderClsid);

   // How big (in bytes) is the JPEG encoder's parameter list?
   listSize := bitmap.GetEncoderParameterListSize(encoderClsid);
   memo1.Lines.Add(format('The parameter list requires %d bytes.', [listSize]));

   // Allocate a buffer large enough to hold the parameter list.
   getmem(EncoderParameters, listSize);

   // Get the parameter list for the JPEG encoder.
   bitmap.GetEncoderParameterList(encoderClsid, listSize, EncoderParameters);

   // pEncoderParameters points to an EncoderParameters object, which
   // has a Count member and an array of EncoderParameter objects.
   // How many EncoderParameter objects are in the array?
   memo1.Lines.Add(format('There are %d EncoderParameter objects in the array.',
      [EncoderParameters.Count]));

   // Look at the first (index 0) EncoderParameter object in the array.
   Memo1.Lines.Add('Parameter[0]');

   strGuid :=  GUIDToString(ArrEncParam(@EncoderParameters.Parameter)[0].Guid);
   memo1.Lines.Add(format('   The guid is %s.', [strGuid]));

   memo1.Lines.Add(format('   The data type is %s.',
      [ValueTypeFromULONG(ArrEncParam(@EncoderParameters.Parameter)[0].Type_)]));

   memo1.Lines.Add(format('   The number of values is %d.',
      [ArrEncParam(@EncoderParameters.Parameter)[0].NumberOfValues]));

   memo1.Lines.Add('   The allowable values are');
   for j := 0 to ArrEncParam(@EncoderParameters.Parameter)[0].NumberOfValues - 1 do
     memo1.Lines.Add(inttostr(ArrULONG(ArrEncParam(@EncoderParameters.Parameter)[0].Value)[j]));

   freemem(EncoderParameters, listSize);
   bitmap.Free;
end;

end.

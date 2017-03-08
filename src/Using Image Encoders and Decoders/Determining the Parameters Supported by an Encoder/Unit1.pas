unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPAPI, GDIPOBJ, GDIPUTIL, StdCtrls;

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

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
    encoderClsid: TGUID;
    listSize: UINT;
    EncoderParameters: PEncoderParameters;
    Bitmap: TGPBitmap;
type
  ArrEnParam = array of TEncoderParameter;
begin
   // Create Bitmap (inherited from Image) object so that we can call
   // GetParameterListSize and GetParameterList.
   Bitmap := TGPBitmap.Create(1,1, PixelFormat32bppARGB);

   // Get the JPEG encoder CLSID.
   GetEncoderClsid('image/jpeg', encoderClsid);

   // How big (in bytes) is the JPEG encoder's parameter list?
   listSize := Bitmap.GetEncoderParameterListSize(encoderClsid);
   memo1.Lines.Add(format('The parameter list requires %d bytes.', [listSize]));

   // Allocate a buffer large enough to hold the parameter list.
   getmem(EncoderParameters, listSize);

   // Get the parameter list for the JPEG encoder.
   Bitmap.GetEncoderParameterList(encoderClsid, listSize, EncoderParameters);

   // pEncoderParameters points to an EncoderParameters object, which
   // has a Count member and an array of EncoderParameter objects.
   // How many EncoderParameter objects are in the array?
   memo1.Lines.Add(format('There are %d EncoderParameter objects in the array.', [EncoderParameters.Count]));

   freemem(EncoderParameters, listSize);
   Bitmap.Free;
end;

end.

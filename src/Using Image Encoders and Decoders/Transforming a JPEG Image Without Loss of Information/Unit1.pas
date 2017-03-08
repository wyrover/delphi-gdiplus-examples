unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GDIPAPI, GDIPOBJ, GDIPUTIL;

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
  encoderParameters: TEncoderParameters;
  transformation: TEncoderValue;
  width: Integer;
  height: Integer;
  stat: TStatus;
  Image: TGPImage;
  tmpstr: string;
begin

   // Get a JPEG image from the disk.
   Image := TGPImage.Create('..\..\Media\FRUIT.JPG');

   // Determine whether the width and height of the image 
   // are multiples of 16.
   width := image.GetWidth;
   height := image.GetHeight;

   tmpstr := format('The width of the image is %d', [width]);
   if(((width / 16.0) - (width / 16)) = 0) then
      memo1.Lines.Add(tmpstr + ', which is a multiple of 16.')
   else
      memo1.Lines.Add(tmpstr + ', which is not a multiple of 16.');

   tmpstr := format('The height of the image is %d', [height]);
   if(((height / 16.0) - (height / 16)) = 0) then
      memo1.Lines.Add(tmpstr + ', which is a multiple of 16.')
   else
      memo1.Lines.Add(tmpstr + ', which is not a multiple of 16.');

   // Get the CLSID of the JPEG encoder.
   GetEncoderClsid('image/jpeg', encoderClsid);

   // Before we call Image::Save, we must initialize an
   // EncoderParameters object. The EncoderParameters object
   // has an array of EncoderParameter objects. In this
   // case, there is only one EncoderParameter object in the array.
   // The one EncoderParameter object has an array of values.
   // In this case, there is only one value (of type ULONG)
   // in the array. We will set that value to EncoderValueTransformRotate90.

   encoderParameters.Count := 1;
   encoderParameters.Parameter[0].Guid := EncoderTransformation;
   encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
   encoderParameters.Parameter[0].NumberOfValues := 1;

   // Rotate and save the image.
   transformation := EncoderValueTransformRotate90;
   encoderParameters.Parameter[0].Value := @transformation;
   stat := image.Save('ShapesR90.jpg', encoderClsid, @encoderParameters);

   if(stat = Ok) then
      memo1.Lines.Add('ShapesR90.jpg saved successfully.')
   else
      memo1.Lines.Add(GetStatus(Stat) + ' Attempt to save ShapesR90.jpg failed.');

   image.Free;
end;

end.

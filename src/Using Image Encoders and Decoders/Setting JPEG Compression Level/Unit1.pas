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
  quality: ULONG;
  stat: TStatus;
  Image: TGPImage;
begin

   // Get an image from the disk.
   Image := TGPImage.Create('..\..\Media\GrapeBunch.bmp');

   // Get the CLSID of the JPEG encoder.
   GetEncoderClsid('image/jpeg', encoderClsid);

   // Before we call Image::Save, we must initialize an
   // EncoderParameters object. The EncoderParameters object
   // has an array of EncoderParameter objects. In this
   // case, there is only one EncoderParameter object in the array.
   // The one EncoderParameter object has an array of values.
   // In this case, there is only one value (of type ULONG)
   // in the array. We will let this value vary from 0 to 100.

   encoderParameters.Count := 1;
   encoderParameters.Parameter[0].Guid := EncoderQuality;
   encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
   encoderParameters.Parameter[0].NumberOfValues := 1;

   // Save the image as a JPEG with quality level 0.
   quality := 0;
   encoderParameters.Parameter[0].Value := @quality;
   stat := image.Save('Shapes001.jpg', encoderClsid, @encoderParameters);

   if(stat = Ok) then
      Memo1.Lines.Add('Shapes001.jpg saved successfully.')
   else
      Memo1.Lines.Add(GetStatus(Stat) + ' Attempt to save Shapes001.jpg failed.');

   // Save the image as a JPEG with quality level 50.
   quality := 50;
   encoderParameters.Parameter[0].Value := @quality;
   stat := image.Save('Shapes050.jpg', encoderClsid, @encoderParameters);

   if(stat = Ok) then
      Memo1.Lines.Add('Shapes050.jpg saved successfully.')
   else
      Memo1.Lines.Add(GetStatus(Stat) + ' Attempt to save Shapes050.jpg failed.');

      // Save the image as a JPEG with quality level 100.
   quality := 100;
   encoderParameters.Parameter[0].Value := @quality;
   stat := image.Save('Shapes100.jpg', encoderClsid, @encoderParameters);

   if(stat = Ok) then
      memo1.Lines.Add('Shapes100.jpg saved successfully.')
   else
      memo1.Lines.Add(GetStatus(Stat) + ' Attempt to save Shapes100.jpg failed.');

   image.Free;
end;

end.

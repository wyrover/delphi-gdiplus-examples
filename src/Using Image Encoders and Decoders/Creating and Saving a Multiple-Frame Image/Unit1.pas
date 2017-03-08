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
  encoderParameters: TEncoderParameters;
  parameterValue: TEncoderValue;
  stat: TStatus;
  multi, page2, page3, page4: TGPImage;
  encoderClsid: TGUID;
begin

   // An EncoderParameters object has an array of
   // EncoderParameter objects. In this case, there is only
   // one EncoderParameter object in the array.
   encoderParameters.Count := 1;

   // Initialize the one EncoderParameter object.
   encoderParameters.Parameter[0].Guid := EncoderSaveFlag;
   encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
   encoderParameters.Parameter[0].NumberOfValues := 1;
   encoderParameters.Parameter[0].Value := @parameterValue;

   // Get the CLSID of the TIFF encoder.
   GetEncoderClsid('image/tiff', encoderClsid);

   // Create four image objects.
   multi := TGPImage.Create('..\..\Media\GrapeBunch.bmp');
   page2 := TGPImage.Create('..\..\Media\Apple.GIF');
   page3 := TGPImage.Create('..\..\Media\Texture1.JPG');
   page4 := TGPImage.Create('..\..\Media\climber.PNG');

   // Save the first page (frame).
   parameterValue := EncoderValueMultiFrame;
   stat := multi.Save('MultiFrame.tif', encoderClsid, @encoderParameters);
   if(stat = Ok) then
     memo1.Lines.Add('Page 1 saved successfully.');

   // Save the second page (frame).
   parameterValue := EncoderValueFrameDimensionPage;
   stat := multi.SaveAdd(page2, @encoderParameters);
   if(stat = Ok) then
     memo1.Lines.Add('Page 2 saved successfully.');

   // Save the third page (frame).
   parameterValue := EncoderValueFrameDimensionPage;
   stat := multi.SaveAdd(page3, @encoderParameters);
   if(stat = Ok) then
     memo1.Lines.Add('Page 3 saved successfully.');

   // Save the fourth page (frame).
   parameterValue := EncoderValueFrameDimensionPage;
   stat := multi.SaveAdd(page4, @encoderParameters);
   if(stat = Ok) then
     memo1.Lines.Add('Page 4 saved successfully.');
                        
   // Close the multiframe file.
   parameterValue := EncoderValueFlush;
   stat := multi.SaveAdd(@encoderParameters);
   if(stat = Ok) then
     memo1.Lines.Add('File closed successfully.');

   multi.Free;
   page2.Free;
   page3.Free;
   page4.Free;
end;

end.
 
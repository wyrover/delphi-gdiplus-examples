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
  num, size: UINT;
  ImageCodecInfo: PImageCodecInfo;
  j: Integer;
type
  ArrImgCodInfo = array of TImageCodecInfo;
begin
   memo1.Clear;
   // How many encoders are there?
   // How big (in bytes) is the array of all ImageCodecInfo objects?
   GetImageEncodersSize(num, size);

   // Create a buffer large enough to hold the array of ImageCodecInfo
   // objects that will be returned by GetImageEncoders.
   getmem(ImageCodecInfo, size);

   // GetImageEncoders creates an array of ImageCodecInfo objects
   // and copies that array into a previously allocated buffer.
   // The third argument, imageCodecInfo, is a pointer to that buffer.
   GetImageEncoders(num, size, ImageCodecInfo);

   // for each ImageCodecInfo object.
   for j := 0 to num - 1 do
   begin
     memo1.Lines.Add(format('Clsid: %s',[GUIDToString(ArrImgCodInfo(ImageCodecInfo)[j].Clsid)]));
     memo1.Lines.Add(format('FormatID: %s',[GUIDToString(ArrImgCodInfo(ImageCodecInfo)[j].FormatID)]));
     memo1.Lines.Add(format('CodecName: %s',[ArrImgCodInfo(ImageCodecInfo)[j].CodecName]));
     memo1.Lines.Add(format('DllName: %s',[ArrImgCodInfo(ImageCodecInfo)[j].DllName]));
     memo1.Lines.Add(format('FormatDescription: %s',[ArrImgCodInfo(ImageCodecInfo)[j].FormatDescription]));
     memo1.Lines.Add(format('FilenameExtension: %s',[ArrImgCodInfo(ImageCodecInfo)[j].FilenameExtension]));
     memo1.Lines.Add(format('MimeType: %s',[ArrImgCodInfo(ImageCodecInfo)[j].MimeType]));
     memo1.Lines.Add(format('Flags: $%x',[ArrImgCodInfo(ImageCodecInfo)[j].Flags]));
     memo1.Lines.Add(format('Version: %d',[ArrImgCodInfo(ImageCodecInfo)[j].Version]));
     memo1.Lines.Add(format('SigCount: %d',[ArrImgCodInfo(ImageCodecInfo)[j].SigCount]));
     memo1.Lines.Add(format('SigSize: %d',[ArrImgCodInfo(ImageCodecInfo)[j].SigSize]));
     memo1.Lines.Add('');
   end;

   freemem(ImageCodecInfo);

end;

end.

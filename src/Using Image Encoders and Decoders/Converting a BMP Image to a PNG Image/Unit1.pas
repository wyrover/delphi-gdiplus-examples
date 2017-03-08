unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

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
uses GDIPAPI, GDIPOBJ, GDIPUTIL;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  encoderClsid: TGUID;
  stat: TStatus;
  Image: TGPImage;
begin
   Image := TGPImage.Create('..\..\Media\GrapeBunch.bmp');

   // Get the CLSID of the PNG encoder.
   GetEncoderClsid('image/png', encoderClsid);
   stat := image.Save('GrapeBunch.png', encoderClsid, nil);

   if(stat = Ok) then
      memo1.Lines.Add('GrapeBunch.png was saved successfully')
   else
      memo1.Lines.Add(format('Failure: stat = %s', [GetStatus(stat)]));

    image.Free;
end;

end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPAPI, GDIPOBJ, GDIPUTIL, StdCtrls, ComObj;

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
  image: TGPImage;
  count, frameCount: UINT;
  DimensionIDs: PGUID;
  strGuid: string;
  var i: integer;
type
  TGUIDDynArray = array of TGUID;
begin
  Image := TGPImage.Create('..\..\..\Media\MultiFrame.tif');

   // How many frame dimensions does the Image object have?
   count := image.GetFrameDimensionsCount;
   memo1.Lines.Add(format('The number of dimensions is %d.', [count]));
   GetMem(DimensionIDs, count * SizeOf(TGUID));

   // Get the list of frame dimensions from the Image object.
   image.GetFrameDimensionsList(DimensionIDs, count);


   for i := 0 to count - 1 do
   begin
     strGuid := GUIDToString(TGUIDDynArray(DimensionIDs)[i]);
     memo1.Lines.Add('The first (and only) dimension ID is ' + strGuid);
   end;

   // Get the number of frames in the first dimension.
   frameCount := image.GetFrameCount(TGUIDDynArray(DimensionIDs)[0]);
   memo1.Lines.Add('The number of frames in that dimension is '+ inttostr(frameCount));

   freemem(DimensionIDs);
   image.Free;
end;


end.

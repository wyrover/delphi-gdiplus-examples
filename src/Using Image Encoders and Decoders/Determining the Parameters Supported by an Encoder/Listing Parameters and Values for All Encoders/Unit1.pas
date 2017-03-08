unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GDIPAPI, GDIPOBJ, GDIPUTIL, ActiveX;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowAllEncoderParameters(const ImageCodecInfo: TImageCodecInfo);
    function EncoderParameterCategoryFromGUID(const guid: TGUID): string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ShowAllEncoderParameters(const ImageCodecInfo: TImageCodecInfo);
var
  strParameterCategory, strValueType: String;
  Bitmap: TGPBitmap;
  listSize: UINT;
  EncoderParameters: PEncoderParameters;
  k: Integer;
begin

   memo1.Lines.Add(ImageCodecInfo.MimeType);

   // Create a Bitmap (inherited from Image) object so that we can call
   // GetParameterListSize and GetParameterList.
   Bitmap:= TGPBitmap.Create(1,1, PixelFormat32bppARGB);

   // How big (in bytes) is the encoder's parameter list?
   listSize := bitmap.GetEncoderParameterListSize(ImageCodecInfo.Clsid);
   memo1.Lines.Add(format('  The parameter list requires %d bytes.', [listSize]));

   if(listSize = 0) then exit;

   // Allocate a buffer large enough to hold the parameter list.
   getmem(EncoderParameters, listSize);

   // Get the parameter list for the encoder.
   bitmap.GetEncoderParameterList(ImageCodecInfo.Clsid, listSize, EncoderParameters);

   // pEncoderParameters points to an EncoderParameters object, which
   // has a Count member and an array of EncoderParameter objects.
   // How many EncoderParameter objects are in the array?
   memo1.Lines.Add(format('  There are %d EncoderParameter objects in the array.',
      [EncoderParameters.Count]));

   // For each EncoderParameter object in the array, list the
   // parameter category, data type, and number of values.
   for k := 0 to EncoderParameters.Count - 1 do
   begin
      strParameterCategory := EncoderParameterCategoryFromGUID(
        EncoderParameters.Parameter[k].Guid);

      strValueType := ValueTypeFromULONG(
         EncoderParameters.Parameter[k].Type_);

      memo1.Lines.Add(format('    Parameter[%d]', [k]));
      memo1.Lines.Add(format('      The category is %s.', [strParameterCategory]));
      memo1.Lines.Add(format('      The data type is %s.', [strValueType]));

      memo1.Lines.Add(format('      The number of values is %d.',
        [EncoderParameters.Parameter[k].NumberOfValues]));
   end;

   Freemem(EncoderParameters, listSize);
end;

function TForm1.EncoderParameterCategoryFromGUID(const guid: TGUID): string;
begin
  if IsEqualGUID(guid, EncoderCompression)     then result := 'Compression'      else
  if IsEqualGUID(guid, EncoderColorDepth)      then result := 'ColorDepth'       else
  if IsEqualGUID(guid, EncoderScanMethod)      then result := 'ScanMethod'       else
  if IsEqualGUID(guid, EncoderVersion)         then result := 'Version'          else
  if IsEqualGUID(guid, EncoderRenderMethod)    then result := 'RenderMethod'     else
  if IsEqualGUID(guid, EncoderQuality)         then result := 'Quality'          else
  if IsEqualGUID(guid, EncoderTransformation)  then result := 'Transformation'   else
  if IsEqualGUID(guid, EncoderLuminanceTable)  then result := 'LuminanceTable'   else
  if IsEqualGUID(guid, EncoderChrominanceTable)then result := 'ChrominanceTable' else
  if IsEqualGUID(guid, EncoderSaveFlag)        then result := 'SaveFlag'         else
      result := 'Unknown category';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  num, size: UINT;
  ImageCodecInfo: PImageCodecInfo;
  j: Integer;
type
  ArrCodInf = array of TImageCodecInfo;
begin
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

   // For each ImageCodecInfo object in the array, show all parameters.
   for j := 0 to num - 1 do
      ShowAllEncoderParameters(ArrCodInf(ImageCodecInfo)[j]);

   freemem(ImageCodecInfo, size);
end;

end.

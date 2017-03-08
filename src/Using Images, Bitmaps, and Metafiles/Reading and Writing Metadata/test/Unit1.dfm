object Form1: TForm1
  Left = 192
  Top = 114
  Width = 271
  Height = 190
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Read: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Read'
    TabOrder = 0
    OnClick = ReadClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 48
    Width = 263
    Height = 108
    Align = alBottom
    TabOrder = 1
  end
end

object MoveMapsForm: TMoveMapsForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 420
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 300
    Width = 266
    Height = 13
    Caption = 'Selected files will be moved to common maps directory :'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 375
    Width = 309
    Height = 2
    Shape = bsTopLine
  end
  object lbPath: TLabel
    Left = 8
    Top = 319
    Width = 309
    Height = 13
    AutoSize = False
  end
  object cbFilesList: TCheckListBox
    Left = 8
    Top = 8
    Width = 309
    Height = 281
    ItemHeight = 13
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 161
    Top = 388
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 242
    Top = 388
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 345
    Width = 309
    Height = 24
    Smooth = True
    TabOrder = 3
  end
end

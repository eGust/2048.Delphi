object frmConfig: TfrmConfig
  Left = 459
  Top = 134
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Configure'
  ClientHeight = 262
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 35
    Width = 33
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Up'
  end
  object Label2: TLabel
    Left = 176
    Top = 115
    Width = 33
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Right'
  end
  object Label3: TLabel
    Left = 16
    Top = 115
    Width = 33
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Left'
  end
  object Label4: TLabel
    Left = 88
    Top = 195
    Width = 33
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Down'
  end
  object txtUp: TEdit
    Left = 128
    Top = 32
    Width = 40
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = 'Up'
    OnKeyDown = Keys_onKeyDown
  end
  object txtDown: TEdit
    Left = 128
    Top = 192
    Width = 40
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = 'Down'
    OnKeyDown = Keys_onKeyDown
  end
  object txtLeft: TEdit
    Left = 56
    Top = 112
    Width = 40
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = 'Left'
    OnKeyDown = Keys_onKeyDown
  end
  object txtRight: TEdit
    Left = 216
    Top = 112
    Width = 40
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = 'Right'
    OnKeyDown = Keys_onKeyDown
  end
  object btnYes: TButton
    Left = 344
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Yes'
    Default = True
    TabOrder = 4
    OnClick = btnYesClick
  end
  object btnNo: TButton
    Left = 344
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'No'
    TabOrder = 5
    OnClick = btnNoClick
  end
end

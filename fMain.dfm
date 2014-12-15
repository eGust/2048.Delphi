object frmMain: TfrmMain
  Left = 284
  Top = 203
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '2048'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInfo: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 600
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 48
      Top = 160
      Width = 89
      Height = 28
      Action = actNewGame
      Flat = True
    end
    object SpeedButton2: TSpeedButton
      Left = 48
      Top = 272
      Width = 89
      Height = 28
      Action = actConfig
      Flat = True
    end
    object SpeedButton3: TSpeedButton
      Left = 48
      Top = 384
      Width = 89
      Height = 28
      Action = actAbout
      Flat = True
    end
    object SpeedButton4: TSpeedButton
      Left = 48
      Top = 504
      Width = 89
      Height = 28
      Action = actExit
      Flat = True
    end
    object lblScore: TStaticText
      Left = 5
      Top = 48
      Width = 190
      Height = 60
      Alignment = taCenter
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      Color = clCream
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -48
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object StaticText2: TStaticText
      Left = 64
      Top = 10
      Width = 81
      Height = 33
      AutoSize = False
      Caption = 'Score'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object pnlGame: TPanel
    Left = 200
    Top = 0
    Width = 600
    Height = 600
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object imgMap: TImage
      Left = 0
      Top = 0
      Width = 600
      Height = 600
      Align = alClient
    end
  end
  object MainMenu1: TMainMenu
    Left = 216
    Top = 8
    object Game1: TMenuItem
      Caption = 'Game'
      object mnNewGame: TMenuItem
        Action = actNewGame
      end
      object mnConfigure: TMenuItem
        Action = actConfig
      end
      object mnExit: TMenuItem
        Action = actExit
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object mnAbout: TMenuItem
        Action = actAbout
      end
    end
  end
  object ActionList1: TActionList
    Left = 264
    Top = 8
    object actNewGame: TAction
      Caption = 'New Game'
      ShortCut = 113
      OnExecute = actNewGameExecute
    end
    object actConfig: TAction
      Caption = 'Configure'
      ShortCut = 116
      OnExecute = actConfigExecute
    end
    object actExit: TAction
      Caption = 'Exit'
      OnExecute = actExitExecute
    end
    object actAbout: TAction
      Caption = 'About'
      ShortCut = 112
      OnExecute = actAboutExecute
    end
  end
end

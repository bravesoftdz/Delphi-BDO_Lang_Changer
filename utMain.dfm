object fmMain: TfmMain
  Left = 445
  Top = 334
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'BDO Lang Changer v1.0'
  ClientHeight = 244
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 401
    Height = 105
    Caption = #1055#1091#1090#1080
    TabOrder = 0
    object lblPath1: TLabel
      Left = 16
      Top = 16
      Width = 62
      Height = 13
      Caption = #1055#1091#1090#1100' '#1082' '#1080#1075#1088#1077':'
    end
    object lblPath2: TLabel
      Left = 16
      Top = 56
      Width = 215
      Height = 13
      Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1088#1091#1089#1080#1092#1080#1082#1072#1090#1086#1088#1072'('#1092#1072#1081#1083' '#1072#1088#1093#1080#1074#1072'):'
    end
    object edPath1: TEdit
      Left = 16
      Top = 30
      Width = 297
      Height = 21
      Color = clWhite
      TabOrder = 0
      Text = 'D:\Games\Black Desert'
    end
    object btnSelect1: TButton
      Left = 312
      Top = 30
      Width = 75
      Height = 21
      Caption = #1080#1079#1084#1077#1085#1080#1090#1100'...'
      TabOrder = 1
      OnClick = btnSelect1Click
    end
    object edPath2: TEdit
      Left = 16
      Top = 70
      Width = 297
      Height = 21
      Color = clWhite
      TabOrder = 2
      Text = 'D:\My Files\BDORUS-master.zip'
    end
    object btnSelect2: TButton
      Left = 312
      Top = 70
      Width = 75
      Height = 21
      Caption = #1080#1079#1084#1077#1085#1080#1090#1100'...'
      TabOrder = 3
      OnClick = btnSelect2Click
    end
    object gpInd: TPanel
      Left = 3
      Top = 33
      Width = 12
      Height = 15
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = '+'
      Color = clRed
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 4
    end
    object rpInd: TPanel
      Left = 3
      Top = 73
      Width = 12
      Height = 15
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = '+'
      Color = clRed
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 5
    end
    object Button4: TButton
      Left = 368
      Top = 9
      Width = 17
      Height = 17
      Caption = '?'
      TabOrder = 6
      OnClick = Button4Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 120
    Width = 401
    Height = 97
    Caption = #1057#1090#1072#1090#1091#1089
    TabOrder = 1
    object lblStatus: TLabel
      Left = 2
      Top = 66
      Width = 397
      Height = 29
      Align = alBottom
      Alignment = taCenter
      Caption = '--//--'
      Color = clWhite
      Enabled = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -24
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object btnCheckSts: TButton
      Left = 8
      Top = 16
      Width = 123
      Height = 41
      Caption = #1059#1079#1085#1072#1090#1100' '#1089#1090#1072#1090#1091#1089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnCheckStsClick
    end
    object Button2: TButton
      Left = 138
      Top = 16
      Width = 123
      Height = 41
      Caption = #1056#1091#1089#1080#1092#1080#1094#1080#1088#1086#1074#1072#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object Button3: TButton
      Left = 268
      Top = 16
      Width = 123
      Height = 41
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 225
    Width = 417
    Height = 19
    Panels = <
      item
        Alignment = taRightJustify
        Bevel = pbRaised
        Text = 'by SCRIBE (_scribe_@ukr.net) for www.nlm.im'
        Width = 200
      end>
  end
end

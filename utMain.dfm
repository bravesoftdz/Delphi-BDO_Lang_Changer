object fmMain: TfmMain
  Left = 461
  Top = 344
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'BDO Lang Changer v1.0'
  ClientHeight = 284
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
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 401
    Height = 145
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
    object lblPath3: TLabel
      Left = 16
      Top = 96
      Width = 179
      Height = 13
      Caption = #1055#1091#1090#1100' '#1082' '#1087#1072#1087#1082#1077' '#1086#1088#1075#1080#1085#1072#1083#1100#1085#1099#1093' '#1092#1072#1081#1083#1086#1074':'
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
    end
    object edPath3: TEdit
      Left = 16
      Top = 110
      Width = 297
      Height = 21
      Color = clWhite
      TabOrder = 4
      Text = 'D:\My files\BDO Backup'
    end
    object btnSelect3: TButton
      Left = 312
      Top = 110
      Width = 75
      Height = 21
      Caption = #1080#1079#1084#1077#1085#1080#1090#1100'...'
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 160
    Width = 401
    Height = 97
    Caption = #1057#1090#1072#1090#1091#1089
    TabOrder = 1
    object lblStatus: TLabel
      Left = 2
      Top = 64
      Width = 397
      Height = 31
      Align = alBottom
      Alignment = taCenter
      Caption = #1056#1059#1057#1048#1060#1048#1062#1048#1056#1054#1042#1040#1053
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
    object Button1: TButton
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
    Top = 265
    Width = 417
    Height = 19
    Panels = <>
  end
end

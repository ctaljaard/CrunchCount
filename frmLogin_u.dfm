object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'CrunchCount | Log In'
  ClientHeight = 540
  ClientWidth = 960
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -13
  Font.Name = 'Segoe UI Semibold'
  Font.Style = [fsBold]
  OnActivate = FormActivate
  OnShow = FormShow
  TextHeight = 17
  object imgLogo: TImage
    Left = 8
    Top = 456
    Width = 169
    Height = 84
  end
  object gbxLogin: TGroupBox
    Left = 319
    Top = 80
    Width = 329
    Height = 369
    Caption = 'Log In'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -22
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object lblSignUp: TLabel
      Left = 120
      Top = 287
      Width = 91
      Height = 17
      Cursor = crHandPoint
      Caption = 'Create account'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = lblSignUpClick
      OnDblClick = lblSignUpClick
    end
    object ldtUsername: TLabeledEdit
      Left = 24
      Top = 96
      Width = 281
      Height = 25
      Cursor = crIBeam
      EditLabel.Width = 61
      EditLabel.Height = 17
      EditLabel.Caption = 'Username'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clGray
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'Segoe UI Semibold'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'bbircher1'
    end
    object bbnEnter: TBitBtn
      Left = 24
      Top = 256
      Width = 281
      Height = 25
      Cursor = crHandPoint
      Caption = 'Enter'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      Kind = bkOK
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = bbnEnterClick
    end
    object ldtPassword: TLabeledEdit
      Left = 24
      Top = 160
      Width = 281
      Height = 25
      EditLabel.Width = 58
      EditLabel.Height = 17
      EditLabel.Caption = 'Password'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clGray
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'Segoe UI Semibold'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 2
      Text = 'pD4/Wbt3'
    end
    object btnShowHidePassword: TButton
      Left = 256
      Top = 160
      Width = 51
      Height = 25
      Cursor = crHelp
      Caption = 'Show'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnShowHidePasswordClick
    end
  end
end

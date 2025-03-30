object frmPT: TfrmPT
  AlignWithMargins = True
  Left = 0
  Top = 0
  Caption = 'CrunchCount | Personal Trainer'
  ClientHeight = 540
  ClientWidth = 960
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  TextHeight = 15
  object imgLogo: TImage
    Left = 855
    Top = 8
    Width = 105
    Height = 49
  end
  object gbxPT: TGroupBox
    Left = 8
    Top = 47
    Width = 944
    Height = 485
    Caption = 'Trainer Portal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object cbxClients: TComboBox
      Left = 282
      Top = 134
      Width = 273
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'Select a client'
    end
    object bbnViewAccount: TBitBtn
      Left = 576
      Top = 136
      Width = 121
      Height = 33
      Caption = '&View Account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      Kind = bkIgnore
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = bbnViewAccountClick
    end
    object gbxMessagePT: TGroupBox
      Left = 258
      Top = 208
      Width = 463
      Height = 209
      Caption = 'Message Client'
      TabOrder = 2
      object redMessagePT: TRichEdit
        Left = 24
        Top = 48
        Width = 273
        Height = 137
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        Lines.Strings = (
          'redMessagePT')
        ParentFont = False
        TabOrder = 0
      end
      object bbnSendMessage: TBitBtn
        Left = 318
        Top = 48
        Width = 121
        Height = 137
        Caption = 'Send Message'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        Kind = bkOK
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 1
        OnClick = bbnSendMessageClick
      end
    end
  end
  object bbnLogOut: TBitBtn
    Left = 760
    Top = 16
    Width = 83
    Height = 25
    Caption = 'Log Out'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = bbnLogOutClick
  end
end

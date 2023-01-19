object frmFlatPAY: TfrmFlatPAY
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmFlatPAY'
  ClientHeight = 195
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    383
    195)
  TextHeight = 13
  object lblCaption: TLabel
    Left = 0
    Top = 0
    Width = 383
    Height = 29
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Terminalbetaling (FlatPAY)'
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object lAmount: TLabel
    Left = 0
    Top = 72
    Width = 383
    Height = 23
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Bel'#248'b - i danske kroner'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object fMessageToClerk: TLabel
    Left = 0
    Top = 123
    Width = 383
    Height = 33
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object btnCancelTransaction: TButton
    Left = 300
    Top = 162
    Width = 75
    Height = 25
    Caption = 'Afbryd'
    TabOrder = 0
    OnClick = btnCancelTransactionClick
  end
  object btnAgain: TButton
    Left = 196
    Top = 162
    Width = 75
    Height = 25
    Caption = 'Pr'#248'v igen'
    TabOrder = 1
    Visible = False
  end
end

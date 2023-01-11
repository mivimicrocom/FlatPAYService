object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'FlatPAY by Microcom A/S'
  ClientHeight = 762
  ClientWidth = 988
  Color = clBtnFace
  Constraints.MinHeight = 800
  Constraints.MinWidth = 1000
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object pnlButtons: TPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 762
    Align = alLeft
    Caption = 'pnlButtons'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = -5
    object btnSettings: TButton
      Left = 24
      Top = 24
      Width = 185
      Height = 25
      Caption = 'Indstillinger'
      TabOrder = 0
      OnClick = btnSettingsClick
    end
    object btnPairTerminal: TButton
      Left = 24
      Top = 64
      Width = 185
      Height = 25
      Caption = 'Forbind til terminal'
      TabOrder = 1
      OnClick = btnPairTerminalClick
    end
    object btnXReport: TButton
      Left = 24
      Top = 104
      Width = 185
      Height = 25
      Caption = 'X-Report'
      TabOrder = 2
      OnClick = btnXReportClick
    end
  end
  object Panel1: TPanel
    Left = 249
    Top = 0
    Width = 739
    Height = 762
    Align = alClient
    Caption = 'pnlLog'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 735
    ExplicitHeight = 761
    object mmoLog: TMemo
      Left = 1
      Top = 1
      Width = 737
      Height = 760
      Align = alClient
      Lines.Strings = (
        'mmoLog')
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      ExplicitWidth = 733
      ExplicitHeight = 759
    end
  end
  object TrayIcon1: TTrayIcon
    Hint = 'Dobbeltklik for at maksimere programmet'
    PopupMenu = PopupMenu1
    Visible = True
    OnDblClick = TrayIcon1DblClick
    Left = 776
    Top = 96
  end
  object PopupMenu1: TPopupMenu
    Left = 768
    Top = 192
    object Afslut1: TMenuItem
      Caption = 'Afslut'
      OnClick = Afslut1Click
    end
  end
  object tiAutoHide: TTimer
    Enabled = False
    OnTimer = tiAutoHideTimer
    Left = 688
    Top = 312
  end
  object tiJob: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tiJobTimer
    Left = 488
    Top = 384
  end
end

object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'Indstillinger'
  ClientHeight = 342
  ClientWidth = 458
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 470
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object edIncomingJobFolder: TLabeledEdit
    Left = 24
    Top = 24
    Width = 345
    Height = 23
    EditLabel.Width = 110
    EditLabel.Height = 15
    EditLabel.Caption = 'Indg'#229'ende job folder'
    TabOrder = 0
    Text = ''
    TextHint = 'Indtast folderen hvor indg'#229'ende jobs afleveres'
  end
  object edOutgoingResultFolder: TLabeledEdit
    Left = 24
    Top = 76
    Width = 345
    Height = 23
    EditLabel.Width = 112
    EditLabel.Height = 15
    EditLabel.Caption = 'Udg'#229'ende svar folder'
    TabOrder = 1
    Text = ''
    TextHint = 'Indtast folderen hvor svar afleveres'
  end
  object edIP: TLabeledEdit
    Left = 24
    Top = 182
    Width = 121
    Height = 23
    EditLabel.Width = 118
    EditLabel.Height = 15
    EditLabel.Caption = 'Terminalens IP adresse'
    TabOrder = 3
    Text = '10.1.0.1'
    TextHint = 'Indtast terminalens IP'
  end
  object edSerial: TLabeledEdit
    Left = 24
    Top = 288
    Width = 121
    Height = 23
    EditLabel.Width = 73
    EditLabel.Height = 15
    EditLabel.Caption = 'Serial number'
    TabOrder = 6
    Text = '1850649053'
    TextHint = 'Indtast terminalens serienummer'
  end
  object edPort: TLabeledEdit
    Left = 248
    Top = 182
    Width = 121
    Height = 23
    EditLabel.Width = 22
    EditLabel.Height = 15
    EditLabel.Caption = 'Port'
    TabOrder = 4
    Text = '8080'
    TextHint = 'Indtast port'
  end
  object edEndpointRessource: TLabeledEdit
    Left = 24
    Top = 235
    Width = 345
    Height = 23
    EditLabel.Width = 49
    EditLabel.Height = 15
    EditLabel.Caption = 'Ressouce'
    TabOrder = 5
    Text = '/POSitiveWebLink/1.1.0/rest'
    TextHint = 'Indtast webservice resource'
  end
  object edLogFolder: TLabeledEdit
    Left = 24
    Top = 129
    Width = 345
    Height = 23
    EditLabel.Width = 51
    EditLabel.Height = 15
    EditLabel.Caption = 'Logfolder'
    TabOrder = 2
    Text = ''
    TextHint = 'Indtast folderen hvor logs gemmes'
  end
  object edToken: TLabeledEdit
    Left = 248
    Top = 288
    Width = 121
    Height = 23
    TabStop = False
    EditLabel.Width = 95
    EditLabel.Height = 15
    EditLabel.Caption = 'Nuv'#230'rende token'
    ReadOnly = True
    TabOrder = 7
    Text = '1850649053'
    TextHint = 'Read only'
  end
end

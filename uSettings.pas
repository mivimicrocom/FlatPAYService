unit uSettings;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls;

type
  TfrmSettings = class(TForm)
    edIncomingJobFolder: TLabeledEdit;
    edOutgoingResultFolder: TLabeledEdit;
    edIP: TLabeledEdit;
    edSerial: TLabeledEdit;
    edPort: TLabeledEdit;
    edEndpointRessource: TLabeledEdit;
    edLogFolder: TLabeledEdit;
    edToken: TLabeledEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}



end.

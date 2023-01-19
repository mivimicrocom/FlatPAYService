program FlatPAYService;

uses
  FastMM4,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uSettings in 'uSettings.pas' {frmSettings},
  uFlatPAY in 'uFlatPAY.pas',
  uFlatPAY_Form in 'uFlatPAY_Form.pas' {frmFlatPAY};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmFlatPAY, frmFlatPAY);
  Application.Run;
end.

unit uMain;

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
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Menus,
  uFlatPAY,
  System.Generics.Collections,
  // REST.Types,
  // System.Json,
  MVCFramework,
  MVCFramework.Serializer.Defaults,
  MVCFramework.Serializer.Commons,
  MVCFramework.Serializer.JsonDataObjects;

type
  TfrmMain = class(TForm)
    TrayIcon1: TTrayIcon;
    pnlButtons: TPanel;
    Panel1: TPanel;
    mmoLog: TMemo;
    btnSettings: TButton;
    PopupMenu1: TPopupMenu;
    Afslut1: TMenuItem;
    btnPairTerminal: TButton;
    tiAutoHide: TTimer;
    btnXReport: TButton;
    tiJob: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Afslut1Click(Sender: TObject);
    procedure tiAutoHideTimer(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnPairTerminalClick(Sender: TObject);
    procedure btnXReportClick(Sender: TObject);
    procedure tiJobTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//  TFlatPAYAction = class
//  private
//    { private declarations }
//    FKindOfJob: string;
//    FTransType: String;
//    FAmount: Double;
//    FGratiuty: Double;
//    FCashBack: Double;
//    FReference: string;
//    FLanguage: string;
//    FDisablePrint: Boolean;
//    Futi: string;
//    FXReportName: String;
//    FZReportName: string;
//    FHistoryName: string;
//    FLastTransactionName: string;
//    FGetStatusName: string;
//    FPaymentName: string;
//    FMerchantReceiptName: string;
//    FCardHolderReceiptName: string;
//    FResultFileName: string;
//    FResultOK: string;
//    FResultError: string;
//  public
//    constructor Create;
//    destructor Destroy; override;
//    { public declarations }
//    [MVCNameAs('KindOfJob')]
//    property KindOfJob: string read FKindOfJob write FKindOfJob;
//    [MVCNameAs('TransType')]
//    property TransType: String read FTransType write FTransType;
//    [MVCNameAs('Amount')]
//    property Amount: Double read FAmount write FAmount;
//    [MVCNameAs('Gratiuty')]
//    property Gratiuty: Double read FGratiuty write FGratiuty;
//    [MVCNameAs('CashBack')]
//    property CashBack: Double read FCashBack write FCashBack;
//    [MVCNameAs('Reference')]
//    property Reference: string read FReference write FReference;
//    [MVCNameAs('Language')]
//    property Language: string read FLanguage write FLanguage;
//    [MVCNameAs('DisablePrint')]
//    property DisablePrint: Boolean read FDisablePrint write FDisablePrint;
//    [MVCNameAs('uti')]
//    property uti: string read Futi write Futi;
//    [MVCDoNotSerialize]
//    property XReportName: String read FXReportName;
//    [MVCDoNotSerialize]
//    property ZReportName: string read FZReportName;
//    [MVCDoNotSerialize]
//    property HistoryName: string read FHistoryName;
//    [MVCDoNotSerialize]
//    property LastTransactionName: string read FLastTransactionName;
//    [MVCDoNotSerialize]
//    property GetStatusName: string read FGetStatusName write FGetStatusName;
//    [MVCDoNotSerialize]
//    property PaymentName: string read FPaymentName write FPaymentName;
//    [MVCDoNotSerialize]
//    property MerchantReceiptName: string read FMerchantReceiptName write FMerchantReceiptName;
//    [MVCDoNotSerialize]
//    property CardHolderReceiptName: string read FCardHolderReceiptName write FCardHolderReceiptName;
//    [MVCDoNotSerialize]
//    property ResultFileName: string read FResultFileName write FResultFileName;
//    property ResultOK: string read FResultOK;
//    [MVCDoNotSerialize]
//    property ResultError: string read FResultError;
//  end;

  TFlatPAYReturnAnswer = class
  private
    FJobCompleted: string;
    FJobStatus: string;
    { private declarations }
  public
    { public declarations }
    [MVCNameAs('Job')]
    property JobCompleted: string read FJobCompleted write FJobCompleted;
    [MVCNameAs('Status')]
    property JobStatus: string read FJobStatus write FJobStatus;
  end;

  TMyFlatPAYCommunication = class(TObject)
  private
    FFlatPAYSetup: TFlatPAYSetup;
    FFlatPAYAction: TFlatPAYAction;
    FReturnAnswer: TFlatPAYReturnAnswer;
    FIncomingJobFolder: string;
    FOutgoingResultFolder: string;
    FLogFolder: string;
    FLogFolderIncomingJobs: string;
    FLogFolderOutgoingResult: string;
    FIP: string;
    FPort: string;
    FEndpointResource: string;
    FSerial: string;
    FConnected: Boolean;
    FToken: string;
    FDisablePrint: Boolean;
    FIncomingJobFile: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReadSettingsFromINIFile;
    procedure WriteSettingsToINIFile;
    procedure ShowSettings;
    procedure PairWithTerminal;
    procedure XReport(aTest: Boolean; aDisablePrint: Boolean);
    procedure ZReport(aTest: Boolean; aDisablePrint: Boolean);
    procedure HistoryReport(aTest: Boolean; aDisablePrint: Boolean);
    procedure GetLastTransaction(aTest: Boolean; aDisablePrint: Boolean; auti: string);
    procedure GetStatus(aTest: Boolean; aDisablePrint: Boolean);
    procedure DoPayment(aTest: Boolean; aFlatPAY_Action: TFlatPAYAction);
    procedure CleanResultFolder;
    procedure DoWritetReturnResponse(aFileName: string; aContent: string);
    procedure AddLog(aText: String);
    procedure CreateSubFolders;
    procedure LookForAJob;

    property FlatPAYSetup: TFlatPAYSetup read FFlatPAYSetup write FFlatPAYSetup;
    property FlatPAYAction: TFlatPAYAction read FFlatPAYAction write FFlatPAYAction;
    property RetrunAnswer: TFlatPAYReturnAnswer read FReturnAnswer write FReturnAnswer;
    property IncomingJobFolder: string read FIncomingJobFolder write FIncomingJobFolder;
    property OutgoingResultFolder: string read FOutgoingResultFolder write FOutgoingResultFolder;
    property LogFolder: string read FLogFolder write FLogFolder;
    property LogFolderIncomingJobs: string read FLogFolderIncomingJobs write FLogFolderIncomingJobs;
    property LogFolderOutgoingResult: string read FLogFolderOutgoingResult write FLogFolderOutgoingResult;
    property IP: string read FIP write FIP;
    property Port: string read FPort write FPort;
    property EndpointResource: string read FEndpointResource write FEndpointResource;
    property Serial: string read FSerial write FSerial;
    property Connected: Boolean read FConnected write FConnected;
    property Token: string read FToken write FToken;
    property DisablePrint: Boolean read FDisablePrint write FDisablePrint;
    property IncomingJobFile: string read FIncomingJobFile write FIncomingJobFile;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}


uses
  uSettings,
  System.IniFiles,
  System.IOUtils,
  uFlatPAY_Form;

var
  DoEndProgram: Boolean = FALSE;
  MyFlatPAYComminucation: TMyFlatPAYCommunication;

procedure TfrmMain.Afslut1Click(Sender: TObject);
begin
  DoEndProgram := TRUE;
  Close;
end;

procedure TfrmMain.btnPairTerminalClick(Sender: TObject);
begin
  MyFlatPAYComminucation.PairWithTerminal;
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
begin
  MyFlatPAYComminucation.ShowSettings;
end;

procedure TfrmMain.btnXReportClick(Sender: TObject);
begin
  MyFlatPAYComminucation.XReport(TRUE, FALSE);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{$IFDEF DEBUG}
  CanClose := TRUE;
{$ENDIF}
{$IFDEF RELEASE}
  CanClose := DoEndProgram;
{$ENDIF}
  if (CanClose) then
  begin
    MyFlatPAYComminucation.AddLog('Program afsluttet');
    MyFlatPAYComminucation.Free;
  end
  else
    self.Hide;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := TRUE;
{$ENDIF}
{$IFDEF RELEASE}
  ReportMemoryLeaksOnShutdown := FALSE;
{$ENDIF}
  mmoLog.Clear;
  tiJob.Enabled := FALSE;
  tiAutoHide.Enabled := TRUE;
end;

procedure TfrmMain.tiAutoHideTimer(Sender: TObject);
begin
  tiAutoHide.Enabled := FALSE;
  MyFlatPAYComminucation := TMyFlatPAYCommunication.Create;
  tiJob.Enabled := TRUE;
{$IFDEF RELEASE}
  self.Hide;
{$ENDIF}
end;

procedure TfrmMain.tiJobTimer(Sender: TObject);
begin
  tiJob.Enabled := FALSE;
  MyFlatPAYComminucation.LookForAJob;
  tiJob.Enabled := TRUE;
end;

procedure TfrmMain.TrayIcon1DblClick(Sender: TObject);
begin
  self.Show;
end;

{ TMyFlatPAYCommunication }

procedure TMyFlatPAYCommunication.AddLog(aText: String);
var
  lStr: string;
begin
  lStr := FormatDateTime('dd-mm-yyyy hh:mm:ss', NOW) + ': ' + aText;
  frmMain.mmoLog.Lines.Add(lStr);
  TFile.AppendAllText((FLogFolder + 'Log_' + FormatDateTime('yyyymmdd', NOW) + '.log'), lStr + #13#10);
end;

procedure TMyFlatPAYCommunication.CleanResultFolder;
/// This will look after all files in OutgoingResultFolder with extension json and txt and move them
var
  Filenames: TArray<string>;
  Filename: string;
  lToFile: string;
begin
  if (FOutgoingResultFolder <> '') then
  begin
    Filenames := TDirectory.GetFiles(FOutgoingResultFolder, '*.txt', TSearchOption.soAllDirectories);
    for Filename in Filenames do
    begin
      lToFile := (FLogFolderOutgoingResult + TPath.GetFileNameWithoutExtension(Filename)) + FormatDateTime('yyyymmdd_hhmmssmss', NOW) + '.txt';
      if (NOT(MoveFile(PWideChar(Filename), PWideChar(lToFile)))) then
        AddLog('Kan ikke flytte fil ' + Filename + ' til ' + lToFile);
    end;
    Filenames := TDirectory.GetFiles(FOutgoingResultFolder, '*.json', TSearchOption.soAllDirectories);
    for Filename in Filenames do
    begin
      lToFile := (FLogFolderOutgoingResult + TPath.GetFileNameWithoutExtension(Filename)) + FormatDateTime('yyyymmdd_hhmmssmss', NOW) + '.json';
      if (NOT(MoveFile(PWideChar(Filename), PWideChar(lToFile)))) then
        AddLog('Kan ikke flytte fil ' + Filename + ' til ' + lToFile);
    end;
  end;
end;

constructor TMyFlatPAYCommunication.Create;
begin
  inherited;
  FReturnAnswer:= TFlatPAYReturnAnswer.Create;
  FConnected := FALSE;
  FDisablePrint := FALSE;
  IncomingJobFile := 'Job.txt';
  ReadSettingsFromINIFile;
  AddLog('Program startet');
  FlatPAYSetup := TFlatPAYSetup.Create(FIP, FPort, FEndpointResource, FSerial, FToken);
  AddLog('  IP: ' + FIP);
  AddLog('  Port: ' + FPort);
  AddLog('  Endpoint resource: ' + FEndpointResource);
  AddLog('  Serial: ' + FSerial);
  AddLog('  Token: ' + FToken);
end;

procedure TMyFlatPAYCommunication.CreateSubFolders;
begin
  FLogFolderIncomingJobs := IncludeTrailingPathDelimiter(FLogFolder + 'IncomingJobs\' + FormatDateTime('yyyy', NOW) + '\' + FormatDateTime('mm', NOW) + '\' +
    FormatDateTime('dd', NOW));
  FLogFolderOutgoingResult := IncludeTrailingPathDelimiter(FLogFolder + 'OutgoingResults\' + FormatDateTime('yyyy', NOW) + '\' + FormatDateTime('mm', NOW) + '\' +
    FormatDateTime('dd', NOW));

  if (not(ForceDirectories(FIncomingJobFolder))) then
    AddLog('Kan ikke oprette folderen: ' + FIncomingJobFolder);
  if (not(ForceDirectories(FOutgoingResultFolder))) then
    AddLog('Kan ikke oprette folderen: ' + FOutgoingResultFolder);
  if (not(ForceDirectories(FLogFolder))) then
    AddLog('Kan ikke oprette folderen: ' + FLogFolder);
  if (not(ForceDirectories(FLogFolderIncomingJobs))) then
    AddLog('Kan ikke oprette folderen: ' + FLogFolderIncomingJobs);
  if (not(ForceDirectories(FLogFolderOutgoingResult))) then
    AddLog('Kan ikke oprette folderen: ' + FLogFolderOutgoingResult);
end;

destructor TMyFlatPAYCommunication.Destroy;
begin
  FReturnAnswer.Free;
  FlatPAYSetup.Free;
  inherited;
end;

procedure TMyFlatPAYCommunication.DoPayment(aTest: Boolean; aFlatPAY_Action: TFlatPAYAction);
var
  luti: string;
  lReturnTransactionsResponse: TFlatPAY_GetTransactionsRespons;
  ii: Integer;
  lPaymentJSONOutput: string;
  lCardHolderReceipt: string;
  lMerchantReceipt: string;
begin
  CleanResultFolder;
  AddLog('Payment');
  AddLog('  BaseURL: ' + FlatPAYSetup.BaseURL);

  lReturnTransactionsResponse := TFlatPAY_GetTransactionsRespons.Create;

  if frmFlatPAY.DoFlatPAYPayment(FlatPAYSetup, aFlatPAY_Action.TransType, aFlatPAY_Action.Amount, aFlatPAY_Action.Gratiuty, aFlatPAY_Action.CashBack, aFlatPAY_Action.Reference,
    aFlatPAY_Action.Language, aFlatPAY_Action.DisablePrint, luti, lReturnTransactionsResponse,
    20000) then
  begin
    AddLog(Format(' Sale accepted (uti: %s, %s;  cardType: %s)', [luti, lReturnTransactionsResponse.uti, lReturnTransactionsResponse.cardType]));
    lPaymentJSONOutput := GetDefaultSerializer.SerializeObject(lReturnTransactionsResponse);
    AddLog('Result: ' + lPaymentJSONOutput);

    lCardHolderReceipt := '';
    for ii := 0 to length(lReturnTransactionsResponse.cardholderReceipt) - 1 do
    begin
      lCardHolderReceipt := lCardHolderReceipt + #13#10 + lReturnTransactionsResponse.cardholderReceipt[ii];
    end;

    lMerchantReceipt := '';
    for ii := 0 to length(lReturnTransactionsResponse.merchantReceipt) - 1 do
    begin
      lMerchantReceipt := lMerchantReceipt + #13#10 + lReturnTransactionsResponse.merchantReceipt[ii];
    end;

    if (not(aTest)) then
    begin
      lPaymentJSONOutput := GetDefaultSerializer.SerializeObject(lReturnTransactionsResponse);
      DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.PaymentName]), lPaymentJSONOutput);
      DoWritetReturnResponse(FlatPAYAction.MerchantReceiptName, lMerchantReceipt);
      DoWritetReturnResponse(FlatPAYAction.CardHolderReceiptName, lCardHolderReceipt);
        FReturnAnswer.FJobCompleted := FlatPAYAction.PaymentName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultOK;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
    end;
  end
  else
  begin
    AddLog(Format(' Sale not accepted (uti: %s, %s;  cardType: %s)', [luti, lReturnTransactionsResponse.uti, lReturnTransactionsResponse.cardType]));
    lPaymentJSONOutput := GetDefaultSerializer.SerializeObject(lReturnTransactionsResponse);
    AddLog('Result: ' + lPaymentJSONOutput);

    lCardHolderReceipt := '';
    for ii := 0 to length(lReturnTransactionsResponse.cardholderReceipt) - 1 do
    begin
      lCardHolderReceipt := lCardHolderReceipt + #13#10 + lReturnTransactionsResponse.cardholderReceipt[ii];
    end;

    lMerchantReceipt := '';
    for ii := 0 to length(lReturnTransactionsResponse.merchantReceipt) - 1 do
    begin
      lMerchantReceipt := lMerchantReceipt + #13#10 + lReturnTransactionsResponse.merchantReceipt[ii];
    end;

    if (not(aTest)) then
    begin
      lPaymentJSONOutput := GetDefaultSerializer.SerializeObject(lReturnTransactionsResponse);
      DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.PaymentName]), lPaymentJSONOutput);
      DoWritetReturnResponse(FlatPAYAction.MerchantReceiptName, lMerchantReceipt);
      DoWritetReturnResponse(FlatPAYAction.CardHolderReceiptName, lCardHolderReceipt);
        FReturnAnswer.FJobCompleted := FlatPAYAction.PaymentName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultError;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
    end;
  end;
  lReturnTransactionsResponse.Free;
end;

procedure TMyFlatPAYCommunication.DoWritetReturnResponse(aFileName: string; aContent: string);
begin
  TFile.WriteAllText((FOutgoingResultFolder + aFileName), aContent);
end;

procedure TMyFlatPAYCommunication.LookForAJob;
var
  lMyFileStr: string;
  lFromFile: string;
  lToFile: string;
begin
  if (FIncomingJobFolder <> '') then
  begin
    if (FileExists(FIncomingJobFolder + FIncomingJobFile)) then
    begin
      // Make sure log folders with dates exist
      CreateSubFolders;

      // Read content of job file
      lMyFileStr := TFile.ReadAllText((FIncomingJobFolder + FIncomingJobFile), TEncoding.UTF8);
      // Set up from and to file
      lFromFile := (FIncomingJobFolder + FIncomingJobFile);
      lToFile := (FLogFolderIncomingJobs + 'Job_' + FormatDateTime('yyyymmdd_hhmmss', NOW) + '.txt');

      // Move job file
      if (NOT(MoveFile(PWideChar(lFromFile), PWideChar(lToFile)))) then
        AddLog('Kan ikke flytte fil ' + lFromFile + ' til ' + lToFile);

      // Create whats needed to communicate with FlatPAY
      FlatPAYAction := TFlatPAYAction.Create;
      try
        // Deserialize job
        GetDefaultSerializer.DeserializeObject(lMyFileStr, FlatPAYAction);

        if (AnsiUpperCase(FlatPAYAction.KindOfJob) = AnsiUpperCase(FlatPAYAction.XReportName)) then
        begin
          AddLog(Format('JOB: %s', [FlatPAYAction.XReportName]));
          XReport(FALSE, FlatPAYAction.DisablePrint);
        end
        else if (AnsiUpperCase(FlatPAYAction.KindOfJob) = AnsiUpperCase(FlatPAYAction.ZReportName)) then
        begin
          AddLog(Format('JOB: %s', [FlatPAYAction.ZReportName]));
          ZReport(FALSE, FlatPAYAction.DisablePrint);
        end
        else if (AnsiUpperCase(FlatPAYAction.KindOfJob) = AnsiUpperCase(FlatPAYAction.HistoryName)) then
        begin
          AddLog(Format('JOB: %s', [FlatPAYAction.HistoryName]));
          HistoryReport(FALSE, FlatPAYAction.DisablePrint);
        end
        else if (AnsiUpperCase(FlatPAYAction.KindOfJob) = AnsiUpperCase(FlatPAYAction.LastTransactionName)) then
        begin
          AddLog(Format('JOB: %s', [FlatPAYAction.LastTransactionName]));
          GetLastTransaction(FALSE, FlatPAYAction.DisablePrint, FlatPAYAction.uti);
        end
        else if (AnsiUpperCase(FlatPAYAction.KindOfJob) = AnsiUpperCase(FlatPAYAction.GetStatusName)) then
        begin
          AddLog(Format('JOB: %s', [FlatPAYAction.GetStatusName]));
          GetStatus(FALSE, FlatPAYAction.DisablePrint);
        end
        else if (AnsiUpperCase(FlatPAYAction.KindOfJob) = AnsiUpperCase(FlatPAYAction.PaymentName)) then
        begin
          AddLog(Format('JOB: %s', [FlatPAYAction.PaymentName]));
          DoPayment(FALSE, FlatPAYAction);
        end;

      finally
        FlatPAYAction.Free;
      end;
    end;
  end;
end;

procedure TMyFlatPAYCommunication.PairWithTerminal;
var
  lFlatPAY: TFlatPAY;
  lResponse: TFlatPAY_Response;
  InputPairingCode: string;
begin
  if (FPort <> '') and (FIP <> '') and (FSerial <> '') and (FEndpointResource <> '') then
  begin
    InputPairingCode := InputBox('Pairing code', 'Indtast pairing code', '');

    if InputPairingCode <> '' then
    begin
      FlatPAYSetup.Free;
      FlatPAYSetup := TFlatPAYSetup.Create(FIP, FPort, FEndpointResource, FSerial, '');
      AddLog('Pair ');
      AddLog('  BaseURL: ' + FlatPAYSetup.BaseURL);
      AddLog('  Endpoint: ' + FlatPAYSetup.PairApi);
      FlatPAYSetup.PairingCode := InputPairingCode;
      lFlatPAY := TFlatPAY.Create;
      try
        if (lFlatPAY.PairWithTerminal(FlatPAYSetup, lResponse)) then
        begin
          AddLog('  Token: ' + (lResponse as TFlatPAY_TokenResponse).authToken);
          AddLog('  Token sat i indstillinger');
          FToken := (lResponse as TFlatPAY_TokenResponse).authToken;
          FConnected := TRUE;
          WriteSettingsToINIFile;
        end
        else
        begin
          FConnected := FALSE;
          AddLog('  Code: ' + intToStr((lResponse as TFlatPAY_ErrorResponse).StatusCode));
          AddLog('  Message: ' + #13#10 + (lResponse as TFlatPAY_ErrorResponse).StatusText);
        end;
        AddLog(' ');
        FreeAndNil(lResponse);
      finally
        FreeAndNil(lFlatPAY);
      end;
    end
    else
    begin
      ShowMessage('Ingen pairing code angivet');
      AddLog('Ingen pairing code angivet');
      FConnected := FALSE;
    end;
  end
  else
  begin
    ShowMessage('Kan ikke skabe forbindelse til terminal.'#13#10'Indstillinger er ikke opsat');
    FConnected := FALSE;
  end;
end;

procedure TMyFlatPAYCommunication.ReadSettingsFromINIFile;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\Settings.ini');
  try
    FIncomingJobFolder := IncludeTrailingPathDelimiter(iniFile.ReadString('COMMUNICATION', 'IncomingJobFolder', ''));
    FOutgoingResultFolder := IncludeTrailingPathDelimiter(iniFile.ReadString('COMMUNICATION', 'OutgoingResultFolder', ''));
    FLogFolder := IncludeTrailingPathDelimiter(iniFile.ReadString('COMMUNICATION', 'LogFolder', ''));
    FIP := iniFile.ReadString('COMMUNICATION', 'IP', '');
    FPort := iniFile.ReadString('COMMUNICATION', 'Port', '8080');
    FSerial := iniFile.ReadString('COMMUNICATION', 'Serial', '');
    FEndpointResource := iniFile.ReadString('COMMUNICATION', 'EndpointRessource', '/POSitiveWebLink/1.1.0/rest');
    FToken := iniFile.ReadString('COMMUNICATION', 'AuthToken', '');
    CreateSubFolders;
  finally
    iniFile.Free;
  end;
end;

procedure TMyFlatPAYCommunication.ShowSettings;
begin
  try
    frmSettings := TfrmSettings.Create(nil);
    frmSettings.edIncomingJobFolder.Text := FIncomingJobFolder;
    frmSettings.edOutgoingResultFolder.Text := FOutgoingResultFolder;
    frmSettings.edLogFolder.Text := FLogFolder;
    frmSettings.edIP.Text := FIP;
    frmSettings.edPort.Text := FPort;
    frmSettings.edSerial.Text := FSerial;
    frmSettings.edEndpointRessource.Text := FEndpointResource;
    frmSettings.edToken.Text := FToken;

    frmSettings.ShowModal;

    FIncomingJobFolder := IncludeTrailingPathDelimiter(frmSettings.edIncomingJobFolder.Text);
    FOutgoingResultFolder := IncludeTrailingPathDelimiter(frmSettings.edOutgoingResultFolder.Text);
    FLogFolder := IncludeTrailingPathDelimiter(frmSettings.edLogFolder.Text);
    FIP := frmSettings.edIP.Text;
    FPort := frmSettings.edPort.Text;
    FSerial := frmSettings.edSerial.Text;
    FEndpointResource := frmSettings.edEndpointRessource.Text;
    FToken := frmSettings.edToken.Text;

    AddLog('  IP: ' + FIP);
    AddLog('  Port: ' + FPort);
    AddLog('  Endpoint resource: ' + FEndpointResource);
    AddLog('  Serial: ' + FSerial);
    AddLog('  Token: ' + FToken);

    WriteSettingsToINIFile;
  finally
    FreeAndNil(frmSettings);
  end;
end;

procedure TMyFlatPAYCommunication.WriteSettingsToINIFile;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\Settings.ini');
  try
    iniFile.WriteString('COMMUNICATION', 'IncomingJobFolder', FIncomingJobFolder);
    iniFile.WriteString('COMMUNICATION', 'OutgoingResultFolder', FOutgoingResultFolder);
    iniFile.WriteString('COMMUNICATION', 'LogFolder', FLogFolder);
    iniFile.WriteString('COMMUNICATION', 'IP', FIP);
    iniFile.WriteString('COMMUNICATION', 'Port', FPort);
    iniFile.WriteString('COMMUNICATION', 'Serial', FSerial);
    iniFile.WriteString('COMMUNICATION', 'EndpointRessource', FEndpointResource);
    iniFile.WriteString('COMMUNICATION', 'AuthToken', FToken);
  finally
    iniFile.Free;
  end;

  CreateSubFolders;
end;

procedure TMyFlatPAYCommunication.XReport(aTest: Boolean; aDisablePrint: Boolean);
var
  lFlatPAY: TFlatPAY;
  lResponse: TFlatPAY_Response;
  lXreportJSONOutput: string;
begin
  CleanResultFolder;
  AddLog('X-Rapport');
  AddLog('  BaseURL: ' + FlatPAYSetup.BaseURL);
  AddLog('  Endpoint: ' + FlatPAYSetup.ReportsApi);

  lFlatPAY := TFlatPAY.Create;
  try
    FlatPAYSetup.DisablePrint := aDisablePrint;
    if (lFlatPAY.GetXReport(FlatPAYSetup, lResponse)) then
    begin
      AddLog('  reportType: ' + (lResponse as TFlatPAY_XReportResponse).reportType);
      AddLog('  reportResponse: ' + (lResponse as TFlatPAY_XReportResponse).reportResponse.ToString(TUseBoolStrs.true));
      AddLog('  saleCount: ' + (lResponse as TFlatPAY_XReportResponse).saleCount.ToString);
      AddLog('  refundCound: ' + (lResponse as TFlatPAY_XReportResponse).refundCount.ToString);
      AddLog('  completionCount: ' + (lResponse as TFlatPAY_XReportResponse).completionCount.ToString);
      AddLog('  cashbackCount: ' + (lResponse as TFlatPAY_XReportResponse).cashbackCount.ToString);
      AddLog('  gratuityCount: ' + (lResponse as TFlatPAY_XReportResponse).gratuityCount.ToString);
      AddLog('  saleAmount: ' + (lResponse as TFlatPAY_XReportResponse).saleAmount.ToString);
      AddLog('  refundAmount: ' + (lResponse as TFlatPAY_XReportResponse).refundAmount.ToString);
      AddLog('  completionAmount: ' + (lResponse as TFlatPAY_XReportResponse).completionAmount.ToString);
      AddLog('  cashbackAmount: ' + (lResponse as TFlatPAY_XReportResponse).cashbackAmount.ToString);
      AddLog('  gratuityAmount: ' + (lResponse as TFlatPAY_XReportResponse).gratuityAmount.ToString);

      if (not(aTest)) then
      begin
        lXreportJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_XReportResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.XReportName]), lXreportJSONOutput);
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, Format('%s %s', [FlatPAYAction.XReportName, FlatPAYAction.ResultOK]));
        FReturnAnswer.FJobCompleted := FlatPAYAction.XReportName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultOk;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end
    else
    begin
      AddLog('  Code: ' + intToStr((lResponse as TFlatPAY_ErrorResponse).StatusCode));
      AddLog('  Message: ' + #13#10 + (lResponse as TFlatPAY_ErrorResponse).StatusText);
      if (not(aTest)) then
      begin
        lXreportJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_ErrorResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.XReportName]), lXreportJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.XReportName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultError;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end;
    AddLog(' ');
    FreeAndNil(lResponse);
  finally
    FreeAndNil(lFlatPAY);
  end;
end;

procedure TMyFlatPAYCommunication.ZReport(aTest: Boolean; aDisablePrint: Boolean);
var
  lFlatPAY: TFlatPAY;
  lResponse: TFlatPAY_Response;
  lZreportJSONOutput: string;
begin
  CleanResultFolder;
  AddLog('X-Rapport');
  AddLog('  BaseURL: ' + FlatPAYSetup.BaseURL);
  AddLog('  Endpoint: ' + FlatPAYSetup.ReportsApi);

  lFlatPAY := TFlatPAY.Create;
  try
    FlatPAYSetup.DisablePrint := aDisablePrint;
    if (lFlatPAY.GetZReport(FlatPAYSetup, lResponse)) then
    begin
      AddLog('  reportType: ' + (lResponse as TFlatPAY_ZReportResponse).reportType);
      AddLog('  reportResponse: ' + (lResponse as TFlatPAY_ZReportResponse).reportResponse.ToString(TUseBoolStrs.true));
      AddLog('  saleCount: ' + (lResponse as TFlatPAY_ZReportResponse).saleCount.ToString);
      AddLog('  refundCound: ' + (lResponse as TFlatPAY_ZReportResponse).refundCount.ToString);
      AddLog('  completionCount: ' + (lResponse as TFlatPAY_ZReportResponse).completionCount.ToString);
      AddLog('  cashbackCount: ' + (lResponse as TFlatPAY_ZReportResponse).cashbackCount.ToString);
      AddLog('  gratuityCount: ' + (lResponse as TFlatPAY_ZReportResponse).gratuityCount.ToString);
      AddLog('  saleAmount: ' + (lResponse as TFlatPAY_ZReportResponse).saleAmount.ToString);
      AddLog('  refundAmount: ' + (lResponse as TFlatPAY_ZReportResponse).refundAmount.ToString);
      AddLog('  completionAmount: ' + (lResponse as TFlatPAY_ZReportResponse).completionAmount.ToString);
      AddLog('  cashbackAmount: ' + (lResponse as TFlatPAY_ZReportResponse).cashbackAmount.ToString);
      AddLog('  gratuityAmount: ' + (lResponse as TFlatPAY_ZReportResponse).gratuityAmount.ToString);

      if (not(aTest)) then
      begin
        lZreportJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_ZReportResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.ZReportName]), lZreportJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.ZReportName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultOk;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end
    else
    begin
      AddLog('  Code: ' + intToStr((lResponse as TFlatPAY_ErrorResponse).StatusCode));
      AddLog('  Message: ' + #13#10 + (lResponse as TFlatPAY_ErrorResponse).StatusText);
      if (not(aTest)) then
      begin
        lZreportJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_ErrorResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.ZReportName]), lZreportJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.ZReportName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultError;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end;
    AddLog(' ');
    FreeAndNil(lResponse);
  finally
    FreeAndNil(lFlatPAY);
  end;
end;

procedure TMyFlatPAYCommunication.HistoryReport(aTest: Boolean; aDisablePrint: Boolean);
var
  lFlatPAY: TFlatPAY;
  lResponse: TFlatPAY_Response;
  lHistoryreportJSONOutput: string;
begin
  CleanResultFolder;
  AddLog('History-Rapport');
  AddLog('  BaseURL: ' + FlatPAYSetup.BaseURL);
  AddLog('  Endpoint: ' + FlatPAYSetup.HistoryReportsApi);

  lFlatPAY := TFlatPAY.Create;
  try
    FlatPAYSetup.DisablePrint := aDisablePrint;
    if (lFlatPAY.GetHistoryReport(FlatPAYSetup, lResponse)) then
    begin
      AddLog('  Count: ' + (lResponse as TFlatPAY_HistoryResponse).History.Count.ToString);
      AddLog('  First record: ');
      AddLog('  cardPan: ' + (lResponse as TFlatPAY_HistoryResponse).History[0].cardPan);
      AddLog('  receieptNumber: ' + (lResponse as TFlatPAY_HistoryResponse).History[0].receieptNumber.ToString);
      AddLog('  retrievalReferenceNumber: ' + (lResponse as TFlatPAY_HistoryResponse).History[0].retrievalReferenceNumber);
      AddLog('  totalAmountTrans: ' + (lResponse as TFlatPAY_HistoryResponse).History[0].totalAmountTrans.ToString);
      AddLog('  transApproved: ' + (lResponse as TFlatPAY_HistoryResponse).History[0].TransApproved);
      AddLog('  transDateTime: ' + (lResponse as TFlatPAY_HistoryResponse).History[0].transDateTime);
      AddLog('  transType: ' + (lResponse as TFlatPAY_HistoryResponse).History[0].TransType);

      if (not(aTest)) then
      begin
        // Just to JSON
        lHistoryreportJSONOutput := GetDefaultSerializer.SerializeCollection((lResponse as TFlatPAY_HistoryResponse).History);
        // Delphi to delphi
        // lHistoryreportJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_HistoryResponse).History);
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.HistoryName]), lHistoryreportJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.HistoryName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultOK;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end
    else
    begin
      AddLog('  Code: ' + intToStr((lResponse as TFlatPAY_ErrorResponse).StatusCode));
      AddLog('  Message: ' + #13#10 + (lResponse as TFlatPAY_ErrorResponse).StatusText);
      if (not(aTest)) then
      begin
        lHistoryreportJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_ErrorResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.HistoryName]), lHistoryreportJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.HistoryName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultError;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end;
    AddLog(' ');
    FreeAndNil(lResponse);
  finally
    FreeAndNil(lFlatPAY);
  end;
end;

procedure TMyFlatPAYCommunication.GetLastTransaction(aTest: Boolean; aDisablePrint: Boolean; auti: string);
var
  lFlatPAY: TFlatPAY;
  lResponse: TFlatPAY_Response;
  ii: Integer;
  lLastTransactionJSONOutput: string;
  lCardHolderReceipt: string;
  lMerchantReceipt: string;
begin
  CleanResultFolder;
  AddLog('Get (last) transaction');
  AddLog('  BaseURL: ' + FlatPAYSetup.BaseURL);
  AddLog('  Endpoint: ' + FlatPAYSetup.GetTransactionApi);

  if (auti = '') then
  begin
    AddLog('  Ingen uti angivet');
    if (not(aTest)) then
    begin
      lLastTransactionJSONOutput := '{ "StatusCode" : -99, "StatusText" : "no uti entered" }';
      DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.LastTransactionName]), lLastTransactionJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.LastTransactionName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultOK;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
    end;
    exit;
  end;
  lFlatPAY := TFlatPAY.Create;
  try
    FlatPAYSetup.uti := auti;
    FlatPAYSetup.DisablePrint := aDisablePrint;
    if (lFlatPAY.GetPaymentRequest(FlatPAYSetup, lResponse)) then
    begin
      AddLog('  uti: ' + (lResponse as TFlatPAY_GetTransactionsRespons).uti);
      AddLog('  TransApproved: ' + (lResponse as TFlatPAY_GetTransactionsRespons).TransApproved.ToString);
      AddLog('  TransCancelled: ' + (lResponse as TFlatPAY_GetTransactionsRespons).TransCancelled.ToString);
      AddLog('  cardType: ' + (lResponse as TFlatPAY_GetTransactionsRespons).cardType);

      lCardHolderReceipt := '';
      for ii := 0 to length((lResponse as TFlatPAY_GetTransactionsRespons).cardholderReceipt) - 1 do
      begin
        lCardHolderReceipt := lCardHolderReceipt + #13#10 + (lResponse as TFlatPAY_GetTransactionsRespons).cardholderReceipt[ii];
      end;

      lMerchantReceipt := '';
      for ii := 0 to length((lResponse as TFlatPAY_GetTransactionsRespons).merchantReceipt) - 1 do
      begin
        lMerchantReceipt := lMerchantReceipt + #13#10 + (lResponse as TFlatPAY_GetTransactionsRespons).merchantReceipt[ii];
      end;

      if (not(aTest)) then
      begin
        lLastTransactionJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_GetTransactionsRespons));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.LastTransactionName]), lLastTransactionJSONOutput);
        DoWritetReturnResponse(FlatPAYAction.MerchantReceiptName, lMerchantReceipt);
        DoWritetReturnResponse(FlatPAYAction.CardHolderReceiptName, lCardHolderReceipt);
        FReturnAnswer.FJobCompleted := FlatPAYAction.LastTransactionName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultOK;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end
    else
    begin
      AddLog('  Code: ' + intToStr((lResponse as TFlatPAY_ErrorResponse).StatusCode));
      AddLog('  Message: ' + #13#10 + (lResponse as TFlatPAY_ErrorResponse).StatusText);
      if (not(aTest)) then
      begin
        lLastTransactionJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_ErrorResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.LastTransactionName]), lLastTransactionJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.LastTransactionName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultError;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end;
    AddLog(' ');
    FreeAndNil(lResponse);
  finally
    FreeAndNil(lFlatPAY);
  end;
end;

procedure TMyFlatPAYCommunication.GetStatus(aTest, aDisablePrint: Boolean);
var
  lFlatPAY: TFlatPAY;
  lResponse: TFlatPAY_Response;
  lMyDisplayData: TDisplayData;
  lGetStatusJSONOutput: string;
begin
  CleanResultFolder;
  AddLog('Get status');
  AddLog('  BaseURL: ' + FlatPAYSetup.BaseURL);
  AddLog('  Endpoint: ' + FlatPAYSetup.StatusRequestApi);

  lFlatPAY := TFlatPAY.Create;
  try
    if (lFlatPAY.GetStatusRequest(FlatPAYSetup, lResponse)) then
    begin
      AddLog('  Statuses: ' + (lResponse as TFlatPAY_StatusRequestResponse).Statuses);

      AddLog('  Count: ' + (lResponse as TFlatPAY_StatusRequestResponse).DisplayData.Count.ToString);
      lMyDisplayData := (lResponse as TFlatPAY_StatusRequestResponse).DisplayData.Last;
      AddLog('Last entry');
      AddLog('    Value: ' + lMyDisplayData.value.ToString);
      AddLog('    Description: ' + lMyDisplayData.description);

      if (not(aTest)) then
      begin
        lGetStatusJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_StatusRequestResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.GetStatusName]), lGetStatusJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.GetStatusName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultOK;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end
    else
    begin
      AddLog('  Code: ' + intToStr((lResponse as TFlatPAY_ErrorResponse).StatusCode));
      AddLog('  Message: ' + #13#10 + (lResponse as TFlatPAY_ErrorResponse).StatusText);
      if (not(aTest)) then
      begin
        lGetStatusJSONOutput := GetDefaultSerializer.SerializeObject((lResponse as TFlatPAY_ErrorResponse));
        DoWritetReturnResponse(Format('%s.json', [FlatPAYAction.GetStatusName]), lGetStatusJSONOutput);
        FReturnAnswer.FJobCompleted := FlatPAYAction.GetStatusName;
        FReturnAnswer.FJobStatus := FlatPAYAction.ResultError;
        DoWritetReturnResponse(FlatPAYAction.ResultFileName, GetDefaultSerializer.SerializeObject(FReturnAnswer));
      end;
    end;
    AddLog(' ');
    FreeAndNil(lResponse);
  finally
    FreeAndNil(lFlatPAY);
  end;
end;

//{ TFlatPAYAction }
//
//constructor TFlatPAYAction.Create;
//begin
//  FXReportName := 'x-report';
//  FZReportName := 'z-report';
//  FHistoryName := 'history';
//  FLastTransactionName := 'last-transaction';
//  FGetStatusName := 'get-status';
//  FPaymentName := 'payment';
//  FMerchantReceiptName := 'merchant-receipt.txt';
//  FCardHolderReceiptName := 'cardholder-receipt.txt';
//  FResultFileName := 'result.txt';
//  FResultOK := 'OK';
//  FResultError := 'ERROR';
//end;
//
//destructor TFlatPAYAction.Destroy;
//begin
//
//  inherited;
//end;

end.

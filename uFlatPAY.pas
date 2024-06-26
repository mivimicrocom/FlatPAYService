unit uFlatPAY;

(*
  This unit has been developed by:    Michael
  The documentation is here:          https://app.swaggerhub.com/apis-docs/PhilClarks/POSitiveWebLink/1.0.1#/admins/execute
  And we have a POSTMAN colleection.

  Statuses that can be returned accorind to swagger:

  0 "Transaction started",
  1 "Transaction Approved",
  2 "Transaction Declined",
  3 "Card type = MSR",
  4 "MSR Transaction Declined",
  5 "Card type EMV",
  6 "Card type CTLS",
  7 "CTLS Transaction Declined",
  8 "Card type = manual",
  9 "Transaction Cancelled",
  10 "Transaction Referred",
  11 "Transaction Finished",
  12 "GetCard Screen Displayed",
  13 "Manual Pan Screen Displayed",
  14 "Pin Requested(Offline)",
  15 "Pin Requested(Online)",
  16 "Host Approved",
  17 "Deferred Auth",
  18 "Reversal Approved",
  19 "Reversal Declined",
  20 "Transaction Declined",
  21 "Card User Cancelled",
  22 "GENAC2 Failed",
  23 "Printer General Error",
  24 "Printer Out Of Paper",
  25 "Amount High",
  26 "Amount Low",
  27 "Card Blocked",
  28 "Card Expired",
  29 "Card Type Not Allowed",
  30 "Invalid Card Number",
  31 "Pin Invalid Retry",
  32 "Pin Invalid Last Try",
  33 "Cashback Too High",
  34 "Pin Cvm Required",
  35 "Signature Cvm Required",
  36 "Locally Declined",
  37 "Host Declined",
  38 "Issuer Declined",
  39 "Issuer Unavailable",
  40 "Update In Progress Error",
  41 "Update Required Error",
  42 "Reversal Not Possible Error",
  43 "Transaction Type Not Allowed",
  44 "Login Failed",
  45 "Chip Unreadable",
  46 "Chip App Unsupported Please Swipe",
  47 "Chip Rid Unsupported Please Swipe",
  48 "Chip Invalid Please Swipe",
  49 "Chip not allowed Please swipe",
  50 "Chip detected Please Insert",
  51 "Chip detected Please Insert OR Force Fallback",
  52 "Insert Or Swipe Card",
  53 "Magnetic Strip Unreadable",
  54 "Magnetic Stripe Invalid",
  55 "Magnetic Stripe Not Allowed",
  56 "Manual Input Invalid",
  57 "Manual Input Invalid Length",
  58 "Manual Input Invalid Date",
  59 "Cashback Only Allowed Online",
  60 "Transaction Only Allowed Online",
  61 "Approval Code Invalid",
  62 "Password Invalid",
  63 "Close Batch Required",
  64 "Close Batch Not Required",
  65 "Technical Error",
  66 "Hardware Error"
*)

interface

uses
  System.Classes,
  System.NetEncoding,
  System.SysUtils,
  REST.Client,
  System.Generics.Collections,
  REST.Types,
  System.Json,
  MVCFramework,
  MVCFramework.Serializer.Defaults,
  MVCFramework.Serializer.Commons,
  MVCFramework.Serializer.JsonDataObjects;

var
  GlUTI: String;

type
  // General responsetype
  TFlatPAY_Response = class
  end;

  TFlatPAY_History = class
  private
    FcardPan: string;
    FreceieptNumber: Integer;
    FretrievalReferenceNumber: string;
    FtotalAmountTrans: Double;
    FtransApproved: string;
    FtransDateTime: string;
    FtransType: string;
  public
    [MVCNameAs('cardPan')]
    property cardPan: string read FcardPan write FcardPan;
    [MVCNameAs('receiptNumber')]
    property receieptNumber: Integer read FreceieptNumber write FreceieptNumber;
    [MVCNameAs('retrievalReferenceNumber')]
    property retrievalReferenceNumber: string read FretrievalReferenceNumber write FretrievalReferenceNumber;
    [MVCNameAs('totalAmountTrans')]
    property totalAmountTrans: Double read FtotalAmountTrans write FtotalAmountTrans;
    [MVCNameAs('transApproved')]
    property transApproved: string read FtransApproved write FtransApproved;
    [MVCNameAs('transDateTime')]
    property transDateTime: string read FtransDateTime write FtransDateTime;
    [MVCNameAs('transType')]
    property transType: string read FtransType write FtransType;
  end;

  TFlatPAY_HistoryResponse = class(TFlatPAY_Response)
  private
    FHistory: TObjectList<TFlatPAY_History>;
  public
    constructor Create;
    destructor Destroy; override;
    property History: TObjectList<TFlatPAY_History> read FHistory write FHistory;
  end;

  // Responsetype when doing a pair where serialnumber and a token will be returned
  TFlatPAY_TokenResponse = class(TFlatPAY_Response)
  private
    FserialNumber: string;
    FauthToken: string;
  public
    property serialNumber: string read FserialNumber write FserialNumber;
    property authToken: string read FauthToken write FauthToken;
  end;

  // ResponseType to Xreport
  TFlatPAY_XReportResponse = class(TFlatPAY_Response)
  private
    FcashbackAmount: Double;
    FcashbackCount: Integer;
    FcompletionAmount: Double;
    FcompletionCount: Integer;
    FgratuityAmount: Double;
    FgratuityCount: Integer;
    FrefundAmount: Double;
    FrefundCount: Integer;
    FreportResponse: boolean;
    FreportType: string;
    FsaleAmount: Double;
    FsaleCount: Integer;
    FpenniesAmount: Double;
    FpenniesCotu: Integer;
  public
    [MVCNameAs('cashbackAmount')]
    property cashbackAmount: Double read FcashbackAmount write FcashbackAmount;
    [MVCNameAs('cashbackCount')]
    property cashbackCount: Integer read FcashbackCount write FcashbackCount;
    [MVCNameAs('completionAmount')]
    property completionAmount: Double read FcompletionAmount write FcompletionAmount;
    [MVCNameAs('completionCount')]
    property completionCount: Integer read FcompletionCount write FcompletionCount;
    [MVCNameAs('gratuityAmount')]
    property gratuityAmount: Double read FgratuityAmount write FgratuityAmount;
    [MVCNameAs('gratuityCount')]
    property gratuityCount: Integer read FgratuityCount write FgratuityCount;
    [MVCNameAs('penniesAmount')]
    property penniesAmount: Double read FpenniesAmount write FpenniesAmount;
    [MVCNameAs('penniesCotu')]
    property penniesCotu: Integer read FpenniesCotu write FpenniesCotu;
    [MVCNameAs('refundAmount')]
    property refundAmount: Double read FrefundAmount write FrefundAmount;
    [MVCNameAs('refundCount')]
    property refundCount: Integer read FrefundCount write FrefundCount;
    [MVCNameAs('reportResponse')]
    property reportResponse: boolean read FreportResponse write FreportResponse;
    [MVCNameAs('reportType')]
    property reportType: string read FreportType write FreportType;
    [MVCNameAs('saleAmount')]
    property saleAmount: Double read FsaleAmount write FsaleAmount;
    [MVCNameAs('saleCount')]
    property saleCount: Integer read FsaleCount write FsaleCount;
  end;

  (* ResponseType to Zreport *)
  TFlatPAY_ZReportResponse = class(TFlatPAY_Response)
  private
    FcashbackAmount: Double;
    FcashbackCount: Integer;
    FcompletionAmount: Double;
    FcompletionCount: Integer;
    FgratuityAmount: Double;
    FgratuityCount: Integer;
    FrefundAmount: Double;
    FrefundCount: Integer;
    FreportResponse: boolean;
    FreportType: string;
    FsaleAmount: Double;
    FsaleCount: Integer;
    FpenniesAmount: Double;
    FpenniesCotu: Integer;
  public
    [MVCNameAs('cashbackAmount')]
    property cashbackAmount: Double read FcashbackAmount write FcashbackAmount;
    [MVCNameAs('cashbackCountcashbackCount')]
    property cashbackCount: Integer read FcashbackCount write FcashbackCount;
    [MVCNameAs('completionAmount')]
    property completionAmount: Double read FcompletionAmount write FcompletionAmount;
    [MVCNameAs('completionCount')]
    property completionCount: Integer read FcompletionCount write FcompletionCount;
    [MVCNameAs('gratuityAmount')]
    property gratuityAmount: Double read FgratuityAmount write FgratuityAmount;
    [MVCNameAs('gratuityCount')]
    property gratuityCount: Integer read FgratuityCount write FgratuityCount;
    [MVCNameAs('penniesAmount')]
    property penniesAmount: Double read FpenniesAmount write FpenniesAmount;
    [MVCNameAs('penniesCotu')]
    property penniesCotu: Integer read FpenniesCotu write FpenniesCotu;
    [MVCNameAs('refundAmount')]
    property refundAmount: Double read FrefundAmount write FrefundAmount;
    [MVCNameAs('refundCount')]
    property refundCount: Integer read FrefundCount write FrefundCount;
    [MVCNameAs('reportResponse')]
    property reportResponse: boolean read FreportResponse write FreportResponse;
    [MVCNameAs('reportType')]
    property reportType: string read FreportType write FreportType;
    [MVCNameAs('saleAmount')]
    property saleAmount: Double read FsaleAmount write FsaleAmount;
    [MVCNameAs('saleCount')]
    property saleCount: Integer read FsaleCount write FsaleCount;
  end;

  (* Errorresponse type *)
  TFlatPAY_ErrorResponse = class(TFlatPAY_Response)
  private
    FStatusCode: Integer;
    FStatusText: string;
  public
    property StatusCode: Integer read FStatusCode write FStatusCode;
    property StatusText: string read FStatusText write FStatusText;
  end;

  // Start transaction response type
  TFlatPAY_StartTransactionRepsons = class(TFlatPAY_Response)
  private
    FamountCashback: Integer;
    FamountGratuity: Integer;
    FamountTrans: Integer;
    FtransType: string;
    Futi: string;
  public
    [MVCNameAs('amountCashback')]
    property amountCashback: Integer read FamountCashback write FamountCashback;
    [MVCNameAs('amountGratuity')]
    property amountGratuity: Integer read FamountGratuity write FamountGratuity;
    [MVCNameAs('amountTrans')]
    property amountTrans: Integer read FamountTrans write FamountTrans;
    [MVCNameAs('transType')]
    property transType: string read FtransType write FtransType;
    [MVCNameAs('uti')]
    property uti: string read Futi write Futi;
  end;

  (* Cancel transaction response type *)
  TFlatPAY_CancelTransactionRespons = class(TFlatPAY_Response)
  private
    FamountCashback: Integer;
    FamountDiscount: Integer;
    FamountGratuity: Integer;
    FamountTrans: Integer;
    FcardPan: string;
    FcardPanSequenceNumber: string;
    FcardScheme: string;
    FcardType: string;
    FcvmPinVerified: boolean;
    FcvmSigRequired: boolean;
    FerrorCode: string;
    FerrorText: string;
    FmerchantReference: string;
    FpenniesAmount: Integer;
    FreceiptNumber: Integer;
    FsoftwareVersion: string;
    Fstan: string;
    FterminalId: string;
    FtransApproved: boolean;
    FtransCancelled: boolean;
    FtransCurrencyCode: string;
    FtransDateTimeEpoch: Integer;
    FtransPartiallyApproved: boolean;
    FtransType: string;
    Futi: string;
    FStatuses: string;
  public
    [MVCNameAs('amountCashback')]
    property amountCashback: Integer read FamountCashback write FamountCashback;
    [MVCNameAs('amountDiscount')]
    property amountDiscount: Integer read FamountDiscount write FamountDiscount;
    [MVCNameAs('amountGratuity')]
    property amountGratuity: Integer read FamountGratuity write FamountGratuity;
    [MVCNameAs('amountTrans')]
    property amountTrans: Integer read FamountTrans write FamountTrans;
    [MVCNameAs('cardPan')]
    property cardPan: string read FcardPan write FcardPan;
    [MVCNameAs('cardPanSequenceNumber')]
    property cardPanSequenceNumber: string read FcardPanSequenceNumber write FcardPanSequenceNumber;
    [MVCNameAs('cardScheme')]
    property cardScheme: string read FcardScheme write FcardScheme;
    [MVCNameAs('cardType')]
    property cardType: string read FcardType write FcardType;
    [MVCNameAs('cvmPinVerified')]
    property cvmPinVerified: boolean read FcvmPinVerified write FcvmPinVerified;
    [MVCNameAs('cvmSigRequired')]
    property cvmSigRequired: boolean read FcvmSigRequired write FcvmSigRequired;
    [MVCNameAs('errorCode')]
    property errorCode: string read FerrorCode write FerrorCode;
    [MVCNameAs('errorText')]
    property errorText: string read FerrorText write FerrorText;
    [MVCNameAs('merchantReference')]
    property merchantReference: string read FmerchantReference write FmerchantReference;
    [MVCNameAs('penniesAmount')]
    property penniesAmount: Integer read FpenniesAmount write FpenniesAmount;
    [MVCNameAs('receiptNumber')]
    property receiptNumber: Integer read FreceiptNumber write FreceiptNumber;
    [MVCNameAs('softwareVersion')]
    property softwareVersion: string read FsoftwareVersion write FsoftwareVersion;
    [MVCNameAs('stan')]
    property stan: string read Fstan write Fstan;
    [MVCNameAs('terminalId')]
    property terminalId: string read FterminalId write FterminalId;
    [MVCNameAs('transApproved')]
    property transApproved: boolean read FtransApproved write FtransApproved;
    [MVCNameAs('transCancelled')]
    property transCancelled: boolean read FtransCancelled write FtransCancelled;
    [MVCNameAs('transCurrencyCode')]
    property transCurrencyCode: string read FtransCurrencyCode write FtransCurrencyCode;
    [MVCNameAs('transDateTimeEpoch')]
    property transDateTimeEpoch: Integer read FtransDateTimeEpoch write FtransDateTimeEpoch;
    [MVCNameAs('transPartiallyApproved')]
    property transPartiallyApproved: boolean read FtransPartiallyApproved write FtransPartiallyApproved;
    [MVCNameAs('transType')]
    property transType: string read FtransType write FtransType;
    [MVCNameAs('uti')]
    property uti: string read Futi write Futi;
    [MVCNameAs('Statuses')]
    property Statuses: string read FStatuses write FStatuses;
  end;

  // TReceipt = Array[1..100] of string;

  // respons to Get Transaction status. Its one long string.
  TFlatPAY_GetTransactionsRespons = class(TFlatPAY_Response)
  private
    FamountCashback: Integer;
    FamountDiscount: Integer;
    FamountGratuity: Integer;
    FamountTrans: Integer;
    FauthorisationCode: string;
    FcardExpiryDate: string;
    FcardPan: string;
    FcardPanSequenceNumber: string;
    FcardScheme: string;
    FcardStartDate: string;
    FcardType: string;
    FcardholderReceipt: TArray<string>;
    FcvmPinVerified: boolean;
    FcvmSigRequired: boolean;
    FemvAId: string;
    FemvCryptogramType: string;
    FemvTsi: string;
    FemvTvr: string;
    FerrorCode: string;
    FerrorText: string;
    FmerchantReceipt: TArray<string>;
    FmerchantReference: string;
    FpaymentId: string;
    FpenniesAmount: Integer;
    FreceiptNumber: Integer;
    FresponseCode: string;
    FretrievalReferenceNumber: string;
    FsoftwareVersion: string;
    Fstan: string;
    FterminalId: string;
    FtransApproved: boolean;
    FtransCancelled: boolean;
    FtransCurrencyCode: string;
    FtransDateTime: string;
    FtransType: string;
    FemvCryptogram: string;
    Futi: string;
  public
    [MVCNameAs('amountCashback')]
    property amountCashback: Integer read FamountCashback write FamountCashback;
    [MVCNameAs('amountDiscount')]
    property amountDiscount: Integer read FamountDiscount write FamountDiscount;
    [MVCNameAs('amountGratuity')]
    property amountGratuity: Integer read FamountGratuity write FamountGratuity;
    [MVCNameAs('amountTrans')]
    property amountTrans: Integer read FamountTrans write FamountTrans;
    [MVCNameAs('authorisationCode')]
    property authorisationCode: string read FauthorisationCode write FauthorisationCode;
    [MVCNameAs('cardExpiryDate')]
    property cardExpiryDate: string read FcardExpiryDate write FcardExpiryDate;
    [MVCNameAs('cardPan')]
    property cardPan: string read FcardPan write FcardPan;
    [MVCNameAs('cardPanSequenceNumber')]
    property cardPanSequenceNumber: string read FcardPanSequenceNumber write FcardPanSequenceNumber;
    [MVCNameAs('cardScheme')]
    property cardScheme: string read FcardScheme write FcardScheme;
    [MVCNameAs('cardStartDate')]
    property cardStartDate: string read FcardStartDate write FcardStartDate;
    [MVCNameAs('cardType')]
    property cardType: string read FcardType write FcardType;
    [MVCNameAs('cardholderReceipt')]
    property cardholderReceipt: TArray<string> read FcardholderReceipt write FcardholderReceipt;
    [MVCNameAs('cvmPinVerified')]
    property cvmPinVerified: boolean read FcvmPinVerified write FcvmPinVerified;
    [MVCNameAs('cvmSigRequired')]
    property cvmSigRequired: boolean read FcvmSigRequired write FcvmSigRequired;
    [MVCNameAs('emvAId')]
    property emvAId: string read FemvAId write FemvAId;
    [MVCNameAs('emvCryptogramType')]
    property emvCryptogramType: string read FemvCryptogramType write FemvCryptogramType;
    [MVCNameAs('emvTsi')]
    property emvTsi: string read FemvTsi write FemvTsi;
    [MVCNameAs('emvTvr')]
    property emvTvr: string read FemvTvr write FemvTvr;
    [MVCNameAs('errorCode')]
    property errorCode: string read FerrorCode write FerrorCode;
    [MVCNameAs('errorText')]
    property errorText: string read FerrorText write FerrorText;
    [MVCNameAs('merchantReceipt')]
    property merchantReceipt: TArray<string> read FmerchantReceipt write FmerchantReceipt;
    [MVCNameAs('merchantReference')]
    property merchantReference: string read FmerchantReference write FmerchantReference;
    [MVCNameAs('paymentId')]
    property paymentId: string read FpaymentId write FpaymentId;
    [MVCNameAs('penniesAmount')]
    property penniesAmount: Integer read FpenniesAmount write FpenniesAmount;
    [MVCNameAs('receiptNumber')]
    property receiptNumber: Integer read FreceiptNumber write FreceiptNumber;
    [MVCNameAs('responseCode')]
    property responseCode: string read FresponseCode write FresponseCode;
    [MVCNameAs('retrievalReferenceNumber')]
    property retrievalReferenceNumber: string read FretrievalReferenceNumber write FretrievalReferenceNumber;
    [MVCNameAs('softwareVersion')]
    property softwareVersion: string read FsoftwareVersion write FsoftwareVersion;
    [MVCNameAs('stan')]
    property stan: string read Fstan write Fstan;
    [MVCNameAs('terminalId')]
    property terminalId: string read FterminalId write FterminalId;
    [MVCNameAs('transApproved')]
    property transApproved: boolean read FtransApproved write FtransApproved;
    [MVCNameAs('transCancelled')]
    property transCancelled: boolean read FtransCancelled write FtransCancelled;
    [MVCNameAs('transCurrencyCode')]
    property transCurrencyCode: string read FtransCurrencyCode write FtransCurrencyCode;
    [MVCNameAs('transDateTime')]
    property transDateTime: string read FtransDateTime write FtransDateTime;
    [MVCNameAs('transType')]
    property transType: string read FtransType write FtransType;
    [MVCNameAs('emvCryptogram')]
    property emvCryptogram: string read FemvCryptogram write FemvCryptogram;
    [MVCNameAs('uti')]
    property uti: string read Futi write Futi;
  end;

  // Display data which are returned as an array from GET Status
  TDisplayData = class
  private
    FValue: Integer;
    FDescription: string;
  public
    property value: Integer read FValue write FValue;
    property description: string read FDescription write FDescription;
  end;

  // Status request resp�ns.
  TFlatPAY_StatusRequestResponse = class(TFlatPAY_Response)
  private
    FStatuses: string;
    FDisplayData: TObjectList<TDisplayData>;
    FCount: Integer;
  public
    property Statuses: string read FStatuses write FStatuses;
    property DisplayData: TObjectList<TDisplayData> read FDisplayData write FDisplayData;
    property Count: Integer read FCount write FCount;
    constructor Create;
    destructor Destroy; Override;
  end;

  // Class holds settings to communicate with FlatPAY terminal
  TFlatPAYSetup = class
  private
    FIP: string;
    FPort: string;
    FBaseUrl: string;
    FPairApi: string;
    FReportsApi: string;
    FHistoryReportsApi: string;
    FSerial: string;
    FPairingCode: string;
    FserialNumber: string;
    FauthToken: string;
    FDisablePrint: boolean;
    FStartTransactionApi: string;
    FGetTransactionApi: string;
    FDeleteTransactionApi: String;
    FStatusRequestApi: string;
    Futi: string;
  public
    constructor Create(aIP, aPort, aEndPointResource, aSerial, aAuthToken: string);
    property IP: string read FIP write FIP;
    property Port: string read FPort write FPort;
    property BaseUrl: string read FBaseUrl;
    property PairApi: string read FPairApi;
    property ReportsApi: string read FReportsApi;
    property StatusRequestApi: string read FStatusRequestApi write FStatusRequestApi;
    property HistoryReportsApi: string read FHistoryReportsApi write FHistoryReportsApi;
    property StartTransactionApi: string read FStartTransactionApi write FStartTransactionApi;
    property GetTransactionApi: string read FGetTransactionApi write FGetTransactionApi;
    property DeleteTransactionApi: String read FDeleteTransactionApi write FDeleteTransactionApi;
    property Serial: string read FSerial;
    property PairingCode: string read FPairingCode write FPairingCode;
    property serialNumber: string read FserialNumber;
    property authToken: string read FauthToken write FauthToken;
    property DisablePrint: boolean read FDisablePrint write FDisablePrint;
    property uti: string read Futi write Futi;
  end;

  // Class that handle all communication with FlatPAY
  TFlatPAYHTTP = class
  private
    FClient: TRestClient;
    FResponse: TRestResponse;
    FRequest: TRestRequest;
  public
    property Client: TRestClient read FClient write FClient;
    property Response: TRestResponse read FResponse write FResponse;
    property Request: TRestRequest read FRequest write FRequest;
    constructor Create(aFlatPAYSetup: TFlatPAYSetup; aMethod: TRESTRequestMethod; aUseTokenAuth: boolean = FALSE);
    destructor Destroy; override;
  end;

  // Class to hold payment request
  TFlatPAY_PaymentRequest = class
  private
    FtransType: string; // [ SALE, REFUND, REVERSAL, PREAUTH, COMPLETION ]
    FamountTrans: Double;
    FamountGratuity: Double;
    FamountCashback: Double;
    FReference: string;
    FLanguage: string;
    Futi: string;
  public
    constructor Create(aTransType: string; aAmount: Double; aGratuity: Double; aCashback: Double; aReference: String; aLanguage: String; auti: String); overload;
    destructor Destroy; override;
    [MVCNameAs('transType')]
    property transType: string read FtransType write FtransType;
    [MVCNameAs('amountTrans')]
    property amountTrans: Double read FamountTrans write FamountTrans;
    [MVCNameAs('amountGratuity')]
    property amountGratuity: Double read FamountGratuity write FamountGratuity;
    [MVCNameAs('amountCashback')]
    property amountCashback: Double read FamountCashback write FamountCashback;
    [MVCNameAs('reference')]
    property reference: string read FReference write FReference;
    [MVCNameAs('language')]
    property language: string read FLanguage write FLanguage;
    [MVCNameAs('uti')]
    property uti: string read Futi write Futi;
  end;

  // Class that holds all functions needed to use FlatPAY terminal
  TFlatPAY = class
  private
    { private declarations }
    procedure SetupTokenRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
    procedure SetupXReportRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
    procedure SetupZReportRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
    procedure SetupHistoryReportRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
    procedure SetupPaymentRequest(aFlatSetup: TFlatPAYSetup; aFlatPAY_Payment: TFlatPAY_PaymentRequest; var aFlatPAYHttp: TFlatPAYHTTP);
    procedure SetupCancelPaymentRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
    procedure SetupGetPaymentRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
    procedure SetupGetStatusRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
  Public
    { public declarations }
    function PairWithTerminal(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
    function GetXReport(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
    function GetZReport(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
    function GetHistoryReport(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
    function StartPaymentRequest(aFlatPAYSetup: TFlatPAYSetup; aFlatPAY_Payment: TFlatPAY_PaymentRequest; out aResponse: TFlatPAY_Response): boolean;
    function CancelPaymentRequest(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
    function GetPaymentRequest(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
    function GetStatusRequest(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response; aLogCall: boolean = FALSE): boolean;
  end;

  TFlatPAYAction = class
  private
    { private declarations }
    FKindOfJob: string;
    FtransType: String;
    FAmount: Double;
    FGratiuty: Double;
    FCashBack: Double;
    FReference: string;
    FLanguage: string;
    FDisablePrint: boolean;
    Futi: string;
    FXReportName: String;
    FZReportName: string;
    FHistoryName: string;
    FLastTransactionName: string;
    FCancelTransaction: string;
    FGetStatusName: string;
    FPaymentName: string;
    FMerchantReceiptName: string;
    FCardHolderReceiptName: string;
    FResultFileName: string;
    FResultOK: string;
    FResultError: string;
  public
    constructor Create;
    destructor Destroy; override;
    { public declarations }
    [MVCNameAs('KindOfJob')]
    property KindOfJob: string read FKindOfJob write FKindOfJob;
    [MVCNameAs('TransType')]
    property transType: String read FtransType write FtransType;
    [MVCNameAs('Amount')]
    property Amount: Double read FAmount write FAmount;
    [MVCNameAs('Gratiuty')]
    property Gratiuty: Double read FGratiuty write FGratiuty;
    [MVCNameAs('CashBack')]
    property CashBack: Double read FCashBack write FCashBack;
    [MVCNameAs('Reference')]
    property reference: string read FReference write FReference;
    [MVCNameAs('Language')]
    property language: string read FLanguage write FLanguage;
    [MVCNameAs('DisablePrint')]
    property DisablePrint: boolean read FDisablePrint write FDisablePrint;
    [MVCNameAs('uti')]
    property uti: string read Futi write Futi;
    [MVCDoNotSerialize]
    property XReportName: String read FXReportName;
    [MVCDoNotSerialize]
    property ZReportName: string read FZReportName;
    [MVCDoNotSerialize]
    property HistoryName: string read FHistoryName;
    [MVCDoNotSerialize]
    property LastTransactionName: string read FLastTransactionName;
    [MVCDoNotSerialize]
    property CancelTransaction: string read FCancelTransaction;
    [MVCDoNotSerialize]
    property GetStatusName: string read FGetStatusName write FGetStatusName;
    [MVCDoNotSerialize]
    property PaymentName: string read FPaymentName write FPaymentName;
    [MVCDoNotSerialize]
    property MerchantReceiptName: string read FMerchantReceiptName write FMerchantReceiptName;
    [MVCDoNotSerialize]
    property CardHolderReceiptName: string read FCardHolderReceiptName write FCardHolderReceiptName;
    [MVCDoNotSerialize]
    property ResultFileName: string read FResultFileName write FResultFileName;
    property ResultOK: string read FResultOK;
    [MVCDoNotSerialize]
    property ResultError: string read FResultError;
  end;

implementation

uses
  uMain;

constructor TFlatPAY_StatusRequestResponse.Create;
begin
  FDisplayData := TObjectList<TDisplayData>.Create(TRUE);
end;

destructor TFlatPAY_StatusRequestResponse.Destroy;
begin
  FDisplayData.Free;
  Inherited;
end;

constructor TFlatPAYSetup.Create(aIP, aPort, aEndPointResource, aSerial, aAuthToken: string);
begin
  FIP := aIP;
  FPort := aPort;
  FSerial := aSerial;
  FauthToken := aAuthToken;

  FBaseUrl := Format('https://%s:%s%s', [aIP, aPort, aEndPointResource]);
  FPairApi := '/pair';
  FReportsApi := '/reports';
  FStatusRequestApi := '/status';
  FHistoryReportsApi := '/historyReports';
  FStartTransactionApi := '/transaction';
  FGetTransactionApi := '/transaction';
  FDeleteTransactionApi := '/transaction';

  FserialNumber := '';
  Futi := '';
  FDisablePrint := TRUE;
end;

constructor TFlatPAYHTTP.Create(aFlatPAYSetup: TFlatPAYSetup; aMethod: TRESTRequestMethod; aUseTokenAuth: boolean = FALSE);
begin
  FClient := TRestClient.Create(aFlatPAYSetup.BaseUrl);
  FRequest := TRestRequest.Create(FClient);
  FResponse := TRestResponse.Create(FClient);
  FRequest.Method := aMethod;

  if aUseTokenAuth then
  begin
    FRequest.Params.AddHeader('Authorization', 'Bearer ' + aFlatPAYSetup.authToken).Options := [TRESTRequestParameterOption.poDoNotEncode];
  end;

  FResponse.ContentType := 'application/json';

  FRequest.Response := FResponse;
end;

destructor TFlatPAYHTTP.Destroy;
begin
  FClient.Free;
  inherited;
end;

procedure TFlatPAY.SetupCancelPaymentRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmDELETE, TRUE);
  aFlatPAYHttp.Request.Resource := Format('%s?tid=%s', [aFlatSetup.FGetTransactionApi, aFlatSetup.Serial]);
end;

procedure TFlatPAY.SetupGetPaymentRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmGET, TRUE);
  aFlatPAYHttp.Request.Resource := Format('%s?uti=%s&tid=%s', [aFlatSetup.FDeleteTransactionApi, aFlatSetup.uti, aFlatSetup.Serial]);
end;

procedure TFlatPAY.SetupGetStatusRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmGET, TRUE);
  aFlatPAYHttp.Request.Resource := Format('%s?tid=%s', [aFlatSetup.FStatusRequestApi, aFlatSetup.Serial]);
  //Added:   uti as query parameter. According to swagger 29-05-2024
//  aFlatPAYHttp.Request.Resource := Format('%s?uti=%s&tid=%s', [aFlatSetup.FStatusRequestApi, aFlatSetup.uti, aFlatSetup.Serial]);
end;

procedure TFlatPAY.SetupHistoryReportRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmGET, TRUE);
  aFlatPAYHttp.Request.Resource := Format('%s?tid=%s&disablePrinting=%s', [aFlatSetup.HistoryReportsApi, aFlatSetup.Serial, aFlatSetup.DisablePrint.ToString(TUseBoolStrs.True)]);
end;

procedure TFlatPAY.SetupPaymentRequest(aFlatSetup: TFlatPAYSetup; aFlatPAY_Payment: TFlatPAY_PaymentRequest; var aFlatPAYHttp: TFlatPAYHTTP);
var
  ajstr: string;
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmPOST, TRUE);
  aFlatPAYHttp.Request.Resource := Format('%s?tid=%s&silent=false&disablePrinting=%s', [
    aFlatSetup.FStartTransactionApi,
    aFlatSetup.Serial,
    aFlatSetup.DisablePrint.ToString(TUseBoolStrs.True)]);
  ajstr := GetDefaultSerializer.SerializeObject(aFlatPAY_Payment);
  aFlatPAYHttp.Request.AddBody(ajstr, ctAPPLICATION_JSON);
end;

procedure TFlatPAY.SetupTokenRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmGET);
  aFlatPAYHttp.Request.Resource := aFlatSetup.FPairApi + '?tid=' + aFlatSetup.FSerial + '&pairingCode=' + aFlatSetup.FPairingCode;
end;

procedure TFlatPAY.SetupXReportRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmGET, TRUE);
  aFlatPAYHttp.Request.Resource := Format('%s?tid=%s&disablePrinting=%s&reportType=XReport',
    [aFlatSetup.ReportsApi, aFlatSetup.Serial, aFlatSetup.DisablePrint.ToString(TUseBoolStrs.True)]);
end;

procedure TFlatPAY.SetupZReportRequest(aFlatSetup: TFlatPAYSetup; var aFlatPAYHttp: TFlatPAYHTTP);
begin
  aFlatPAYHttp := TFlatPAYHTTP.Create(aFlatSetup, rmGET, TRUE);
  aFlatPAYHttp.Request.Resource := Format('%s?tid=%s&disablePrinting=%s&reportType=ZReport',
    [aFlatSetup.ReportsApi, aFlatSetup.Serial, aFlatSetup.DisablePrint.ToString(TUseBoolStrs.True)]);
end;

function TFlatPAY.CancelPaymentRequest(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
begin
  result := FALSE;
  SetupCancelPaymentRequest(aFlatPAYSetup, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Timeout := 2000;
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200:
          begin
            result := TRUE;
            aResponse := TFlatPAY_CancelTransactionRespons.Create;
            GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);
            result := (aResponse as TFlatPAY_CancelTransactionRespons).transCancelled;
          end;
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

function TFlatPAY.GetPaymentRequest(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
begin
  result := FALSE;
  SetupGetPaymentRequest(aFlatPAYSetup, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Timeout := 2000;
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200, 206:
          begin
            result := TRUE;
            aResponse := TFlatPAY_GetTransactionsRespons.Create;
            GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);

          end
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

function TFlatPAY.GetStatusRequest(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response; aLogCall: boolean = FALSE): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
begin
  result := FALSE;
  SetupGetStatusRequest(aFlatPAYSetup, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Timeout := 2000;
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200:
          begin
            result := TRUE;
            aResponse := TFlatPAY_StatusRequestResponse.Create;
            GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);
          end;
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

function TFlatPAY.GetHistoryReport(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
begin
  result := FALSE;
  SetupHistoryReportRequest(aFlatPAYSetup, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200:
          begin
            result := TRUE;
            aResponse := TFlatPAY_HistoryResponse.Create;
            GetDefaultSerializer.DeserializeCollection(lFlatPAYHttp.Response.Content, (aResponse as TFlatPAY_HistoryResponse).FHistory, TFlatPAY_History);
          end
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

function TFlatPAY.GetXReport(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
begin
  result := FALSE;
  SetupXReportRequest(aFlatPAYSetup, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200:
          begin
            aResponse := TFlatPAY_XReportResponse.Create;
            GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);
            result := (aResponse as TFlatPAY_XReportResponse).FreportResponse;
          end;
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

function TFlatPAY.GetZReport(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
begin
  result := FALSE;
  SetupZReportRequest(aFlatPAYSetup, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200:
          begin
            // Empty answer:  'No transactions to reconcile'
            if (lFlatPAYHttp.Response.Content = 'No transactions to reconcile') then
            begin
              result := FALSE;
              aResponse := TFlatPAY_ErrorResponse.Create;
              (aResponse as TFlatPAY_ErrorResponse).StatusCode := 200;
              (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.Content;
            end
            else
            begin
              aResponse := TFlatPAY_ZReportResponse.Create;
              GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);
              result := (aResponse as TFlatPAY_ZReportResponse).FreportResponse;
            end;
          end;
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

function TFlatPAY.StartPaymentRequest(aFlatPAYSetup: TFlatPAYSetup; aFlatPAY_Payment: TFlatPAY_PaymentRequest; out aResponse: TFlatPAY_Response): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
  lStr: string;
begin
  result := FALSE;
  SetupPaymentRequest(aFlatPAYSetup, aFlatPAY_Payment, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Timeout := 2000;
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200, 201:
          begin
            result := TRUE;

            aResponse := TFlatPAY_StartTransactionRepsons.Create;
            GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);
            aFlatPAYSetup.uti := (aResponse as TFlatPAY_StartTransactionRepsons).uti;
            result := (aResponse as TFlatPAY_StartTransactionRepsons).uti <> '';
          end;
        206: //Transaction in progress
          begin
            result := TRUE;

            aResponse := TFlatPAY_StartTransactionRepsons.Create;
            GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);
            aFlatPAYSetup.uti := (aResponse as TFlatPAY_StartTransactionRepsons).uti;
            result := (aResponse as TFlatPAY_StartTransactionRepsons).uti <> '';
          end;
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
          aFlatPAYSetup.uti := '';
          lStr := lFlatPAYHttp.Response.Content;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

function TFlatPAY.PairWithTerminal(aFlatPAYSetup: TFlatPAYSetup; out aResponse: TFlatPAY_Response): boolean;
var
  lFlatPAYHttp: TFlatPAYHTTP;
begin
  result := FALSE;
  SetupTokenRequest(aFlatPAYSetup, lFlatPAYHttp);
  try
    try
      lFlatPAYHttp.Request.Execute;
      case lFlatPAYHttp.Response.StatusCode of
        200:
          begin
            aResponse := TFlatPAY_TokenResponse.Create;
            GetDefaultSerializer.DeserializeObject(lFlatPAYHttp.Response.Content, aResponse);
            aFlatPAYSetup.FauthToken := (aResponse as TFlatPAY_TokenResponse).authToken;
            aFlatPAYSetup.FserialNumber := (aResponse as TFlatPAY_TokenResponse).serialNumber;
            result := aFlatPAYSetup.FauthToken <> '';
          end;
      else
        begin
          result := FALSE;
          aResponse := TFlatPAY_ErrorResponse.Create;
          (aResponse as TFlatPAY_ErrorResponse).StatusCode := lFlatPAYHttp.Response.StatusCode;
          (aResponse as TFlatPAY_ErrorResponse).StatusText := lFlatPAYHttp.Response.StatusText;
        end;
      end;
    except
      on E: Exception do
      begin
        aResponse := TFlatPAY_ErrorResponse.Create;
        GetDefaultSerializer.DeserializeObject(Format('{ "StatusCode" : -99, "StatusText" : "%s" }', [E.Message]), aResponse);
      end;
    end;
  finally
    lFlatPAYHttp.Free;
  end;
end;

constructor TFlatPAY_PaymentRequest.Create(aTransType: string; aAmount, aGratuity, aCashback: Double; aReference, aLanguage, auti: String);
begin
  FtransType := aTransType;
  FamountTrans := aAmount;
  FamountGratuity := aGratuity;
  FamountCashback := aCashback;
  FReference := aReference;
  FLanguage := aLanguage;
  Futi := auti;
end;

destructor TFlatPAY_PaymentRequest.Destroy;
begin
  inherited;
end;

{ TTFlatPAY_HistoryResponse }

constructor TFlatPAY_HistoryResponse.Create;
begin
  inherited;
  FHistory := TObjectList<TFlatPAY_History>.Create;
end;

destructor TFlatPAY_HistoryResponse.Destroy;
begin
  FHistory.Free;
  inherited;
end;

{ TFlatPAYAction }

constructor TFlatPAYAction.Create;
begin
  FXReportName := 'x-report.json';
  FZReportName := 'z-report.json';
  FHistoryName := 'history.json';
  FLastTransactionName := 'last-transaction.json';
  FCancelTransaction := 'cancel-transaction.json';
  FGetStatusName := 'get-status.json';
  FPaymentName := 'payment.json';
  FMerchantReceiptName := 'merchant-receipt.txt';
  FCardHolderReceiptName := 'cardholder-receipt.txt';
  FResultFileName := 'result.txt';
  FResultOK := 'OK';
  FResultError := 'ERROR';
end;

destructor TFlatPAYAction.Destroy;
begin

  inherited;
end;

end.

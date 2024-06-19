unit uFlatPAY_Form;
(*
  This form will be displayed when a sale/return is being made.
  It is a lot like MobilePAY.
*)

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
  System.Generics.Collections,
  uFlatPAY;

type
  TfrmFlatPAY = class(TForm)
    lblCaption: TLabel;
    lAmount: TLabel;
    fMessageToClerk: TLabel;
    btnCancelTransaction: TButton;
    btnAgain: TButton;
    procedure btnCancelTransactionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    fFlatPayThread: TThread;
    fFlatPay_Setup: TFlatPAYSetup;
    fFlatPay_Pay: TFlatPAY_PaymentRequest;
    fFlatPay: TFlatPAY;
    futi: string;
    fResult: integer;
    fReturnRespons: TFlatPAY_GetTransactionsRespons;
    procedure FlatPAY_Payment(aFlatPAY_Pay: TFlatPAY_PaymentRequest; var aFlatPAY: TFlatPAY; aLogCall: Boolean = FALSE);
    procedure CallFlatPAYAndStartPayment;
    procedure UpdateTextToShowClerk(aTekst: string);
    procedure ShowFlatPAYError(lFlatPAY_Response: TFlatPAY_Response);
    function CancelFlatPAYPayment(out aModalResult: TModalResult): Boolean;
    function WaitForPaymentToBeStarted(var aFlatPAY: TFlatPAY; var aFlatPAY_Response: TFlatPAY_Response; aFlatPAY_Pay: TFlatPAY_PaymentRequest; aLogCall: Boolean = FALSE): Boolean;
  public
    { Public declarations }

    class function DoFlatPAYPayment(aFlatPaySetup: TFlatPAYSetup;
      aTransType: string;
      aAmount: Double;
      aGratuity: Double;
      aCashback: Double;
      aReference: string;
      aLanguage: string;
      aDisablePrint: Boolean;
      out auti: string;
      out aTransactionRespons: TFlatPAY_GetTransactionsRespons;
      aResizeMultiplier: integer = 10000;
      aLogCall: Boolean = FALSE): Boolean;

    procedure ShowFlatPAYErrorMessage(lFlatPAY_Response: TFlatPAY_Response);
  end;

var
  frmFlatPAY: TfrmFlatPAY;

implementation

{$R *.dfm}


uses
  uMain,
  RTTI;

class function TfrmFlatPAY.DoFlatPAYPayment(aFlatPaySetup: TFlatPAYSetup;
  aTransType: string;
  aAmount: Double;
  aGratuity: Double;
  aCashback: Double;
  aReference: string;
  aLanguage: string;
  aDisablePrint: Boolean;
  out auti: string;
  out aTransactionRespons: TFlatPAY_GetTransactionsRespons;
  aResizeMultiplier: integer = 10000;
  aLogCall: Boolean = FALSE): Boolean;

  function CopyObject(const FromObj, ToObj: TObject): Boolean;
  var
    Ctx: TRTTIContext;
    FromObjType: TRttiType;
    ToObjType: TRttiType;
    FromField: TRttiField;
    ToField: TRttiField;
  begin
    Result := FALSE;
    FromObjType := Ctx.GetType(FromObj.ClassInfo);
    ToObjType := Ctx.GetType(ToObj.ClassInfo);
    for FromField in FromObjType.GetFields do
    begin
      ToField := ToObjType.GetField(FromField.Name);
      if Assigned(ToField) then
      begin
        if ToField.FieldType = FromField.FieldType then
          ToField.SetValue(ToObj, FromField.GetValue(FromObj));
        Result := True;
      end;
    end;
  end;

begin
  (*
    This will setup the enitre payment.
    It will create a thread, where the payment is started and the flow where it waits until it is done and shows messages to user is handled in the thread
    A class with the repsonse from the transaction is created (global to this form). This will be returned to caller
  *)

  frmFlatPAY := TfrmFlatPAY.Create(nil);
  try
    with frmFlatPAY do
    begin
      try
        aFlatPaySetup.DisablePrint := aDisablePrint;
        UpdateTextToShowClerk('Overfører beløb...vent...');
        // Button to cancel will be enabled when the transation is started.
        btnCancelTransaction.Enabled := FALSE;
        // Scaler formen
        ScaleBy(aResizeMultiplier, 10000);
        // Set default values
        aFlatPaySetup.uti := '';
        futi := '';
        // Create class to hold respons, to give to caller
        fReturnRespons := TFlatPAY_GetTransactionsRespons.Create;
        fResult := mrNone; // 0 = mrNone
        // Set setupclass
        fFlatPay_Setup := aFlatPaySetup;

        fFlatPay_Pay := TFlatPAY_PaymentRequest.Create(aTransType, aAmount, aGratuity, aCashback, aReference, aLanguage, auti);
        // Display type and amount
        lAmount.Caption := aTransType + ' ' + FormatCurr('0.00', (aAmount / 100));
        // Starting background thread to hancle FlatPAY payment and all needed to handled messages and flow in genera.
        CallFlatPAYAndStartPayment;
        // Show iteself (this form)    HVAD FÅR DEN TIL AT STOPPE??
        top := (screen.Height DIV 2) - (Height DIV 2);
        left := (screen.Width DIV 2) - (Width DIV 2);
        Result := ShowModal = mrOK;
        try
          // Always return Unique Transaction ID. With this we can later ask on this specific transaction
          // Behøves egentlig ikke, da det er i classen, der returneres.
          auti := futi;

          // Copy class to result to  be returned.
          CopyObject(fReturnRespons, aTransactionRespons);
          // Free class
          fReturnRespons.Free;

          // Thread started - wait for it to end (ensure it will end).
          // Fordi jeg kan afslutte med ALT+F4
          fFlatPayThread.WaitFor;

        except
          ;
        end;
      finally
        fFlatPay.Free;
      end;
    end;
  finally
    frmFlatPAY.Free;
  end;
end;

procedure TfrmFlatPAY.btnCancelTransactionClick(Sender: TObject);
var
  lMR: TModalResult;
begin
  // Clerk wants to abort
  // Set result to cancle.
  lMR := mrCancel;
  // If a transaction is runing then try to abort
  if futi <> '' then
    CancelFlatPAYPayment(lMR);
  // Return result
  fResult := lMR;
  if (fResult = mrCancel) then
    ModalResult := fResult;
end;

procedure TfrmFlatPAY.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // See if you can close the forrm - only if transaction not started or succesfully canclled (by clerk)
  ModalResult := fResult;
  CanClose := fResult in [mrCancel, mrOK];
end;

procedure TfrmFlatPAY.FlatPAY_Payment(aFlatPAY_Pay: TFlatPAY_PaymentRequest; var aFlatPAY: TFlatPAY; aLogCall: Boolean = FALSE);
var
  lFlatPAY_Response: TFlatPAY_Response;
  lFlatPAYPaymentHasBeenStarted: Boolean;
  lMyDisplayData: TDisplayData;
  lMyDisplayDataArray: TObjectList<TDisplayData>;
  lStr: string;
  lTransApproved: Boolean;
  lTransCancelled: Boolean;
  UntilNotEmptyResponse: Boolean;
  luti: string;
  lGetStatus: Boolean;
  lDisplayTextToShow: string;

  function ArrayContains12(out aDisplayText: string): Boolean;
  var
    lFundet: Boolean;
    lMyData: TDisplayData;
  begin
    lFundet := FALSE;
    for lMyData in lMyDisplayDataArray do
    begin
      lFundet := (lMyData.value = 12) OR lFundet;
      if lMyData.description <> '' then
        aDisplayText := lMyData.description;
    end;
    Result := lFundet;
  end;

  function CopyObject(const FromObj, ToObj: TObject): Boolean;
  var
    Ctx: TRTTIContext;
    FromObjType: TRttiType;
    ToObjType: TRttiType;
    FromField: TRttiField;
    ToField: TRttiField;
  begin
    Result := FALSE;
    FromObjType := Ctx.GetType(FromObj.ClassInfo);
    ToObjType := Ctx.GetType(ToObj.ClassInfo);
    for FromField in FromObjType.GetFields do
    begin
      ToField := ToObjType.GetField(FromField.Name);
      if Assigned(ToField) then
      begin
        if ToField.FieldType = FromField.FieldType then
          ToField.SetValue(ToObj, FromField.GetValue(FromObj));
        Result := True;
      end;
    end;
  end;

begin
  try
    if (Self.fFlatPay_Setup.authToken = '') then
    begin
      // Program has not been paired with the terminal. Abort routine
      UpdateTextToShowClerk('Terminal er ikke parret med program');
      Sleep(1000);
      fResult := mrCancel;
      RePaint;
      // Will clsoe the form itself
      // ModalResult := fResult;
      exit;
    end;

    try
      // Do start payment
      lFlatPAYPaymentHasBeenStarted := WaitForPaymentToBeStarted(aFlatPAY, lFlatPAY_Response, aFlatPAY_Pay, aLogCall);

      if lFlatPAYPaymentHasBeenStarted then
      begin
        // Payment has been started - Do save UTI
        futi := (lFlatPAY_Response as TFlatPAY_StartTransactionRepsons).uti;
        lFlatPAY_Response.Free;
        // Get status of the payment transaction
        lGetStatus := aFlatPAY.GetStatusRequest(fFlatPay_Setup, lFlatPAY_Response, aLogCall);
        if lGetStatus then
        begin
          lMyDisplayData := (lFlatPAY_Response as TFlatPAY_StatusRequestResponse).DisplayData.Last;
          lMyDisplayDataArray := (lFlatPAY_Response as TFlatPAY_StatusRequestResponse).DisplayData;
          ArrayContains12(lDisplayTextToShow);
          UpdateTextToShowClerk(lDisplayTextToShow);
        end
        else
        begin
          ShowFlatPAYErrorMessage(lFlatPAY_Response);
        end;
        FreeAndNil(lFlatPAY_Response);

        // Has been informed, that   Transaction Finished\",\"statusValue\":12   is the end of it, and we do not need to wait anymore.
        while (NOT(lMyDisplayData.value = 12)) AND (NOT(ArrayContains12(lDisplayTextToShow))) do
        // Keep in routine until transaction is finished {\"statusDescription\":\"Transaction Finished\",\"statusValue\":12}
        begin
          if Assigned(lFlatPAY_Response) then
            FreeAndNil(lFlatPAY_Response);

          UpdateTextToShowClerk(lDisplayTextToShow);

          // Information to Clerk

          // Get status of the payment transaction
          if (NOT(aFlatPAY.GetStatusRequest(fFlatPay_Setup, lFlatPAY_Response, aLogCall))) then
          begin
            // Failed - break the routine
            FreeAndNil(lFlatPAY_Response);
            Break;
          end;
          lMyDisplayData := (lFlatPAY_Response as TFlatPAY_StatusRequestResponse).DisplayData.Last;
          lMyDisplayDataArray := (lFlatPAY_Response as TFlatPAY_StatusRequestResponse).DisplayData;

          Sleep(500); // Just give everything a chance to react

        end;
        // Transaction is now finishe
        if Assigned(lFlatPAY_Response) then
          FreeAndNil(lFlatPAY_Response);

        // Do Get Transaction
        UntilNotEmptyResponse := FALSE;
        repeat
          if (aFlatPAY.GetPaymentRequest(fFlatPay_Setup, lFlatPAY_Response)) then
          begin
            lStr := (lFlatPAY_Response as TFlatPAY_GetTransactionsRespons).cardType;
            lTransApproved := (lFlatPAY_Response as TFlatPAY_GetTransactionsRespons).TransApproved;
            lTransCancelled := (lFlatPAY_Response as TFlatPAY_GetTransactionsRespons).TransCancelled;
            luti := (lFlatPAY_Response as TFlatPAY_GetTransactionsRespons).uti;

            CopyObject((lFlatPAY_Response as TFlatPAY_GetTransactionsRespons), fReturnRespons);

            if lTransCancelled then
            begin

              lStr := fReturnRespons.cardType;

              UntilNotEmptyResponse := True;
              UpdateTextToShowClerk('Transaktionen er blevet afbrudt.');
              fResult := mrCancel;
            end
            else if lTransApproved then
            begin

              UntilNotEmptyResponse := True;
              UpdateTextToShowClerk('Transaktionen er blevet godkendt.');
              fResult := mrOK;
            end
            else if (luti <> futi) then
            begin
              (*
                HER ER MÅSKE ET ISSUE OMKRING AFVISTE KALD.

                KONTROLLER
              *)
              FreeAndNil(lFlatPAY_Response);
              UpdateTextToShowClerk('Answer not ready yet. Try again.');
              UntilNotEmptyResponse := FALSE;
              // Just let things finish before fetching transaction status
              Sleep(500);
              fResult := mrCancel;
            end
            else
            begin
              // uti has been verified in the  return result to be the same as the one we started with.
              // transaction not cancelled and bot approved. But we have our answer??

              lStr := fReturnRespons.cardType;

              UntilNotEmptyResponse := True;
              UpdateTextToShowClerk('Transaktionen er ikke fuldført.');
              fResult := mrCancel;
            end;
          end
          else
          begin
            // if aLogCall then
            // Should always be a success.
            fResult := mrCancel;
            ShowFlatPAYErrorMessage(lFlatPAY_Response);

            (*
              MUST I NOT DO THIS???
              UntilNotEmptyResponse := True;
            *)
          end;
        until (UntilNotEmptyResponse);

        FreeAndNil(lFlatPAY_Response);

      end
      else
      begin
      end;
    except
      ShowFlatPAYErrorMessage(lFlatPAY_Response);
    end;
  finally
    aFlatPAY_Pay.Free;
  end;
  // Will close the form
  ModalResult := fResult;
end;

procedure TfrmFlatPAY.ShowFlatPAYErrorMessage(lFlatPAY_Response: TFlatPAY_Response);
begin
  // Show any error message from terminal from a failed call
  if (lFlatPAY_Response <> nil) and (lFlatPAY_Response is TFlatPAY_ErrorResponse) then
  begin
    UpdateTextToShowClerk(Format('%d : %s', [(lFlatPAY_Response as TFlatPAY_ErrorResponse).StatusCode, (lFlatPAY_Response as TFlatPAY_ErrorResponse).StatusText]));
    RePaint;
  end;
end;

procedure TfrmFlatPAY.UpdateTextToShowClerk(aTekst: string);
begin
  // Update label with information to show clerk
  TThread.Synchronize(nil,
    procedure
    begin
      fMessageToClerk.Caption := aTekst;
    end);
end;

function TfrmFlatPAY.WaitForPaymentToBeStarted(var aFlatPAY: TFlatPAY; var aFlatPAY_Response: TFlatPAY_Response; aFlatPAY_Pay: TFlatPAY_PaymentRequest;
aLogCall: Boolean = FALSE): Boolean;
begin
  // Set default resulkt
  Result := FALSE;
  while (not Result) and (fResult in [mrNone, mrRetry]) do
  begin
    fResult := mrNone;
    // Do create a páyment
    Result := aFlatPAY.StartPaymentRequest(fFlatPay_Setup, aFlatPAY_Pay, aFlatPAY_Response);
    if not Result then
    begin
      // Unsuccesfull - Show error
      ShowFlatPAYErrorMessage(aFlatPAY_Response);
      aFlatPAY_Response.Free;
    end;
    if ModalResult = mrCancel then
    begin
      // Something went wrong starting the payment - abort
      fResult := mrCancel;
    end;
  end;
end;

procedure TfrmFlatPAY.CallFlatPAYAndStartPayment;
begin
  fFlatPay := TFlatPAY.Create;
  fFlatPayThread := TThread.CreateAnonymousThread(
    procedure
    begin
      FlatPAY_Payment(fFlatPay_Pay, fFlatPay, True);
    end);
  fFlatPayThread.FreeOnTerminate := True;
  fFlatPayThread.Start;

  btnCancelTransaction.Enabled := True;

end;

function TfrmFlatPAY.CancelFlatPAYPayment(out aModalResult: TModalResult): Boolean;
var
  lFlatPAYPaymentHasBeenCancelled: Boolean;
  lFlatPAY_Response: TFlatPAY_Response;
begin
  // This is the clerk pressing abort.
  // NOw try to abort - can not be made, if customer has already pressed in PIN and ACCEPT

  // Default - not cancelled
  lFlatPAYPaymentHasBeenCancelled := FALSE;
  aModalResult := mrNone;
  while (not lFlatPAYPaymentHasBeenCancelled) and (aModalResult in [mrNone, mrRetry]) do
  begin
    aModalResult := mrNone;
    // Do try to cancel
    lFlatPAYPaymentHasBeenCancelled := fFlatPay.CancelPaymentRequest(fFlatPay_Setup, lFlatPAY_Response);
    if not lFlatPAYPaymentHasBeenCancelled then
    begin
      // Unsuccesful - show error/reason
      ShowFlatPAYError(lFlatPAY_Response);
      lFlatPAY_Response.Free;
    end;
  end;
  lFlatPAY_Response.Free;
  // Return result
  if lFlatPAYPaymentHasBeenCancelled then
  begin
    aModalResult := mrCancel;
  end;
  Result := lFlatPAYPaymentHasBeenCancelled;
end;

procedure TfrmFlatPAY.ShowFlatPAYError(lFlatPAY_Response: TFlatPAY_Response);
begin
  // This routine is called when cancelling by clerk has failed

  // Show it self
  Position := poDesktopCenter;
  if not Visible then
    Show;
  BringToFront;

  // Do find out, what can happen!!!

  if (lFlatPAY_Response is TFlatPAY_ErrorResponse) and ((lFlatPAY_Response as TFlatPAY_ErrorResponse).StatusCode <> 0) then
  begin
    case (lFlatPAY_Response as TFlatPAY_ErrorResponse).StatusCode of
      - 99: // fejl ved initiering af MP betaling.
        begin
          fResult := mrRetry;
          UpdateTextToShowClerk('Forbindelsen til FlatPAYterminalen er lidt ulden ... ');
          // RePaint;
        end;
    else
      ShowFlatPAYErrorMessage(lFlatPAY_Response);
    end;
  end;
  RePaint;
end;

end.

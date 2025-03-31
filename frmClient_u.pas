unit frmClient_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus,
  dmCrunchCount_u,
  Vcl.Buttons, Math, Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids,
  VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.Series, VclTee.TeeProcs,
  VclTee.Chart, Vcl.Mask, Vcl.ComCtrls;

type
  TfrmClient = class(TForm)
    gbxClient: TGroupBox;
    imgLogo: TImage;
    bbnLogOut: TBitBtn;
    pnlUsername: TPanel;
    pnlNutrition: TPanel;
    pnlProgress: TPanel;
    pnlMessages: TPanel;
    imgTabIcon: TImage;
    gbxNutrition: TGroupBox;
    dbgFoods: TDBGrid;
    lblFoods: TLabel;
    Chart1: TChart;
    Series1: TPieSeries;
    cbxFoods: TComboBox;
    lblFood: TLabel;
    lblNumberOfServings: TLabel;
    cbxServingSize: TComboBox;
    lblServingSize: TLabel;
    bbnLogFoood: TBitBtn;
    edtNumberServings: TEdit;
    gbxProgress: TGroupBox;
    barCalories: TProgressBar;
    gbxGoals: TGroupBox;
    ldtCalories: TLabeledEdit;
    ldtProtein: TLabeledEdit;
    ldtWeight: TLabeledEdit;
    bbnSetGoals: TBitBtn;
    lblCalories: TLabel;
    barProtein: TProgressBar;
    lblProtein: TLabel;
    lblCaloriesProgress: TLabel;
    lblProteinProgress: TLabel;
    chtWeight: TChart;
    Series2: TLineSeries;
    redFoodLog: TRichEdit;
    gbxMacros: TGroupBox;
    lblFoodLog: TLabel;
    Series3: TLineSeries;
    barWeightRemaining: TProgressBar;
    lblWeightCurrent: TLabel;
    lblWeightRemaining: TLabel;
    lblGoalWeight: TLabel;
    lblTotalConsumption: TLabel;
    chtTotal: TChart;
    Series4: TPieSeries;
    ldtLogWeight: TLabeledEdit;
    bbnLogWeight: TBitBtn;
    gbxMessages: TGroupBox;
    redMessages: TRichEdit;
    lblEmail: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure LogOut;
    procedure Nutrition;
    procedure Progress;
    procedure bbnLogOutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pnlNutritionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgFoodsCellClick(Column: TColumn);
    procedure bbnLogFooodClick(Sender: TObject);
    procedure UpdateChart;
    procedure Log;

    procedure DeleteUser(iUserID: Integer; bIsClient: Boolean);

    procedure SetTabStops;

    procedure GetPer100gValues(FoodName: String;
      var arr100gInput: array of real);

    function CalculateScaledNutrition(const arr100gInput: array of real;
      Quantity: real; UnitType: string): TArray<real>;
    procedure cbxFoodsClick(Sender: TObject);
    procedure pnlProgressClick(Sender: TObject);
    procedure bbnSetGoalsClick(Sender: TObject);
    procedure bbnLogWeightClick(Sender: TObject);
    procedure pnlUsernameClick(Sender: TObject);
    procedure pnlMessagesClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    rCarbs, rSugar, rProtein, rFat: real;
    sFoodName: string;
    arr100gInput: array [1 .. 5] of real;
    arrOutput: TArray<real>;
    rWeight: real;
  end;

var
  frmClient: TfrmClient;

implementation

{$R *.dfm}

uses
  frmLogin_u;

procedure TfrmClient.bbnLogFooodClick(Sender: TObject);
var
  bValid: Boolean;
  rQuantity: real;
begin
  bValid := True;

  // validate food selcted

  if cbxFoods.ItemIndex < 0 then
  begin
    showmessage('Please select a food');
    bValid := False;
  end;

  // validate serving size

  if (bValid = True) AND (edtNumberServings.Text = '') then
  begin
    showmessage('Please enter a number for servings.');
    bValid := False;
  end
  else
  begin
    if (Pos('.', edtNumberServings.Text) = 0) then
    begin
      showmessage
        ('Please enter a valid number for servings with a decimal point.');
      bValid := False;
    end
    else
    begin
      for var i := 1 to Length(edtNumberServings.Text) do
      begin
        if not(edtNumberServings.Text[i] in ['0' .. '9', '.']) then
        begin
          showmessage
            ('Please enter a valid  number for servings with a decimal point.');
          bValid := False;
          break;
        end;
      end;
    end;
  end;

  if bValid = True then
  begin
    rQuantity := StrToFloat(edtNumberServings.Text);
  end;

  // validate unit selection

  if (bValid = True) AND (cbxServingSize.ItemIndex < 0) then
  begin
    showmessage('Please select a unit type');
    bValid := False;
  end;

  // start processing

  if bValid = True then
  begin
    GetPer100gValues(cbxFoods.Text, arr100gInput);

    CalculateScaledNutrition(arr100gInput, rQuantity, cbxServingSize.Text);
    sFoodName := cbxFoods.Text;

    with dmCrunchCount do
    begin
      tblClients.Locate('ClientID', iClientID, []);
      rWeight := tblClients['Weight'];
    end;

    Log;

    showmessage(cbxFoods.Text + #13#10 + 'Calories: ' +
      (FloatTostr(Round(arrOutput[0]))) + #13#10 + 'Carbohydrates: ' +
      FloatTostr(arrOutput[1]) + #13#10 + 'Sugar: ' + FloatTostr(arrOutput[2]) +
      #13#10 + 'Protein: ' + FloatTostr(arrOutput[3]) + #13#10 + 'Fat: ' +
      FloatTostr(arrOutput[4]));
  end;
end;

procedure TfrmClient.bbnLogOutClick(Sender: TObject);
begin
  LogOut;
end;

procedure TfrmClient.bbnLogWeightClick(Sender: TObject);
var
  bValid: Boolean;
  i: Integer;
begin
  bValid := True;

  if ldtLogWeight.Text = '' then
  begin
    showmessage('Please enter a Weight value');
    bValid := False;
  end;

  if (bValid = True) then
  begin
    for i := 1 to Length(ldtLogWeight.Text) do
    begin

      if not(ldtLogWeight.Text[i] in ['0' .. '9', '.']) then
      begin
        showmessage('Please enter a valid decimal Weight value.');
        bValid := False;
        break;
      end;
    end;
  end;

  if bValid = True then
  begin
    sFoodName := 'NONE';

    SetLength(arrOutput, 5);

    for i := 0 to 4 do
    begin
      arrOutput[i] := 0;
    end;

    rWeight := StrToFloat(ldtLogWeight.Text);

    with dmCrunchCount do
    begin
      tblClients.Locate('ClientID', iClientID, []);
      tblClients.Edit;
      tblClients['Weight'] := rWeight;
      tblClients.post;

    end;

    Log;

    Progress;

    showmessage('Weight successfully updated!');
  end;

end;

procedure TfrmClient.bbnSetGoalsClick(Sender: TObject);
var
  bValid: Boolean;
begin
  with dmCrunchCount do
  begin
    bValid := True;

    if (bValid = True) AND (ldtCalories.Text = '') then
    begin
      showmessage('Please eneter a number for Goal Calories');
      bValid := False;
    end
    else if (bValid = True) AND (ldtProtein.Text = '') then
    begin
      showmessage('Please eneter a number for Goal Protein');
      bValid := False;
    end
    else if (bValid = True) AND (ldtWeight.Text = '') then
    begin
      showmessage('Please eneter a number for Goal Weight');
      bValid := False;
    end;

    if bValid = True then
    begin
      for var i := 1 to Length(ldtCalories.Text) do
      begin

        if not(ldtCalories.Text[i] in ['0' .. '9']) then
        begin
          showmessage('Please enter a valid integer value for Goal Calories');
          bValid := False;
          break;
        end;
      end;
    end;

    if bValid = True then
    begin
      for var i := 1 to Length(ldtProtein.Text) do
      begin

        if not(ldtProtein.Text[i] in ['0' .. '9', '.']) then
        begin
          showmessage
            ('Please enter a valid number Goal Protein with a decimal point');
          bValid := False;
          break;
        end;
      end;
    end;

    if bValid = True then
    begin
      for var i := 1 to Length(ldtWeight.Text) do
      begin

        if not(ldtWeight.Text[i] in ['0' .. '9', '.']) then
        begin
          showmessage
            ('Please enter a valid number Goal Weight with a decimal point');
          bValid := False;
          break;
        end;
      end;
    end;

    if bValid = True then
    begin
      tblClients.Locate('ClientID', iClientID, []);

      tblClients.Edit;

      tblClients['GoalCalories'] := ldtCalories.Text;
      tblClients['GoalProtein'] := ldtProtein.Text;
      tblClients['GoalWeight'] := ldtWeight.Text;

      tblClients.post;
      tblClients.Refresh;

      Nutrition;

      showmessage('Goals updated successfully!');
    end;

  end;
end;

function TfrmClient.CalculateScaledNutrition(const arr100gInput: array of real;
  Quantity: real; UnitType: string): TArray<real>;

const

  GramToGram = 1.0;
  KgToGram = 1000.0;
  MgToGram = 0.001;
  OzToGram = 28.3495;
  PoundToGram = 453.592;

  MlToGram = 1.0;
  LiterToGram = 1000.0;
  PintToGram = 473.176;
  CupToGram = 240.0;
  TspToGram = 4.92892;
  TbspToGram = 14.7868;
var
  rGrams, rScalar: real;
  i: Integer;
begin
  SetLength(arrOutput, Length(arr100gInput));

  if UnitType = 'g' then
    rGrams := Quantity * GramToGram
  else if UnitType = 'kg' then
    rGrams := Quantity * KgToGram
  else if UnitType = 'mg' then
    rGrams := Quantity * MgToGram
  else if UnitType = 'oz' then
    rGrams := Quantity * OzToGram
  else if (UnitType = 'lb') then
    rGrams := Quantity * PoundToGram
  else if UnitType = 'ml' then
    rGrams := Quantity * MlToGram
  else if (UnitType = 'l') then
    rGrams := Quantity * LiterToGram
  else if UnitType = 'pint' then
    rGrams := Quantity * PintToGram
  else if UnitType = 'cup' then
    rGrams := Quantity * CupToGram
  else if UnitType = 'tsp' then
    rGrams := Quantity * TspToGram
  else if UnitType = 'tbsp' then
    rGrams := Quantity * TbspToGram
  else
    raise Exception.Create('Unsupported unit type');

  rScalar := rGrams / 100.0;

  arrOutput[0] := Round(arr100gInput[0] * rScalar);

  for i := 2 to 5 do
  begin
    arrOutput[i - 1] := roundto((arr100gInput[i - 1] * rScalar), -1);
  end;

  Result := arrOutput;
end;

procedure TfrmClient.cbxFoodsClick(Sender: TObject);
begin
  with dmCrunchCount do
  begin
    tblFoods.Locate('FoodName', cbxFoods.Text, []);
  end;

  UpdateChart;
end;

procedure TfrmClient.dbgFoodsCellClick(Column: TColumn);
var
  iRecNo: Integer;
begin
  iRecNo := dbgFoods.DataSource.DataSet.RecNo;

  dbgFoods.DataSource.DataSet.RecNo := iRecNo;

  UpdateChart;
end;

procedure TfrmClient.DeleteUser(iUserID: Integer; bIsClient: Boolean);
var
  sFileName: string;
begin
  with dmCrunchCount do
  begin
    if tblUsers.Locate('UserID', iUserID, []) then
    begin
      tblUsers.Delete;
    end
    else
    begin
      showmessage('User not found.');
      Exit;
    end;

    if bIsClient then
    begin
      begin
        if tblClients.Locate('UserID', iUserID, []) then
        begin
          tblClients.Edit;
          tblClients.FieldByName('PTID').Clear;
          tblClients.post;

          tblClients.Delete;
        end;

        sFileName := pnlUsername.Caption + '.txt';
        if FileExists(sFileName) then
        begin
          if not DeleteFile(sFileName) then
            showmessage('Error deleting log file: ' + sFileName);
        end;
      end;
    end
    else
    begin
      if tblPTs.Locate('UserID', iUserID, []) then
        tblPTs.Delete;
    end;

    showmessage('User account and associated data deleted successfully.');
  end;
end;

procedure TfrmClient.FormActivate(Sender: TObject);
begin
  imgLogo.Stretch := False;
  imgLogo.Proportional := True;
  imgLogo.Picture.LoadFromFile('CrunchCount logo vertical.png');

  // gbxOverview.Show;
  gbxNutrition.Show;

  Nutrition;

  with dmCrunchCount do
  begin
    tblUsers.Locate('UserID', iUserID, []);
    pnlUsername.Caption := tblUsers['Username'];
  end;
end;

procedure TfrmClient.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  iResponse: Integer;
  // sUsername: string;
begin
  // Call LogOut to confirm logout
  with dmCrunchCount do
  begin
    tblUsers.Locate('UserID', iUserID, []);
    sUsername := tblUsers['Username'];
  end;
  iResponse := MessageDlg('Are you sure you would like to log out of ' +
    sUsername + '''s account?', mtConfirmation, [mbYes, mbNo], 0);
  if iResponse = mrYes then
  begin
    showmessage('Log out successful');
    CanClose := True;
    frmLogin.Show;
    frmClient.hide;
    frmLogin.ldtUsername.Clear;
    frmLogin.ldtPassword.Clear;
  end
  else
  begin
    showmessage('Log out aborted');
    CanClose := False;
  end;
end;

procedure TfrmClient.FormShow(Sender: TObject);
begin
  pnlUsername.Caption := sUsername;
end;

procedure TfrmClient.GetPer100gValues(FoodName: String;
  var arr100gInput: array of real);
begin
  with dmCrunchCount do
  begin
    if tblFoods.Locate('FoodName', cbxFoods.Text, []) then
    begin
      arr100gInput[0] := tblFoods['Calories'];
      arr100gInput[1] := tblFoods['Carbohydrates'];
      arr100gInput[2] := tblFoods['Sugar'];
      arr100gInput[3] := tblFoods['Protein'];
      arr100gInput[4] := tblFoods['Fat'];
    end
    else
      raise Exception.Create('Food item not found.');
  end;
end;

procedure TfrmClient.Log;
var
  TlogFile: TextFile;
  sFileName: String;
  i: Integer;

begin
  sUsername := pnlUsername.Caption;
  sFileName := sUsername + '.txt';

  if FileExists(sFileName) then
    AssignFile(TlogFile, sFileName)
  else
  begin
    AssignFile(TlogFile, sFileName);
    Rewrite(TlogFile);
  end;

  Append(TlogFile);

  WriteLn(TlogFile, sFoodName + '#' + FloatTostr(arrOutput[0]) + '#' +
    FloatTostr(arrOutput[1]) + '#' + FloatTostr(arrOutput[2]) + '#' +
    FloatTostr(arrOutput[3]) + '#' + FloatTostr(arrOutput[4]) + '#' +
    FloatTostr(rWeight));

  CloseFile(TlogFile);

end;

procedure TfrmClient.LogOut;
var
  iResponse: Integer;
  sUsername: string;
begin
  with dmCrunchCount do
  begin
    tblUsers.Locate('UserID', iUserID, []);
    sUsername := tblUsers['Username'];
  end;
  iResponse := MessageDlg('Are you sure you would like to log out of ' +
    sUsername + '''s account?', mtConfirmation, [mbYes, mbNo], 0);

  if iResponse = mrYes then
  begin
    showmessage('Log out successful');
    frmLogin.Show;
    frmClient.hide;
    frmLogin.ldtUsername.Clear;
    frmLogin.ldtPassword.Clear;
  end
  else
  begin
    showmessage('Log out aborted');
  end;

end;

procedure TfrmClient.Nutrition;
var
  i: Integer;

begin
  with dmCrunchCount do
  begin
    imgTabIcon.Picture.LoadFromFile('nutrition.png');
    gbxNutrition.Show;
    gbxProgress.hide;
    gbxMessages.hide;

    tblFoods.First;

    sFoodName := tblFoods['FoodName'];

    rCarbs := tblFoods['Carbohydrates'];
    rSugar := tblFoods['Sugar'];
    rProtein := tblFoods['Protein'];
    rFat := tblFoods['Fat'];

    Chart1.Series[0].Clear;

    Chart1.Series[0].Add(rCarbs, 'Carbohydrates');
    Chart1.Series[0].Add(rSugar, 'Sugar');
    Chart1.Series[0].Add(rProtein, 'Protein');
    Chart1.Series[0].Add(rFat, 'Fat');

    Chart1.Series[0].Marks.Visible := False;

    Chart1.Legend.Visible := True;
    Chart1.Legend.Frame.Visible := False;
    Chart1.Legend.Alignment := laRight;

    Chart1.Series[0].Marks.Style := smsValue;
    Chart1.Title.Text.Clear;
    Chart1.Title.Font.Color := clblack;
    Chart1.Title.Text.Add('Macronutrients per 100g of ' + sFoodName);

    with dmCrunchCount do
    begin
      dscFoods.DataSet := dmCrunchCount.tblFoods;
      dbgFoods.DataSource := dmCrunchCount.dscFoods;

      for i := 1 to dbgFoods.Columns.Count - 1 do
      begin
        dbgFoods.Columns[i].Width := dbgFoods.Width div dbgFoods.Columns.Count;
        // dbg column distribution
      end;

      tblFoods.First;
      while not tblFoods.Eof do
      begin
        cbxFoods.Items.Add(tblFoods['FoodName']);
        tblFoods.Next;
      end;
      tblFoods.First;

    end;
  

    tblClients.Locate('ClientID', iClientID, []);

    if tblClients['GoalCalories'] = NULL then
    begin
      ldtCalories.Text := '0.00';
    end
    else
      ldtCalories.Text := FloatTostr(tblClients['GoalCalories']);

    if tblClients['GoalProtein'] = NULL then
    begin
      ldtProtein.Text := '0.00';
    end
    else
      ldtProtein.Text := FloatTostr(tblClients['GoalProtein']);

    if tblClients['GoalWeight'] = NULL then
    begin
      ldtWeight.Text := '0.00';
    end
    else
      ldtWeight.Text := FloatTostr(tblClients['GoalWeight']);
  end;
end;

procedure TfrmClient.pnlMessagesClick(Sender: TObject);
var
  iPTID: Integer;
  sEmail, sPTUsername: string;
  sMessage: string;
begin
  imgTabIcon.Picture.LoadFromFile('messages.png');
  gbxNutrition.hide;
  gbxProgress.hide;
  gbxMessages.Show;

  redMessages.Clear;

  redMessages.Paragraph.TabCount := 2;

  redMessages.Paragraph.Tab[0] := 200;

  dmCrunchCount.tblClients.Locate('ClientID', iClientID, []);
  lblEmail.Caption := 'To: ' + dmCrunchCount.tblClients['Email'] + ' (' +
    pnlUsername.Caption + ')';
  iPTID := dmCrunchCount.tblClients['PTID'];
  dmCrunchCount.tblPTs.Locate('PTID', iPTID, []);
  dmCrunchCount.tblUsers.Locate('UserID', dmCrunchCount.tblPTs['UserID'], []);
  sPTUsername := dmCrunchCount.tblUsers['Username'];
  sEmail := dmCrunchCount.tblPTs['Email'];

  if dmCrunchCount.tblClients['Message'] = NULL then
  begin
    redMessages.Lines.Add('Nothing to display. Keep going!');
  end
  else
  begin
    sMessage := dmCrunchCount.tblClients['Message'];
    redMessages.Lines.Add('From: ' + sPTUsername + #9 + 'Message');
    redMessages.Lines.Add('');
    redMessages.Lines.Add(sEmail + #9 + sMessage);
  end;

end;

procedure TfrmClient.pnlNutritionClick(Sender: TObject);
begin
  Nutrition;
end;

procedure TfrmClient.pnlProgressClick(Sender: TObject);
begin
  Progress;
end;

procedure TfrmClient.pnlUsernameClick(Sender: TObject);
var
  iResponse: Integer;
begin
  iResponse := MessageDlg('Are you sure you would like to delete ' + sUsername +
    '''s account and associated data? This cannot be undone.', mtConfirmation,
    [mbYes, mbNo], 0);

  if iResponse = mrYes then
  begin
    DeleteUser(iUserID, bIsClient);

    frmClient.hide;
    frmLogin.Show;
  end
  else
  begin
    showmessage('Account deletion aborted');
  end;

end;

procedure TfrmClient.Progress;
var
  tFile: TextFile;
  sLine, sReadFoodName, sOut: string;
  iCalories, iPos, iCount: Integer;
  rCarbs, rSugar, rProtein, rFat, rGoalWeight: real;
  LineSeries: TLineSeries;
begin
  imgTabIcon.Picture.LoadFromFile('progress.png');
  gbxNutrition.hide;
  gbxProgress.Show;
  gbxMessages.hide;

  ldtLogWeight.Text := dmCrunchCount.tblClients['Weight'];

  with dmCrunchCount do
  begin
    tblClients.Locate('ClientID', iClientID, []);
    rGoalWeight := tblClients['GoalWeight'];
  end;

  redFoodLog.Clear;
  SetTabStops;

  chtWeight.Series[0].Clear;
  chtWeight.Series[1].Clear;
  chtTotal.Series[0].Clear;

  iCalories := 0;
  rCarbs := 0;
  rSugar := 0;
  rProtein := 0;
  rFat := 0;
  iCount := 0;

  sUsername := pnlUsername.Caption;

  with dmCrunchCount do
  begin
    tblClients.Locate('ClientID', iClientID, []);
    ldtWeight.Text := tblClients['Weight'];

    if NOT FileExists(sUsername + '.txt') then
    begin
      showmessage(sUsername +
        '.txt could not be found or has not been created yet. Log a weight value below or add a food under Nutrition.');
      Exit
    end
    else
    begin
      AssignFile(tFile, sUsername + '.txt');
      Reset(tFile);

      while not(Eof(tFile)) do
      begin
        ReadLn(tFile, sLine);

        // Food name

        iPos := Pos('#', sLine);
        sReadFoodName := Copy(sLine, 1, iPos - 1);

        if NOT(Uppercase(sReadFoodName) = 'NONE') then
        begin
          // redFoodLog.Lines.Add(sReadFoodName + #9);
          sOut := sReadFoodName + #9;

          Delete(sLine, 1, iPos);

          // Calories

          iPos := Pos('#', sLine);
          // redFoodLog.Lines.Append(Copy(sLine, 1, iPos - 1) + #9);
          sOut := sOut + (Copy(sLine, 1, iPos - 1) + #9);
          iCalories := iCalories + StrToint(Copy(sLine, 1, iPos - 1));
          Delete(sLine, 1, iPos);

          // Carbs

          iPos := Pos('#', sLine);
          // redFoodLog.Lines.Append(Copy(sLine, 1, iPos - 1) + #9);
          sOut := sOut + (Copy(sLine, 1, iPos - 1) + #9);
          rCarbs := rCarbs + StrToFloat(Copy(sLine, 1, iPos - 1));
          Delete(sLine, 1, iPos);

          // Sugar

          iPos := Pos('#', sLine);
          // redFoodLog.Lines.Append(Copy(sLine, 1, iPos - 1) + #9);
          sOut := sOut + (Copy(sLine, 1, iPos - 1) + #9);
          rSugar := rSugar + StrToFloat(Copy(sLine, 1, iPos - 1));
          Delete(sLine, 1, iPos);

          // Protein

          iPos := Pos('#', sLine);
          // redFoodLog.Lines.Append(Copy(sLine, 1, iPos - 1) + #9);
          sOut := sOut + (Copy(sLine, 1, iPos - 1) + #9);
          rProtein := rProtein + StrToFloat(Copy(sLine, 1, iPos - 1));
          Delete(sLine, 1, iPos);

          // Fat

          iPos := Pos('#', sLine);
          // redFoodLog.Lines.Append(Copy(sLine, 1, iPos - 1));
          sOut := sOut + (Copy(sLine, 1, iPos - 1));
          rFat := rFat + StrToFloat(Copy(sLine, 1, iPos - 1));

          redFoodLog.Lines.Add(sOut);
        end
        else
        begin
          if iCount = 0 then
          begin
            inc(iCount);
            sLine := dmCrunchCount.tblClients['Weight'];
          end
          else
          begin
            inc(iCount);
            for var i := 1 to 6 do
            begin
              iPos := Pos('#', sLine);
              Delete(sLine, 1, iPos);
            end;
          end;

          // Add weight series

          chtWeight.Series[0].AddXY(iCount, StrToFloat(sLine));

          chtWeight.Series[1].AddXY(iCount, rGoalWeight);

        end;

      end;
    end;

    redFoodLog.Lines.Add('');
    redFoodLog.Lines.Add(StringOfChar('-', ((redFoodLog.Width div 2) - 50)));
    redFoodLog.Lines.Add('');

    redFoodLog.Lines.Add('Totals:' + #9 + IntToStr(iCalories) + #9 +
      FormatFloat('0.0', rCarbs) + #9 + FormatFloat('0.0', rSugar) + #9 +
      FormatFloat('0.0', rProtein) + #9 + FormatFloat('0.0', rFat));

    CloseFile(tFile);
  end;

  chtTotal.Series[0].Add(rCarbs, 'Carbohydrates');
  chtTotal.Series[0].Add(rSugar, 'Sugar');
  chtTotal.Series[0].Add(rProtein, 'Protein');
  chtTotal.Series[0].Add(rFat, 'Fat');

  barCalories.Max := dmCrunchCount.tblClients['GoalCalories'];
  barCalories.Position := iCalories;

  lblCaloriesProgress.Caption := IntToStr(iCalories) + '/' +
    IntToStr(barCalories.Max) + ' (kcal)';

  barProtein.Max := dmCrunchCount.tblClients['GoalProtein'];
  barProtein.Position := Round(rProtein);

  lblProteinProgress.Caption := FormatFloat('0.0', rProtein) + '/' +
    FormatFloat('0.0', barProtein.Max) + ' (g)';

  if dmCrunchCount.tblClients['GoalWeight'] > dmCrunchCount.tblClients['Weight']
  then
  begin
    // Weight gain scenario
    lblWeightCurrent.Caption := FormatFloat('0.0',
      dmCrunchCount.tblClients['Weight']);
    lblGoalWeight.Caption := FormatFloat('0.0',
      dmCrunchCount.tblClients['GoalWeight']);

    barWeightRemaining.Max := Round(dmCrunchCount.tblClients['GoalWeight']);
    barWeightRemaining.Min := 0;
    barWeightRemaining.Position := Round(dmCrunchCount.tblClients['Weight']);

    lblWeightRemaining.Caption :=
      FormatFloat('0.0', (dmCrunchCount.tblClients['GoalWeight'] - rWeight)) +
      ' kg remaining';
  end
  else
  begin
    // Weight loss scenario
    lblWeightCurrent.Caption := FormatFloat('0.0',
      dmCrunchCount.tblClients['Weight']);
    lblGoalWeight.Caption := FormatFloat('0.0',
      dmCrunchCount.tblClients['GoalWeight']);

    barWeightRemaining.Max := Round(dmCrunchCount.tblClients['Weight']);
    // Current weight as the max for loss
    barWeightRemaining.Min := 0; // Goal weight as the min for loss
    barWeightRemaining.Position :=
      Round(dmCrunchCount.tblClients['GoalWeight']);

    lblWeightRemaining.Caption :=
      FormatFloat('0.0', (dmCrunchCount.tblClients['Weight'] -
      dmCrunchCount.tblClients['GoalWeight'])) + ' kg remaining';
  end;

end;

procedure TfrmClient.SetTabStops;
begin

  redFoodLog.Paragraph.TabCount := 6;
  redFoodLog.Paragraph.Tab[0] := 100;
  redFoodLog.Paragraph.Tab[1] := 170;
  redFoodLog.Paragraph.Tab[2] := 240;
  redFoodLog.Paragraph.Tab[3] := 320;
  redFoodLog.Paragraph.Tab[4] := 390;
  redFoodLog.Paragraph.Tab[5] := 460;

  redFoodLog.Lines.Add('Food Name' + #9 + 'Calories (kcal)' + #9 +
    'Carbohydrates (g)' + #9 + 'Sugar (g)' + #9 + 'Protein (g)' + #9 +
    'Fat (g)');

  redFoodLog.Lines.Add('');
  redFoodLog.Lines.Add(StringOfChar('-', ((redFoodLog.Width div 2) - 50)));
  redFoodLog.Lines.Add('');

end;

procedure TfrmClient.UpdateChart;
var
  iRecNo: Integer;
begin
  with dmCrunchCount do
  begin

    sFoodName := tblFoods['FoodName'];

    rCarbs := tblFoods['Carbohydrates'];
    rSugar := tblFoods['Sugar'];
    rProtein := tblFoods['Protein'];
    rFat := tblFoods['Fat'];

    Chart1.Series[0].Clear;

    Chart1.Series[0].Add(rCarbs, 'Carbohydrates');
    Chart1.Series[0].Add(rSugar, 'Sugar');
    Chart1.Series[0].Add(rProtein, 'Protein');
    Chart1.Series[0].Add(rFat, 'Fat');

    Chart1.Title.Clear;
    Chart1.Title.Text.Add('Macronutrients per 100g of ' + sFoodName);
  end;
end;

end.

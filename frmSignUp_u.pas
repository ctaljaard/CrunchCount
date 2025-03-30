unit frmSignUp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Spin, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, Vcl.Imaging.pngimage, dmCrunchCount_u,
  Math;

type
  TfrmSignUp = class(TForm)
    gbxSignUp: TGroupBox;
    lblAge: TLabel;
    lblLogin: TLabel;
    ldtUsername: TLabeledEdit;
    bbnCreateAccount: TBitBtn;
    ldtPassword: TLabeledEdit;
    rgpGender: TRadioGroup;
    ldtEmail: TLabeledEdit;
    sedAge: TSpinEdit;
    rgpUser: TRadioGroup;
    ldtConfirmPassword: TLabeledEdit;
    ldtWeight: TLabeledEdit;
    ldtHeight: TLabeledEdit;
    imgLogo: TImage;
    btnShowHidePassword: TButton;
    btnShowHideConfirmPassword: TButton;
    procedure lblLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbnCreateAccountClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure btnShowHidePasswordClick(Sender: TObject);
    procedure btnShowHideConfirmPasswordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bValid: boolean;
  end;

var
  frmSignUp: TfrmSignUp;

implementation

uses
  frmLogin_u;

{$R *.dfm}

procedure TfrmSignUp.bbnCreateAccountClick(Sender: TObject);
var
  rWeight, rHeight: real;
  sSpecials: string;
  i, iUserIDSignUp, iPT: integer;
  bUppercase, bLowercase, bNumber, bSpecial, bGenderSignUp,
    bIsClientSignUp: boolean;
begin
  bValid := True;

  FormatSettings.DecimalSeparator := '.';

  if (ldtEmail.Text = '') AND (bValid = True) then
  begin
    MessageDlg('Email cannot be empty.', mtError, [mbOK], 0);
    bValid := False;
    ldtEmail.SetFocus;
  end
  else if (ldtUsername.Text = '') AND (bValid = True) then
  begin
    MessageDlg('Username cannot be empty.', mtError, [mbOK], 0);
    bValid := False;
    ldtUsername.SetFocus;
  end
  else if (ldtPassword.Text = '') AND (bValid = True) then
  begin
    MessageDlg('Password cannot be empty.', mtError, [mbOK], 0);
    bValid := False;
    ldtPassword.SetFocus;
  end
  else if (ldtConfirmPassword.Text = '') AND (bValid = True) then
  begin
    MessageDlg('Confirm password cannot be empty.', mtError, [mbOK], 0);
    bValid := False;
    ldtConfirmPassword.SetFocus;
  end
  else if (rgpGender.ItemIndex < 0) AND (bValid = True) then
  begin
    MessageDlg('Please select a gender.', mtError, [mbOK], 0);
    bValid := False;
  end
  else if (rgpUser.ItemIndex < 0) AND (bValid = True) then
  begin
    MessageDlg('Please select a user type.', mtError, [mbOK], 0);
    bValid := False;
  end
  else if (ldtWeight.Text = '') AND (bValid = True) then
  begin
    MessageDlg('Weight cannot be empty.', mtError, [mbOK], 0);
    bValid := False;
    ldtWeight.SetFocus;
  end
  else if (ldtHeight.Text = '') AND (bValid = True) then
  begin
    MessageDlg('Height cannot be empty.', mtError, [mbOK], 0);
    bValid := False;
    ldtHeight.SetFocus;
  end
  else if bValid = True then
  begin
    if (bValid = True) AND ((pos('@', ldtEmail.Text) < 2) OR
      (pos('.', ldtEmail.Text) < ((pos('@', ldtEmail.Text)) + 2)) OR
      (pos('.', ldtEmail.Text) = length(ldtEmail.Text))) OR
      (pos(' ', ldtEmail.Text) > 0) then
    begin
      MessageDlg('Invalid email address.', mtError, [mbOK], 0);
      bValid := False;
      ldtEmail.SetFocus;
    end;

    if bValid = True then
    begin
      if length(ldtUsername.Text) > 20 then
      begin
        MessageDlg('Username must contain 20 or fewer characters.', mtError,
          [mbOK], 0);
        Exit;
      end
      else
      begin
        for i := 1 to length(ldtUsername.Text) do
        begin
          if NOT(ldtUsername.Text[i] IN ['A' .. 'Z', 'a' .. 'z', '0' .. '9'])
          then
          begin
            MessageDlg
              ('Username must not contain spaces or special characters.',
              mtError, [mbOK], 0);
            bValid := False;
            ldtUsername.SetFocus;
            Exit;
          end;
        end;
      end;
    end;

    if bValid = True then
    begin
      bUppercase := False;
      bLowercase := False;
      bNumber := False;
      bSpecial := False;
      sSpecials := ' !"#$%&''()*+,-./:;<=>?@[\]^_`{|}~';

      if length(ldtPassword.Text) < 8 then
      begin
        MessageDlg('Password must contain at least 8 characters.', mtError,
          [mbOK], 0);
        Exit;
      end
      else if length(ldtPassword.Text) > 20 then
      begin
        MessageDlg('Password must contain 20 or fewer characters.', mtError,
          [mbOK], 0);
        Exit;
      end
      else
      begin
        for i := 1 to length(ldtPassword.Text) do
        begin
          if ldtPassword.Text[i] IN ['A' .. 'Z'] then
            bUppercase := True;
          if ldtPassword.Text[i] IN ['a' .. 'z'] then
            bLowercase := True;
          if ldtPassword.Text[i] IN ['0' .. '9'] then
            bNumber := True;
          if pos(ldtPassword.Text[i], sSpecials) > 0 then
            bSpecial := True;
        end;

        if not bUppercase then
        begin
          MessageDlg('Password must contain at least one uppercase letter.',
            mtError, [mbOK], 0);
          bValid := False;
        end
        else if not bLowercase then
        begin
          MessageDlg('Password must contain at least one lowercase letter.',
            mtError, [mbOK], 0);
          bValid := False;
        end
        else if not bNumber then
        begin
          MessageDlg('Password must contain a number.', mtError, [mbOK], 0);
          bValid := False;
        end
        else if not bSpecial then
        begin
          MessageDlg('Password must contain a special character.', mtError,
            [mbOK], 0);
          bValid := False;
        end;

        if bValid = True then
        begin
          ShowMessage('Your password is strong!');
        end;
      end;
    end;

    if bValid = True then
    begin
      if ldtPassword.Text <> ldtConfirmPassword.Text then
      begin
        MessageDlg('Passwords do not match.', mtError, [mbOK], 0);
        bValid := False;
        ldtConfirmPassword.Clear;
        ldtPassword.SetFocus;
      end;
    end;

    if bValid = True then
    begin
      try
        if StrToFloat(ldtWeight.Text) <= 0 then
        begin
          MessageDlg('Please enter a positive weight value.', mtError,
            [mbOK], 0);
          bValid := False;
          ldtWeight.Clear;
          ldtWeight.SetFocus;
        end;
      except
        on E: EConvertError do
        begin
          MessageDlg
            ('Please enter a valid weight value. Use "." as the decimal separator.',
            mtError, [mbOK], 0);
          bValid := False;
          ldtWeight.Clear;
          ldtWeight.SetFocus;
        end;
      end;
    end;

    if bValid = True then
    begin
      try
        if StrToFloat(ldtHeight.Text) <= 0 then
        begin
          MessageDlg('Please enter a positive height value.', mtError,
            [mbOK], 0);
          bValid := False;
          ldtHeight.Clear;
          ldtHeight.SetFocus;
        end;
      except
        on E: EConvertError do
        begin
          MessageDlg
            ('Please enter a valid height value. Use "." as the decimal separator.',
            mtError, [mbOK], 0);
          bValid := False;
          ldtHeight.Clear;
          ldtHeight.SetFocus;
        end;
      end;
    end;

    if bValid = True then
    begin
      // ShowMessage('Account created successfully.');

      if rgpUser.ItemIndex = 0 then
      begin
        bIsClientSignUp := True;
      end
      else
      begin
        bIsClientSignUp := False;
      end;

      if rgpGender.ItemIndex = 0 then
      begin
        bGenderSignUp := True;
      end
      else
      begin
        bGenderSignUp := False;
      end;

      with dmCrunchCount do
      begin
        tblusers.append;
        tblusers['Username'] := ldtUsername.Text;
        tblusers['Password'] := ldtPassword.Text;
        tblusers['IsClient'] := bIsClientSignUp;

        tblusers.Post;
        tblusers.Refresh;

        iUserIDSignUp := tblusers['UserID'];

        if bIsClientSignUp = True then
        begin
          tblClients.append;
          tblClients['UserID'] := iUserIDSignUp;
          tblClients['PTID'] := randomrange(1, tblPTs.RecordCount + 1);
          tblClients['Email'] := ldtEmail.Text;
          tblClients['Gender'] := bGenderSignUp;
          tblClients['Age'] := sedAge.Value;
          tblClients['Weight'] := ldtWeight.Text;
          tblClients['Height'] := ldtHeight.Text;
          tblClients['GoalCalories'] := 0;
          tblClients['GoalProtein'] := 0;
          tblClients['GoalWeight'] := 0;
          tblClients['Message'] := '';
          tblClients.Post;
          tblClients.Refresh;
          ShowMessage('Client ' + ldtUsername.Text + ' successfully added!');

          frmLogin.Show;
          frmLogin.Enabled := True;
          frmSignUp.Hide;
        end
        else
        begin
          tblPTs.append;
          tblPTs['UserID'] := iUserIDSignUp;
          tblPTs['Email'] := ldtEmail.Text;
          tblPTs.Post;
          tblPTs.Refresh;
          ShowMessage('Personal Trainer ' + ldtUsername.Text +
            ' successfully added!');

          frmLogin.Show;
          frmLogin.Enabled := True;
          frmSignUp.Hide;
        end;

        ldtEmail.Clear;
        ldtUsername.Clear;
        ldtPassword.Clear;
        ldtConfirmPassword.Clear;
        sedAge.Clear;
        rgpGender.ItemIndex := -1;
        rgpUser.ItemIndex := -1;
        ldtWeight.Clear;
        ldtHeight.Clear;
      end;

    end;
  end;
end;

procedure TfrmSignUp.btnShowHidePasswordClick(Sender: TObject);
begin
  if ldtPassword.PasswordChar = '*' then
  begin
    ldtPassword.PasswordChar := #0;
    btnShowHidePassword.Caption := 'Hide';
  end
  else
  begin
    ldtPassword.PasswordChar := '*';
    btnShowHidePassword.Caption := 'Show';
  end;
end;

procedure TfrmSignUp.btnShowHideConfirmPasswordClick(Sender: TObject);
begin
  if ldtConfirmPassword.PasswordChar = '*' then
  begin
    ldtConfirmPassword.PasswordChar := #0;
    btnShowHidePassword.Caption := 'Hide';
  end
  else
  begin
    ldtConfirmPassword.PasswordChar := '*';
    btnShowHidePassword.Caption := 'Show';
  end;
end;

procedure TfrmSignUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmLogin.Show;
  frmLogin.Enabled := True;
end;

procedure TfrmSignUp.FormHide(Sender: TObject);
begin
  frmSignUp.Hide;
  frmLogin.Show;
end;

procedure TfrmSignUp.FormShow(Sender: TObject);
begin
  ldtUsername.Clear;
  ldtPassword.Clear;
  ldtEmail.Clear;
  ldtConfirmPassword.Clear;
  ldtWeight.Clear;
  ldtHeight.Clear;
  rgpGender.ItemIndex := -1;
  rgpUser.ItemIndex := -1;
  sedAge.Value := 1;
  ldtEmail.SetFocus;
  imgLogo.Stretch := False;
  imgLogo.Proportional := True;
  imgLogo.Picture.LoadFromFile('CrunchCount logo vertical.png');
end;

procedure TfrmSignUp.lblLoginClick(Sender: TObject);
begin
  frmSignUp.Hide;
  frmLogin.Enabled := True;
  frmLogin.ldtUsername.SetFocus;
  frmLogin.Show;
end;

end.

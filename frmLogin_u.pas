// Christopher Taljaard 2024

unit frmLogin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Math, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, frmSignUp_u, frmClient_u,
  frmPT_u, Vcl.Samples.Spin, dmCrunchCount_u;

type
  TfrmLogin = class(TForm)
    imgLogo: TImage;
    ldtUsername: TLabeledEdit;
    bbnEnter: TBitBtn;
    gbxLogin: TGroupBox;
    ldtPassword: TLabeledEdit;
    lblSignUp: TLabel;
    btnShowHidePassword: TButton;
    procedure FormActivate(Sender: TObject);
    procedure lblSignUpClick(Sender: TObject);
    procedure bbnEnterClick(Sender: TObject);
    procedure btnShowHidePasswordClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmLogin: TfrmLogin;
  bIsClient: boolean;
  iUserID: integer;
  iClientID: integer;
  iPTID: integer;
  sUsername: string;

implementation

{$R *.dfm}

procedure TfrmLogin.bbnEnterClick(Sender: TObject);
var
  sInUsername, sInPass, sUsername, sPass: string;
  bFound, bValid: boolean;
begin

  if NOT((ldtUsername.Text = '') OR (ldtPassword.Text = '')) then
  begin
    sInUsername := ldtUsername.Text;
    sInPass := ldtPassword.Text;
    bFound := False;
    bValid := False;

    with dmCrunchCount do
    begin
      tblUsers.First;
      while not tblUsers.Eof do
      begin
        if tblUsers['Username'] = sInUsername then
        begin
          sUsername := tblUsers['Username'];
          iUserID := tblUsers['UserID'];
          bFound := True;
          sPass := tblUsers['Password'];
          break
        end;
        tblUsers.Next;
      end;

      if bFound = False then
      begin
        MessageDlg('Incorrect username', mtError, [mbOK], 0);
      end
      else
      begin
        if sInPass = sPass then
        begin
          bValid := True;
        end
        else
        begin
          MessageDlg('Incorrect password', mtError, [mbOK], 0);
        end;

      end;

      if bValid = True then
      begin
        if tblUsers['IsClient'] = True then
        begin
          bIsClient := True;
          tblClients.Open;
          tblClients.First;
          if tblClients.Locate('UserID', iUserID, []) then
            iClientID := tblClients['ClientID'];
        end
        else
        begin
          bIsClient := False;
          tblPTs.Open;
          tblPTs.First;
          tblPTs.Locate('UserID', iUserID, []);
          iPTID := tblPTs['PTID'];
        end;

        tblUsers.Locate('UserID', iUserID, []);
        sUsername := tblUsers['Username'];
      end;
    end;

  end
  else
  begin
    MessageDlg('Username and password must not be empty', mtError, [mbOK], 0);
  end;

  if bValid = True then
  begin
    if bIsClient = True then
    begin
      frmLogin.Hide;
      if not Assigned(frmClient) then
      begin
        frmClient := TfrmClient.Create(Application);
      end;
      frmClient.Show;
    end
    else
    begin
      if not Assigned(frmPT) then
      begin
        frmPT := TfrmPT.Create(Application);
      end;
      frmPT.Show;
    end;

  end;
end;

procedure TfrmLogin.btnShowHidePasswordClick(Sender: TObject);
begin

  if ldtPassword.PasswordChar = #0 then
  begin
    ldtPassword.PasswordChar := '*';
    btnShowHidePassword.Caption := 'Show';
  end
  else
  begin
    ldtPassword.PasswordChar := #0;
    btnShowHidePassword.Caption := 'Hide';
  end;
end;

procedure TfrmLogin.FormActivate(Sender: TObject);
begin
  imgLogo.Stretch := False;
  imgLogo.Proportional := True;
  imgLogo.Picture.LoadFromFile('CrunchCount logo vertical.png');

end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  ldtUsername.setfocus;
end;

procedure TfrmLogin.lblSignUpClick(Sender: TObject);
begin
  frmSignUp.Show;
  frmLogin.Enabled := False;

end;

end.

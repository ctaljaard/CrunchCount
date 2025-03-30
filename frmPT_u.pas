unit frmPT_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dmCrunchCount_u, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, frmClient_u, Vcl.ComCtrls;

type
  TfrmPT = class(TForm)
    gbxPT: TGroupBox;
    imgLogo: TImage;
    bbnLogOut: TBitBtn;
    cbxClients: TComboBox;
    bbnViewAccount: TBitBtn;
    gbxMessagePT: TGroupBox;
    redMessagePT: TRichEdit;
    bbnSendMessage: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure LogOut;
    procedure bbnLogOutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bbnSendMessageClick(Sender: TObject);
    procedure bbnViewAccountClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sPTUsername: string;
    iUserIDpermanent: integer;
  end;

var
  frmPT: TfrmPT;

implementation

{$R *.dfm}

uses

  frmLogin_u;

procedure TfrmPT.bbnLogOutClick(Sender: TObject);
begin
  LogOut;
end;

procedure TfrmPT.bbnSendMessageClick(Sender: TObject);
var
  sUserIDFound, sCBX: string;
begin
  if redMessagePT.Text = '' then
  begin
    showmessage('Please enter a message');
  end
  else if cbxClients.itemindex = -1 then
  begin
    showmessage('Please select a client');
  end
  else
  begin
    with dmCrunchCount do
    begin
      sCBX := cbxClients.Items[cbxClients.itemindex];
      tblUsers.Locate('Username', sCBX, []);
      sUserIDFound := tblUsers['UserID'];
      tblClients.Locate('UserID', sUserIDFound, []);
      tblClients.edit;
      tblClients['Message'] := redMessagePT.Text;
      tblClients.post;
    end;

    showmessage('Successfully sent!');
  end;
end;

procedure TfrmPT.bbnViewAccountClick(Sender: TObject);
begin
  if cbxClients.itemindex = -1 then
  begin
    showmessage('Please select a client');
  end
  else
  begin

    with dmCrunchCount do
    begin
      tblUsers.Locate('Username', cbxClients.Items[cbxClients.itemindex], []);
      tblClients.Locate('UserID', tblUsers['UserID'], []);
      iUserID := tblClients['UserID'];
      iclientID := tblClients['ClientID'];
      bIsClient := True;

    end;

    sPTUsername := sUsername;

    if not Assigned(frmClient) then
    begin

      frmClient := TfrmClient.Create(Application);
    end;
    frmClient.Show;
  end;

end;

procedure TfrmPT.FormActivate(Sender: TObject);
begin
  imgLogo.Stretch := False;
  imgLogo.Proportional := True;
  imgLogo.Picture.LoadFromFile('CrunchCount logo vertical.png');

  dmCrunchCount.tblClients.First;

  cbxClients.clear;
  cbxClients.Text := 'Select a client';

  iUserIDpermanent := iUserID;
  dmCrunchCount.tblPTs.Locate('PTID', iPTID, []);
  dmCrunchCount.tblUsers.Locate('UserID', dmCrunchCount.tblPTs['UserID'], []);

  sPTUsername := dmCrunchCount.tblUsers['Username'];

  with dmCrunchCount do
  begin
    for var i := 1 to tblClients.RecordCount do
    begin
      if tblClients['PTID'] = iPTID then
      begin
        tblUsers.Locate('UserID', tblClients['UserID'], []);
        cbxClients.Items.add(tblUsers['Username']);
      end;
      tblClients.Next;
    end;

  end;

  cbxClients.itemindex := -1;

  redMessagePT.clear;
end;

procedure TfrmPT.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  iResponse: integer;
  // sUsername: string;
begin
  // Call LogOut to confirm logout

  iResponse := MessageDlg('Are you sure you would like to log out of ' +
    sPTUsername + '''s account?', mtConfirmation, [mbYes, mbNo], 0);
  if iResponse = mrYes then
  begin
    showmessage('Log out successful');
    CanClose := True;
    frmLogin.Show;
    frmClient.Hide;
    frmLogin.ldtUsername.clear;
    frmLogin.ldtPassword.clear;
  end
  else
  begin
    showmessage('Log out aborted');
    CanClose := False;
  end;
end;

procedure TfrmPT.LogOut;
var
  iResponse: integer;
  sUsername: string;
begin
  // with dmCrunchCount do
  // begin
  // tblUsers.Locate('UserID', iUserID, []);
  // sUsername := tblUsers['Username'];
  // end;

  iResponse := MessageDlg('Are you sure you would like to log out of ' +
    sPTUsername + '''s account?', mtConfirmation, [mbYes, mbNo], 0);

  if iResponse = mrYes then
  begin
    showmessage('Log out successful');
    frmLogin.Show;
    frmPT.Hide;
    frmLogin.ldtUsername.clear;
    frmLogin.ldtPassword.clear;
  end
  else
  begin
    showmessage('Log out aborted');
  end;
end;

end.

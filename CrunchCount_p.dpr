program CrunchCount_p;

uses
  Vcl.Forms,
  frmLogin_u in 'frmLogin_u.pas' {frmLogin},
  dmCrunchCount_u in 'dmCrunchCount_u.pas' {dmCrunchCount: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  frmSignUp_u in 'frmSignUp_u.pas' {frmSignUp},
  frmClient_u in 'frmClient_u.pas' {frmClient},
  frmPT_u in 'frmPT_u.pas' {frmPT};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TdmCrunchCount, dmCrunchCount);
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TfrmClient, frmClient);
  Application.CreateForm(TfrmPT, frmPT);
  Application.Run;
end.

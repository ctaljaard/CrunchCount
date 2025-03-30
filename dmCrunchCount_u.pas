// Christopher Taljaard 2024
unit dmCrunchCount_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmCrunchCount = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    conCrunchCountDB: TADOConnection;

    tblUsers: TADOTable;
    dscUsers: TDataSource;

    tblClients: TADOTable;
    dscClients: TDataSource;

    tblPTs: TADOTable;
    dscPTs: TDataSource;

    tblFoods: TADOTable;
    dscFoods: TDataSource;

   // tblLogFoods: TADOTable;
   // dscLogFoods: TDataSource;

  end;

var
  dmCrunchCount: TdmCrunchCount;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TdmCrunchCount.DataModuleCreate(Sender: TObject);
begin
  conCrunchCountDB := TADOConnection.Create(dmCrunchCount);

  tblUsers := TADOTable.Create(dmCrunchCount);
  dscUsers := TDataSource.Create(dmCrunchCount);

  tblClients := TADOTable.Create(dmCrunchCount);
  dscClients := TDataSource.Create(dmCrunchCount);

  tblPTs := TADOTable.Create(dmCrunchCount);
  dscPTs := TDataSource.Create(dmCrunchCount);

  tblFoods := TADOTable.Create(dmCrunchCount);
  dscFoods := TDataSource.Create(dmCrunchCount);

  // tblLogFoods := TADOTable.Create(dmCrunchCount);
  // dscLogFoods := TDataSource.Create(dmCrunchCount);

  conCrunchCountDB.Close;

  conCrunchCountDB.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
    ExtractFilePath(ParamStr(0)) + 'CrunchCount.mdb' +
    ';Persist Security Info=False';

  conCrunchCountDB.LoginPrompt := False;

  conCrunchCountDB.Open;

  tblUsers.Connection := conCrunchCountDB;
  tblUsers.TableName := 'tblUsers';
  dscUsers.DataSet := tblUsers;
  tblUsers.Open;

  tblClients.Connection := conCrunchCountDB;
  tblClients.TableName := 'tblClients';
  dscClients.DataSet := tblClients;
  tblClients.Open;

  tblPTs.Connection := conCrunchCountDB;
  tblPTs.TableName := 'tblPTs';
  dscPTs.DataSet := tblPTs;
  tblPTs.Open;

  tblFoods.Connection := conCrunchCountDB;
  tblFoods.TableName := 'tblFoods';
  dscFoods.DataSet := tblFoods;
  tblFoods.Open;

  // tblLogFoods.Connection := conCrunchCountDB;
  // tblLogFoods.TableName := 'tblLogFoods';
  // dscLogFoods.DataSet := tblLogFoods;
  // tblLogFoods.Open;

end;

end.

unit uDBConnection;

interface

uses
  Vcl.Forms, Winapi.Windows, Vcl.Dialogs, System.SysUtils, System.IniFiles, FireDAC.Comp.Client,
  FireDAC.Stan.Def, StrUtils, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.IBBase,
  FireDAC.DApt, FireDAC.Phys.IB, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

type
  IDatabaseConnection = interface
    ['{10464CBE-2D1A-41DF-BB93-FDE84165076E}']
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
    function GetConnection : TFDConnection;
    function CreateQuery : TFDQuery;
  end;

  TDatabaseConnection = class(TInterfacedObject, IDatabaseConnection)
  private
    FConnection                : TFDConnection;
    FTransaction               : TFDTransaction;
    FDriverLink                : TFDPhysDriverLink;
    class var FInstance        : IDatabaseConnection;
    class function GetInstance : IDatabaseConnection; static;
    constructor Create;
    procedure LoadConnectionConfig();
  public
    destructor Destroy; override;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
    function GetConnection : TFDConnection;
    function CreateQuery : TFDQuery;
    property Connection : TFDConnection read GetConnection;
    class property Instance : IDatabaseConnection read GetInstance;
  end;

implementation

{ TDatabaseConnection }

constructor TDatabaseConnection.Create;
begin
  inherited;
  FConnection             := TFDConnection.Create(nil);
  FTransaction            := TFDTransaction.Create(nil);
  FConnection.Transaction := FTransaction;
  LoadConnectionConfig;
end;

destructor TDatabaseConnection.Destroy;
begin
  FreeAndNil(FConnection);
  FreeAndNil(FTransaction);
  FreeAndNil(FDriverLink);
  inherited Destroy;
end;

function TDatabaseConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

function TDatabaseConnection.CreateQuery: TFDQuery;
begin
  Result            := TFDQuery.Create(nil);
  Result.Connection := GetConnection;
end;

class function TDatabaseConnection.GetInstance: IDatabaseConnection;
begin
  if not Assigned(FInstance) then
    FInstance := TDatabaseConnection.Create;

  Result := FInstance;
end;

procedure TDatabaseConnection.LoadConnectionConfig();
var
  vIniFile           : TIniFile;
  vDBType, vFileName : String;
begin
  vFileName := ExtractFilePath(ParamStr(0)) + 'Conexao.ini';
  vIniFile := TIniFile.Create(vFileName);

  try
    try
      vDBType := vIniFile.ReadString('Conexao', 'DBType', '');

      if vDBType = 'Firebird' then
      begin
        FDriverLink := TFDPhysFBDriverLink.Create(nil);
        FConnection.Params.DriverID := 'FB';
      end
      else
      begin
        FDriverLink := TFDPhysMSSQLDriverLink.Create(nil);
        FConnection.Params.DriverID := 'MSSQL';
      end;

      FConnection.Params.Database := vIniFile.ReadString('Conexao', 'DataBase', '');
      FConnection.Params.UserName := vIniFile.ReadString('Conexao', 'UserName', '');
      FConnection.Params.Password := vIniFile.ReadString('Conexao', 'Password', '');
      FConnection.Params.Add('Server=' + vIniFile.ReadString('Conexao', 'Server', ''));
      FConnection.Connected := True;
    except
      on E: Exception do
      begin
        Application.MessageBox('Não foi possível conectar ao Banco de Dados', 'Erro', MB_OK + MB_ICONERROR);
        raise;
      end;
    end;
  finally
    vIniFile.Free;
  end;
end;

procedure TDatabaseConnection.StartTransaction;
begin
  FTransaction.StartTransaction;
end;

procedure TDatabaseConnection.Commit;
begin
  FTransaction.Commit;
end;

procedure TDatabaseConnection.Rollback;
begin
  FTransaction.Rollback;
end;

end.


unit uTarefaController;

interface

uses
  System.Generics.Collections, uTarefa, uTarefaDAO, uDBConnection,
  Datasnap.DBClient;

type
  TTarefaController = class
  private
    FTarefaDAO: ITarefaDAO;
  public
    constructor Create;
    function Salvar(const pTarefa: TTarefa): Boolean;
    function Excluir(const pId: Integer): Boolean;
    procedure Consultar(pDataSet: TClientDataSet; pWhere: string = '');
  end;

implementation

uses
  System.SysUtils;

{ TTarefaController }

constructor TTarefaController.Create;
var vConnection: IDatabaseConnection;
begin
  vConnection := TDatabaseConnection.Instance;
  FTarefaDAO  := TTarefaDAO.Create(vConnection);
end;

function TTarefaController.Salvar(const pTarefa: TTarefa) : Boolean;
begin
  Result := FTarefaDAO.Salvar(pTarefa);
end;

function TTarefaController.Excluir(const pId: Integer) : Boolean;
begin
  Result := FTarefaDAO.Excluir(pId);
end;

procedure TTarefaController.Consultar(pDataSet: TClientDataSet; pWhere: String = '');
begin
  pDataSet.Close;
  pDataSet.Data := TClientDataSet(FTarefaDAO.Consultar(pWhere)).Data;
end;

end.


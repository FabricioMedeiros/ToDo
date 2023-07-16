unit uTarefaDAO;

interface

uses
  System.SysUtils, Vcl.Forms, Winapi.Windows, System.Generics.Collections, FireDAC.Comp.Client,
  uDBConnection, Data.DB, uTarefa, FireDAC.Stan.Param, System.StrUtils,
  Datasnap.DBClient, System.Classes, Datasnap.Provider, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.Async;

type
  ITarefaDAO = interface
  ['{E2D20C83-0ABD-4B89-9B4D-02DA4C15E4AB}']
  function Salvar(const pTarefa: TTarefa): Boolean;
  function Excluir(const pId: Integer): Boolean;
  function Consultar(pWhere: string): TClientDataSet;
  function ValidarCampos(const pTarefa: TTarefa): Boolean;
end;

TTarefaDAO = class(TInterfacedObject, ITarefaDAO)
private
  FConnection : IDatabaseConnection;
public
  constructor Create(pConnection : IDatabaseConnection);
  function Salvar(const pTarefa: TTarefa): Boolean;
  function Excluir(const pId: Integer): Boolean;
  function Consultar(pWhere: string): TClientDataSet;
  function ValidarCampos(const pTarefa: TTarefa): Boolean;
end;

implementation

{ TTarefaDAO }

constructor TTarefaDAO.Create(pConnection : IDatabaseConnection);
begin
  FConnection := pConnection;
end;

function TTarefaDAO.Salvar(const pTarefa: TTarefa): Boolean;
var vQuery : TFDQuery;
    Params : TFDParams;
begin
  Result := False;

  if not ValidarCampos(pTarefa) then
    Exit;

  FConnection.StartTransaction;

  try
    try
      vQuery := FConnection.CreateQuery;

      if (pTarefa.Id = 0) then
      begin
        vQuery.SQL.Text := 'INSERT INTO TAREFAS                                     ' +
                           '(DESCRICAO, DATA_HORA, PRIORIDADE, CONCLUIDA)           ' +
                           'VALUES(:DESCRICAO, :DATA_HORA, :PRIORIDADE, :CONCLUIDA) ' +

        IfThen(FConnection.GetConnection.DriverName = 'FB', 'RETURNING ID', 'SELECT ID = SCOPE_IDENTITY()');

        Params := vQuery.Params;
        Params.ParamByName('DESCRICAO').AsString   := pTarefa.Descricao;
        Params.ParamByName('DATA_HORA').AsDateTime := pTarefa.DataHora;
        Params.ParamByName('PRIORIDADE').AsInteger := Ord(pTarefa.Prioridade);
        Params.ParamByName('CONCLUIDA').AsBoolean  := pTarefa.Concluida;
        vQuery.Open;

        pTarefa.Id := vQuery.FieldByName('ID').AsInteger;
      end
      else
      begin
        vQuery.SQL.Text := 'UPDATE                       ' +
                          '  TAREFAS                     ' +
                          'SET                           ' +
                          '  DESCRICAO = :DESCRICAO,     ' +
                          '  DATA_HORA = :DATA_HORA,     ' +
                          '  PRIORIDADE = :PRIORIDADE,   ' +
                          '  CONCLUIDA = :CONCLUIDA      ' +
                          'WHERE ID = :ID                ';

        Params := vQuery.Params;
        Params.ParamByName('ID').AsInteger         := pTarefa.Id;
        Params.ParamByName('DESCRICAO').AsString   := pTarefa.Descricao;
        Params.ParamByName('DATA_HORA').AsDateTime := pTarefa.DataHora;
        Params.ParamByName('PRIORIDADE').AsInteger := Ord(pTarefa.Prioridade);
        Params.ParamByName('CONCLUIDA').AsBoolean  := pTarefa.Concluida;
        vQuery.ExecSQL;
      end;

      FConnection.Commit;
      Result := True;
   except
     on E: Exception do
     begin
       FreeAndNil(vQuery);
       FConnection.Rollback;
       Application.MessageBox(PChar('Erro ao salvar a tarefa: ' + E.Message), 'Erro', MB_ICONERROR);
       raise;
     end;
   end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function TTarefaDAO.ValidarCampos(const pTarefa: TTarefa): Boolean;
var vQuery : TFDQuery;
    Params : TFDParams;
begin
  Result := False;

  if (Trim(pTarefa.Descricao) = '') or (pTarefa.DataHora = 0) then
  begin
    Application.MessageBox('Preencha todas as informações da Tarefa.', 'Atenção', MB_ICONEXCLAMATION);
    Exit;
  end;

  vQuery := FConnection.CreateQuery;
  try
    vQuery.SQL.Text := 'SELECT ID FROM TAREFAS WHERE DATA_HORA = :DATA_HORA ' + IfThen(pTarefa.Id > 0, ' AND ID <> :ID ', '');

    Params := vQuery.Params;
    Params.ParamByName('DATA_HORA').AsDateTime := pTarefa.DataHora;

    if pTarefa.Id > 0 then
      Params.ParamByName('ID').AsInteger := pTarefa.Id;

    vQuery.Open;

    if not vQuery.IsEmpty then
    begin
      Application.MessageBox('Já existe uma tarefa cadastrada para a mesma data e hora.', 'Atenção', MB_ICONEXCLAMATION);
      Exit;
    end;
  finally
    FreeAndNil(vQuery);
  end;

  Result := True;
end;

function TTarefaDAO.Excluir(const pId: Integer) : Boolean;
var vQuery : TFDQuery;
begin
  Result := False;

  vQuery := FConnection.CreateQuery;

  FConnection.StartTransaction;

  try
    try
      vQuery.SQL.Text := 'DELETE FROM TAREFAS WHERE ID = :ID';
      vQuery.Params.ParamByName('ID').AsInteger := pId;
      vQuery.ExecSQL;

      FConnection.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FreeAndNil(vQuery);
        FConnection.Rollback;
        Application.MessageBox(PChar('Erro ao excluir a tarefa: ' + E.Message), 'Erro', MB_ICONERROR);
        raise;
      end;
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function TTarefaDAO.Consultar(pWhere: String) : TClientDataSet;
var vQuery           : TFDQuery;
    vDataSetProvider : TDataSetProvider;
begin
  Result           := TClientDataSet.Create(nil);
  vQuery           := FConnection.CreateQuery;
  vDataSetProvider := TDataSetProvider.Create(nil);

  try
    vQuery.SQL.Text := 'SELECT                                                                ' +
                       '  ID,                                                                 ' +
                       '  DESCRICAO,                                                          ' +
                       '  DATA_HORA,                                                          ' +
                       '  PRIORIDADE,                                                         ' +
                       '  CASE                                                                ' +
                       '    WHEN PRIORIDADE = 0 THEN ''Baixa''                                ' +
                       '    WHEN PRIORIDADE = 1 THEN ''Média''                                ' +
                       '    ELSE ''Alta''                                                     ' +
                       '  END PRIORIDADE_DESCRICAO,                                           ' +
                       '  CONCLUIDA                                                           ' +
                       'FROM                                                                  ' +
                       '  TAREFAS                                                             ' +
                       IfThen(Trim(pWhere) <> EmptyStr,
                       'WHERE (LOWER(DESCRICAO) LIKE ''%' + pWhere + '%'' ESCAPE ''\'') ', ' ') +
                       'ORDER BY                                                              ' +
                       '  DATA_HORA                                                           ';

    vDataSetProvider.DataSet := vQuery;
    TClientDataSet(Result).SetProvider(vDataSetProvider);
    Result.Open;
  except
    FreeAndNil(Result);
    raise;
  end;

  FreeAndNil(vDataSetProvider);
end;

end.

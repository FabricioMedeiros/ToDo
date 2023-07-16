unit uFrmConsultaTarefas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, uTarefa,
  uTarefaController;

type
  TFrmConsultaTarefas = class(TForm)
    pnlPesquisa: TPanel;
    Label1: TLabel;
    edtPesquisa: TEdit;
    btnPesquisar: TBitBtn;
    Panel1: TPanel;
    btnIncluir: TBitBtn;
    btnExcluir: TBitBtn;
    dtsTarefas: TDataSource;
    cdsTarefas: TClientDataSet;
    cdsTarefasID: TIntegerField;
    cdsTarefasDESCRICAO: TStringField;
    cdsTarefasDATA_HORA: TSQLTimeStampField;
    cdsTarefasPRIORIDADE: TIntegerField;
    cdsTarefasPRIORIDADE_DESCRICAO: TStringField;
    cdsTarefasCONCLUIDA: TBooleanField;
    grdTarefas: TDBGrid;
    procedure btnExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure grdTarefasDblClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure grdTarefasDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cdsTarefasCONCLUIDAGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure edtPesquisaChange(Sender: TObject);
  private
    FTarefa : TTarefa;
    FTarefaController: TTarefaController;
    procedure PreencherTarefa;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConsultaTarefas: TFrmConsultaTarefas;

implementation

{$R *.dfm}

uses uFrmCadastroTarefas;

procedure TFrmConsultaTarefas.FormCreate(Sender: TObject);
begin
  inherited;

  FTarefa           := TTarefa.Create;
  FTarefaController := TTarefaController.Create;
  FTarefaController.Consultar(cdsTarefas);
end;

procedure TFrmConsultaTarefas.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTarefa);
  FreeAndNil(FTarefaController);

  inherited;
end;

procedure TFrmConsultaTarefas.grdTarefasDblClick(Sender: TObject);
begin
  PreencherTarefa;

  if not Assigned(FTarefa) then
    Exit;

  FrmCadastroTarefas := TFrmCadastroTarefas.Create(Self, cdsTarefas, edtPesquisa.Text, FTarefa);
  FrmCadastroTarefas.ShowModal;
  FrmCadastroTarefas.Release;
end;

procedure TFrmConsultaTarefas.grdTarefasDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var CheckRect: TRect;
    DrawState: Integer;
begin
  if Column.FieldName = 'CONCLUIDA' then
  begin
    CheckRect.Left   := Rect.Left + (Rect.Width - 14) div 2;
    CheckRect.Right  := CheckRect.Left + 14;
    CheckRect.Top    := Rect.Top + (Rect.Height - 14) div 2;
    CheckRect.Bottom := CheckRect.Top + 14;

    grdTarefas.Canvas.FillRect(Rect);

    if Column.Field.AsBoolean then
      DrawState := DFCS_BUTTONCHECK or DFCS_CHECKED
    else
      DrawState := DFCS_BUTTONCHECK;

    DrawFrameControl(grdTarefas.Canvas.Handle, CheckRect, DFC_BUTTON, DrawState);
  end;
end;


procedure TFrmConsultaTarefas.PreencherTarefa();
begin
  if not (cdsTarefas.Active) or (cdsTarefas.isEmpty)  then
  begin
    FTarefa := nil;
    Exit;
  end;

  FTarefa.Id         := cdsTarefasID.AsInteger;
  FTarefa.Descricao  := cdsTarefasDESCRICAO.AsString;
  FTarefa.DataHora   := cdsTarefasDATA_HORA.AsDateTime;
  FTarefa.Prioridade := TPrioridade(cdsTarefasPRIORIDADE.asInteger);
  FTarefa.Concluida  := cdsTarefasCONCLUIDA.AsBoolean;
end;

procedure TFrmConsultaTarefas.btnIncluirClick(Sender: TObject);
begin
  FrmCadastroTarefas := TFrmCadastroTarefas.Create(Self, cdsTarefas, edtPesquisa.Text);
  FrmCadastroTarefas.ShowModal;
  FrmCadastroTarefas.Release;
end;

procedure TFrmConsultaTarefas.btnExcluirClick(Sender: TObject);
begin
  if not (cdsTarefas.Active) or (cdsTarefas.isEmpty)  then
    Exit;

  if (MessageBox(Self.Handle, PChar('Confirma a Exclusão da Tarefa: ' + cdsTarefasDESCRICAO.AsString + '?'), 'Atenção', MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2) <> ID_YES) then
    Exit;

  FTarefaController.Excluir(cdsTarefasID.AsInteger);
  FTarefaController.Consultar(cdsTarefas);
end;

procedure TFrmConsultaTarefas.btnPesquisarClick(Sender: TObject);
begin
  FTarefaController.Consultar(cdsTarefas, LowerCase(edtPesquisa.Text));
end;

procedure TFrmConsultaTarefas.edtPesquisaChange(Sender: TObject);
begin
  if Trim(EdtPesquisa.Text) = EmptyStr then
    btnPesquisar.Click;
end;


procedure TFrmConsultaTarefas.cdsTarefasCONCLUIDAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := EmptyStr;
end;

end.

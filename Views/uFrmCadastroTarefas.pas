unit uFrmCadastroTarefas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls, Datasnap.DBClient, uTarefa, uTarefaController, DateUtils;

type
  TFrmCadastroTarefas = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    edtDescricao: TEdit;
    dtpData: TDateTimePicker;
    cmbPrioridade: TComboBox;
    chkConcluida: TCheckBox;
    Panel1: TPanel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    btnFechar: TBitBtn;
    dtpHora: TDateTimePicker;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    cdsTarefas        : TClientDataSet;
    FTarefa           : TTarefa;
    FTarefaController : TTarefaController;
    FPesquisa         : String;
    procedure PreencherFormulario(pTarefa: TTarefa);
    procedure PreencherTarefa(var pTarefa: TTarefa);
    { Private declarations }
  public
    constructor Create(AOwner : TComponent; pClientDataSet : TClientDataset; pPesquisa : String; pTarefa : TTarefa = nil);
    destructor Destroy; override;
    { Public declarations }
  end;

var
  FrmCadastroTarefas: TFrmCadastroTarefas;

implementation

{$R *.dfm}

uses uUtils;

constructor TFrmCadastroTarefas.Create(AOwner: TComponent; pClientDataSet: TClientDataSet; pPesquisa: String; pTarefa: TTarefa = nil);
begin
  inherited Create(AOwner);

  cdsTarefas        := pClientDataSet;
  FPesquisa         := pPesquisa;
  FTarefa           := pTarefa;
  FTarefaController := TTarefaController.Create;
  PreencherFormulario(FTarefa);
end;

destructor TFrmCadastroTarefas.Destroy();
begin
  FreeAndNil(FTarefaController);
  inherited;
end;

procedure TFrmCadastroTarefas.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFrmCadastroTarefas.PreencherFormulario(pTarefa: TTarefa);
begin
  Caption := 'Cadastro de Tarefas - Inclusão';
  LimparCamposFormulario(Self);

  if Assigned(pTarefa) then
  begin
    Caption                 := 'Cadastro de Tarefas - Alteração';
    edtDescricao.Text       := pTarefa.Descricao;
    dtpData.Date            := pTarefa.DataHora;
    dtpHora.Time            := pTarefa.DataHora;
    cmbPrioridade.ItemIndex := Ord(pTarefa.Prioridade);
    chkConcluida.Checked    := pTarefa.Concluida;
  end;
end;

procedure TFrmCadastroTarefas.PreencherTarefa(var pTarefa: TTarefa);
begin
  if not Assigned(pTarefa) then
    pTarefa := TTarefa.Create;

  pTarefa.Descricao  := edtDescricao.Text;
  pTarefa.DataHora   := EncodeDateTime(YearOf(dtpData.Date), MonthOf(dtpData.Date), DayOf(dtpData.Date), HourOf(dtpHora.Time), MinuteOf(dtpHora.Time), 0, 0);
  pTarefa.Prioridade := TPrioridade(cmbPrioridade.ItemIndex);
  pTarefa.Concluida  := chkConcluida.Checked;
end;

procedure TFrmCadastroTarefas.btnSalvarClick(Sender: TObject);
begin
  PreencherTarefa(FTarefa);

  if FTarefaController.Salvar(FTarefa) then
  begin
    FTarefa := nil;
    FTarefaController.Consultar(cdsTarefas, FPesquisa);
    LimparCamposFormulario(Self);

    Application.MessageBox('Tarefa salva com sucesso!', 'Atenção', MB_ICONINFORMATION);
  end;

  edtDescricao.SetFocus;
end;

procedure TFrmCadastroTarefas.btnCancelarClick(Sender: TObject);
begin
  LimparCamposFormulario(Self);
  edtDescricao.SetFocus;
end;

procedure TFrmCadastroTarefas.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.

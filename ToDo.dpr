program ToDo;

uses
  Vcl.Forms,
  uDBConnection in 'Models\uDBConnection.pas',
  uTarefa in 'Models\uTarefa.pas',
  uTarefaDAO in 'Models\uTarefaDAO.pas',
  uTarefaController in 'Controllers\uTarefaController.pas',
  uUtils in 'Utils\uUtils.pas',
  uFrmConsultaTarefas in 'Views\uFrmConsultaTarefas.pas' {FrmConsultaTarefas},
  uFrmCadastroTarefas in 'Views\uFrmCadastroTarefas.pas' {FrmCadastroTarefas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmConsultaTarefas, FrmConsultaTarefas);
  Application.Run;
end.

unit uTarefa;

interface

type
  TPrioridade = (tpBaixa, tpMedia, tpAlta);

TTarefa = class
 private
  FId: Integer;
  FDescricao: string;
  FDataHora: TDateTime;
  FPrioridade: TPrioridade;
  FConcluida: Boolean;
public
  property Id: Integer read FId write FId;
  property Descricao: string read FDescricao write FDescricao;
  property DataHora: TDateTime read FDataHora write FDataHora;
  property Prioridade: TPrioridade read FPrioridade write FPrioridade;
  property Concluida: Boolean read FConcluida write FConcluida;
end;

implementation

end.

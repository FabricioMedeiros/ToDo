CREATE DATABASE 'CAMINHO\DO\BANCO_DE_DADOS\TAREFAS.FDB' PAGE_SIZE 8192;

CREATE TABLE TAREFAS (
  ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  DESCRICAO VARCHAR(100) NOT NULL,
  DATA_HORA TIMESTAMP NOT NULL,
  PRIORIDADE INTEGER NOT NULL,
  CONCLUIDA BOOLEAN NOT NULL
);

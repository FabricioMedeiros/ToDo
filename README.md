# Controle de Tarefas - Aplicativo VCL 💼

Aplicativo de Controle de Tarefas desenvolvido em Delphi, utilizando o framework VCL.

## Descrição

O Controle de Tarefas é um aplicativo para gerenciamento e organização de tarefas, permitindo aos usuários incluir, alterar, excluir e consultar suas tarefas de forma eficiente. O aplicativo foi desenvolvido seguindo boas práticas de Clean Code, visando um código legível, modular e de fácil manutenção.

## Tecnologias Utilizadas

- Delphi
- VCL (Visual Component Library)
- SQL Server
- Firebird
- Programação Orientada a Objeto (POO)
- Clean Code
- Padrão MVC (Model-View-Controller)

## Configuração de Conexão com Banco de Dados

O aplicativo suporta os bancos de dados SQL Server e Firebird. Para configurar a conexão com o banco de dados, siga as instruções abaixo:

### Configuração do Banco de Dados Firebird 💾

```ini
[Conexao]
DBType=Firebird
Server=localhost
Database=Caminho_do_Banco\Tarefas.fdb
UserName=SYSDBA
Password=masterkey

[Conexao]
DBType=MSSQL
Server=NOME_DA_MAQUINA
Database=Tarefas
UserName=USUARIO
Password=SENHA

Certifique-se de que o arquivo de configuração conexao.ini esteja presente no diretório raiz do aplicativo.
```
###  Scripts de Criação do Banco de Dados

Os scripts de criação dos bancos de dados estão disponíveis no diretório SCRIPTS. Certifique-se de executar os scripts correspondentes antes de configurar a conexão no arquivo conexao.ini. Os seguintes arquivos devem estar disponíveis:

- DB_Tarefas_Firebird.sql para a criação do banco de dados Firebird.
- DB_Tarefas_SQLServer.sql para a criação do banco de dados SQL Server.

/scripts
  - DB_Tarefas_Firebird.sql
  - DB_Tarefas_SQLServer.sql

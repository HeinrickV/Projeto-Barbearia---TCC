unit PesquisaCliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBGrids, DataModule;

type

  { TPesquisaClienteF }

  TPesquisaClienteF = class(TForm)
    BtnCancelar1: TBitBtn;
    BtnPesquisa1: TBitBtn;
    DBGrid1: TDBGrid;
    dsCliente: TDataSource;
    eCodigo: TEdit;
    LabelCodigo: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure BtnCancelar1Click(Sender: TObject);
    procedure BtnPesquisa1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);

  private

  public

  end;

var
  PesquisaClienteF: TPesquisaClienteF;

implementation

{$R *.lfm}
uses
  Orcamento ;

{ TPesquisaClienteF }

procedure TPesquisaClienteF.BtnCancelar1Click(Sender: TObject);
begin
  Close;
end;

procedure TPesquisaClienteF.BtnPesquisa1Click(Sender: TObject);
begin
  DataModuleF.qryCliente.Close;
  if ecodigo.Text = '' then
  begin

    DataModuleF.qryCliente.SQL.Text :=
      ' SELECT ' + ' CLIENTEID, ' + ' CPF_CNPJ_CLIENTE, ' +
      ' NOME_CLIENTE,' + 'TIPO_CLIENTE ' + 'FROM CLIENTE';
  end
  else
  begin
    DataModuleF.qryCliente.SQL.Text :=
      ' SELECT ' + ' CLIENTEID, ' + ' CPF_CNPJ_CLIENTE, ' + ' NOME_CLIENTE,' +
      'TIPO_CLIENTE ' + 'FROM CLIENTE' + ' WHERE CLIENTEID = ' + eCodigo.Text;
  end;
  DataModuleF.qryCliente.Open;
end;

procedure TPesquisaClienteF.DBGrid1DblClick(Sender: TObject);
begin

  DataModuleF.qryOrcamentoclienteid.AsInteger:=  DataModuleF.qryClienteclienteid.AsInteger;

  OrcamentoF.dbeDescrCat.Caption := DataModuleF.qryClientenome_cliente.AsString;

  Close;
end;




end.

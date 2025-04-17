unit PesqProd;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBGrids, DataModule;

type

  { TPesqProdF }

  TPesqProdF = class(TForm)
    BtnCancelar1: TBitBtn;
    BtnPesquisa1: TBitBtn;
    DBGrid1: TDBGrid;
    DsCategoria: TDataSource;
    edtPesqCat: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure BtnCancelar1Click(Sender: TObject);
    procedure BtnPesquisa1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    SelectedProdutoID: Integer;
    SelectedProdutoDesc: String;
    SelectedVlrUnit: Double;
  end;

var
  PesqProdF: TPesqProdF;

implementation
uses


{$R *.lfm}

{ TPesqProdF }

procedure TPesqProdF.DBGrid1DblClick(Sender: TObject);
begin
  if not DataModuleF.qryProduto.IsEmpty then
  begin
    SelectedProdutoID := DataModuleF.qryProduto.FieldByName('produtoid').AsInteger;
    SelectedProdutoDesc := DataModuleF.qryProduto.FieldByName('ds_produto').AsString;
    SelectedVlrUnit := DataModuleF.qryProduto.FieldByName('vl_venda_produto').AsFloat;
    ModalResult := mrOk;
  end;
end;

procedure TPesqProdF.BtnPesquisa1Click(Sender: TObject);
var
  AuxWhere : String;
begin
  if edtPesqCat.Text = '' then
    AuxWhere := '1 = 1'
  else
    AuxWhere := 'UPPER(DS_PRODUTO) LIKE UPPER(''%' + edtPesqCat.Text + '%'')';

  DataModuleF.qryProduto.Close;
  DataModuleF.qryProduto.SQL.Text :=
            'SELECT '+
            'PRODUTOID, '+
            'CATEGORIAPRODUTOID, '+
            'DS_PRODUTO, '+
            'OBS_PRODUTO, '+
            'VL_VENDA_PRODUTO, '+
            'DT_CADASTRO_PRODUTO, '+
            'STATUS_PRODUTO '+
            'FROM PRODUTO '+
            'WHERE STATUS_PRODUTO = ''ATIVO'' AND '+AuxWhere+' '+
            'ORDER BY DS_PRODUTO';
  DataModuleF.qryProduto.Open;
end;

procedure TPesqProdF.BtnCancelar1Click(Sender: TObject);
begin
  Close;
end;

procedure TPesqProdF.FormShow(Sender: TObject);
begin
  BtnPesquisa1.Click; // Executa a pesquisa ao abrir o formulário
  if DBGrid1.CanFocus then
    DBGrid1.SetFocus;
end;

end.

unit Produtos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  DBExtCtrls, Buttons, modelo, datamodule, DB, PesquisaCategoria;

type

  { TProdutosF }

  TProdutosF = class(TModeloF)
    DbDateNovo: TDBDateEdit;
    dbeDescrCat: TDBEdit;
    dbEditCategoria: TDBEdit;
    dbEditDesc: TDBEdit;
    dbEditId: TDBEdit;
    dbEditObs: TDBEdit;
    dbEditVenda: TDBEdit;
    DBStatus: TDBComboBox;
    dsProdutos: TDataSource;
    LabelStatus: TLabel;
    LabelCodigo: TLabel;
    LabelDataCad: TLabel;
    LabelObs: TLabel;
    LabelDescSimples: TLabel;
    LabelCategoria: TLabel;
    LabelValorVenda: TLabel;
    SpCategoria: TSpeedButton;
    procedure BtnCancelar1Click(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnExcluir1Click(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnPesquisa1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);

    procedure SpCategoriaClick(Sender: TObject);

  private

  public

  end;

var
  ProdutosF: TProdutosF;

implementation

{$R *.lfm}

{ TProdutosF }

procedure TProdutosF.BtnCancelar1Click(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  BtnPesquisa1Click(Sender);
end;

procedure TProdutosF.BtnCancelarClick(Sender: TObject);
begin
  Close;

end;

procedure TProdutosF.BtnExcluir1Click(Sender: TObject);
begin
  if MessageDlg('Aviso', 'Você tem certeza que deseja excluir o registro?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DataModuleF.qryProduto.Delete;
    pagecontrol1.TabIndex := 0;
  end;

end;

procedure TProdutosF.BtnGravarClick(Sender: TObject);
begin
  if DataModuleF.qryProduto.State in [dsEdit, dsInsert] then
  begin
    DataModuleF.qryProduto.Post;
    DataModuleF.qryProduto.ApplyUpdates;
    PageControl1.TabIndex := 0;
    ecodigo.Text := '';
    BtnPesquisa1Click(nil);
  end;
end;

procedure TProdutosF.BtnNovoClick(Sender: TObject);
begin
  PageControl1.TabIndex := 1;
  DataModuleF.qryProduto.insert;
  dbEditCategoria.SetFocus;
end;

procedure TProdutosF.BtnPesquisa1Click(Sender: TObject);
begin
  DataModuleF.qryProduto.Close;

  if eCodigo.Text = '' then
  begin

    DataModuleF.qryProduto.SQL.Text :=


      'SELECT p.PRODUTOID, p.CATEGORIAPRODUTOID, p.DS_PRODUTO, p.OBS_PRODUTO, '+
      'p.VL_VENDA_PRODUTO, p.DT_CADASTRO_PRODUTO, p.STATUS_PRODUTO, c.DS_CATEGORIA_PRODUTO '
      + 'FROM produto p ' + 'JOIN categoria_produto c ON p.CATEGORIAPRODUTOID = c.CATEGORIAPRODUTOID';

  end
  else
  begin
    DataModuleF.qryProduto.SQL.Text :=


      'SELECT ' + 'p.PRODUTOID, ' + 'p.CATEGORIAPRODUTOID, ' +
      'p.DS_PRODUTO, ' + 'p.OBS_PRODUTO, ' +
      'p.VL_VENDA_PRODUTO, ' + 'p.DT_CADASTRO_PRODUTO, ' +
      'p.STATUS_PRODUTO, ' + 'c.DS_CATEGORIA_PRODUTO ' +
      'FROM produto p ' +
      'JOIN categoria_produto c ON p.CATEGORIAPRODUTOID = c.CATEGORIAPRODUTOID ' +
      'WHERE p.PRODUTOID = ' + eCodigo.Text;

  end;
  DataModuleF.qryProduto.Open;

end;

procedure TProdutosF.DBGrid1DblClick(Sender: TObject);
begin
  pagecontrol1.TabIndex := 1;
  DataModuleF.qryProduto.Edit;
end;


procedure TProdutosF.SpCategoriaClick(Sender: TObject);
begin

  PesquisaCategoriaf.showmodal;

end;

end.

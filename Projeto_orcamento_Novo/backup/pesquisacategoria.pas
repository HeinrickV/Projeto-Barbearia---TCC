unit PesquisaCategoria;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,ExtCtrls,
  Buttons, DBGrids, DataModule;

type

  { TPesquisaCategoriaF }

  TPesquisaCategoriaF = class(TForm)
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
  private

  public

  end;

var
  PesquisaCategoriaF: TPesquisaCategoriaF;

implementation

{$R *.lfm}

uses
  Produtos;

{ TPesquisaCategoriaF }

procedure TPesquisaCategoriaF.BtnPesquisa1Click(Sender: TObject);
begin
  DataModuleF.qryCategoria.Close;
  if edtPesqCat.Text = '' then
  begin
    DataModuleF.qryCategoria.SQL.Text :=
      'SELECT ' + 'CATEGORIAPRODUTOID, ' + 'DS_CATEGORIA_PRODUTO  ' +
      'FROM CATEGORIA_PRODUTO';
  end
  else
  begin
    DataModuleF.qryCategoria.SQL.Text :=
      'SELECT ' + 'CATEGORIAPRODUTOID, ' + 'DS_CATEGORIA_PRODUTO ' +
      'FROM CATEGORIA_PRODUTO ' + 'WHERE UPPER(DS_CATEGORIA_PRODUTO) LIKE ' +
      QuotedStr('%' + UpperCase(edtPesqCat.Text) + '%');
  end;
  DataModuleF.qryCategoria.Open;
end;

procedure TPesquisaCategoriaF.DBGrid1DblClick(Sender: TObject);
begin
     DataModuleF.qryProdutocategoriaprodutoid.AsInteger :=
     DataModuleF.qryCategoriacategoriaprodutoid.AsInteger;
     ProdutosF.dbeDescrCat.Caption := DataModuleF.qryCategoriads_categoria_produto.AsString;
    // ProdutosF.Caption := DataModuleF.qryCategoriads_categoria_produto.AsString;
     Close;
end;


procedure TPesquisaCategoriaF.BtnCancelar1Click(Sender: TObject);
begin
  Close;
end;


end.

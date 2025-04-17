unit Categoria;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  Buttons, modelo, DB, DataModule;

type

  { TCategoriaF }

  TCategoriaF = class(TModeloF)
    dbEditDesc: TDBEdit;
    dbEditId: TDBEdit;
    DsCategoria: TDataSource;
    LabelCodigo: TLabel;
    LabelDesc: TLabel;

    procedure BtnCancelar1Click(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnExcluir1Click(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnPesquisa1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);



  private


  public

  end;

var
  CategoriaF: TCategoriaF;

implementation

{$R *.lfm}

{ TCategoriaF }



procedure TCategoriaF.BtnCancelarClick(Sender: TObject);
begin
  Close;

end;

procedure TCategoriaF.BtnCancelar1Click(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  BtnPesquisa1Click(Sender);

end;



procedure TCategoriaF.BtnExcluir1Click(Sender: TObject);
begin
  if MessageDlg('Aviso', 'Você tem certeza que deseja excluir o registro?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
       DataModuleF.qryCategoria.Delete;
    pagecontrol1.TabIndex := 0;

  end;
end;

procedure TCategoriaF.BtnGravarClick(Sender: TObject);

begin
  if DataModuleF.qryCategoria.State in [dsEdit, dsInsert] then
  begin
    DataModuleF.qryCategoria.Post;
    DataModuleF.qryCategoria.ApplyUpdates;
    PageControl1.TabIndex := 0;
    ecodigo.Text := '';
    BtnPesquisa1Click(nil);
  end;
end;


procedure TCategoriaF.BtnNovoClick(Sender: TObject);
begin
  PageControl1.TabIndex := 1;
  DataModuleF.qryCategoria.Insert;
  dbEditDesc.SetFocus;
end;

procedure TCategoriaF.BtnPesquisa1Click(Sender: TObject);
begin
  DataModuleF.qryCategoria.Close;

  if ecodigo.Text = '' then
  begin
    // Caso eu não preencha nada no ecodigo, todos os produtos serão retornados
    DataModuleF.qryCategoria.SQL.Text :=
      'SELECT ' + 'CATEGORIAPRODUTOID, ' + 'DS_CATEGORIA_PRODUTO  ' +
      'FROM CATEGORIA_PRODUTO';
  end
  else
  begin
    DataModuleF.qryCategoria.SQL.Text :=
      'SELECT ' + 'CATEGORIAPRODUTOID, ' + 'DS_CATEGORIA_PRODUTO ' +
      'FROM CATEGORIA_PRODUTO ' + 'WHERE UPPER(DS_CATEGORIA_PRODUTO) LIKE ' +
      QuotedStr('%' + UpperCase(ecodigo.Text) + '%');
  end;
  DataModuleF.qryCategoria.Open;
end;



procedure TCategoriaF.DBGrid1DblClick(Sender: TObject);
begin
  pagecontrol1.TabIndex := 1;

end;




end.

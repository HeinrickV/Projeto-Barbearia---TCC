unit DataModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset, ZSqlUpdate, Dialogs;

type
  { TDataModuleF }
  TDataModuleF = class(TDataModule)
    ZConnection1: TZConnection;
    qryCategoria: TZQuery;
    qryCliente: TZQuery;
    qryOrcamento: TZQuery;
    qryGenerica: TZQuery;
    qryOrcamentoItem: TZQuery;
    qryProduto: TZQuery;
    qryUsuarios: TZQuery;

    // Campos qryCategoria
    qryCategoriacategoriaprodutoid: TLongintField;
    qryCategoriads_categoria_produto: TStringField;

    // Campos qryCliente
    qryClienteclienteid: TLongintField;
    qryClientecpf_cnpj_cliente: TStringField;
    qryClientenome_cliente: TStringField;
    qryClientetipo_cliente: TStringField;

    // Campos qryOrcamento
    qryOrcamentogravado: TStringField;
    qryOrcamentoclienteid: TLongintField;
    qryOrcamentodt_orcamento: TDateTimeField;
    qryOrcamentodt_validade_orcamento: TDateTimeField;
    qryOrcamentonome_cliente: TStringField;
    qryOrcamentoorcamentoid: TLongintField;
    qryOrcamentovl_total_orcamento: TFloatField;

    // Campos qryOrcamentoItem
    qryOrcamentoItemorcamentoid: TLongintField;
    qryOrcamentoItemorcamentoitemid: TLongintField;
    qryOrcamentoItemprodutodesc: TStringField;
    qryOrcamentoItemprodutoid: TLongintField;
    qryOrcamentoItemqt_produto: TFloatField;
    qryOrcamentoItemvl_total: TFloatField;
    qryOrcamentoItemvl_unitario: TFloatField;

    // Campos qryProduto
    qryProdutocategoriaprodutoid: TLongintField;
    qryProdutods_categoria_produto: TStringField;
    qryProdutods_produto: TStringField;
    qryProdutodt_cadastro_produto: TDateTimeField;
    qryProdutoobs_produto: TStringField;
    qryProdutoprodutoid: TLongintField;
    qryProdutostatus_produto: TStringField;
    qryProdutovl_venda_produto: TFloatField;

    // Campos qryUsuarios
    qryUsuariosid: TLongintField;
    qryUsuariosnome_completo: TStringField;
    qryUsuariossenha: TStringField;
    qryUsuariosusuario: TStringField;

    // UpdateSQL
    updtCategoria: TZUpdateSQL;
    updtCliente: TZUpdateSQL;
    updtOrcamento: TZUpdateSQL;
    updtOrcamentoItem: TZUpdateSQL;
    updtProduto: TZUpdateSQL;
    zupdUsuarios: TZUpdateSQL;

    // Eventos
    procedure DataModuleCreate(Sender: TObject);
    procedure qryCategoriaNewRecord(DataSet: TDataSet);
    procedure qryClienteNewRecord(DataSet: TDataSet);
    procedure qryOrcamentoAfterInsert(DataSet: TDataSet);
    procedure qryOrcamentoAfterOpen(DataSet: TDataSet);
    procedure qryOrcamentoAfterPost(DataSet: TDataSet);
    procedure qryOrcamentoItemNewRecord(DataSet: TDataSet);
    procedure qryOrcamentoItemqt_produtoChange(Sender: TField);
    procedure qryProdutoAfterInsert(DataSet: TDataSet);
    procedure qryProdutoNewRecord(DataSet: TDataSet);

  private
    procedure ConfigurarConexao;
    procedure AbrirQueriesPrincipais;

  public
    procedure SomaItens;
    function getSequence(const pNomeSequence: string): string;
    procedure VerificaDatasetAtivo(Dataset: TZQuery);
    procedure VerificarConexaoAtiva;
  end;

var
  DataModuleF: TDataModuleF;

implementation

{$R *.lfm}

{ TDataModuleF }

procedure TDataModuleF.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexao;
  AbrirQueriesPrincipais;
end;

procedure TDataModuleF.ConfigurarConexao;
begin
  try
    ZConnection1.HostName := 'localhost';
    ZConnection1.Database := 'postgres';
    ZConnection1.User := 'postgres';
    ZConnection1.Password := '1234';
    ZConnection1.Port := 5432;
    ZConnection1.Protocol := 'postgresql';
    ZConnection1.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco: ' + E.Message);
  end;
end;

procedure TDataModuleF.AbrirQueriesPrincipais;
begin
  try
    qryOrcamento.Active := True;
    qryCliente.Active := True;
    qryProduto.Active := True;
    qryCategoria.Active := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao abrir queries: ' + E.Message);
  end;
end;

procedure TDataModuleF.VerificarConexaoAtiva;
begin
  if not ZConnection1.Connected then
  begin
    try
      ZConnection1.Connect;
      if not ZConnection1.Connected then
        raise Exception.Create('Não foi possível conectar ao banco de dados');
    except
      on E: Exception do
        raise Exception.Create('Erro na conexão: ' + E.Message);
    end;
  end;
end;

function TDataModuleF.getSequence(const pNomeSequence: string): string;
begin
  Result := '';
  try
    qryGenerica.Close;
    qryGenerica.SQL.Clear;
    qryGenerica.SQL.Add('SELECT NEXTVAL(' + QuotedStr(pNomeSequence) + ') AS CODIGO');
    qryGenerica.Open;
    Result := qryGenerica.FieldByName('CODIGO').AsString;
  finally
    qryGenerica.Close;
  end;
end;

procedure TDataModuleF.VerificaDatasetAtivo(Dataset: TZQuery);
begin
  if not Dataset.Active then
  begin
    try
      Dataset.Open;
    except
      on E: Exception do
        raise Exception.Create('Erro ao abrir dataset: ' + E.Message);
    end;
  end;
end;

procedure TDataModuleF.SomaItens;
var
  vlTotal: Double;
begin
  if not (qryOrcamento.Active and qryOrcamentoItem.Active) then
    Exit;

  try
    qryOrcamentoItem.DisableControls;
    vlTotal := 0;
    qryOrcamentoItem.First;

    while not qryOrcamentoItem.Eof do
    begin
      vlTotal := vlTotal + qryOrcamentoItemvl_total.AsFloat;
      qryOrcamentoItem.Next;
    end;

    if not (qryOrcamento.State in [dsEdit, dsInsert]) then
      qryOrcamento.Edit;

    qryOrcamentovl_total_orcamento.AsFloat := vlTotal;
  finally
    qryOrcamentoItem.EnableControls;
  end;
end;

procedure TDataModuleF.qryCategoriaNewRecord(DataSet: TDataSet);
begin
  qryCategoriacategoriaprodutoid.AsString := getSequence('categoria_produto_categoriaprodutoid_seq');
end;

procedure TDataModuleF.qryClienteNewRecord(DataSet: TDataSet);
begin
  qryClienteclienteid.AsString := getSequence('cliente_clienteid_seq');
end;

procedure TDataModuleF.qryOrcamentoAfterInsert(DataSet: TDataSet);
begin
  qryOrcamentoorcamentoid.AsInteger := StrToInt(getSequence('orcamento_orcamentoid_seq'));
  qryOrcamentodt_orcamento.AsDateTime := Now;
  qryOrcamentodt_validade_orcamento.AsDateTime := Now + 30;
  qryOrcamentogravado.AsString := 'NAO';
end;

procedure TDataModuleF.qryOrcamentoAfterOpen(DataSet: TDataSet);
begin
  if not qryOrcamentoorcamentoid.IsNull then
  begin
    qryOrcamentoItem.Close;
    qryOrcamentoItem.ParamByName('orcamentoid').AsInteger := qryOrcamentoorcamentoid.AsInteger;
    qryOrcamentoItem.Open;
  end;
end;

procedure TDataModuleF.qryOrcamentoAfterPost(DataSet: TDataSet);
begin
  if qryOrcamento.ChangeCount > 0 then
    qryOrcamento.Refresh;
end;

procedure TDataModuleF.qryOrcamentoItemNewRecord(DataSet: TDataSet);
var
  novoID: Integer;
begin
  qryGenerica.Close;
  qryGenerica.SQL.Text := 'SELECT COALESCE(MAX(orcamentoitemid), 0) + 1 AS novoID FROM orcamento_item WHERE orcamentoid = :id';
  qryGenerica.ParamByName('id').AsInteger := qryOrcamentoorcamentoid.AsInteger;
  qryGenerica.Open;

  novoID := qryGenerica.FieldByName('novoID').AsInteger;
  qryOrcamentoItemorcamentoitemid.AsInteger := novoID;
  qryOrcamentoItemorcamentoid.AsInteger := qryOrcamentoorcamentoid.AsInteger;
end;

procedure TDataModuleF.qryOrcamentoItemqt_produtoChange(Sender: TField);
var
  xQtde, xVlrUnit: Double;
begin
  xQtde := qryOrcamentoItemqt_produto.AsFloat;
  xVlrUnit := qryOrcamentoItemvl_unitario.AsFloat;

  if xQtde > 0 then
    qryOrcamentoItemvl_total.AsFloat := xQtde * xVlrUnit;
end;

procedure TDataModuleF.qryProdutoAfterInsert(DataSet: TDataSet);
begin
  qryProdutoprodutoid.AsInteger := StrToInt(getSequence('produto_produtoid'));
  qryProdutodt_cadastro_produto.AsDateTime := Now;
  qryProdutostatus_produto.AsString := 'ATIVO';
end;

procedure TDataModuleF.qryProdutoNewRecord(DataSet: TDataSet);
begin
  qryProdutoprodutoid.AsString := getSequence('produto_produtoid');
  qryProdutodt_cadastro_produto.AsDateTime := Now;
  qryProdutostatus_produto.AsString := 'ATIVO';
end;

end.


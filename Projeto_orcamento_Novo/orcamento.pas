unit Orcamento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGrids, ComCtrls, DBCtrls, DBExtCtrls, LR_Class, LR_DBSet,
  DataModule, PesquisaCliente, caditemOrc, ZDataset;

type
  { TOrcamentoF }

  TOrcamentoF = class(TForm)
    Btnadd: TBitBtn;
    BtnCancelar: TBitBtn;
    BtnCancelar1: TBitBtn;
    BtnExcluir1: TBitBtn;
    BtnExcluirItem: TBitBtn;
    BtnGravar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnNovo: TBitBtn;
    BtnPesquisa: TBitBtn;
    Cadastro: TTabSheet;
    Consulta: TTabSheet;
    dbEditTotalOrc1: TDBEdit;
    DsOrcamentoItem: TDataSource;
    DbDataCadastro: TDBDateEdit;
    DbDataValidade: TDBDateEdit;
    dbeDescrCat: TDBEdit;
    dbEditTotalOrc: TDBEdit;
    dbEditId: TDBEdit;
    dbEditId1: TDBEdit;
    DBGrid2: TDBGrid;
    dsOrcamento: TDataSource;
    DBGrid1: TDBGrid;
    eCodigo: TEdit;
    frdbOrcItens: TfrDBDataSet;
    frReportOrcamento: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    LabelCodigo: TLabel;
    LabelDataCadastro: TLabel;
    LabelDataValidade: TLabel;
    LabelDataValidade1: TLabel;
    LabelDataValidade2: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    PanelPadrao: TPanel;
    SpCliente: TSpeedButton;
    procedure BtnaddClick(Sender: TObject);
    procedure BtnCancelar1Click(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnExcluir1Click(Sender: TObject);
    procedure BtnExcluirItemClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnPesquisaClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SpClienteClick(Sender: TObject);
    procedure AbreOrcItens(orcamentoid: integer);
  public
  end;

var
  OrcamentoF: TOrcamentoF;

implementation

{$R *.lfm}

{ TOrcamentoF }

procedure TOrcamentoF.BtnNovoClick(Sender: TObject);
begin
  PageControl1.TabIndex := 1;

  // Garante que qualquer edição anterior foi finalizada
  if DataModuleF.qryOrcamento.State in [dsInsert, dsEdit] then
  begin
    DataModuleF.qryOrcamento.Post;
    DataModuleF.qryOrcamento.ApplyUpdates;
  end;

  // Inicia novo orçamento
  DataModuleF.qryOrcamento.Insert;
  DataModuleF.qryOrcamento.FieldByName('GRAVADO').AsString := 'NAO';
  DataModuleF.qryOrcamento.FieldByName('DT_ORCAMENTO').AsDateTime := Now;
  DataModuleF.qryOrcamento.FieldByName('DT_VALIDADE_ORCAMENTO').AsDateTime := Now + 30;

  // Abre itens com orcamentoid temporário
  AbreOrcItens(-1);

end;

procedure TOrcamentoF.BtnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TOrcamentoF.BtnExcluir1Click(Sender: TObject);
var
  qryAux: TZQuery;
begin
  if MessageDlg('Aviso', 'Você tem certeza que deseja excluir o registro?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    qryAux := TZQuery.Create(nil);
    try
      qryAux.Connection := DataModuleF.ZConnection1;

      // Exclui itens primeiro
      qryAux.SQL.Text := 'DELETE FROM ORCAMENTO_ITEM WHERE ORCAMENTOID = ' +
        DataModuleF.qryOrcamento.FieldByName('ORCAMENTOID').AsString;
      qryAux.ExecSQL;

      // Exclui orçamento
      DataModuleF.qryOrcamento.Delete;
      PageControl1.TabIndex := 0;
    finally
      qryAux.Free;
    end;
  end;
end;

procedure TOrcamentoF.BtnExcluirItemClick(Sender: TObject);
begin
  if not (dsOrcamentoItem.DataSet.State in [dsInsert, dsEdit]) then
    dsOrcamentoItem.DataSet.Edit;

  if MessageDlg('Aviso', 'Deseja realmente excluir este item?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    dsOrcamentoItem.DataSet.Delete;
    DataModuleF.SomaItens;
  end;
end;
procedure TOrcamentoF.BtnGravarClick(Sender: TObject);
begin
  // Desabilita controles para evitar interação durante o processamento
  Screen.Cursor := crHourGlass;
  try
    try
      // Validação básica
      if not DataModuleF.qryOrcamento.Active then
      begin
        ShowMessage('Dataset não está ativo');
        Exit;
      end;

      // Força a saída dos campos de data
      if DbDataCadastro.Focused then
        DbDataCadastro.EditingDone;
      if DbDataValidade.Focused then
        DbDataValidade.EditingDone;

      // Validação de cliente
      if DataModuleF.qryOrcamento.FieldByName('CLIENTEID').IsNull then
      begin
        ShowMessage('Selecione um cliente antes de gravar!');
        Exit;
      end;

      // Garante modo de edição
      if not (DataModuleF.qryOrcamento.State in [dsEdit, dsInsert]) then
        DataModuleF.qryOrcamento.Edit;

      // Atualiza totais
      DataModuleF.SomaItens;

      // Marca como gravado e aplica
      DataModuleF.qryOrcamento.FieldByName('GRAVADO').AsString := 'SIM';

      // Processo de gravação seguro
      DataModuleF.ZConnection1.StartTransaction;
      try
        DataModuleF.qryOrcamento.Post;
        DataModuleF.qryOrcamento.ApplyUpdates;
        DataModuleF.ZConnection1.Commit;

        ShowMessage('Orçamento gravado com sucesso!');
        PageControl1.TabIndex := 0;
      except
        on E: Exception do
        begin
          DataModuleF.ZConnection1.Rollback;
          DataModuleF.qryOrcamento.Cancel;
          raise Exception.Create('Erro ao gravar: ' + E.Message);
        end;
      end;
    except
      on E: Exception do
        ShowMessage('Erro: ' + E.Message);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TOrcamentoF.BtnImprimirClick(Sender: TObject);
begin
  if DataModuleF.qryOrcamento.IsEmpty then
  begin
    ShowMessage('Nenhum orçamento selecionado para impressão!');
    Exit;
  end;

  frReportOrcamento.LoadFromFile('RelImpressaoOrcamento.lrf');
  frReportOrcamento.PrepareReport;
  frReportOrcamento.ShowReport;
end;

procedure TOrcamentoF.BtnCancelar1Click(Sender: TObject);
begin
  if DataModuleF.qryOrcamento.State in [dsEdit, dsInsert] then
    DataModuleF.qryOrcamento.Cancel;

  PageControl1.TabIndex := 0;
end;
  procedure TOrcamentoF.BtnaddClick(Sender: TObject);
var
  FormItem: TcadItemOrcF;
begin
  // Verifica se pode adicionar itens
  if DataModuleF.qryOrcamento.State = dsInsert then
  begin
    ShowMessage('Grave o orçamento antes de adicionar itens!');
    Exit;
  end;

  if DataModuleF.qryOrcamento.IsEmpty then
  begin
    ShowMessage('Nenhum orçamento selecionado!');
    Exit;
  end;

  // Garante que o dataset de itens está ativo
  if not DataModuleF.qryOrcamentoItem.Active then
    DataModuleF.qryOrcamentoItem.Open;

  // Abre formulário de itens
  FormItem := TcadItemOrcF.Create(Self);
  try
    FormItem.ShowModal;
    DataModuleF.SomaItens;
  finally
    FormItem.Free;
  end;
end;

procedure TOrcamentoF.BtnPesquisaClick(Sender: TObject);
begin
  DataModuleF.qryOrcamento.Close;

  if eCodigo.Text = '' then
    DataModuleF.qryOrcamento.SQL.Text :=
      'SELECT o.ORCAMENTOID, o.CLIENTEID, o.DT_ORCAMENTO, o.DT_VALIDADE_ORCAMENTO, ' +
      'o.VL_TOTAL_ORCAMENTO, c.NOME_CLIENTE, o.GRAVADO ' +
      'FROM ORCAMENTO o JOIN CLIENTE c ON o.CLIENTEID = c.CLIENTEID ' +
      'ORDER BY o.DT_ORCAMENTO DESC'
  else
    DataModuleF.qryOrcamento.SQL.Text :=
      'SELECT o.ORCAMENTOID, o.CLIENTEID, o.DT_ORCAMENTO, o.DT_VALIDADE_ORCAMENTO, ' +
      'o.VL_TOTAL_ORCAMENTO, c.NOME_CLIENTE, o.GRAVADO ' +
      'FROM ORCAMENTO o JOIN CLIENTE c ON o.CLIENTEID = c.CLIENTEID ' +
      'WHERE o.ORCAMENTOID = ' + eCodigo.Text;

  DataModuleF.qryOrcamento.Open;
end;

procedure TOrcamentoF.DBGrid1DblClick(Sender: TObject);
begin
  if not DataModuleF.qryOrcamento.IsEmpty then
  begin
    AbreOrcItens(DataModuleF.qryOrcamento.FieldByName('ORCAMENTOID').AsInteger);
    PageControl1.TabIndex := 1;

    // Garante modo de edição
    if not (DataModuleF.qryOrcamento.State in [dsEdit]) then
      DataModuleF.qryOrcamento.Edit;
  end;
end;

procedure TOrcamentoF.FormShow(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  BtnPesquisa.Click;
end;

procedure TOrcamentoF.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = Consulta then
  begin
    if DataModuleF.qryOrcamento.State in [dsInsert, dsEdit] then
      DataModuleF.qryOrcamento.Cancel;

    BtnPesquisa.Click;
  end;
end;

procedure TOrcamentoF.SpClienteClick(Sender: TObject);
begin
  PesquisaClienteF.ShowModal;

  if not DataModuleF.qryOrcamento.IsEmpty and
     (DataModuleF.qryOrcamento.State in [dsInsert, dsEdit]) then
  begin
    DataModuleF.qryOrcamento.FieldByName('CLIENTEID').AsInteger :=
      DataModuleF.qryCliente.FieldByName('CLIENTEID').AsInteger;
    dbeDescrCat.Text := DataModuleF.qryCliente.FieldByName('NOME_CLIENTE').AsString;

    if dbeDescrCat.CanFocus then
      dbeDescrCat.SetFocus;
  end;
end;
procedure TOrcamentoF.AbreOrcItens(orcamentoid: integer);
begin
  try
    DataModuleF.qryOrcamentoItem.Close;
    if orcamentoid > 0 then
    begin
      DataModuleF.qryOrcamentoItem.SQL.Text :=
        'SELECT ORCAMENTOITEMID, ORCAMENTOID, PRODUTOID, PRODUTODESC, '+
        'QT_PRODUTO, VL_UNITARIO, VL_TOTAL '+
        'FROM ORCAMENTO_ITEM '+
        'WHERE ORCAMENTOID = :ORCAMENTOID '+
        'ORDER BY ORCAMENTOITEMID';
      DataModuleF.qryOrcamentoItem.ParamByName('ORCAMENTOID').AsInteger := orcamentoid;
    end
    else
    begin
      DataModuleF.qryOrcamentoItem.SQL.Text := 'SELECT * FROM ORCAMENTO_ITEM WHERE 1=0';
    end;
    DataModuleF.qryOrcamentoItem.Open;
  except
    on E: Exception do
      ShowMessage('Erro ao abrir itens: ' + E.Message);
  end;
end;

end.

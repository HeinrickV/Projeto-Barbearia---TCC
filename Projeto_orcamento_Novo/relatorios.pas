unit Relatorios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DB,
  ExtCtrls, Buttons, StdCtrls, LR_Class, LR_DBSet, ZConnection, ZDataset;

type
  { TRelatoriosF }
  TRelatoriosF = class(TForm)
    BtnImprimir1: TBitBtn;
    BtnImprimir2: TBitBtn;
    BtnImprimir3: TBitBtn;
    BtnImprimir4: TBitBtn;
    dsOrcamento: TDataSource;
    DsOrcamentoItem: TDataSource;
    frdbOrcamentos: TfrDBDataSet;
    frdbOrcItens: TfrDBDataSet;
    frdbOrcItens1: TfrDBDataSet;
    frdbOrcItens2: TfrDBDataSet;
    frReportOrcamento: TfrReport;
    frReportOrcamento1: TfrReport;
    frReportOrcamento2: TfrReport;
    LabelDataValidade1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryOrcamentos: TZQuery;
    qryOrcItens: TZQuery;
    dsOrcamentos: TDataSource;
    dsOrcItens: TDataSource;
    procedure BtnImprimir4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ConfigurarRelatorioPrincipal;
    procedure ConfigurarRelatorioItens;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  RelatoriosF: TRelatoriosF;

implementation

{$R *.lfm}

{ TRelatoriosF }

procedure TRelatoriosF.FormCreate(Sender: TObject);
begin

  qryOrcamentos.Connection := ZConnection1;
  qryOrcItens.Connection := ZConnection1;

  // Configura SQL para buscar orçamentos
  qryOrcamentos.SQL.Text :=
    'SELECT orcamento_id, cliente_id, data_emissao, valor_total '+
    'FROM orcamentos '+
    'ORDER BY data_emissao DESC';

  // Configura SQL para buscar itens dos orçamentos
  qryOrcItens.SQL.Text :=
    'SELECT oi.item_id, oi.orcamento_id, oi.produto_id, '+
    'p.descricao as produto_desc, oi.quantidade, oi.valor_unitario, '+
    'oi.valor_total '+
    'FROM orcamento_itens oi '+
    'JOIN produtos p ON p.produto_id = oi.produto_id '+
    'WHERE oi.orcamento_id = :orcamento_id';

  qryOrcamentos.Open;
end;

procedure TRelatoriosF.ConfigurarRelatorioPrincipal;
begin
  // Configura o relatório principal de orçamentos
  frdbOrcamentos.DataSet := qryOrcamentos;

  // Carrega o arquivo .lrf do relatório (crie no FastReport Designer)
  frReportOrcamento.LoadFromFile('rel_orcamentos.lrf');

  // Configura parâmetros se necessário
  frReportOrcamento.ShowReport;
end;

procedure TRelatoriosF.ConfigurarRelatorioItens;
begin
  // Configura o relatório detalhado com itens
  frdbOrcItens.DataSet := qryOrcItens;

  // Configura relação mestre-detalhe
  qryOrcItens.MasterSource := dsOrcamentos;
  qryOrcItens.MasterFields := 'orcamento_id';
  qryOrcItens.LinkedFields := 'orcamento_id';
  qryOrcItens.Open;

  // Carrega o arquivo .lrf do relatório de itens
  frReportOrcamento.LoadFromFile('rel_orcamentos_itens.lrf');

  frReportOrcamento.ShowReport;
end;

procedure TRelatoriosF.BtnImprimir4Click(Sender: TObject);
begin
  // Gera relatório completo com orçamentos e itens
  try
    ConfigurarRelatorioPrincipal;
    ConfigurarRelatorioItens;object dsOrcamento: TDataSource
  DataSet = DataModuleF.qryOrcamento
  Left = 780
  Top = 391
end

    // Prepara o relatório principal
    frReportOrcamento.PrepareReport;

    // Mostra o relatório
    frReportOrcamento.ShowReport;
  except
    on E: Exception do
      ShowMessage('Erro ao gerar relatório: ' + E.Message);
  end;
end;

end.

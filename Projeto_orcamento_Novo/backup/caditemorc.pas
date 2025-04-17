unit CadItemOrc;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, DBCtrls, ExtCtrls, DataModule, PesqProd, DB;

type

  { TCadItemOrcF }

  TCadItemOrcF = class(TForm)
    BtnInserir: TBitBtn;
    BtnCancelar1: TBitBtn;
    DbEProd: TDBEdit;
    DbEditDesc: TDBEdit;
    DbEditQtde: TDBEdit;
    DbEditVlrUnit: TDBEdit;
    DbEditVlrTotal: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    SpCliente: TSpeedButton;
    procedure BtnCancelar1Click(Sender: TObject);
    procedure BtnInserirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpClienteClick(Sender: TObject);
    procedure DbEditQtdeChange(Sender: TObject);
    procedure DbEditVlrUnitChange(Sender: TObject);
  private
    FProdutoID: Integer;
    FProdutoDesc: String;
    FVlrUnit: Double;
    procedure CalcularTotal;
    procedure AtualizarCampos;
    procedure ValidarCampos;
  public
  end;

var
  CadItemOrcF: TCadItemOrcF;

implementation

{$R *.lfm}

{ TCadItemOrcF }

procedure TCadItemOrcF.BtnInserirClick(Sender: TObject);
begin
  // Validação dos campos
  if FProdutoID = 0 then
  begin
    ShowMessage('Selecione o produto.');
    Exit;
  end;

  try
    // Verifica se os datasets estão ativos
    DataModuleF.VerificaDatasetAtivo(DataModuleF.qryOrcamentoItem);

    // Inserção do item
    with DataModuleF.qryOrcamentoItem do
    begin
      if not (State in [dsInsert, dsEdit]) then
        Insert;

      try
        FieldByName('orcamentoid').AsInteger := DataModuleF.qryOrcamento.FieldByName('orcamentoid').AsInteger;
        FieldByName('produtoid').AsInteger := FProdutoID;
        FieldByName('produtodesc').AsString := FProdutoDesc;
        FieldByName('qt_produto').AsFloat := StrToFloat(DbEditQtde.Text);
        FieldByName('vl_unitario').AsFloat := FVlrUnit;
        FieldByName('vl_total').AsFloat := StrToFloat(DbEditVlrTotal.Text);

        Post;
        ApplyUpdates;
        ModalResult := mrOk;
      except
        on E: Exception do
        begin
          Cancel;
          ShowMessage('Erro ao inserir item: ' + E.Message);
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

procedure TCadItemOrcF.BtnCancelar1Click(Sender: TObject);
begin
  if DataModuleF.qryOrcamentoItem.State in [dsInsert, dsEdit] then
    DataModuleF.qryOrcamentoItem.Cancel;
  Close;
end;

procedure TCadItemOrcF.SpClienteClick(Sender: TObject);
begin
  PesqProdF := TPesqProdF.Create(Self);
  try
    if PesqProdF.ShowModal = mrOk then
    begin
      FProdutoID := PesqProdF.SelectedProdutoID;
      FProdutoDesc := PesqProdF.SelectedProdutoDesc;
      FVlrUnit := PesqProdF.SelectedVlrUnit;
      AtualizarCampos;
    end;
  finally
    PesqProdF.Free;
  end;
end;

procedure TCadItemOrcF.AtualizarCampos;
begin
  DbEProd.Text := IntToStr(FProdutoID);
  DbEditDesc.Text := FProdutoDesc;
  DbEditVlrUnit.Text := FormatFloat('0.00', FVlrUnit);
  CalcularTotal;
end;

procedure TCadItemOrcF.FormShow(Sender: TObject);
begin
  try
    // Verifica se os datasets estão ativos
    DataModuleF.VerificaDatasetAtivo(DataModuleF.qryOrcamentoItem);

    FProdutoID := 0;
    FProdutoDesc := '';
    FVlrUnit := 0;

    // Limpa os campos
    DbEditQtde.Text := '';
    DbEditVlrTotal.Text := '0.00';
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao abrir formulário: ' + E.Message);
      Close;
    end;
  end;
end;

procedure TCadItemOrcF.DbEditQtdeChange(Sender: TObject);
begin
  CalcularTotal;
end;

procedure TCadItemOrcF.DbEditVlrUnitChange(Sender: TObject);
begin
  CalcularTotal;
end;

procedure TCadItemOrcF.CalcularTotal;
var
  Qtde: Double;
begin
  try
    if Trim(DbEditQtde.Text) <> '' then
    begin
      Qtde := StrToFloatDef(DbEditQtde.Text, 0);
      DbEditVlrTotal.Text := FormatFloat('0.00', Qtde * FVlrUnit);
    end;
  except
    on E: EConvertError do
      DbEditVlrTotal.Text := '0.00';
  end;
end;

procedure TCadItemOrcF.ValidarCampos;
begin
  if Trim(DbEditQtde.Text) = '' then
    raise Exception.Create('Informe a quantidade');

  if StrToFloatDef(DbEditQtde.Text, 0) <= 0 then
    raise Exception.Create('Quantidade deve ser maior que zero');
end;

end.

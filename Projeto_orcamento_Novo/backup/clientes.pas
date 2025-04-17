unit Clientes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBCtrls, DBExtCtrls, Buttons, modelo, DB, DataModule, MaskUtils;

type

  { TClienteF }

  TClienteF = class(TModeloF)
    dbEditCPFCNPJ: TDBEdit;
    dbEditTipo: TDBEdit;
    dbEditId: TDBEdit;
    dbEditNome: TDBEdit;
    dsCliente: TDataSource;
    LabelTipo: TLabel;
    LabelId: TLabel;
    LabelNomeFantasia: TLabel;
    LabelCPFCNPJ: TLabel;
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
  ClienteF: TClienteF;
  CPFMask: string = '999\.999\.999\-99;0;_';
  CNPJMask: string = '99\.999\.999\/9999\-99;0;_';

implementation

{$R *.lfm}

{ TClienteF }

procedure TClienteF.BtnNovoClick(Sender: TObject);
begin
  PageControl1.TabIndex := 1;
  DataModuleF.qryCliente.Insert;
  dbEditTipo.SetFocus;
end;

procedure TClienteF.BtnPesquisa1Click(Sender: TObject);
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






procedure TClienteF.DBGrid1DblClick(Sender: TObject);
begin
  pagecontrol1.TabIndex := 1;
  DataModuleF.qryCliente.Edit;
end;

procedure TClienteF.BtnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TClienteF.BtnExcluir1Click(Sender: TObject);
begin
  if MessageDlg('Aviso', 'Você tem certeza que deseja excluir o registro?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DataModuleF.qryCliente.Delete;
    pagecontrol1.TabIndex := 0;
  end;
end;

procedure TClienteF.BtnGravarClick(Sender: TObject);
begin
  if DataModuleF.qryCliente.State in [dsEdit, dsInsert] then
  begin
    DataModuleF.qryCliente.Post;
    DataModuleF.qryCliente.ApplyUpdates;
    PageControl1.TabIndex := 0;
    ecodigo.Text := '';
    BtnPesquisa1Click(nil);
  end;
end;

procedure TClienteF.BtnCancelar1Click(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  BtnPesquisa1Click(Sender);
end;

end.

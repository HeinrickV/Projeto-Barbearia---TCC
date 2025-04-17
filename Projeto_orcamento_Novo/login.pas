unit Login;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, menu, datamodule;

type

  { TLoginF }

  TLoginF = class(TForm)
    btnCancelar: TBitBtn;
    btnEntrar: TBitBtn;
    eSenha: TEdit;
    eUsuario: TEdit;
    Image1: TImage;
    lSenha: TLabel;
    LTitulo: TLabel;
    lUsaurio: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);

    procedure eSenhaKeyPress(Sender: TObject; var Key: char);
    function ValidaUsuario(pUsusario: string; pSenha: string): boolean;

  private

  public

  end;

var
  LoginF: TLoginF;

implementation

{$R *.lfm}

{ TLoginF }

function TloginF.ValidaUsuario(pUsusario: string; pSenha: string): boolean;
begin

  DataModulef.qryGenerica.Close;
  DataModulef.qryGenerica.SQL.Clear;
  DataModulef.qryGenerica.SQL.Add('SELECT COUNT(*) AS NUMBER ' +
    'FROM USUARIOS ' + 'WHERE USUARIO = ' + QuotedStr(pUsusario) +
    ' ' + 'AND SENHA = ' + QuotedStr(pSenha));
  DataModulef.qryGenerica.Open;

  if DataModulef.qryGenerica.FieldByName('NUMBER').AsInteger = 0 then
  begin

    MessageDlg('Aviso', 'Digite um nome de Usuario/Senha válido.',
      mtConfirmation, [mbOK], 0);
    eUsuario.SetFocus;
    Result := False;
  end
  else
    Result := True;

end;

procedure TLoginF.btnCancelarClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TLoginF.btnEntrarClick(Sender: TObject);
begin
  if ValidaUsuario(eUsuario.Text, eSenha.Text) = True then
  begin

    MenuF.ShowModal;
    LoginF.Free;
    Application.Terminate;

  end;
end;



procedure TLoginF.eSenhaKeyPress(Sender: TObject; var Key: char);
begin

  if key = #13 then
    BtnEntrar.Click;
end;




end.

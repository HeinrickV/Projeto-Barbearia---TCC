unit menu;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus,
  sobre, categoria, Produtos, Clientes, orcamento;

type

  { TMenuF }

  TMenuF = class(TForm)
    MenuCadastros: TMenuItem;
    Separator1: TMenuItem;
    Usuario: TMenuItem;
    MenuManutencao: TMenuItem;
    MenuPrincipal: TMainMenu;
    MenuRelatorios: TMenuItem;
    MenuSair: TMenuItem;
    MenuSobre: TMenuItem;
    SubMenuCliente: TMenuItem;
    SubMenuOrcamento: TMenuItem;
    SubMenuProdutos: TMenuItem;
    SubMenusCategoria: TMenuItem;


    procedure MenuRelatoriosClick(Sender: TObject);
    procedure MenuSairClick(Sender: TObject);
    procedure MenuSobreClick(Sender: TObject);
    procedure SubMenuClienteClick(Sender: TObject);
    procedure SubMenuOrcamentoClick(Sender: TObject);
    procedure SubMenuProdutosClick(Sender: TObject);
    procedure SubMenusCategoriaClick(Sender: TObject);
  private

  public

  end;

var
  MenuF: TMenuF;

implementation

{$R *.lfm}

{ TMenuF }

procedure TMenuF.MenuSairClick(Sender: TObject);
begin
  if MessageDlg('Aviso', 'Você quer sair do programa?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    application.terminate;
  end;

end;

procedure TMenuF.MenuRelatoriosClick(Sender: TObject);
begin
RelatoriosF.ShowModal;
end;


procedure TMenuF.MenuSobreClick(Sender: TObject);
begin
  sobref.showmodal;
end;

procedure TMenuF.SubMenuClienteClick(Sender: TObject);
begin
  ClienteF.PageControl1.ActivePageIndex := 0;
  ClienteF.ShowModal;
end;

procedure TMenuF.SubMenuOrcamentoClick(Sender: TObject);
begin
  OrcamentoF.PageControl1.ActivePageIndex := 0;
  OrcamentoF.ShowModal;
end;

procedure TMenuF.SubMenuProdutosClick(Sender: TObject);
begin
  ProdutosF.PageControl1.ActivePageIndex := 0;
  ProdutosF.ShowModal;
end;

procedure TMenuF.SubMenusCategoriaClick(Sender: TObject);

begin
  categoriaf.PageControl1.ActivePageIndex := 0;
  categoriaf.ShowModal;

end;




end.

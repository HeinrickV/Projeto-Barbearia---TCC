unit modelo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DBGrids, ComCtrls, DBCtrls;

type

  { TModeloF }

  TModeloF = class(TForm)
    BtnCancelar: TBitBtn;
    BtnCancelar1: TBitBtn;
    BtnExcluir1: TBitBtn;
    BtnGravar: TBitBtn;
    BtnGravar1: TBitBtn;
    BtnNovo: TBitBtn;
    BtnNovo1: TBitBtn;
    BtnPesquisa1: TBitBtn;
    BtnPesquisa2: TBitBtn;
    Consulta: TTabSheet;
    DBGrid1: TDBGrid;
    eCodigo: TEdit;
    eCodigo1: TEdit;
    LCodigo: TLabel;
    LCodigo1: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PanelPadraoCima: TPanel;
    Panel6: TPanel;
    PanelPadraoLateral: TPanel;
    PanelPadrao1: TPanel;
    Cadastro: TTabSheet;




  private

  public

  end;

var
  ModeloF: TModeloF;

implementation

{$R *.lfm}

{ TModeloF }






end.

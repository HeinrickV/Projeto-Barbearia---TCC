unit Relatorios;

{$mode ObjFPC}{$H+}

interface

uses
                  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
		  ExtCtrls, Buttons, StdCtrls, LR_Class, LR_DBSet;

type

		  { TRelatoriosF }

                  TRelatoriosF = class(TForm)
				    BtnImprimir1: TBitBtn;
				    BtnImprimir2: TBitBtn;
				    BtnImprimir3: TBitBtn;
				    BtnImprimir4: TBitBtn;
				    BtnImprimir5: TBitBtn;
				    BtnImprimir6: TBitBtn;
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



                  private

                  public

                  end;

var
                  RelatoriosF: TRelatoriosF;

implementation

{$R *.lfm}

{ TRelatoriosF }




end.


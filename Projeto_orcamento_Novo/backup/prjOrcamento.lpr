program prjOrcamento;

{$mode objfpc}{$H+}

uses
                  {$IFDEF UNIX}
                  cthreads,
                  {$ENDIF}
                  {$IFDEF HASAMIGA}
                  athreads,
                  {$ENDIF}
                  Interfaces, // this includes the LCL widgetset
                  Forms, datetimectrls, zcomponent, Orcamento, modelo, menu,
		  sobre, Categoria, DataModule, Produtos, PesquisaCategoria, Clientes,
		  PesquisaCliente, CadItemOrc, PesqProd, Login, Relatorios
                  { you can add units after this };

{$R *.res}

begin
                  RequireDerivedFormResource:=True;
		  Application.Scaled:=True;
                  Application.Initialize;
		  Application.CreateForm(TLoginF, LoginF);
		  Application.CreateForm(TMenuF, MenuF);
		  Application.CreateForm(TModeloF, ModeloF);
		  Application.CreateForm(TOrcamentoF, OrcamentoF);
		  Application.CreateForm(TSobreF, SobreF);
		  Application.CreateForm(TCategoriaF, CategoriaF);
		  Application.CreateForm(TDataModuleF, DataModuleF);
		  Application.CreateForm(TProdutosF, ProdutosF);
		  Application.CreateForm(TPesquisaCategoriaF, PesquisaCategoriaF
				    );
		  Application.CreateForm(TClienteF, ClienteF);
		  Application.CreateForm(TPesquisaClienteF, PesquisaClienteF);
		  Application.CreateForm(TCadItemOrcF, CadItemOrcF);
		  Application.CreateForm(TPesqProdF, PesqProdF);
		  Application.CreateForm(TRelatoriosF, RelatoriosF);
                  Application.Run;
end.


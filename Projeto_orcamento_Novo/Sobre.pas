unit sobre;

{$mode ObjFPC}{$H+}

interface

uses
                  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
		  StdCtrls, ExtCtrls;

type

		  { TSobreF }

                  TSobreF = class(TForm)
				    Image1: TImage;
				    LInformacoes: TLabel;
				    LTitulo: TLabel;
				    procedure LTituloClick(Sender: TObject);
                  private

                  public

                  end;

var
                  SobreF: TSobreF;

implementation

{$R *.lfm}

{ TSobreF }

procedure TSobreF.LTituloClick(Sender: TObject);
begin

end;

end.


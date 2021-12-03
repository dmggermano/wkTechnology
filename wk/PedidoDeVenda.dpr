program PedidoDeVenda;

uses
  Vcl.Forms,
  uPedidoDeVendas in 'View\uPedidoDeVendas.pas' {FpedidoDeVendas},
  uModelDados in 'Model\uModelDados.pas' {dmConectaBases: TDataModule},
  uModelMemo in 'Model\uModelMemo.pas' {dmConectaMemo: TDataModule},
  udiversos in 'Controller\udiversos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFpedidoDeVendas, FpedidoDeVendas);
  Application.CreateForm(TdmConectaBases, dmConectaBases);
  Application.CreateForm(TdmConectaBases, dmConectaBases);
  Application.CreateForm(TdmConectaMemo, dmConectaMemo);
  Application.Run;
end.

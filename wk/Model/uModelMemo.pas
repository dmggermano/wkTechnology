unit uModelMemo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmConectaMemo = class(TDataModule)
    fdmItemPedido: TFDMemTable;
    dsItemPedido: TDataSource;
    fdmItemPedidocodItemProduto: TIntegerField;
    fdmItemPedidodescricaoProduto: TStringField;
    fdmItemPedidoqtd: TIntegerField;
    fdmItemPedidovalorUnitario: TFloatField;
    fdmItemPedidovalor: TCurrencyField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConectaMemo: TdmConectaMemo;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

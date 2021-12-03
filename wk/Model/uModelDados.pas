unit uModelDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI;



type
  TdmConectaBases = class(TDataModule)
    fdConectorDB: TFDConnection;
    fdCliente: TFDQuery;
    fdProduto: TFDQuery;
    fdTabelaDiversos: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    { Private declarations }
  public
    { Public declarations }
//    function ConectarBase(): Boolean;
  end;

  tCliente = class
  private
  public
    codigo : integer;
    nome : string;
    cidade : string;
    uf : string;
  end;

  tProduto = class
  private
  public
    codigo : integer;
    descricao : string;
    precoDeVenda : real;
  end;

var
  dmConectaBases: TdmConectaBases;



implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}




{
 ****************************** observação criação db   ( wk_pedido )

CREATE USER 'wk_pedido'@'localhost' IDENTIFIED VIA mysql_native_password USING '***'
;GRANT ALL PRIVILEGES ON *.* TO 'wk_pedido'@'localhost'
REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0
MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;


??  GRANT ALL PRIVILEGES ON `wk_pedido`.* TO 'wk_pedido'@'localhost' WITH GRANT OPTION;

 ********************************* ********************* **************
}
{
CREATE TABLE `wk_pedido`.`lixo` ( `id` INT NOT NULL AUTO_INCREMENT ,
 `descricao` VARCHAR(50) NOT NULL , PRIMARY KEY (`id`(11)), INDEX `nome`
 (`descricao`)) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_unicode_ci COMMENT = 'lixo';


////////////////////////
CREATE TABLE `lixo` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`descricao` VARCHAR(50) NOT NULL DEFAULT '',
	INDEX `descricao` (`descricao`),
	PRIMARY KEY (`id`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;
////////////////////////////

}

end.

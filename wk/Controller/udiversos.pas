unit udiversos;

interface

uses uModelDados, System.SysUtils, Vcl.Dialogs,
    System.Classes;

/// <summary>
///   trata componente/campo string no valor.
/// str=tecla digitada  text=text/conteudo do campo
/// </summary>
//function fStringSoNumerosEVirgua(str,text:string):string;

/// <summary>
///   retorna string com apenas numeros de uma string
/// </summary>
function fSoNumeros(soNumeros:string):string;

/// <summary>
///   cria as tabelas do sistema. tabela = nome da que sera criada
/// </summary>
function sqlCriaTabela(tabela:string):Boolean;


/// <summary>
///   retorna string com apenas numeros e virgulas de uma string
/// </summary>
function fSoNumerosEVirgula(soNumerosEVirgula:string):string;

/// <summary>
///   conecta o sistema ao banco de dados e valida tabelas
/// </summary>
function conectaBaseDeDados():Boolean;

/// <summary>
///   conecta o sistema ao banco de dados
/// </summary>
function ConectarBase():Boolean;

/// <summary>
///   desconecta o sistema ao banco de dados
/// </summary>
function desconectaBaseDeDados():Boolean;

/// <summary>
///   verifica a existencia das tabelas e do banco de dados
///  db = nome do banco de dados
///  tabela = nome da tabela a ser verificada a existencia
/// </summary>
function validarTabelas(db,tabela:string):Boolean;

/// <summary>
///   incli registros q faltam no tabela cliente e produto
/// </summary>
procedure validarDadosQtd();

/// <summary>
///   trata/converte uma string->"numerica" de R$ para US$
///   exemplo entra R$ 15.051,21 e sai 15051.21
/// </summary>
function trataValorComPonto(str:string):string;

implementation



{
  Abre/conecta banco de dados
}
function ConectarBase():Boolean;
begin
// conecta db
  try
    dmConectaBases.fdConectorDB.connected := true;
  except
    begin
      result:=false;
      exit;
    end;
  end;
end;

{
  Fecha/desconecta banco de dados
}
function desconectaBaseDeDados():Boolean;
begin
// desconecta db
  try
    dmConectaBases.fdConectorDB.connected:=false;
  except
    begin
      result:=false;
      exit;
    end;
  end;
end;

{
  verifica se existe a tabela
}
function validarBancoDeDados(db:string):Boolean;
var
  qtd:integer;
  sql:string;
begin
  result:=true;
  exit;
  sql:='SELECT COUNT(*) as qtd FROM information_schema. tables WHERE table_schema = '+
      QuotedStr(db);
  dmConectaBases.fdTabelaDiversos.sql.text:=sql;
  dmConectaBases.fdTabelaDiversos.active:=true;
  if dmConectaBases.fdtabelaDiversos.FieldByName('qtd').value <= 0 then
  begin
    result:=false;
  end;
end;




{
  retorna uma string no formato 0.00 tirando os pontos e virgulas portugues
}
function trataValorComPonto(str:string):string;
begin
  str := stringreplace(str, 'R$', '', [rfreplaceall, rfignorecase]);
  str := stringreplace(str, '.', '', [rfreplaceall, rfignorecase]);
  str := stringreplace(str, ',', '.', [rfreplaceall, rfignorecase]);
  if length(str) <= 0 then
    str := '0';
  result := str;
end;

{
  verifica se existe a tabela
}
function validarTabelas(db,tabela:string):Boolean;
var
  qtd : integer;
  sql : string;
begin
  result:=true;
  try
    sql:='select * from '+tabela+' tab where 0 = 1';
    dmConectaBases.fdTabelaDiversos.sql.text:=sql;
    dmConectaBases.fdTabelaDiversos.Active:=true;
  except
    result := False
  end;
end;



{
  verifica a qtd de registro nas tabelas
}
procedure validarDadosQtd();
var
  qtd : integer;
  sql : string;
  nomeDescricao : string;
begin

    try
    // verifica qtd que falta de registros e inclui a diferença TABELA cliente
      sql := 'select count(id) as qtd from cliente';
      dmConectaBases.fdTabelaDiversos.sql.Text:=sql;
      dmConectaBases.fdTabelaDiversos.Active:=true;
      qtd := dmConectaBases.fdTabelaDiversos.FieldByName('qtd').Value;
      nomeDescricao := 'Drausio M Germano ';
      while qtd <= 20 do
      begin
        qtd:=qtd+1;
        sql:='insert into cliente (nome,cidade,uf) values (' +
              quotedstr(nomeDescricao+inttostr(qtd))+
              ','+QuotedStr('SOROCABA')+
              ','+QuotedStr('SP')+
              ')';
        dmConectaBases.fdTabelaDiversos.SQL.Text:=sql;
        dmConectaBases.fdTabelaDiversos.ExecSQL;
      end;
    except

    end;

    try
    // verifica qtd que falta de registros e inclui a diferença TABELA produto
      sql := 'select count(id) as qtd from produto';
      dmConectaBases.fdTabelaDiversos.sql.Text:=sql;
      dmConectaBases.fdTabelaDiversos.Active:=true;
      qtd := dmConectaBases.fdTabelaDiversos.FieldByName('qtd').Value;
      nomeDescricao := 'Produto ';
      while qtd <= 20 do
      begin
        qtd:=qtd+1;
        sql:='insert into produto (descricao,valor) values (' +
             QuotedStr(nomeDescricao+inttostr(qtd))+
             ','+inttostr(qtd)+
             ')';
        dmConectaBases.fdTabelaDiversos.SQL.Text:=sql;
        dmConectaBases.fdTabelaDiversos.ExecSQL;
      end;
    except

    end;

end;

function fSoNumeros(soNumeros:string):string;
var
  i:integer;
begin
    result:='';
    for i := 1 to length(soNumeros) do
    begin
      if ((soNumeros[i] in ['0'..'9']) = true) then
          result := result + copy(soNumeros,i,1);
    end;
end;

{ retorna string com apenas nurero e a virgula }
function fSoNumerosEVirgula(soNumerosEVirgula:string):string;
var
  i:integer;
begin
    result:='';
    for i := 1 to length(soNumerosEVirgula) do
    begin
      if ((soNumerosEVirgula[i] in ['0'..'9' , ',']) = true) then
          result := result + copy(soNumerosEVirgula,i,1);
    end;
end;

{
  cria as tabelas no Banco de Dados
}
function sqlCriaTabela(tabela:string):Boolean;
var
  sql:string;
begin
  result := true;
  sql:='';
  if tabela='cliente' then
      sql := 'CREATE TABLE cliente ('+
	            'id INT NOT NULL AUTO_INCREMENT,'+
	            'nome VARCHAR(50) NOT NULL  ,'+
              'cidade VARCHAR(35) NULL ,'+
              'uf VARCHAR(2) NULL,'+
	            'INDEX `nome` (`nome`),'+
	            'PRIMARY KEY (`id`)'+
              ')'+
              'COLLATE=`utf8_unicode_ci`'+
              'ENGINE=InnoDB';

  if tabela='produto' then
      sql := 'CREATE TABLE produto ('+
	            'id INT NOT NULL AUTO_INCREMENT,'+
	            'descricao VARCHAR(50) NOT NULL ,'+
              'valor DOUBLE(12,2) NOT NULL DEFAULT 0,'+
              'uf VARCHAR(2) NULL ,'+
	            'INDEX descricao (`descricao`),'+
	            'PRIMARY KEY (`id`)'+
              ')'+
              'COLLATE=`utf8_unicode_ci`'+
              'ENGINE=InnoDB';

  if tabela='pedido' then
      sql := 'CREATE TABLE pedido ('+
	            'id INT NOT NULL AUTO_INCREMENT,'+
	            'idCliente int NOT NULL  DEFAULT 0,'+
              'dataEmissao DATE NULL DEFAULT NULL ,'+
              'valorPedido DOUBLE(12,2) NOT NULL DEFAULT 0,'+
	            'INDEX idCliente (`idCliente`),'+
              'INDEX dataEmissao (`dataEmissao`),'+
	            'PRIMARY KEY (`id`)'+
              ')'+
              'COLLATE=`utf8_unicode_ci`'+
              'ENGINE=InnoDB';

  if tabela='itensPedido' then
      sql := 'CREATE TABLE itenspedido ('+
	            'id INT NOT NULL AUTO_INCREMENT,'+
	            'idPedido INT NOT NULL  DEFAULT 0,'+
              'idProduto INT NOT NULL  DEFAULT 0,'+
              'qtd DOUBLE(12,2) NOT NULL DEFAULT 0,'+
              'valorUnitario DOUBLE(12,2) NOT NULL DEFAULT 0,'+
              'valorTotal DOUBLE(12,2) NOT NULL DEFAULT 0,'+
	            'INDEX idPedido (`idPedido`),'+
              'INDEX idProduto (`idProduto`),'+
	            'PRIMARY KEY (`id`)'+
              ')'+
              'COLLATE=`utf8_unicode_ci`'+
              'ENGINE=InnoDB';

  if tabela='fk_pedido_Cliente' then
      sql:='ALTER TABLE `pedido` ADD CONSTRAINT `fk_pedido_idCliente`'+
            ' FOREIGN KEY ( `idcliente` ) REFERENCES `cliente` ( `id` ) ;';

  if tabela='fk_ItensPedido_Produto' then
      sql:='ALTER TABLE `ItensPedido` ADD CONSTRAINT `fk_Itenspedido_Produto`'+
            ' FOREIGN KEY ( `idProduto` ) REFERENCES `produto` ( `id` ) ;';

  if tabela='fk_ItensPedido_Pedido' then
      sql:='ALTER TABLE `ItensPedido` ADD CONSTRAINT `fk_Itenspedido_Pedido`'+
            ' FOREIGN KEY ( `idPedido` ) REFERENCES `pedido` ( `id` ) ;';

  try
    if (length(sql) > 0) then
    begin
        dmConectaBases.fdTabelaDiversos.sql.text:=sql;
        dmConectaBases.fdTabelaDiversos.ExecSQL;
    end;
  except
        on E: Exception do
        begin
          if (pos('121',E.Message ) > 0) then
             result:=true
          else
             result:=false;
    end;
  end;

end;

function conectaBaseDeDados():Boolean;
const
  ip : string = '127.0.0.1';
  db : string = 'wk_pedido';
  usuario : string = 'wk_pedido';
  senha : string = 'wk_pedido';
var
  sql:string;
begin
  result:=true;
  try
    dmConectaBases.fdConectorDB.Params.UserName := usuario;
    dmConectaBases.fdConectorDB.params.Password := senha;
    dmConectaBases.fdConectorDB.Params.Values['Server'] :=  ip;
    dmConectaBases.fdConectorDB.Params.Database := db;
    dmConectaBases.fdConectorDB.connected := true;
  except
    result:=false;
    exit;
  end;

  // cria as tabelas no Banco de Dados
  if validarTabelas(db,'cliente') = false then
  begin
    result := sqlCriaTabela('cliente');
  end;
  if validarTabelas(db,'produto') = false then
  begin
    result := sqlCriaTabela('produto');
  end;
  if validarTabelas(db,'pedido') = false then
  begin
    result := sqlCriaTabela('pedido');
  end;
  if validarTabelas(db,'itensPedido') = false then
  begin
    result := sqlCriaTabela('itensPedido');
  end;

  // cria as FK e PK das tabelas no Banco de Dados
  if result = true then
  begin
    result := sqlCriaTabela('fk_pedido_Cliente');
  end;

  if result = true then
  begin
    result := sqlCriaTabela('fk_ItensPedido_Produto');
  end;

  if result = true then
  begin
    result := sqlCriaTabela('fk_ItensPedido_Pedido');
  end;

  if result = false then
  begin
      messagedlg('Erro na estrutura da tabela!',TMsgDlgType.mtError,[TMsgDlgBtn.mbOK],0);
      exit;
  end;

  validarDadosQtd();
  desconectaBaseDeDados;
end;



end.

unit uPedidoDeVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TFpedidoDeVendas = class(TForm)
    pnlTopTela: TPanel;
    pnlRodape: TPanel;
    pnlGridProdutoPedido: TPanel;
    pnlProduto: TPanel;
    pnlCliente: TPanel;
    lblCodCliente: TLabel;
    lblNomeCliente: TLabel;
    lblCidadeCliente: TLabel;
    lblUfCliente: TLabel;
    edtNomeCliente: TEdit;
    edtCidadeCliente: TEdit;
    edtUfCliente: TEdit;
    pnlRodapeGripProdutoPedido: TPanel;
    Label1: TLabel;
    lblDescricaoProduto: TLabel;
    Label3: TLabel;
    dbgProdutoPedido: TDBGrid;
    btnInclirItemPedido: TButton;
    btnInclirPedido: TButton;
    edtDescricaoProduto: TEdit;
    Label2: TLabel;
    edtCodProduto: TEdit;
    edtQtd: TEdit;
    edtValorUnitario: TEdit;
    edtCodCliente: TEdit;
    bltIncluirPedido: TButton;
    lblTotalPedido: TLabel;
    lblVlTotal: TLabel;
    bntConsultaPedido: TButton;
    btnExcluiPedido: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btnInclirPedidoClick(Sender: TObject);
    procedure btnInclirItemPedidoClick(Sender: TObject);
    procedure dbgProdutoPedidoKeyPress(Sender: TObject; var Key: Char);
    procedure bltIncluirPedidoClick(Sender: TObject);
    procedure edtCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure medtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodProdutoEnter(Sender: TObject);
    procedure edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtCodClienteEnter(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure bntConsultaPedidoClick(Sender: TObject);
    procedure edtCodClienteChange(Sender: TObject);
    procedure btnExcluiPedidoClick(Sender: TObject);
  private
    function limpaTabelaMemoItemPedido: Boolean;
    procedure mensagemErroStop(mensagem: string);
    function incluiReg: Boolean;
    function validarReg: boolean;
    function validarReg2: boolean;
    function validarCliente: Boolean;
    procedure limpaItemInsert;
    function alteraReg: Boolean;
    procedure limpaCliente;
    procedure somaVlTotal;
    function incluirPedido: Boolean;
    procedure consultaPedido(id:string);
    procedure montaConsultaPedido(id,idCliente: string);
    procedure mostraDadosCliente;
    procedure montaConsultaItensPedido(id:string);
    function incluiRegConsulta: Boolean;
    procedure excluiPedido(id: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FpedidoDeVendas: TFpedidoDeVendas;

implementation

{$R *.dfm}

uses   uModelMemo, udiversos, uModelDados;

{ valida para incluir pedido no banco de dados }
procedure TFpedidoDeVendas.bltIncluirPedidoClick(Sender: TObject);
begin
    if validarCliente = false then
       abort;
    if validarReg2 = false then
       abort;
    if incluirPedido = true then
        limpaTabelaMemoItemPedido;
    dmConectaBases.fdConectorDB.Connected:=false;

end;



{ valida dados do cliente }
function TFpedidoDeVendas.validarCliente():Boolean;
begin
  result:=true;
  if (length(edtNomeCliente.text) <= 0) then
  begin
    messagedlg('Cliente inválido!', mtWarning, [mbOK], 0);
    result:=false;
  end;
end;

{ valida para incluir os dados do item no pedido }
procedure TFpedidoDeVendas.btnExcluiPedidoClick(Sender: TObject);
var
  id:string;
begin
    id:='';
    id := InputBox ('Exclusão Pedido',
	     'Insira o número do pedido a ser EXCLUIDO:', '0');
    id := udiversos.fSoNumeros(id);
    if (length(trim(id)) <= 0) then
        id := '0';
    excluiPedido(id);
end;

{ consulta um pedido informado }
procedure TFpedidoDeVendas.excluiPedido(id:string);
var
  sql:string;
begin
  try
    sql:='select id,idCliente from pedido where id ='+id;
    dmConectaBases.fdTabelaDiversos.SQL.Text:=sql;
    dmConectaBases.fdTabelaDiversos.Active:=true;
    if dmConectaBases.fdTabelaDiversos.Eof then
    begin
      messagedlg('Código pedido não localizado.',TMsgDlgType.mtError,[mbOK],0);
      exit;
    end;
    sql := 'delete from itenspedido where idPedido = '+id;
    dmConectaBases.fdTabelaDiversos.SQL.Text:=sql;
    dmConectaBases.fdTabelaDiversos.ExecSQL;
    sql := 'delete from pedido where id = '+id;
    dmConectaBases.fdTabelaDiversos.SQL.Text:=sql;
    dmConectaBases.fdTabelaDiversos.ExecSQL;
  except
      mensagemErroStop('Erro ao excluir um pedido! Ligar para o suporte.')
  end;
  messagedlg('Pedido excluido com sucesso!',TMsgDlgType.mtInformation,[TMsgDlgBtn.mbOK],0);
end;


procedure TFpedidoDeVendas.btnInclirItemPedidoClick(Sender: TObject);
begin
    if validarReg = false then
       abort;
    if btnInclirItemPedido.Caption = 'Alterar Item' then
    begin
      alteraReg;
      btnInclirItemPedido.Caption:='Inclui Item';
    end
    else
      incluiReg;
    SomaVlTotal;
end;

procedure TFpedidoDeVendas.somaVlTotal;
var
  soma:real;
begin
  soma:=0;
  dmConectaMemo.fdmItemPedido.First;
  while not dmConectaMemo.fdmItemPedido.eof do
  begin
    soma:=soma+dmConectaMemo.fdmItemPedido.FieldByName('valor').value;
    dmConectaMemo.fdmItemPedido.Next;
  end;
  lblVlTotal.caption := floattostrf(soma,ffNumber,12,2);
end;


{ verifica se há itens no pedido }
function TFpedidoDeVendas.validarReg2():boolean;
var
  mensagem:string;
begin
  result:=true;
  if dmConectaMemo.fdmItemPedido.RecordCount <= 0 then
  begin
    messagedlg('Não há itens no pedido!', mtWarning, [mbOK], 0);
    result:=false;
  end;
end;

{ verifica as informações para incluir item no pedido }
function TFpedidoDeVendas.validarReg():boolean;
var
  mensagem:string;
begin
    result:=true;
    mensagem:='';
    if (length(edtCodProduto.text) <= 0) then
    begin
       mensagem:=#13+'Código';
    end;
    if (length(edtQtd.text) <= 0) or (strtoint(edtQtd.text) <= 0) then
    begin
       mensagem:=mensagem+#13+' Quantidade';
    end;
    if (length(edtValorUnitario.text) <= 0) then
    begin
       mensagem:=mensagem+#13+' Valor Unitário';
    end;
    if length(mensagem) > 0 then
    begin
      messagedlg('Favor informe:'+mensagem, mtWarning, [mbOK], 0);
      edtCodProduto.SetFocus;
      result:=false;
    end;
end;

{ altera dados na tabela/memória }
function TFpedidoDeVendas.alteraReg():Boolean;
var
  item:integer;
begin
    result:=true;
    try
         dmConectaMemo.fdmItemPedido.Edit;
         dmConectaMemo.fdmItemPedido.FieldByName('codItemProduto').Value:=strtoint(edtCodProduto.Text);
         dmConectaMemo.fdmItemPedido.FieldByName('descricaoProduto').Value:=edtDescricaoProduto.Text;
         dmConectaMemo.fdmItemPedido.FieldByName('qtd').Value:=strtoint(edtQtd.Text);
         dmConectaMemo.fdmItemPedido.FieldByName('valorUnitario').Value:=edtValorUnitario.Text;
         dmConectaMemo.fdmItemPedido.FieldByName('valor').Value:=strtoint(edtQtd.Text)*strtofloat(edtValorUnitario.text);
         dmConectaMemo.fdmItemPedido.Post;
    except
          result:=false;
    end;
    result:=true;
end;


procedure TFpedidoDeVendas.btnInclirPedidoClick(Sender: TObject);
begin
  limpaTabelaMemoItemPedido;
end;

{ *********************
  contro tecla dbgridItensPedido DEL ENTER exclui altera intens pedido
}
procedure TFpedidoDeVendas.dbgProdutoPedidoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #127 then
  begin
    if dbgProdutoPedido.SelectedRows.Count <= 0 then
    begin
      messagedlg('Não há item seleciona para excluir!', mtWarning, [mbOK], 0);
      exit;
    end;
    if messagedlg('Confirma a excluisão do ítem?'+#13+#13+
        dmConectaMemo.fdmItemPedido.FieldByName('descricaoProduto').value, mtConfirmation,
        [mbNo, mbYes], 0) = mryes then
    begin
       dmConectaMemo.fdmItemPedido.Delete;
       messagedlg('Item excluido !!',mtConfirmation,[mbok],0);
    end;
  end;

  if key = #13 then
  begin
    if dbgProdutoPedido.SelectedRows.Count <= 0 then
    begin
      messagedlg('Não há item seleciona para alterar!', mtWarning, [mbOK], 0);
      exit;
    end;
    if messagedlg('Confirma o ítem a ser alterado?'+#13+#13+
        dmConectaMemo.fdmItemPedido.FieldByName('descricaoProduto').value, mtConfirmation,
        [mbNo, mbYes], 0) = mryes then
    begin
        edtCodProduto.Text:=dmConectaMemo.fdmItemPedido.FieldByName('codItemProduto').Value;
        edtDescricaoProduto.Text:=dmConectaMemo.fdmItemPedido.FieldByName('descricaoProduto').Value;
        edtQtd.Text:=dmConectaMemo.fdmItemPedido.FieldByName('qtd').Value;
        edtValorUnitario.Text:=dmConectaMemo.fdmItemPedido.FieldByName('valorUnitario').Value;
        edtqtd.SetFocus;
        btnInclirItemPedido.Caption:='Alterar Item';
    end;
  end;
end;

{ verifica as teclas digitadas}
procedure TFpedidoDeVendas.edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', ',']) then
  begin
     Key := #0;
  end
  else
  if (Key = ',') and (Pos(Key, edtValorUnitario.Text) > 0) then
  begin
    Key := #0;
  end;
end;


{ consulta o codigo do cliente na tabela cliente }
procedure TFpedidoDeVendas.edtCodClienteExit(Sender: TObject);
VAR
  sql :string;
begin
  try
    if length(edtCodCliente.Text) > 0 then
    begin
      sql:='select id,nome,cidade,uf from cliente where id = '+edtCodCliente.Text;
      dmConectaBases.fdCliente.sql.Text:=sql;
      dmConectaBases.fdCliente.Active:=true;
      if not dmConectaBases.fdCliente.Eof then
      begin
         mostraDadosCliente;
      end
      else
        messagedlg('Código CLIENTE inválido!',TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOK],0);
    end;
  except
      mensagemErroStop('Erro de acesso ao banco de dados!');
  end;
end;

procedure TFpedidoDeVendas.edtCodClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in [#8, '0'..'9', ',']) then
  begin
     Key := #0;
  end;
end;

procedure TFpedidoDeVendas.edtCodProdutoEnter(Sender: TObject);
begin
  limpaItemInsert;
end;

{ consulta o codigo do produto na tabela produtos }
procedure TFpedidoDeVendas.edtCodProdutoExit(Sender: TObject);
var
  sql:string;
begin
  try
    if length(edtCodProduto.Text) > 0 then
    begin
      sql:='select descricao,valor from produto where id = '+edtCodProduto.Text;
      dmConectaBases.fdProduto.sql.Text:=sql;
      dmConectaBases.fdProduto.Active:=true;
      if not dmConectaBases.fdProduto.Eof then
      begin
        edtDescricaoProduto.Text := dmConectaBases.fdProduto.FieldByName('descricao').Value;
        edtValorUnitario.Text := FloatToStr(dmConectaBases.fdProduto.FieldByName('valor').Value);
      end
      else
        messagedlg('Código PRODUTO inválido!',TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOK],0);
    end;
    except
        mensagemErroStop('Erro de acesso ao banco de dados!');
  end;
end;


procedure TFpedidoDeVendas.edtCodClienteChange(Sender: TObject);
begin
  if length(trim(edtCodCliente.Text)) > 0 then
  begin
    bntConsultaPedido.Visible:=false;
    btnExcluiPedido.Visible:=false;
  end
  else
  begin
    bntConsultaPedido.Visible:=true;
    btnExcluiPedido.Visible:=true;
  end;
end;

procedure TFpedidoDeVendas.edtCodClienteEnter(Sender: TObject);
begin
    limpaCliente;
end;

{ limpa os campos para localizar novo cliente }
procedure TFpedidoDeVendas.limpaCliente();
begin
  edtNomeCliente.Text := '';
  edtCodCliente.Text := '';
  edtUfCliente.Text := '';
  edtCidadeCliente.Text := '';
end;

{ limpa os campos para inserir nos dados }
procedure TFpedidoDeVendas.limpaItemInsert();
begin
  edtCodProduto.Text:='';
  edtDescricaoProduto.Text:='';
  edtQtd.Text:='1';
  edtValorUnitario.text:='0';
end;

{
  valida teclas digitadas
}
procedure TFpedidoDeVendas.edtCodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', ',']) then
  begin
     Key := #0;
  end;
end;

{****************
    limpa os itens da tabela/memória itens do pedido
}
function  TFpedidoDeVendas.limpaTabelaMemoItemPedido():Boolean;
begin
  result:=true;
  try
    dmConectaMemo.fdmItemPedido.Active:=true;
    dmConectaMemo.fdmItemPedido.First;
    while not dmConectaMemo.fdmItemPedido.Eof do
    begin
      dmConectaMemo.fdmItemPedido.Delete;
    end;
  Except
    Result:=false;
  end;
  btnInclirItemPedido.Caption:='Incluir';
  lblVlTotal.Caption := '0,00';
end;


{ **********************************
    limpa a tabela de memória itens do pedido
}
procedure TFpedidoDeVendas.medtValorUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin

end;

{
  mostra mensagem de erro e fecha o sistema
}
procedure TFpedidoDeVendas.mensagemErroStop(mensagem:string);
begin
  try
     MessageDlg('Erro.'+#13+'Favor ligar para o suporte. Obrigado.', TMsgDlgType.mtError, [mbOK], 0);
//     close;
  finally

  end;
end;


{
  verifica a tabela memo intens do pedido - cliente e produto
}
procedure TFpedidoDeVendas.FormActivate(Sender: TObject);
begin
    if limpaTabelaMemoItemPedido()=false then
        mensagemErroStop('Erro acesso tabela itens do pedido!');
    if udiversos.conectaBaseDeDados()=false then
        mensagemErroStop('Erro ao acessar ao servidor!');
end;


procedure TFpedidoDeVendas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    dmConectaBases.fdConectorDB.Connected:=false;
end;

{ confirma/inclui o pedido no banco de dados }
function TFpedidoDeVendas.incluirPedido():Boolean;
var
  sql:string;
  id : integer;
begin
  result:=true;
  try
      if messagedlg('Confirma o fechamento o pedido?', mtConfirmation,
          [mbNo, mbYes], 0) = mrno then
      begin
         messagedlg('Operação cancelada !!',TMsgDlgType.mtInformation,[mbok],0);
         result:=false;
         exit;
      end;

      if (dmConectaMemo.fdmItemPedido.RecordCount <= 0) then
      begin
         messagedlg('Não há itens no pedido !!',TMsgDlgType.mtInformation,[mbok],0);
         result:=false;
         exit;
      end;

      if (length(edtNomeCliente.Text) <= 0) then
      begin
         messagedlg('Cliente não informado !!',TMsgDlgType.mtInformation,[mbok],0);
         result:=false;
         exit;
      end;

      // inclui registro pedido
      sql:='insert into pedido (idCliente,dataEmissao,valorPedido) values (' +
           edtCodCliente.Text+','+
           'now(),'+
           udiversos.trataValorComPonto(lblVlTotal.Caption)+
           ')';
      dmConectaBases.fdTabelaDiversos.sql.Text:=sql;
      dmConectaBases.fdTabelaDiversos.ExecSQL;

      // pega o id/numero do pedido
      sql:='select last_insert_id() as id ';
      dmConectaBases.fdTabelaDiversos.sql.Text:=sql;
      dmConectaBases.fdTabelaDiversos.active := true;
      if not dmConectaBases.fdTabelaDiversos.eof then
      begin
         id :=  dmConectaBases.fdTabelaDiversos.FieldByName('id').value;
      end
      else
      begin
        result := false;
      end;

      dmConectaMemo.fdmItemPedido.First;
      while not dmConectaMemo.fdmItemPedido.Eof do
      begin
          sql:='';
          // inclui registro pedido
          sql:='insert into itenspedido (idPedido,idProduto,qtd,valorUnitario,valorTotal) values (' +
                inttostr(id)+','+
                inttostr(dmConectaMemo.fdmItemPedido.FieldByName('codItemProduto').value)+','+
                inttostr(dmConectaMemo.fdmItemPedido.FieldByName('qtd').value)+','+
                udiversos.trataValorComPonto(floattostr(dmConectaMemo.fdmItemPedido.FieldByName('valorUnitario').value))+','+
                udiversos.trataValorComPonto(floattostr(dmConectaMemo.fdmItemPedido.FieldByName('valor').value))+
               ')';
          dmConectaBases.fdTabelaDiversos.sql.Text:=sql;
          dmConectaBases.fdTabelaDiversos.ExecSQL;
          dmConectaMemo.fdmItemPedido.next;
      end;

      messagedlg('Pedido incluso e finalizado. Obrigado.',TMsgDlgType.mtInformation,[TMsgDlgBtn.mbOK],0);

  except
      mensagemErroStop('Erro na incluisão dos dados do pedido!'+#13)
  end;

end;


procedure TFpedidoDeVendas.bntConsultaPedidoClick(Sender: TObject);
var
  id:string;
begin
    id:='';
    id := InputBox ('Consulta Pedido',
	     'Insira o número do pedido:', '0');
    id := udiversos.fSoNumeros(id);
    if (length(trim(id)) <= 0) then
        id := '0';
    consultaPedido(id);
end;

{ consulta um pedido informado }
procedure TFpedidoDeVendas.consultaPedido(id:string);
var
  sql:string;
begin
  try
    sql:='select id,idCliente from pedido where id ='+id;
    dmConectaBases.fdTabelaDiversos.SQL.Text:=sql;
    dmConectaBases.fdTabelaDiversos.Active:=true;
    if dmConectaBases.fdTabelaDiversos.Eof then
    begin
      messagedlg('Código pedido não localizado.',TMsgDlgType.mtError,[mbOK],0);
      exit;
    end;
    montaConsultaPedido(id,inttostr(dmConectaBases.fdTabelaDiversos.FieldByName('idCliente').value));
  except
    mensagemErroStop('Erro na consulta de pedido!'+#13+'Ligar para o suporte.');
  end;
end;


{ consulta um pedido informado }
procedure TFpedidoDeVendas.montaConsultaPedido(id,idCliente:string);
var
  sql:string;
begin
  try
      limpaTabelaMemoItemPedido;
      {localiza o cadastro do cliente}
      sql:='select id,nome,cidade,uf from cliente where id = '+idCliente;
      dmConectaBases.fdCliente.sql.Text:=sql;
      dmConectaBases.fdCliente.Active:=true;
      mostraDadosCliente;
      {localiza os itens do pedido }
      sql:='select ip.idProduto,p.descricao,ip.qtd,ip.valorUnitario,ip.valorTotal '+
           ' from itenspedido as ip ' +
           ' inner join produto as p on ip.idProduto = p.id ' +
           ' where ip.idPedido = '+id;
      dmConectaBases.fdProduto.sql.Text:=sql;
      dmConectaBases.fdProduto.Active:=true;
      montaConsultaItensPedido(id);
  except
    mensagemErroStop('Erro na consulta de pedido!'+#13+'Ligar para o suporte.');
  end;
end;

{ carrega os dados da tabela cliente nos edit de tela }
procedure TFpedidoDeVendas.mostraDadosCliente();
begin
        edtCodCliente.Text := dmConectaBases.fdCliente.FieldByName('id').Value;
        edtNomeCliente.Text := dmConectaBases.fdCliente.FieldByName('nome').Value;
        edtCidadeCliente.Text := dmConectaBases.fdCliente.FieldByName('cidade').Value;
        edtUfCliente.Text := dmConectaBases.fdCliente.FieldByName('uf').Value;
end;

procedure TFpedidoDeVendas.montaConsultaItensPedido(id:string);
var
  sql:string;
begin
  try
    dmConectaBases.fdProduto.First;
    while not dmConectaBases.fdProduto.Eof do
    begin
      incluiRegConsulta;
      dmConectaBases.fdProduto.Next;
    end;
  except

  end;
end;

{ inclui dados na tabela/memória }
function TFpedidoDeVendas.incluiRegConsulta():Boolean;
var
  item:integer;
begin
    result:=true;
    try
       dmConectaMemo.fdmItemPedido.Append;
       dmConectaMemo.fdmItemPedido.FieldByName('codItemProduto').Value:=
          (dmConectaBases.fdProduto.FieldByName('idProduto').value);
       dmConectaMemo.fdmItemPedido.FieldByName('descricaoProduto').Value:=
          (dmConectaBases.fdProduto.FieldByName('descricao').value);
       dmConectaMemo.fdmItemPedido.FieldByName('qtd').Value:=
          (dmConectaBases.fdProduto.FieldByName('qtd').value);
       dmConectaMemo.fdmItemPedido.FieldByName('valorUnitario').Value:=
          (dmConectaBases.fdProduto.FieldByName('valorUnitario').value);
       dmConectaMemo.fdmItemPedido.FieldByName('valor').Value:=
          (dmConectaBases.fdProduto.FieldByName('valorTotal').value);
       dmConectaMemo.fdmItemPedido.Post;
    except
          result:=false;
    end;
    result:=true;
end;

{ inclui dados na tabela/memória }
function TFpedidoDeVendas.incluiReg():Boolean;
var
  item:integer;
begin
    result:=true;
    try
       dmConectaMemo.fdmItemPedido.Append;
       dmConectaMemo.fdmItemPedido.FieldByName('codItemProduto').Value:=strtoint(edtCodProduto.Text);
       dmConectaMemo.fdmItemPedido.FieldByName('descricaoProduto').Value:=edtDescricaoProduto.Text;
       dmConectaMemo.fdmItemPedido.FieldByName('qtd').Value:=strtoint(edtQtd.Text);
       dmConectaMemo.fdmItemPedido.FieldByName('valorUnitario').Value:=edtValorUnitario.Text;
       dmConectaMemo.fdmItemPedido.FieldByName('valor').Value:=strtoint(edtQtd.Text)*strtofloat(edtValorUnitario.text);
       dmConectaMemo.fdmItemPedido.Post;
    except
          result:=false;
    end;
    result:=true;
end;


end.

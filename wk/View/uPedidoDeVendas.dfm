object FpedidoDeVendas: TFpedidoDeVendas
  Left = 0
  Top = 0
  Caption = 'Pedido de Vendas'
  ClientHeight = 471
  ClientWidth = 1217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTopTela: TPanel
    Left = 0
    Top = 0
    Width = 1217
    Height = 41
    Align = alTop
    Caption = 'Pedido de Venda'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsItalic, fsUnderline]
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 976
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 430
    Width = 1217
    Height = 41
    Align = alBottom
    TabOrder = 3
    ExplicitWidth = 976
    object lblTotalPedido: TLabel
      Left = 535
      Top = 9
      Width = 115
      Height = 19
      Caption = 'Total Pedido: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lblVlTotal: TLabel
      Left = 671
      Top = 9
      Width = 35
      Height = 19
      Caption = '0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object btnInclirPedido: TButton
      Left = 9
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Limpar Pedido'
      TabOrder = 0
      OnClick = btnInclirPedidoClick
    end
  end
  object pnlGridProdutoPedido: TPanel
    Left = 0
    Top = 164
    Width = 1217
    Height = 266
    Align = alClient
    TabOrder = 4
    ExplicitWidth = 976
    object pnlRodapeGripProdutoPedido: TPanel
      Left = 1
      Top = 258
      Width = 1215
      Height = 7
      Align = alBottom
      TabOrder = 0
      ExplicitWidth = 974
    end
    object dbgProdutoPedido: TDBGrid
      Left = 1
      Top = 1
      Width = 1215
      Height = 257
      Align = alClient
      DataSource = dmConectaMemo.dsItemPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyPress = dbgProdutoPedidoKeyPress
    end
  end
  object pnlProduto: TPanel
    Left = 0
    Top = 123
    Width = 1217
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 976
    object Label1: TLabel
      Left = 9
      Top = 14
      Width = 107
      Height = 19
      Caption = 'C'#243'd.Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDescricaoProduto: TLabel
      Left = 185
      Top = 16
      Width = 71
      Height = 19
      Caption = 'Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 590
      Top = 16
      Width = 93
      Height = 19
      Caption = 'Vl.Unit'#225'rio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 488
      Top = 16
      Width = 41
      Height = 19
      Caption = 'QTD:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnInclirItemPedido: TButton
      Left = 778
      Top = 2
      Width = 175
      Height = 34
      Caption = 'Incluir Item'
      TabOrder = 4
      OnClick = btnInclirItemPedidoClick
    end
    object edtDescricaoProduto: TEdit
      Left = 262
      Top = 15
      Width = 204
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object edtCodProduto: TEdit
      Left = 122
      Top = 14
      Width = 49
      Height = 21
      MaxLength = 6
      TabOrder = 0
      OnEnter = edtCodProdutoEnter
      OnExit = edtCodProdutoExit
      OnKeyPress = edtCodProdutoKeyPress
    end
    object edtQtd: TEdit
      Left = 535
      Top = 15
      Width = 49
      Height = 21
      MaxLength = 4
      TabOrder = 2
      OnKeyPress = edtCodProdutoKeyPress
    end
    object edtValorUnitario: TEdit
      Left = 689
      Top = 15
      Width = 68
      Height = 21
      MaxLength = 6
      TabOrder = 3
      OnKeyPress = edtValorUnitarioKeyPress
    end
    object bltIncluirPedido: TButton
      Left = 1047
      Top = 3
      Width = 141
      Height = 33
      Caption = 'Gravar Pedido'
      TabOrder = 5
      OnClick = bltIncluirPedidoClick
    end
  end
  object pnlCliente: TPanel
    Left = 0
    Top = 41
    Width = 1217
    Height = 82
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 1
    ExplicitTop = 39
    ExplicitWidth = 976
    object lblCodCliente: TLabel
      Left = 49
      Top = 6
      Width = 100
      Height = 19
      Caption = 'C'#243'd.Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNomeCliente: TLabel
      Left = 33
      Top = 31
      Width = 116
      Height = 19
      Caption = 'Nome Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCidadeCliente: TLabel
      Left = 24
      Top = 56
      Width = 125
      Height = 19
      Caption = 'Cidade Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblUfCliente: TLabel
      Left = 472
      Top = 55
      Width = 90
      Height = 19
      Caption = 'UF Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtNomeCliente: TEdit
      Left = 160
      Top = 30
      Width = 489
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object edtCidadeCliente: TEdit
      Left = 160
      Top = 54
      Width = 306
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object edtUfCliente: TEdit
      Left = 568
      Top = 55
      Width = 81
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object edtCodCliente: TEdit
      Left = 160
      Top = 5
      Width = 81
      Height = 21
      MaxLength = 6
      TabOrder = 0
      OnChange = edtCodClienteChange
      OnEnter = edtCodClienteEnter
      OnExit = edtCodClienteExit
      OnKeyPress = edtCodClienteKeyPress
    end
    object bntConsultaPedido: TButton
      Left = 778
      Top = 6
      Width = 175
      Height = 70
      Caption = 'Consulta Pedido'
      TabOrder = 4
      OnClick = bntConsultaPedidoClick
    end
    object btnExcluiPedido: TButton
      Left = 986
      Top = 6
      Width = 175
      Height = 70
      Caption = 'EXCLUI pedido'
      TabOrder = 5
      OnClick = btnExcluiPedidoClick
    end
  end
end

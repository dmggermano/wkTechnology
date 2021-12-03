object dmConectaMemo: TdmConectaMemo
  OldCreateOrder = False
  Height = 192
  Width = 399
  object fdmItemPedido: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 64
    Top = 24
    object fdmItemPedidocodItemProduto: TIntegerField
      DisplayLabel = 'Cod. Item'
      DisplayWidth = 10
      FieldName = 'codItemProduto'
    end
    object fdmItemPedidodescricaoProduto: TStringField
      DisplayLabel = 'Desc. Produto'
      DisplayWidth = 48
      FieldName = 'descricaoProduto'
      Size = 35
    end
    object fdmItemPedidoqtd: TIntegerField
      DisplayLabel = 'QTD'
      DisplayWidth = 10
      FieldName = 'qtd'
    end
    object fdmItemPedidovalorUnitario: TFloatField
      DisplayLabel = 'Valor Unit'#225'rio'
      DisplayWidth = 16
      FieldName = 'valorUnitario'
    end
    object fdmItemPedidovalor: TCurrencyField
      DisplayLabel = 'Valor Total Item'
      DisplayWidth = 25
      FieldName = 'valor'
    end
  end
  object dsItemPedido: TDataSource
    DataSet = fdmItemPedido
    Left = 160
    Top = 24
  end
end

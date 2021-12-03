object dmConectaBases: TdmConectaBases
  OldCreateOrder = False
  Height = 359
  Width = 523
  object fdConectorDB: TFDConnection
    Params.Strings = (
      'DriverID=MySQL'
      'Password=wk_pedido'
      'Server=127.0.0.1'
      'Database=wk_pedido'
      'User_Name=wk_pedido')
    LoginPrompt = False
    Left = 64
    Top = 16
  end
  object fdCliente: TFDQuery
    Connection = fdConectorDB
    Left = 64
    Top = 80
  end
  object fdProduto: TFDQuery
    Connection = fdConectorDB
    Left = 64
    Top = 144
  end
  object fdTabelaDiversos: TFDQuery
    Connection = fdConectorDB
    SQL.Strings = (
      'select * from lixo')
    Left = 160
    Top = 85
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 168
    Top = 16
  end
end

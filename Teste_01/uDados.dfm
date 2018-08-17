object dmDados: TdmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object db: TIBDatabase
    DatabaseName = 
      'D:\Usu'#225'rios\Isac\'#193'rea de Trabalho\Areco\Teste_01\banco\dbteste01' +
      '.ib'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    DefaultTransaction = ts
    ServerType = 'IBServer'
    Left = 24
    Top = 16
  end
  object ts: TIBTransaction
    DefaultDatabase = db
    Left = 72
    Top = 16
  end
  object sqlAux: TIBSQL
    Database = db
    Transaction = ts
    Left = 120
    Top = 16
  end
  object qyAux: TIBQuery
    Database = db
    Transaction = ts
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 168
    Top = 16
  end
  object sqlProdutos: TIBSQL
    Database = db
    SQL.Strings = (
      'select CODIGO, DESCRICAO, TIPO, IMPORTADO, QUANTIDADE,'
      'UNIDADE, PRECO '
      ' FROM PRODUTOS order by CODIGO asc')
    Transaction = ts
    Left = 120
    Top = 72
  end
end

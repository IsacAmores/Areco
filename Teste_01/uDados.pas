unit uDados;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBSQL, IBX.IBDatabase, uProduto;

type
  TdmDados = class(TDataModule)
    db: TIBDatabase;
    ts: TIBTransaction;
    sqlAux: TIBSQL;
    qyAux: TIBQuery;
    sqlProdutos: TIBSQL;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function DeletarProduto(const pCodigo: Integer): Boolean;
    function SalvarProduto(const pProduto: TProduto): Boolean;
    function BuscarCodigo: Integer;
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  Forms, uConst;

{$R *.dfm}

procedure TdmDados.DataModuleCreate(Sender: TObject);
const
  BANCO = 'banco\dbteste01.ib';
var
  vLocal: String;
begin
  vLocal:= ExtractFilePath(Application.ExeName);
  vLocal:= format('%s%s', [vLocal, BANCO]);
  try
    db.databasename:= vLocal;
    Self.db.Open;
    Self.ts.Active:= db.Connected;
  Except
    on e: Exception do
    begin
      raise Exception.Create('Não foi possível conectar ao banco. Mensagem Original: ' + e.Message);
    end;
  end;
end;

function TdmDados.DeletarProduto(const pCodigo: Integer): Boolean;
const
  SQLDEL = 'DELETE FROM PRODUTOS WHERE CODIGO = %d';
begin
  Result:= True;

  Self.sqlAux.Close;
  Self.sqlAux.SQL.Clear;
  Self.sqlAux.SQL.Text:= format(SQLDEL, [pCodigo]);
  try
    Self.sqlAux.ExecQuery;
    Self.ts.CommitRetaining;
  except
    on e: Exception do
    begin
      Self.ts.Rollback;
      Result:= False;
      raise Exception.Create('Não foi possível deletar o produto. Mensagem Original: ' + e.Message);
    end;
  end;
end;

function TdmDados.SalvarProduto(const pProduto: TProduto): Boolean;
const
  SQLINC = ' UPDATE OR INSERT INTO PRODUTOS '+
           ' (CODIGO, DESCRICAO, TIPO, IMPORTADO, QUANTIDADE, UNIDADE, PRECO) '+
           ' VALUES '+
           ' (:CODIGO, :DESCRICAO, :TIPO, :IMPORTADO, :QUANTIDADE, :UNIDADE, :PRECO)'+
           ' matching (CODIGO)';
begin
  Result:= True;

  Self.sqlAux.Close;
  Self.sqlAux.SQL.Clear;
  Self.sqlAux.SQL.Text:= SQLINC;

  Self.sqlAux.ParamByName('CODIGO').AsInteger:= pProduto.Codigo;
  Self.sqlAux.ParamByName('DESCRICAO').AsString:= pProduto.Descricao;
  Self.sqlAux.ParamByName('TIPO').AsInteger:= TConversoes.TipoToInt(pProduto.Tipo);
  Self.sqlAux.ParamByName('IMPORTADO').AsString:= pProduto.Importado;
  Self.sqlAux.ParamByName('QUANTIDADE').AsFloat:= pProduto.Quantidade;
  Self.sqlAux.ParamByName('UNIDADE').AsInteger:= TConversoes.UnidToInt(pProduto.Unidade);
  Self.sqlAux.ParamByName('PRECO').AsFloat:= pProduto.Preco;

  try
    Self.sqlAux.ExecQuery;
    Self.ts.CommitRetaining;
  except
    on e: Exception do
    begin
      Self.ts.Rollback;
      Result:= False;
      raise Exception.Create('Não foi possível salvar o produto. Mensagem Original: ' + e.Message);
    end;
  end;
end;

function TdmDados.BuscarCodigo: Integer;
begin
  Self.sqlAux.Close;
  Self.sqlAux.SQL.Clear;
  Self.sqlAux.SQL.Text:= 'SELECT MAX(CODIGO) AS ULTIMO FROM PRODUTOS';
  Self.sqlAux.ExecQuery;

  Result:= Self.sqlAux.FieldByName('ULTIMO').AsInteger + 1;
end;

end.

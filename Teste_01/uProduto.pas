unit uProduto;

interface

uses
  uConst;

  type
    TProduto = class
      private
        FCodigo: Integer;
        FDescricao: String;
        FTipo: TTIpo;
        FUnidade: TUnidade;
        FImportado: Char;
        FQuantidade: Double;
        FPreco: Double;
      public
        property Codigo: Integer read FCodigo write FCodigo;
        property Descricao: String read FDescricao write FDescricao;
        property Tipo: TTipo read FTipo write FTipo;
        property Importado: Char read FImportado write FImportado;
        property Quantidade: Double read FQuantidade write FQuantidade;
        property Unidade: TUnidade read FUnidade write FUnidade;
        property Preco: Double read FPreco write FPreco;

        constructor Create;
    end;

implementation

{ TProduto }

constructor TProduto.Create;
begin
  Self.FCodigo:= 0;
  Self.FDescricao:= '';
  Self.FTipo:= tpRevenda;
  Self.FImportado:= #0;
  Self.FUnidade:= tuG;
  Self.FQuantidade:= 0;
  Self.FPreco:= 0;
end;

end.

unit uListaProdutos;

interface

uses
  System.Classes, uProduto;

  type
    TListaProdutos = class
      private
        FListaProdutos: TList;
      public
        constructor Create;
        procedure Add(pProduto: TProduto);
        procedure Delete(pIndice: Integer);
        function Item(pIndice: Integer): TProduto;
        function Count: Integer;
    end;

implementation

{ TListaProdutos }

constructor TListaProdutos.Create;
begin
  inherited Create;
  Self.FListaProdutos:= TList.Create;
end;

function TListaProdutos.Item(pIndice: Integer): TProduto;
begin
  Result:= Self.FListaProdutos.Items[pIndice];
end;

procedure TListaProdutos.Add(pProduto: TProduto);
begin
  Self.FListaProdutos.Add(pProduto);
end;

function TListaProdutos.Count: Integer;
begin
  Result:= Self.FListaProdutos.Count;
end;

procedure TListaProdutos.Delete(pIndice: Integer);
begin
  Self.FListaProdutos.Delete(pIndice);
end;

end.

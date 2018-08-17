unit FRProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, System.Actions, Vcl.ActnList, uListaProdutos, Datasnap.DBClient, FREdicaoProduto,
  Vcl.Buttons;

type
  TfrPrincipal = class(TForm)
    gbProdutos: TGroupBox;
    grProdutos: TDBGrid;
    acAcoes: TActionList;
    alAdicionar: TAction;
    alEditar: TAction;
    alExcluir: TAction;
    dsProdutos: TDataSource;
    csProdutos: TClientDataSet;
    csProdutosCODIGO: TIntegerField;
    csProdutosDESCRICAO: TStringField;
    csProdutosTIPO: TSmallintField;
    csProdutosIMPORTADO: TStringField;
    csProdutosUNIDADE: TSmallintField;
    csProdutosQUANTIDADE: TFloatField;
    csProdutosPRECO: TFloatField;
    btAdicionar: TBitBtn;
    btEditar: TBitBtn;
    btExcluir: TBitBtn;
    procedure alAdicionarExecute(Sender: TObject);
    procedure alEditarExecute(Sender: TObject);
    procedure alExcluirExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure csProdutosTIPOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure csProdutosIMPORTADOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure csProdutosUNIDADEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FListaProdutos: TListaProdutos;

    procedure CarregarProdutos;
    procedure CarregarCds;
    procedure Salvar(var pForm: TfrEditorProduto);
  public
    { Public declarations }
  end;

var
  frPrincipal: TfrPrincipal;

implementation

uses
  System.TypInfo, uProduto, uDados, uConst;

{$R *.dfm}

procedure TfrPrincipal.alAdicionarExecute(Sender: TObject);
var
  vEdicao: TfrEditorProduto;
begin
  try
    vEdicao:= TfrEditorProduto.Create(Nil);
    vEdicao.ShowModal;

    Self.Salvar(vEdicao);
  finally
    FreeAndNil(vEdicao);
  end;
end;

procedure TfrPrincipal.alEditarExecute(Sender: TObject);
var
  vEdicao: TfrEditorProduto;
begin
  if Self.FListaProdutos.Count = 0 then
  begin
    MessageDlg('Não há produto disponível para edição', mtInformation, [mbOk], 0);
    Exit;
  end;

  try
    vEdicao:= TfrEditorProduto.Create(Nil);
    vEdicao.Produto:= Self.FListaProdutos.Item(csProdutos.RecNo -1);
    vEdicao.ShowModal;

    Self.Salvar(vEdicao);
  finally
    FreeAndNil(vEdicao);
  end;
end;

procedure TfrPrincipal.alExcluirExecute(Sender: TObject);
var
  vIndex: Integer;
begin
  if Self.FListaProdutos.Count = 0 then
  begin
    MessageDlg('Não há produto disponível para ser excluído', mtInformation, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir?', mtWarning, [mbOk, mbCancel], 0, mbCancel) = mrOk then
  begin
    vIndex:= csProdutos.RecNo -1;

    if dmDados.DeletarProduto(Self.FListaProdutos.Item(vIndex).Codigo) then
    begin
      Self.FListaProdutos.Delete(vIndex);
      csProdutos.Delete;
    end;
  end;
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  Self.FListaProdutos:= TListaProdutos.Create;
  csProdutos.CreateDataSet;
end;

procedure TfrPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Self.FListaProdutos);
  csProdutos.EmptyDataSet;
end;

procedure TfrPrincipal.FormShow(Sender: TObject);
begin
  Self.CarregarProdutos;
end;

procedure TfrPrincipal.CarregarProdutos;
var
  vProduto: Tproduto;
begin
  dmDados.sqlProdutos.ExecQuery;
  while not dmDados.sqlProdutos.Eof do
  begin
    vProduto:= TProduto.Create;

    vProduto.Codigo:= dmDados.sqlProdutos.FieldByName('CODIGO').AsInteger;
    vProduto.Descricao:= dmDados.sqlProdutos.FieldByName('DESCRICAO').AsString;
    vProduto.Tipo:= TConversoes.IntToTipo(dmDados.sqlProdutos.FieldByName('TIPO').AsInteger);
    vProduto.Importado:= dmDados.sqlProdutos.FieldByName('IMPORTADO').AsString [1];
    vProduto.Quantidade:= dmDados.sqlProdutos.FieldByName('QUANTIDADE').AsFloat;
    vProduto.Unidade:= TConversoes.IntToUnid(dmDados.sqlProdutos.FieldByName('UNIDADE').AsInteger);
    vProduto.Preco:= dmDados.sqlProdutos.FieldByName('PRECO').AsFloat;

    Self.FListaProdutos.Add(vProduto);
    dmDados.sqlProdutos.Next;
  end;
  Self.CarregarCds;
end;

procedure TfrPrincipal.CarregarCds;
var
  vCont: Integer;
begin
  for vCont:= 0 to Self.FListaProdutos.Count - 1 do
  begin
    if csProdutos.Locate('CODIGO', Self.FListaProdutos.Item(vCont).Codigo, []) then
      csProdutos.Edit
    else
      csProdutos.Append;

    csProdutos.FieldByName('CODIGO').AsInteger:= Self.FListaProdutos.Item(vCont).Codigo;
    csProdutos.FieldByName('DESCRICAO').AsString:= Self.FListaProdutos.Item(vCont).descricao;
    csProdutos.FieldByName('TIPO').AsInteger:= Tconversoes.TipoToInt(Self.FListaProdutos.Item(vCont).Tipo);
    csProdutos.FieldByName('IMPORTADO').AsString:= Self.FListaProdutos.Item(vCont).Importado;
    csProdutos.FieldByName('QUANTIDADE').AsFloat:= Self.FListaProdutos.Item(vCont).Quantidade;
    csProdutos.FieldByName('UNIDADE').AsInteger:= TConversoes.UnidToInt(Self.FListaProdutos.Item(vCont).Unidade);
    csProdutos.FieldByName('PRECO').AsFloat:= Self.FListaProdutos.Item(vCont).Preco;
    csProdutos.Post;
  end;
end;

procedure TfrPrincipal.csProdutosIMPORTADOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
  begin
    Text:= '';
    Exit;
  end;

  case Sender.AsInteger of
    0: Text:= 'Não';
    1: Text:= 'Sim';
  else
    Text:= '';
  end;
end;

procedure TfrPrincipal.csProdutosTIPOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = '' then
  begin
    Text:= '';
    Exit;
  end;

  Text:= GetEnumName(TypeInfo(TTipo), Sender.AsInteger);
  Text:= Copy(Text, 3, length(Text));
end;

procedure TfrPrincipal.csProdutosUNIDADEGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
  begin
    Text:= '';
    Exit;
  end;

  Text:= GetEnumName(TypeInfo(TUnidade), Sender.AsInteger);
  Text:= Copy(Text, 3, length(Text));
end;

procedure TfrPrincipal.Salvar(var pForm: TfrEditorProduto);
begin
  if pForm.ModalResult = mrOk then
  begin
    if dmDados.SalvarProduto(pForm.Produto) then
    begin
      Self.FListaProdutos.Add(pForm.Produto);
      Self.CarregarCds;
    end;
  end;
end;

end.

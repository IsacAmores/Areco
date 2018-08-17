unit FREdicaoProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uProduto, Vcl.Buttons;

type
  TfrEditorProduto = class(TForm)
    grInformacoes: TGroupBox;
    lbCodigo: TLabel;
    lbDescricao: TLabel;
    lbTipo: TLabel;
    lbImportado: TLabel;
    cbTipo: TComboBox;
    cbImportado: TComboBox;
    edDescricao: TEdit;
    edCodigo: TEdit;
    btSalvar: TBitBtn;
    btCancelar: TBitBtn;
    lbUnidade: TLabel;
    cbUnidade: TComboBox;
    lbQtd: TLabel;
    edQtd: TEdit;
    lbPreco: TLabel;
    edPreco: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edQtdKeyPress(Sender: TObject; var Key: Char);
    procedure edPrecoExit(Sender: TObject);
  private
    FProduto: TProduto;

    function ValidarCampos: Boolean;
    procedure CarregarTipo(pCombo: TComboBox);
    procedure CarregarUnidade(pCombo: TComboBox);
  public
    property Produto: TProduto read FProduto write FProduto;
  end;

var
  frEditorProduto: TfrEditorProduto;

implementation

uses
  System.TypInfo, uConst, uDados;

{$R *.dfm}

procedure TfrEditorProduto.FormCreate(Sender: TObject);
begin
  Self.FProduto:= TProduto.Create;
  Self.CarregarTipo(cbTipo);
  Self.CarregarUnidade(cbUnidade);
end;

procedure TfrEditorProduto.FormShow(Sender: TObject);
begin
  if Self.FProduto.Codigo <> 0 then
  begin
    edCodigo.Text:= IntToStr(Self.FProduto.Codigo);
    edDescricao.Text:= Self.FProduto.Descricao;
    cbTipo.ItemIndex:= Integer(Self.FProduto.Tipo);
    cbImportado.ItemIndex:= StrToInt(Self.FProduto.Importado);
    cbUnidade.ItemIndex:= Integer(Self.FProduto.Unidade);
    edQtd.Text:= FloatToStr(Self.FProduto.Quantidade);
    edQtd.Text:= FormatFloat('#,0', StrToFloat(edQtd.Text));
    edPreco.Text:= FloatToStr(Self.FProduto.Preco);
    edPreco.Text:= FormatFloat('#,0.00', StrToFloat(edPreco.Text));
  end
  else
    edCodigo.Text:= IntToStr(dmDados.BuscarCodigo);
end;

procedure TfrEditorProduto.btSalvarClick(Sender: TObject);
begin
  if not Self.ValidarCampos then
    Exit;

  btSalvar.Enabled:= False;

  Self.Produto.Codigo:= StrToInt(Trim(edcodigo.Text));
  Self.Produto.Descricao:= Trim(edDescricao.Text);
  Self.Produto.Tipo:= TConversoes.IntToTipo(cbTipo.ItemIndex);
  Self.Produto.Importado:= IntToStr(cbimportado.ItemIndex) [1];
  Self.Produto.Quantidade:= StrToInt(Trim(StringReplace(edQtd.Text, '.', '', [rfReplaceAll])));
  Self.Produto.Unidade:= TConversoes.IntToUnid(cbUnidade.ItemIndex);
  Self.Produto.Preco:= StrToFloat(Trim(StringReplace(edPreco.Text, '.', '', [rfReplaceAll])));
end;

procedure TfrEditorProduto.btCancelarClick(Sender: TObject);
begin
  begin
    if MessageDlg('Tem certeza que deseja cancelar?', mtWarning, [mbYes, mbNo], 0, mbNo) = mrNo then
    begin
      Self.ModalResult:= mrNone;
    end;
  end;
end;

function TfrEditorProduto.ValidarCampos: Boolean;
begin
  Result:= True;
  if (Trim(edQtd.Text) = '') or (Trim(edDescricao.Text) = '') or
     (Trim(cbTipo.Text) = '') or (Trim(cbImportado.Text) = '') or
     (Trim(edPreco.Text) = '') or (Trim(cbUnidade.Text) = '') then
  begin
    MessageDlg('Há campos sem preencher. Por favor, revise o cadastro.', mtWarning, [mbOK], 0);
    Result:= False;
    Self.ModalResult:= mrNone;
  end;
end;

procedure TfrEditorProduto.CarregarTipo(pCombo: TComboBox);
var
  vCont: Integer;
  vTipo: String;
begin
  for vCont:= Ord(Low(TTipo)) to Ord(High(TTipo)) do
  begin
    vTipo:= GetEnumName(TypeInfo(TTipo), vCont);
    pCombo.Items.Add(Copy(vTipo, 3, length(vTipo)));
  end;
  pCombo.ItemIndex:= 0;
end;

procedure TfrEditorProduto.CarregarUnidade(pCombo: TComboBox);
var
  vCont: Integer;
  vUnid: String;
begin
  for vCont:= Ord(Low(TUnidade)) to Ord(High(TUnidade)) do
  begin
    vUnid:= GetEnumName(TypeInfo(TUnidade), vCont);
    pCombo.Items.Add(Copy(vUnid, 3, length(vUnid)));
  end;
  pCombo.ItemIndex:= 0;
end;

procedure TfrEditorProduto.edPrecoExit(Sender: TObject);
begin
  if Trim(edPreco.Text) <> '' then
  begin
    edPreco.Text:= FormatFloat('#,0.00', StrToFloat(edPreco.Text));
  end;
end;

procedure TfrEditorProduto.edQtdKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', ',', #8]) then
  begin
    Key:= #0;
  end;
end;

end.




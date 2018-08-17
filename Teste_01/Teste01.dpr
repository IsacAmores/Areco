program Teste01;

uses
  Vcl.Forms,
  FRProdutos in 'FRProdutos.pas' {frPrincipal},
  uProduto in 'uProduto.pas',
  uListaProdutos in 'uListaProdutos.pas',
  uDados in 'uDados.pas' {dmDados: TDataModule},
  FREdicaoProduto in 'FREdicaoProduto.pas' {frEditorProduto},
  uConst in 'uConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDados, dmDados);
  if not dmDados.db.Connected then
    Exit;
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.Run;
end.

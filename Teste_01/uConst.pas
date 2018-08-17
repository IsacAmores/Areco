unit uConst;

interface

type
  TTipo = (tpInsumo, tpPerecível, tpRevenda, tpEmbalagem, tpLimpeza);
  TUnidade = (tuG, tuMG, tuKG, tuUN, tuM, tuCM);

  TConversoes = class
    private
      function SetInt(const pTipo: TTipo): SmallInt; overload;
      function SetTipo(const pIndex: Integer): TTipo;
      function SetInt(const pUnid: TUnidade): SmallInt; overload;
      function SetUnid(const pIndex: Integer): TUnidade;
    public
     class function TipoToInt(const pTipo: TTipo): SmallInt;
     class function IntToTipo(const pIndex: Integer): TTipo;
     class function UnidToInt(const pUnid: TUnidade): SmallInt;
     class function IntToUnid(const pIndex: Integer): TUnidade;
  end;

implementation

uses
  System.SysUtils, System.TypInfo;

{ TConversoes }

class function TConversoes.TipoToInt(const pTipo: TTipo): SmallInt;
var
  vConvert: TConversoes;
begin
  try
    vConvert:= TConversoes.Create;
    Result:= vConvert.SetInt(pTipo);
  finally
    FreeAndNil(vConvert);
  end;
end;

function TConversoes.SetInt(const pTipo: TTipo): SmallInt;
begin
  Result:= Integer(pTipo);
end;

class function TConversoes.IntToTipo(const pIndex: Integer): TTipo;
var
  vConvert: TConversoes;
begin
  try
    vConvert:= TConversoes.Create;
    Result:= vConvert.SetTipo(pIndex);
  finally
    FreeAndNil(vConvert);
  end;
end;

function TConversoes.SetTipo(const pIndex: Integer): TTipo;
begin
  Result:= TTipo(pIndex);
end;

class function TConversoes.IntToUnid(const pIndex: Integer): TUnidade;
var
  vConvert: TConversoes;
begin
  try
    vConvert:= TConversoes.Create;
    Result:= vConvert.SetUnid(pIndex);
  finally
    FreeAndNil(vConvert);
  end;
end;

function TConversoes.SetUnid(const pIndex: Integer): TUnidade;
begin
  Result:= TUnidade(pIndex);
end;

class function TConversoes.UnidToInt(const pUnid: TUnidade): SmallInt;
var
  vConvert: TConversoes;
begin
  try
    vConvert:= TConversoes.Create;
    Result:= vConvert.SetInt(pUnid);
  finally
    FreeAndNil(vConvert);
  end;
end;

function TConversoes.SetInt(const pUnid: TUnidade): SmallInt;
begin
  Result:= Integer(pUnid);
end;

end.

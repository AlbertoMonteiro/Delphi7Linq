unit PowerStringList;

interface

uses
  Contnrs, Classes, PowerObjectList;

type
  TFunctionStringObject = function(obj: String): TObject of object;

  TPowerStringList = class(TStringList)
  public
    function Select(predicado: TFunctionStringObject): TPowerObjectList;
  end;

implementation

{ TPowerStringList }

function TPowerStringList.Select(predicado: TFunctionStringObject): TPowerObjectList;
var
  I: Integer;
begin
  Result := TPowerObjectList.Create;
  for I := 0 to Self.Count - 1 do
    Result.Add(predicado(Self[I]));
end;

end.

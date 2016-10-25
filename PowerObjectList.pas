unit PowerObjectList;

interface

uses
  Contnrs;

type
  TFunctionObjectBoolean = function(obj: TObject): Boolean of object;
  TFunctionObjectObject = function(obj: TObject): TObject of object;
  TFunctionObjectInteger = function(obj: TObject): Integer of object;

  TPowerObjectList = class(TObjectList)
  public
    function Where(predicado: TFunctionObjectBoolean): TPowerObjectList;
    function Select(predicado: TFunctionObjectObject): TPowerObjectList;
    function Sum(): Integer; overload;
    function Sum(predicado: TFunctionObjectInteger): Integer; overload;
    function Average(predicado: TFunctionObjectInteger): Integer;
  end;

implementation

{ TPowerObjectList }

function TPowerObjectList.Average(predicado: TFunctionObjectInteger): Integer;
begin
  Result := Trunc(Self.Sum(predicado) / Self.Count);
end;

function TPowerObjectList.Sum(): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Self.Count - 1 do
    Result := Result + Integer(Self.Items[I]);
end;

function TPowerObjectList.Select(predicado: TFunctionObjectObject): TPowerObjectList;
var
  I: Integer;
begin
  Result := TPowerObjectList.Create;
  for I := 0 to Self.Count - 1 do
    Result.Add(predicado(Self.Items[I]));
end;

function TPowerObjectList.Sum(predicado: TFunctionObjectInteger): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Self.Count - 1 do
    Result := Result + predicado(Self.Items[I]);
end;

function TPowerObjectList.Where(predicado: TFunctionObjectBoolean): TPowerObjectList;
var
  I: Integer;
begin
  Result := TPowerObjectList.Create;
  for I := 0 to Self.Count - 1 do
  begin
    if predicado(Self.Items[I]) then
      Result.Add(Self.Items[I]);
  end;
end;

end.

unit PowerObjectList;

interface

uses
  Contnrs, SysUtils, Math;

type
  TProcedureObject = procedure(obj: TObject) of object;
  TFunctionObjectBoolean = function(obj: TObject): Boolean of object;
  TFunctionObjectObject = function(obj: TObject): TObject of object;
  TFunctionObjectInteger = function(obj: TObject): Integer of object;

  TPowerObjectList = class(TObjectList)
  public
    function Skip(quantidade: Integer): TPowerObjectList;
    function Where(predicado: TFunctionObjectBoolean): TPowerObjectList;
    function Select(predicado: TFunctionObjectObject): TPowerObjectList;
    procedure ForEach(predicado: TProcedureObject);
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

procedure TPowerObjectList.ForEach(predicado: TProcedureObject);
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    predicado(Self.Items[I]);
end;

function TPowerObjectList.Select(predicado: TFunctionObjectObject): TPowerObjectList;
var
  I: Integer;
begin
  Result := TPowerObjectList.Create;
  for I := 0 to Self.Count - 1 do
    Result.Add(predicado(Self.Items[I]));
end;

function TPowerObjectList.Skip(quantidade: Integer): TPowerObjectList;
var
  I, de: Integer;
begin
  de := Min(quantidade, Self.Count - 1);
  Result := TPowerObjectList.Create;
  for I := de to Self.Count - 1 do
    Result.Add(Self.Items[I]);
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

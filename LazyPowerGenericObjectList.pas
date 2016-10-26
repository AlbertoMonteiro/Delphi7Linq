unit LazyPowerGenericObjectList;

interface

uses
  Contnrs, Classes, SysUtils, Math, PowerObjectList, ColletionManager;

type
  TLazyPowerGenericObjectList = class
  private
    FItemGetter: IColletionManager;
    FWherePredicate: TFunctionObjectBoolean;
    constructor Create(itemGetter: IColletionManager);
    function GetCount: Integer;
  public
    class function FromStringList(lista: TStringList): TLazyPowerGenericObjectList;
    class function FromObjectList(lista: TObjectList): TLazyPowerGenericObjectList;
    function Skip(quantidade: Integer): TLazyPowerGenericObjectList;
    function Where(predicado: TFunctionObjectBoolean): TLazyPowerGenericObjectList;
    function Select(predicado: TFunctionObjectObject): TLazyPowerGenericObjectList;
    procedure ForEach(action: TProcedureObject);
    function Sum: Integer; overload;
    function Sum(predicado: TFunctionObjectInteger): Integer; overload;
    function Average(predicado: TFunctionObjectInteger): Integer;
    procedure Add(obj: TObject);
    property Count: Integer read GetCount;
  end;

implementation

{ TPowerObjectList }

function TLazyPowerGenericObjectList.Average(predicado: TFunctionObjectInteger): Integer;
begin
  Result := Trunc(Self.Sum(predicado) / FItemGetter.GetCount);
end;

function TLazyPowerGenericObjectList.Sum: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FItemGetter.GetCount - 1 do
    Result := Result + Integer(FItemGetter.GetItem(i));
end;

procedure TLazyPowerGenericObjectList.ForEach(action: TProcedureObject);
var
  i: Integer;
  item: TObject;
begin
  for i := 0 to FItemGetter.GetCount - 1 do
  begin
    item := FItemGetter.GetItem(i);
    if FWherePredicate(item) then
      action(item);
  end;
end;

function TLazyPowerGenericObjectList.Select(predicado: TFunctionObjectObject): TLazyPowerGenericObjectList;
var
  i: Integer;
begin
  Result := TLazyPowerGenericObjectList.FromObjectList(TObjectList.Create);
  for i := 0 to FItemGetter.GetCount - 1 do
    Result.Add(predicado(FItemGetter.GetItem(i)));
end;

function TLazyPowerGenericObjectList.Skip(quantidade: Integer): TLazyPowerGenericObjectList;
var
  i, de: Integer;
begin
  de := Min(quantidade, FItemGetter.GetCount - 1);
  Result := TLazyPowerGenericObjectList.FromObjectList(TObjectList.Create);
  for i := de to FItemGetter.GetCount - 1 do
    Result.Add(FItemGetter.GetItem(i));
end;

function TLazyPowerGenericObjectList.Sum(predicado: TFunctionObjectInteger): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FItemGetter.GetCount - 1 do
    Result := Result + predicado(FItemGetter.GetItem(i));
end;

function TLazyPowerGenericObjectList.Where(predicado: TFunctionObjectBoolean): TLazyPowerGenericObjectList;
begin
  FWherePredicate := predicado;
  Result := Self;
end;

constructor TLazyPowerGenericObjectList.Create(itemGetter: IColletionManager);
begin
  Self.FItemGetter := itemGetter;
end;

class function TLazyPowerGenericObjectList.FromObjectList(lista: TObjectList): TLazyPowerGenericObjectList;
begin
  Result := TLazyPowerGenericObjectList.Create(TObjectListManager.Create(lista));
end;

class function TLazyPowerGenericObjectList.FromStringList(lista: TStringList): TLazyPowerGenericObjectList;
begin
  Result := TLazyPowerGenericObjectList.Create(TStringListManager.Create(lista));
end;

procedure TLazyPowerGenericObjectList.Add(obj: TObject);
begin
  FItemGetter.Add(obj);
end;

function TLazyPowerGenericObjectList.GetCount: Integer;
begin
  Result := FItemGetter.GetCount;
end;

end.

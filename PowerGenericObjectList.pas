unit PowerGenericObjectList;

interface

uses
  Contnrs, Classes, SysUtils, Math, PowerObjectList;

type
  IItemGetter = interface
    function GetItem(i: Integer): TObject;
    function GetCount(): Integer;
    procedure Add(obj: TObject);
  end;

  TStringListItemGetter = class(TInterfacedObject, IItemGetter)
  private
    FLista: TStringList;
  public
    function GetItem(i: Integer): TObject;
    function GetCount(): Integer;
    procedure Add(obj: TObject);
    constructor Create(lista: TStringList);
  end;

  TObjectListItemGetter = class(TInterfacedObject, IItemGetter)
  private
    FLista: TObjectList;
  public
    function GetItem(i: Integer): TObject;
    function GetCount(): Integer;
    procedure Add(obj: TObject);
    constructor Create(lista: TObjectList);
  end;

  TPowerGenericObjectList = class
  private
    FItemGetter: IItemGetter;
    constructor Create(itemGetter: IItemGetter);
    function GetCount: Integer;
  public
    class function FromStringList(lista: TStringList): TPowerGenericObjectList;
    class function FromObjectList(lista: TObjectList): TPowerGenericObjectList;
    function Skip(quantidade: Integer): TPowerGenericObjectList;
    function Where(predicado: TFunctionObjectBoolean): TPowerGenericObjectList;
    function Select(predicado: TFunctionObjectObject): TPowerGenericObjectList;
    procedure ForEach(predicado: TProcedureObject);
    function Sum: Integer; overload;
    function Sum(predicado: TFunctionObjectInteger): Integer; overload;
    function Average(predicado: TFunctionObjectInteger): Integer;
    procedure Add(obj: TObject);
    property Count: Integer read GetCount;
  end;

implementation

{ TPowerObjectList }

function TPowerGenericObjectList.Average(predicado: TFunctionObjectInteger): Integer;
begin
  Result := Trunc(Self.Sum(predicado) / FItemGetter.GetCount);
end;

function TPowerGenericObjectList.Sum: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FItemGetter.GetCount - 1 do
    Result := Result + Integer(FItemGetter.GetItem(I));
end;

procedure TPowerGenericObjectList.ForEach(predicado: TProcedureObject);
var
  I: Integer;
begin
  for I := 0 to FItemGetter.GetCount - 1 do
    predicado(FItemGetter.GetItem(I));
end;

function TPowerGenericObjectList.Select(predicado: TFunctionObjectObject): TPowerGenericObjectList;
var
  I: Integer;
begin
  Result := TPowerGenericObjectList.FromObjectList(TObjectList.Create);
  for I := 0 to FItemGetter.GetCount - 1 do
    Result.Add(predicado(FItemGetter.GetItem(I)));
end;

function TPowerGenericObjectList.Skip(quantidade: Integer): TPowerGenericObjectList;
var
  I, de: Integer;
begin
  de := Min(quantidade, FItemGetter.GetCount - 1);
  Result := TPowerGenericObjectList.FromObjectList(TObjectList.Create);
  for I := de to FItemGetter.GetCount - 1 do
    Result.Add(FItemGetter.GetItem(I));
end;

function TPowerGenericObjectList.Sum(predicado: TFunctionObjectInteger): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FItemGetter.GetCount - 1 do
    Result := Result + predicado(FItemGetter.GetItem(I));
end;

function TPowerGenericObjectList.Where(predicado: TFunctionObjectBoolean): TPowerGenericObjectList;
var
  I: Integer;
begin
  Result := TPowerGenericObjectList.FromObjectList(TObjectList.Create);
  for I := 0 to FItemGetter.GetCount - 1 do
  begin
    if predicado(FItemGetter.GetItem(I)) then
      Result.Add(FItemGetter.GetItem(I));
  end;
end;

constructor TPowerGenericObjectList.Create(itemGetter: IItemGetter);
begin
  Self.FItemGetter := itemGetter;
end;

{ TStringListItemGetter }

procedure TStringListItemGetter.Add(obj: TObject);
begin

end;

constructor TStringListItemGetter.Create(lista: TStringList);
begin
  Self.FLista := lista;
end;

function TStringListItemGetter.GetCount: Integer;
begin
  Result := FLista.Count;
end;

function TStringListItemGetter.GetItem(i: Integer): TObject;
begin
  Result := TObject(FLista[i]);
end;

{ TObjectListItemGetter }

procedure TObjectListItemGetter.Add(obj: TObject);
begin
  FLista.Add(obj);
end;

constructor TObjectListItemGetter.Create(lista: TObjectList);
begin
  FLista := lista;
end;

function TObjectListItemGetter.GetCount: Integer;
begin
  Result := FLista.Count;
end;

function TObjectListItemGetter.GetItem(i: Integer): TObject;
begin
  Result := FLista.Items[i];
end;

class function TPowerGenericObjectList.FromObjectList(lista: TObjectList): TPowerGenericObjectList;
begin
  Result := TPowerGenericObjectList.Create(TObjectListItemGetter.Create(lista));
end;

class function TPowerGenericObjectList.FromStringList(lista: TStringList): TPowerGenericObjectList;
begin
  Result := TPowerGenericObjectList.Create(TStringListItemGetter.Create(lista));
end;

procedure TPowerGenericObjectList.Add(obj: TObject);
begin
  FItemGetter.Add(obj);
end;

function TPowerGenericObjectList.GetCount: Integer;
begin
  Result := FItemGetter.GetCount;
end;

end.


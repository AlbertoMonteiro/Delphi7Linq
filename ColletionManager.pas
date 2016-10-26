unit ColletionManager;

interface

uses
  Contnrs, Classes, SysUtils, Math;

type
  IColletionManager = interface
    function GetItem(i: Integer): TObject;
    function GetCount(): Integer;
    procedure Add(obj: TObject);
  end;

  TStringListManager = class(TInterfacedObject, IColletionManager)
  private
    FLista: TStringList;
  public
    function GetItem(i: Integer): TObject;
    function GetCount(): Integer;
    procedure Add(obj: TObject);
    constructor Create(lista: TStringList);
  end;

  TObjectListManager = class(TInterfacedObject, IColletionManager)
  private
    FLista: TObjectList;
  public
    function GetItem(i: Integer): TObject;
    function GetCount(): Integer;
    procedure Add(obj: TObject);
    constructor Create(lista: TObjectList);
  end;

implementation

{ TStringListItemGetter }

procedure TStringListManager.Add(obj: TObject);
begin

end;

constructor TStringListManager.Create(lista: TStringList);
begin
  Self.FLista := lista;
end;

function TStringListManager.GetCount: Integer;
begin
  Result := FLista.Count;
end;

function TStringListManager.GetItem(i: Integer): TObject;
begin
  Result := TObject(FLista[i]);
end;

{ TObjectListItemGetter }

procedure TObjectListManager.Add(obj: TObject);
begin
  FLista.Add(obj);
end;

constructor TObjectListManager.Create(lista: TObjectList);
begin
  FLista := lista;
end;

function TObjectListManager.GetCount: Integer;
begin
  Result := FLista.Count;
end;

function TObjectListManager.GetItem(i: Integer): TObject;
begin
  Result := FLista.Items[i];
end;

end.

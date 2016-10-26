unit Unit1;

interface

uses
  SysUtils, Classes, PowerObjectList, PowerGenericObjectList, Contnrs,
  Forms, Dialogs, Controls, StdCtrls, LazyPowerGenericObjectList;

type
  TEstadoCivil = (Solteiro, Casado, Divorciado, Viuvo);

  TPessoa = class
  private
    FNome: string;
    FIdade: integer;
    FEstadoCivil: TEstadoCivil;
  public
    property Nome: string read FNome write FNome;
    property Idade: integer read FIdade write FIdade;
    property EstadoCivil: TEstadoCivil read FEstadoCivil write FEstadoCivil;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FPessoas: TLazyPowerGenericObjectList;
    function MaiorDeIdade(obj: TObject): Boolean;
    function MenorDeIdade(obj: TObject): Boolean;
    function IdadePessoa(obj: TObject): TObject;
    function IdadeDaPessoa(obj: TObject): integer;
    function ToPessoa(obj: TObject): TObject;
    procedure ExibeDadosPessoa(pessoa: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  PowerStringList;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //ShowMessage(Format('%d são maiores de idade', [FPessoas.Where(MaiorDeIdade).Count]));
  //ShowMessage(Format('As idades somadas é igual a: %d', [FPessoas.Where(MaiorDeIdade).Sum(IdadeDaPessoa)]));
  //ShowMessage(Format('As idades das pessoas menores de idade somadas é igual a: %d',
  //  [FPessoas.Where(MenorDeIdade).Select(IdadePessoa).Sum]));
  FPessoas.Where(MaiorDeIdade).ForEach(ExibeDadosPessoa);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  lista: TStringList;
begin
  lista := TStringList.Create;
  lista.LoadFromFile('..\..\pessoas.csv');
  FPessoas.FreeInstance;
  FPessoas := TLazyPowerGenericObjectList.FromStringList(lista).Select(ToPessoa);
  lista.FreeInstance;
end;

procedure TForm1.ExibeDadosPessoa(pessoa: TObject);
begin
  ShowMessage(Format('%s tem %d anos', [TPessoa(pessoa).Nome, TPessoa(pessoa).Idade]));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  pessoa: TPessoa;
begin
  FPessoas := TLazyPowerGenericObjectList.FromObjectList(TObjectList.Create);

  pessoa := TPessoa.Create;
  pessoa.Nome := 'Alberto';
  pessoa.Idade := 26;
  FPessoas.Add(pessoa);

  pessoa := TPessoa.Create;
  pessoa.Nome := 'Marília';
  pessoa.Idade := 26;
  FPessoas.Add(pessoa);

  pessoa := TPessoa.Create;
  pessoa.Nome := 'Araujo';
  pessoa.Idade := 10;
  FPessoas.Add(pessoa);
end;

function TForm1.IdadeDaPessoa(obj: TObject): integer;
begin
  Result := TPessoa(obj).Idade;
end;

function TForm1.IdadePessoa(obj: TObject): TObject;
begin
  Result := TObject(TPessoa(obj).Idade);
end;

function TForm1.MaiorDeIdade(obj: TObject): Boolean;
begin
  Result := TPessoa(obj).Idade >= 18;
end;

function TForm1.MenorDeIdade(obj: TObject): Boolean;
begin
  Result := TPessoa(obj).Idade < 18;
end;

function TForm1.ToPessoa(obj: TObject): TObject;
var
  pessoa: TPessoa;
  valores: TStringList;
begin
  valores:= nil;
  try
    valores := TStringList.Create;
    valores.Delimiter := ',';
    valores.DelimitedText := string(obj);
    pessoa := TPessoa.Create;
    pessoa.Nome := valores[0];
    pessoa.Idade := StrToInt(valores[1]);
    Result := pessoa;
  finally
    valores.FreeInstance;
  end;
end;

end.

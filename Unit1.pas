unit Unit1;

interface

uses
  System.SysUtils, System.Classes, PowerObjectList,
  Vcl.Forms, Vcl.Dialogs, Vcl.Controls, Vcl.StdCtrls;

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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FPessoas: TPowerObjectList;
    function MaiorDeIdade(obj: TObject): Boolean;
    function MenorDeIdade(obj: TObject): Boolean;
    function IdadePessoa(obj: TObject): TObject;
    function IdadeDaPessoa(obj: TObject): integer;
    procedure ExibeDadosPessoa(pessoa: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(Format('%d s�o maiores de idade', [FPessoas.Where(MaiorDeIdade).Count]));
  ShowMessage(Format('As idades somadas � igual a: %d', [FPessoas.Where(MaiorDeIdade).Sum(IdadeDaPessoa)]));
  ShowMessage(Format('As idades das pessoas menores de idade somadas � igual a: %d', [FPessoas.Where(MenorDeIdade).Select(IdadePessoa).Sum]));
  FPessoas.ForEach(ExibeDadosPessoa);
end;

procedure TForm1.ExibeDadosPessoa(pessoa: TObject);
begin
  ShowMessage(Format('%s tem %d anos', [TPessoa(pessoa).Nome, TPessoa(pessoa).Idade]));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  pessoa: TPessoa;
begin
  FPessoas := TPowerObjectList.Create;

  pessoa := TPessoa.Create;
  pessoa.Nome := 'Alberto';
  pessoa.Idade := 26;
  FPessoas.Add(pessoa);

  pessoa := TPessoa.Create;
  pessoa.Nome := 'Mar�lia';
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

end.

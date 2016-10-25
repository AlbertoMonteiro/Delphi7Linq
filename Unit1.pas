unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, PowerObjectList,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type

  TPessoa = class
  private
    FNome: string;
    FIdade: integer;
  public
    property Nome: string read FNome write FNome;
    property Idade: integer read FIdade write FIdade;
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
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(Format('%d são maiores de idade', [FPessoas.Where(MaiorDeIdade).Count]));
  ShowMessage(Format('As idades somadas é igual a: %d', [FPessoas.Where(MaiorDeIdade).Sum(IdadeDaPessoa)]));
  ShowMessage(Format('As idades das pessoas menores de idade somadas é igual a: %d',
    [FPessoas.Where(MenorDeIdade).Select(IdadePessoa).Sum]));
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

end.

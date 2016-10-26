program Project1;

uses
  Forms,
  PowerObjectList in 'PowerObjectList.pas',
  PowerStringList in 'PowerStringList.pas',
  Unit1 in 'Unit1.pas' {Form1},
  PowerGenericObjectList in 'PowerGenericObjectList.pas',
  LazyPowerGenericObjectList in 'LazyPowerGenericObjectList.pas',
  ColletionManager in 'ColletionManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program Extraktor;

uses
  Forms,
  Zeichen in '..\Units\Zeichen.pas',
  StringUnit in '..\Units\StringUnit.pas',
  Bibel in '..\Units\Bibel.pas',
  Language in '..\Units\Language.pas',
  Numbers in '..\Units\Numbers.pas',
  UnitExtraktor in 'UnitExtraktor.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

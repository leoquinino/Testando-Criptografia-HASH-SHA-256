unit Unit1;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Hash,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    labelCriaSenha: TLabel;
    EditCriaSenha: TEdit;
    ButtonCriptoCria: TButton;
    MemoCripto: TMemo;
    ButtonCriptoLogin: TButton;
    MemoCriptoLogin: TMemo;
    Button_CompararSenhas: TButton;
    labelDigitaSenhaLogin: TLabel;
    EditLoginSenha: TEdit;
    procedure ButtonCriptoCriaClick(Sender: TObject);
    procedure Button_CompararSenhasClick(Sender: TObject);
    procedure ButtonCriptoLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ButtonCriptoCriaClick(Sender: TObject);
begin
  MemoCripto.Lines.Clear;
  MemoCripto.Lines.Add(THashSHA2.GetHashString(EditCriaSenha.Text));
end;

procedure TForm1.ButtonCriptoLoginClick(Sender: TObject);
begin
  MemoCriptoLogin.Lines.Clear;
  MemoCriptoLogin.Lines.Add(THashSHA2.GetHashString(EditLoginSenha.Text));

end;

procedure TForm1.Button_CompararSenhasClick(Sender: TObject);
begin
  if MemoCripto.Text = MemoCriptoLogin.Text then
  begin
    ShowMessage('Senhas Válida, Seja Bem Vindo.')
  end else
  begin
    ShowMessage('Senha Inválida, Tente Novamente.');
  end;

end;

end.

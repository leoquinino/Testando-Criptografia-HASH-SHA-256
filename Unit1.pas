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
  FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Stan.StorageJSON, System.Rtti,
  FMX.Grid.Style, FMX.Grid, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope;

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
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery1: TFDQuery;
    EditUsuario: TEdit;
    ButtonRefresh: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    StringGrid1: TStringGrid;
    Column1: TColumn;
    Column2: TColumn;
    Column3: TColumn;
    Column4: TColumn;
    procedure ButtonCriptoCriaClick(Sender: TObject);
    procedure Button_CompararSenhasClick(Sender: TObject);
    procedure ButtonCriptoLoginClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
  private
    procedure LoadDataToStringGrid;
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
  MemoCripto.Lines.Add(THashSHA2.GetHashString(EditCriaSenha.Text+EditUsuario.Text));

  FDQuery1.Close;
  FDQuery1.Open;

  if FDQuery1.Locate('nome', EditUsuario.Text, []) then
  begin
     FDQuery1.Edit;
  end
  else
  begin
     FDQuery1.Insert;
     FDQuery1.FieldByName('nome').AsString := EditUsuario.Text;
  end;

  FDQuery1.FieldByName('senha').Value   :=  MemoCripto.Text;
  FDQuery1.Post;
end;

procedure TForm1.ButtonCriptoLoginClick(Sender: TObject);
begin
  MemoCriptoLogin.Lines.Clear;
  MemoCriptoLogin.Lines.Add(THashSHA2.GetHashString(EditLoginSenha.Text+EditUsuario.Text));

  FDQuery1.Close;
  FDQuery1.Open;
  if FDQuery1.Locate('nome', EditUsuario.Text, []) then
  begin
    if FDQuery1.FieldByName('senha').Value = MemoCriptoLogin.Text then
      ShowMessage('Usu�ro e Senha V�lidos, Seja Bem Vindo.')
    else
      ShowMessage('Usu�ro e Senha N�o Encontrado.');
  end;
end;

procedure TForm1.ButtonRefreshClick(Sender: TObject);
begin
  FDQuery1.Close;
  FDQuery1.Open;
  LoadDataToStringGrid;
end;

procedure TForm1.LoadDataToStringGrid;
var
  i: Integer;
begin
  // Limpar o conte�do atual do StringGrid
  StringGrid1.RowCount := 0;

  // Abrir o dataset
  FDQuery1.Open;
  try
    // Configurar o n�mero de linhas de acordo com os registros do dataset
    FDQuery1.First;
    StringGrid1.RowCount := FDQuery1.RecordCount;

    i := 0;
    while not FDQuery1.Eof do
    begin
      StringGrid1.Cells[0, i] := FDQuery1.FieldByName('id').AsString;
      StringGrid1.Cells[1, i] := FDQuery1.FieldByName('nome').AsString;
      StringGrid1.Cells[2, i] := FDQuery1.FieldByName('senha').AsString;
      StringGrid1.Cells[3, i] := FDQuery1.FieldByName('last_acesso').AsString;

      // Continue para cada coluna necess�ria

      Inc(i);
      FDQuery1.Next;
    end;
  finally
    FDQuery1.Close;
  end;
end;

procedure TForm1.Button_CompararSenhasClick(Sender: TObject);
begin
  if MemoCripto.Text = MemoCriptoLogin.Text then
  begin
    ShowMessage('Senhas V�lida, Seja Bem Vindo.')
  end else
  begin
    ShowMessage('Senha Inv�lida, Tente Novamente.');
  end;

end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  if StringGrid1.IsFocused then
  begin
    Handled := True;

    if WheelDelta > 0 then
    begin
      // para cima
      if StringGrid1.TopRow > 0 then
        StringGrid1.TopRow := StringGrid1.TopRow - 1;
    end
    else
    begin
      // para baixo
      if StringGrid1.TopRow < StringGrid1.RowCount - 1 then
        StringGrid1.TopRow := StringGrid1.TopRow + 1;
    end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LoadDataToStringGrid;
end;

end.

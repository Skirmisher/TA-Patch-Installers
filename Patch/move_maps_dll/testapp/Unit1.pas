unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowMoveMapsDialog(TAPath, MapsPath: PChar) :integer; cdecl; external 'move_maps.dll' name 'ShowMoveMapsDialog';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMoveMapsDialog(PChar(Edit1.Text), PChar(Edit2.Text));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    IniFile.WriteString('paths', 'tapath', Edit1.Text);
    IniFile.WriteString('paths', 'mapspath', Edit2.Text);
  finally
    IniFile.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Edit1.Text := IniFile.ReadString('paths', 'tapath', 'G:\CAVEDOG\TOTALA\');
    Edit2.Text := IniFile.ReadString('paths', 'mapspath', 'G:\CAVEDOG\TOTALA\CommonMaps\');
  finally
    IniFile.Free;
  end;
end;

end.

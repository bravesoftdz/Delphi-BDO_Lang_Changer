unit utMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FileCtrl, IniFiles, sevenzip;

type
  TfmMain = class(TForm)
    edPath1: TEdit;
    GroupBox1: TGroupBox;
    lblPath1: TLabel;
    btnSelect1: TButton;
    lblPath2: TLabel;
    edPath2: TEdit;
    btnSelect2: TButton;
    lblPath3: TLabel;
    edPath3: TEdit;
    btnSelect3: TButton;
    GroupBox2: TGroupBox;
    lblStatus: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    StatusBar1: TStatusBar;
    procedure btnSelect1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelect2Click(Sender: TObject);
  private
    { Private declarations }
  public
    gamePath, rusPath, originPath : string;
    gPCorrect, rPCorrect, oPCorrect: boolean;
  end;

var
  fmMain: TfmMain;

implementation

uses utFuncs;

{$R *.dfm}

procedure TfmMain.btnSelect1Click(Sender: TObject);
var
  dir: string;
begin
  if SelectDirectory('', '', dir) then
  begin
  	if DirectoryExists(dir) then
    begin
    	// TODO Сделать реальную проверку папки с игрой!
	    fmMain.gamePath:= dir;
      gpCorrect:= true;
    end
    else
      MessageBox(handle,PChar('Данный путь недоступен!'+#13#10), PChar('Ошибка'), 16);
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
	utFuncs.Init;
end;

procedure TfmMain.btnSelect2Click(Sender: TObject);
var
	openDlg: TOpenDialog;
begin
	openDlg:= TOpenDialog.Create(fmMain);
  openDlg.Filter:= 'Zip архив|*.zip';
  openDlg.Title:= 'Выберите архив с русификатором.';
  openDlg.Options:= openDlg.Options + [ofFileMustExist];
	openDlg.InitialDir:= ExtractFilePath(Application.ExeName);
  openDlg.Execute;
end;

end.


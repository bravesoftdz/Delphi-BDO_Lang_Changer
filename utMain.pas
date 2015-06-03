unit utMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FileCtrl, ExtCtrls;

type
  TfmMain = class(TForm)
    edPath1: TEdit;
    GroupBox1: TGroupBox;
    lblPath1: TLabel;
    btnSelect1: TButton;
    lblPath2: TLabel;
    edPath2: TEdit;
    btnSelect2: TButton;
    GroupBox2: TGroupBox;
    lblStatus: TLabel;
    btnCheckSts: TButton;
    Button2: TButton;
    Button3: TButton;
    StatusBar1: TStatusBar;
    gpInd: TPanel;
    rpInd: TPanel;
    Button4: TButton;
    procedure btnSelect1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelect2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCheckStsClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    gamePath, rusPath: string;
    gPCorrect, rPCorrect: boolean;
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
      fmMain.gamePath := dir;
      gpCorrect := true;
    end
    else
      MessageBox(handle, PChar('Данный путь недоступен!' + #13#10),
        PChar('Ошибка'), 16);
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  utFuncs.Init;
  utFuncs.LoadSettings;
end;

procedure TfmMain.btnSelect2Click(Sender: TObject);
var
  openDlg: TOpenDialog;
begin
  openDlg := TOpenDialog.Create(fmMain);
  openDlg.Filter := 'Zip архив|*.zip';
  openDlg.Title := 'Выберите архив с русификатором.';
  openDlg.Options := openDlg.Options + [ofFileMustExist];
  if (edPath2.Text <> '') and (DirectoryExists(ExtractFilePath(edPath2.Text)))
    then
  begin
    openDlg.InitialDir := ExtractFilePath(edPath2.Text);
  end
  else
  begin
    openDlg.InitialDir := ExtractFilePath(ParamStr(0));
  end;
  if openDlg.Execute then
  begin
    rusPath := openDlg.FileName;
    if not CheckRUS(rusPath) then
    begin
    	rPCorrect := false;
      rpInd.Color := clRed;
      MessageBox(handle, PChar('Неправильная структура русификатора!' + #13#10),
        PChar('Ошибка'), 16);
    end
    else
      edPath2.Text := rusPath;
      rPCorrect := true;
      rpInd.Color := clGreen;
  end;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
	utFuncs.SaveSettings;
end;

procedure TfmMain.btnCheckStsClick(Sender: TObject);
begin
	if CheckStatus then
  begin
  	lblStatus.Enabled := true;
    lblStatus.Caption := 'РУСИФИЦИРОВАН';
    lblStatus.Font.Color := RGB(0, 255, 0);
  end
  else
  begin
  	lblStatus.Enabled := true;
    lblStatus.Caption := 'ОРИГИНАЛЬНЫЙ';
    lblStatus.Font.Color := RGB(255, 128, 0);
  end;
end;

procedure TfmMain.Button4Click(Sender: TObject);
begin
	MessageBox(handle,PChar(infostr), PChar('Краткая справка.'), 64);
end;

end.


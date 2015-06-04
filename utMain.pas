unit utMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FileCtrl, ExtCtrls, DateUtils;

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
    btnRUS: TButton;
    btnRecover: TButton;
    StatusBar1: TStatusBar;
    gpInd: TPanel;
    rpInd: TPanel;
    Button4: TButton;
    cbAutoStatus: TCheckBox;
    procedure btnSelect1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelect2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCheckStsClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnRUSClick(Sender: TObject);
    procedure btnRecoverClick(Sender: TObject);
  private
    { Private declarations }
  public
    gamePath, rusPath: string;
    gPCorrect, rPCorrect: boolean;
    glStatus: integer;
  end;

resourcestring
  infostr = 'Black Desert Online Lang Changer v1.0' + #13#10 +
    'by SCRIBE. Kyiv. 2015. Гильдия - Nephilims Legacy (www.nlm.im), www.scribe-soft.at.ua' + #13#10
    +
    'Данная утилита предназначена для быстрой установки русификатора/восстановления для популярной игры Black Desert Online(Корея).' + #13#10
    +
    'Русификаторы можно скачать отсюда: ' + #13#10 +
    'Это не самостоятельная программа, она НЕ проверяет версию игры или русификатора и т.д.' + #13#10
    +
    'Вы сами выбиратете что устанавливать.' + #13#10 +
    'Была создана для удобства (не вручную распаковывать/копировать/хранить файлы).' + #13#10
    + #13#10 +
    'Технические подробности:' + #13#10 +
    '1. Оригинальные файлы игры находяться в папке с самой программой (patch/dd-mm-yyyy--random).' + #13#10
    +
    '2. Последний использованный русификатор(распакованный) тут (temp/)' + #13#10
    +
    '3. ОБЯЗАТЕЛЬНО. Первый раз запускать для НЕ русифицированной игры(чтобы программа скопировала оригинальные файлы)' + #13#10
    +
    '4. Заточена под структуру архива русификатора, если что либо поменяеться, она просто не сработает. Тогда ко мне=)' + #13#10
    +
    'Приятного использования! Aх да, на свой страх и риск=)';

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
    dir := dir + '\';
    if FileExists(dir + 'Blackdesert_launcher.exe') then
    begin
      // TODO Сделать реальную проверку папки с игрой!
      fmMain.gamePath := dir;
      fmMain.edPath1.Text := fmMain.gamePath;
      gpCorrect := true;
    end
    else
    begin
      gpCorrect := false;
      MessageBox(handle, PChar('Это не папка с игрой Black Desert Online!' +
        #13#10),
        PChar('Ошибка'), 16);
    end;
  end;
  ShowCheck;
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
      rpInd.Color := RGB(255, 0, 0);
      MessageBox(handle, PChar('Неправильная структура русификатора!' + #13#10),
        PChar('Ошибка'), 16);
    end
    else
    begin
      edPath2.Text := rusPath;
      rPCorrect := true;
      rpInd.Color := RGB(0, 255, 0);
    end;
  end;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  utFuncs.SaveSettings;
end;

procedure TfmMain.btnCheckStsClick(Sender: TObject);
var
  otv: integer;
begin
  otv := CheckStatus;
  if otv = 1 then
  begin
    lblStatus.Enabled := true;
    lblStatus.Caption := 'РУСИФИЦИРОВАН';
    lblStatus.Font.Color := RGB(0, 255, 0);
    glStatus := 1;
  end
  else if otv = 0 then
  begin
    lblStatus.Enabled := true;
    lblStatus.Caption := 'ОРИГИНАЛЬНЫЙ';
    lblStatus.Font.Color := RGB(255, 128, 0);
    glStatus := 0;
  end
  else if otv = 3 then
  begin
    lblStatus.Enabled := false;
    lblStatus.Caption := '--//--';
    glStatus := 0;
    StatusBar1.Panels[0].Text := '* исходные файлы игры повреждены';
  end;
end;

procedure TfmMain.Button4Click(Sender: TObject);
begin
  MessageBox(handle, PChar(infostr), PChar('Краткая справка.'), 64);
end;

procedure TfmMain.btnRUSClick(Sender: TObject);
begin
	Screen.Cursor := crHourGlass;
  if glStatus = 0 then
  begin
    if CopyOrigin then
      if DeleteOrigin then
        if UnPackRUS then
          if CopyRUS then
          begin
            lblStatus.Caption := 'РУСИФИЦИРОВАН';
            lblStatus.Font.Color := RGB(0, 255, 0);
            glStatus := 1;
            StatusBar1.Panels[0].Text := 'Успешно русифицированно!';
          end;
  end
  else if glStatus = 1 then
  begin
    MessageBox(handle, PChar('Игра уже русифицированна!' + #13#10 +
      'Для повторной/новой русификации восстановите игру.'), PChar('Ошибка'),
        48);
  end
  else
    MessageBox(handle, PChar('Сначала проверьте статус русицикации!' + #13#10),
      PChar('Ошибка'), 16);
  Screen.Cursor := crDefault;
end;

procedure TfmMain.btnRecoverClick(Sender: TObject);
begin
  if RecoverOrigin then
  begin
    btnCheckSts.Click;
  end
  else
  begin
    lblStatus.Enabled := true;
    lblStatus.Caption := 'GAME OVER =)';
    lblStatus.Font.Color := RGB(255, 0, 0);
  end;
end;

end.


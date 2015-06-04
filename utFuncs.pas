unit utFuncs;

interface

uses utMain, sevenzlib, Dialogs, SysUtils, Classes, Windows, IniFiles,
  DateUtils, ShellAPI;

procedure Init;
procedure LoadSettings;
procedure SaveSettings;
function CheckRUS(const ruspath: string): boolean;
function RemoveDirEx(sDir: string): Boolean;
function CheckStatus: integer;
procedure ShowCheck;
function CopyOrigin: boolean;
function DeleteOrigin: boolean;
function UnPackRUS: boolean;
function CopyRUS: boolean;
function RecoverOrigin: boolean;
function GetNewestDir(const path: string): string;
function DeleteDirdEx(const path: string): boolean;

const
  gameFiles: array[0..2] of string = ('\paz\PAD00001.PAZ', '\paz\pad00000.meta',
    '\service.ini');

implementation

// Инициализация

procedure Init;
begin
  utMain.fmMain.gPCorrect := false;
  utMain.fmMain.rPCorrect := false;
  utMain.fmMain.gpInd.Color := RGB(255, 0, 0);
  utMain.fmMain.rpInd.Color := RGB(255, 0, 0);
  utMain.fmMain.glStatus := 2;
end;

// Проверка путей

procedure CheckPaths;
begin
  if FileExists(utMain.fmMain.gamePath + 'Blackdesert_launcher.exe') then
    utMain.fmMain.gPCorrect := true
  else
    utMain.fmMain.gPCorrect := false;
  if CheckRUS(utMain.fmMain.rusPath) then
    utMain.fmMain.rPCorrect := true
  else
    utMain.fmMain.rPCorrect := false;
end;

// Отображение результатов проверки

procedure ShowCheck;
begin
  // GamePath
  if utMain.fmMain.gPCorrect then
    utMain.fmMain.gpInd.Color := RGB(0, 255, 0)
  else
    utMain.fmMain.gpInd.Color := RGB(255, 0, 0);
  // RusPath
  if utMain.fmMain.rPCorrect then
    utMain.fmMain.rpInd.Color := RGB(0, 255, 0)
  else
    utMain.fmMain.rpInd.Color := RGB(255, 0, 0);
end;

// Загрузка настроек

procedure LoadSettings;
var
  settfile: TIniFile;
begin
  settfile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  try
    utMain.fmMain.gamePath := settfile.ReadString('Path', 'GamePath',
      'D:\Games\Black Desert');
    utMain.fmMain.edPath1.Text := utMain.fmMain.gamePath;
    utMain.fmMain.rusPath := settfile.ReadString('Path', 'RusPath',
      'D:\My Files\BDORUS-master.zip');
    utMain.fmMain.edPath2.Text := utMain.fmMain.rusPath;
    CheckPaths;
    ShowCheck;
    utMain.fmMain.cbAutoStatus.Checked := settfile.ReadBool('Program',
      'AutoCheckStatus', true);
    if utMain.fmMain.cbAutoStatus.Checked then
      utMain.fmMain.btnCheckSts.Click;
  finally
    settfile.Free;
  end;
end;

// Сохранение настроек

procedure SaveSettings;
var
  settfile: TIniFile;
begin
  settfile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  try
    if utMain.fmMain.gPCorrect then
      settfile.WriteString('Path', 'GamePath', utMain.fmMain.gamePath);
    if utMain.fmMain.rPCorrect then
      settfile.WriteString('Path', 'RusPath', utMain.fmMain.rusPath);
    settfile.WriteBool('Program', 'AutoCheckStatus',
      utMain.fmMain.cbAutoStatus.Checked);
  finally
    settfile.Free;
  end;
end;

// Проверка файла русификации на структуру

function CheckRUS(const ruspath: string): boolean;
var
  i, n: integer;
begin
  result := false;
  n := 0;
  if not FileExists(ruspath) then
    Exit;
  try
    with CreateInArchive(CLSID_CFormatZip) do
    begin
      OpenFile(ruspath);
      for i := 0 to NumberOfItems - 1 do
      begin
        if ItemIsFolder[i] then
        begin
          if (pos('prestringtable\kr', ItemPath[i]) > 1) then
            n := n + 1
          else if (pos('prestringtable', ItemPath[i]) > 1) then
            n := n + 1
          else if (pos('paz', ItemPath[i]) > 1) then
            n := n + 1;
        end;
      end;
      if n = 3 then
        Result := true;
    end;
  except
    MessageBox(utMain.fmMain.Handle, PChar('Ошибка при обращении к архиву!' +
      #13#10),
      PChar('Ошибка'), 16);
  end;
end;

function RemoveDirEx(sDir: string): Boolean;
var
  iIndex: Integer;
  SearchRec: TSearchRec;
  sFileName: string;
begin
  Result := False;
  sDir := sDir + '\*.*';
  iIndex := FindFirst(sDir, faAnyFile, SearchRec);
  while iIndex = 0 do
  begin
    sFileName := ExtractFileDir(sDir) + '\' + SearchRec.Name;
    if SearchRec.Attr = faDirectory then
    begin
      if (SearchRec.Name <> '') and (SearchRec.Name <> '.') and (SearchRec.Name
        <> '..') then
        RemoveDirEx(sFileName);
    end
    else
    begin
      if SearchRec.Attr <> faArchive then
        FileSetAttr(sFileName, faArchive);
      if not DeleteFile(PChar(sFileName)) then
        ShowMessage('Could NOT delete ' + sFileName);
    end;
    iIndex := FindNext(SearchRec);
  end;
  FindClose(SearchRec.FindHandle);
  RemoveDir(ExtractFileDir(sDir));
  Result := True;
end;

function DeleteDirdEx(const path: string): boolean;
var
  lpFileOp: TSHFileOpStruct;
begin
  Result := false;
  FillChar(lpFileOp, SizeOf(lpFileOp), 0);
  lpFileOp.Wnd := utMain.fmMain.Handle;
  lpFileOp.wFunc := FO_DELETE;
  lpFileOp.pFrom := PChar(path);
  lpFileOp.fFlags := FOF_NOCONFIRMATION;
  if SHFileOperation(lpFileOp) = 0 then
    Result := true;
end;

// Проверка статуса русификации

function CheckStatus: integer;
begin
  Result := 2;
  if utMain.fmMain.gPCorrect then
  begin
    if utMain.fmMain.gamePath[length(utMain.fmMain.gamePath)] <> '\' then
      utMain.fmMain.gamePath := utMain.fmMain.gamePath + '\';
    if not FileExists(utMain.fmMain.gamePath + 'paz\pad00000.meta.bak') or
      not DirectoryExists(utMain.fmMain.gamePath + 'prestringtable\kr') then
    begin
      Result := 0;
    end
    else if not FileExists(utMain.fmMain.gamePath + 'paz\pad00000.meta') then
    begin
      Result := 3;
    end
    else
    begin
      Result := 1;
    end;
  end
  else
  begin
    MessageBox(utMain.fmMain.Handle,
      PChar('Сначала укажите корректную папку с игрой!' + #13#10),
      PChar('Ошибка'), 16);
  end;
end;

function CopyDir(fromDir, toDir: string): boolean;
var
  fos: TSHFileOpStruct;
  todir2: string;
begin
  todir2 := todir;
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc := FO_COPY;
    //fFlags := FOF_FILESONLY;
    fFlags := FOF_SIMPLEPROGRESS;
    fflags := fflags or FOF_NOCONFIRMATION;
    fflags := fflags or FOF_SILENT;
    pFrom := PChar(fromDir + #0);
    pTo := PChar(toDir2);
  end;
  Result := (0 = ShFileOperation(fos));
end;

function CopyOrigin: boolean;
var
  rstr: string[5];
  path: string;
label
  onemore;
begin
  Result := false;
  if utMain.fmMain.gPCorrect then
  begin
    Randomize;
    onemore:
    rstr := inttostr(Random(9)) + inttostr(Random(9)) + inttostr(Random(9)) +
      inttostr(Random(9)) + inttostr(Random(9));
    path := ExtractFilePath(ParamStr(0)) + 'patch\' + inttostr(DayOf(Date)) +
      '-' + inttostr(MonthOf(Date)) + '-' + inttostr(YearOf(Date)) + '-' + rstr;
    if not DirectoryExists(path) then
    begin
      if not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'patch') then
        CreateDir(ExtractFilePath(ParamStr(0)) + 'patch');
      if CreateDir(path) then
      begin
        CreateDir(path + '\paz');
        if CopyFile(PChar(utMain.fmMain.gamePath + 'paz\PAD00001.PAZ'),
          PChar(path + '\paz\PAD00001.PAZ'), false) and
          CopyFile(PChar(utMain.fmMain.gamePath + 'paz\pad00000.meta'),
          PChar(path + '\paz\pad00000.meta'), false) and
          CopyFile(PChar(utMain.fmMain.gamePath + 'service.ini'), PChar(path +
          '\service.ini'), false) then
        begin
          Result := true;
          utMain.fmMain.StatusBar1.Panels[0].Text :=
            'Исходные файлы успешно скопировано!';
        end
        else
        begin
          Result := false;
          MessageBox(utMain.fmMain.Handle,
            PChar('Не удалось скопировать исходные файлы игры!' +
            #13#10 +
            'Проверьте права доступа к папке с игрой, или запустите программу от имени администратора.'),
            PChar('Ошибка'), 16);
        end;
      end
      else
      begin
        Result := false;
        MessageBox(utMain.fmMain.Handle, PChar('Невозможно создать каталог!' +
          #13#10), PChar('Ошибка'), 48);
      end;
    end
    else
      goto onemore;
  end;
end;

function DeleteOrigin: boolean;
begin
  Result := false;
  if SysUtils.DeleteFile(PChar(utMain.fmMain.gamePath + 'paz\PAD00001.PAZ')) and
    SysUtils.DeleteFile(PChar(utMain.fmMain.gamePath + 'paz\pad00000.meta')) and
    SysUtils.DeleteFile(PChar(utMain.fmMain.gamePath + 'service.ini')) then
  begin
    Result := true;
    utMain.fmMain.StatusBar1.Panels[0].Text :=
      '* исходные файлы успешно удалено.';
  end
  else
  begin
    Result := false;
    MessageBox(utMain.fmMain.Handle, PChar('Невозможно удалить файлы!' +
      #13#10), PChar('Ошибка'), 16);
  end;
end;

function UnPackRUS: boolean;
var
  i: integer;
  stream: TFileStream;
begin
  Result := false;
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + '\temp') then
    CreateDir(ExtractFilePath(ParamStr(0)) + '\temp');
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + '\temp\paz') then
    CreateDir(ExtractFilePath(ParamStr(0)) + '\temp\paz');
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + '\temp\prestringtable')
    then
    CreateDir(ExtractFilePath(ParamStr(0)) + '\temp\prestringtable');
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) +
    '\temp\prestringtable\kr') then
    CreateDir(ExtractFilePath(ParamStr(0)) + '\temp\prestringtable\kr');
  if not FileExists(utMain.fmMain.rusPath) then
    Exit;
  try
    with CreateInArchive(CLSID_CFormatZip) do
    begin
      OpenFile(utMain.fmMain.rusPath);
      for i := 0 to NumberOfItems - 1 do
      begin
        if not ItemIsFolder[i] then
        begin
          if (pos('prestringtable\kr', ItemPath[i]) > 1) then
          begin
            stream := TFileStream.Create(ExtractFilePath(ParamStr(0)) +
              '\temp\prestringtable\kr\' + ExtractFileName(ItemPath[i]),
              fmCreate);
            try
              ExtractItem(i, stream, false);
            finally
              stream.Free;
            end;
          end
          else if pos('paz', ItemPath[i]) > 1 then
          begin
            stream := TFileStream.Create(ExtractFilePath(ParamStr(0)) +
              '\temp\paz\' + ExtractFileName(ItemPath[i]), fmCreate);
            try
              ExtractItem(i, stream, false);
            finally
              stream.Free;
            end;
          end
          else if pos('service.ini', ItemPath[i]) > 1 then
          begin
            stream := TFileStream.Create(ExtractFilePath(ParamStr(0)) +
              '\temp\' + ExtractFileName(ItemPath[i]), fmCreate);
            try
              ExtractItem(i, stream, false);
            finally
              stream.Free;
            end;
          end
        end;
      end;
      if FileExists(ExtractFilePath(ParamStr(0)) + '\temp\paz\pad00000.meta.bak')
        and
        FileExists(ExtractFilePath(ParamStr(0)) + '\temp\service.ini') then
      begin
        Result := true;
      end
      else
      begin
        MessageBox(utMain.fmMain.Handle,
          PChar('Некорректная розархивация, или структура архива поменялась!' +
          #13#10 +
          'Обратитесь к автору для исправления возможной ошибки.' +
          #13#10),
          PChar('Ошибка'), 16);
      end;
    end;
  except
    MessageBox(utMain.fmMain.Handle, PChar('Ошибка при обращении к архиву!' +
      #13#10),
      PChar('Ошибка'), 16);
  end;
end;

function CopyRUS: boolean;
begin
  Result := false;
  if CreateDir(utMain.fmMain.gamePath + 'prestringtable') and
    CreateDir(utMain.fmMain.gamePath + 'prestringtable\kr') then
  begin
    if CopyDir(ExtractFilePath(ParamStr(0)) + '\temp\paz\pa*.*',
      utMain.fmMain.gamePath + 'paz\') and
      CopyDir(ExtractFilePath(ParamStr(0)) + '\temp\prestringtable\kr\*.*',
      utMain.fmMain.gamePath + 'prestringtable\kr\') and
      CopyFile(PChar(ExtractFilePath(ParamStr(0)) + '\temp\service.ini'),
      PChar(utMain.fmMain.gamePath + 'service.ini'), true) then
    begin
      Result := true;
      utMain.fmMain.StatusBar1.Panels[0].Text :=
        '* файлы русификатора успешно скопированно в папку с игрой.';
    end
    else
    begin
      MessageBox(utMain.fmMain.Handle,
        PChar('Не удалось скопировать файлы русификатора, будет произведена попытка восстановления исходных файлов.'
        +
        #13#10),
        PChar('Ошибка'), 16);
      if not RecoverOrigin then
      begin
        MessageBox(utMain.fmMain.Handle,
          PChar('Восстановить исходные файлы не удалось.' + #13#10 +
          'Не расстраивайтесь, вы можете сделать это вручную.' + #13#10 +
          'В папке с программой (\patch\dd-mm-yyyy-randomValue), выберите последнюю созданную папку,' + #13#10
          +
          'это и есть исходные файлы, скопируйте их вручную в папку с игрой.' + #13#10
          +
          'Чтобы данная ошибка не повторялась, запускайте программу от имени администратора, или настройте соответствующие права.' + #13#10
          +
          #13#10),
          PChar('Ошибка'), 16);
      end
      else
      begin
        utMain.fmMain.StatusBar1.Panels[0].Text :=
          '* исходные файлы успешно восстановлено.';
      end;
    end;
  end
  else
  begin
    MessageBox(utMain.fmMain.Handle,
      PChar('Не удалось создать директории в папке с игрой.' + #13#10 +
      'Проверьте ваши права доступа к папке!' + #13#10 +
      'Будет произведена попытка восстановления исходных файлов.'
      +
      #13#10),
      PChar('Ошибка'), 16);
    if not RecoverOrigin then
    begin
      MessageBox(utMain.fmMain.Handle,
        PChar('Восстановить исходные файлы не удалось.' + #13#10 +
        'Не расстраивайтесь, вы можете сделать это вручную.' + #13#10 +
        'В папке с программой (\patch\dd-mm-yyyy-randomValue), выберите последнюю созданную папку,' + #13#10
        +
        'это и есть исходные файлы, скопируйте их вручную в папку с игрой.' + #13#10
        +
        'Чтобы данная ошибка не повторялась, запускайте программу от имени администратора, или настройте соответствующие права.' + #13#10
        +
        #13#10),
        PChar('Ошибка'), 16);
    end
    else
    begin
      utMain.fmMain.StatusBar1.Panels[0].Text :=
        '* исходные файлы успешно восстановлено.';
    end;
  end;
end;

function GetDirTime(const Dir: string): TDateTime;
var
  H: Integer;
  F: TFileTime;
  S: TSystemTime;
begin
  H := CreateFile(PChar(Dir), $0080, 0, nil, OPEN_EXISTING,
    FILE_FLAG_BACKUP_SEMANTICS, 0);
  if H <> -1 then
  begin
    GetFileTime(H, @F, nil, nil);
    FileTimeToLocalFileTime(F, F);
    FileTimeToSystemTime(F, S);
    Result := SystemTimeToDateTime(S);
    CloseHandle(H);
  end
  else
    Result := -1;
end;

function RecoverOrigin: boolean;
var
  patchDir, patchDirName: string;
begin
  Result := false;
  CheckPaths;
  ShowCheck;
  if utMain.fmMain.gPCorrect then
  begin
    // Удаление русификатора
    if FileExists(utMain.fmMain.gamePath + 'paz\PAD00001.PAZ') then
      if not SysUtils.DeleteFile(utMain.fmMain.gamePath + 'paz\PAD00001.PAZ')
        then
        utMain.fmMain.StatusBar1.Panels[0].Text :=
          '* ошибка удаления файла PAD00001.PAZ';
    if FileExists(utMain.fmMain.gamePath + 'paz\PAD00001.PAZ.bak') then
      if not SysUtils.DeleteFile(utMain.fmMain.gamePath + 'paz\PAD00001.PAZ.bak')
        then
        utMain.fmMain.StatusBar1.Panels[0].Text :=
          '* ошибка удаления файла PAD00001.PAZ.bak';
    if FileExists(utMain.fmMain.gamePath + 'paz\pad00000.meta') then
      if not SysUtils.DeleteFile(utMain.fmMain.gamePath + 'paz\pad00000.meta')
        then
        utMain.fmMain.StatusBar1.Panels[0].Text :=
          '* ошибка удаления файла pad00000.meta';
    if FileExists(utMain.fmMain.gamePath + 'paz\pad00000.meta.bak') then
      if not SysUtils.DeleteFile(utMain.fmMain.gamePath +
        'paz\pad00000.meta.bak') then
        utMain.fmMain.StatusBar1.Panels[0].Text :=
          '* ошибка удаления файла pad00000.meta.bak';
    if FileExists(utMain.fmMain.gamePath + 'service.ini') then
      if not SysUtils.DeleteFile(utMain.fmMain.gamePath + 'service.ini') then
        utMain.fmMain.StatusBar1.Panels[0].Text :=
          '* ошибка удаления файла service.ini';
    if DirectoryExists(utMain.fmMain.gamePath + 'prestringtable') then
      if not DeleteDirdEx(utMain.fmMain.gamePath + 'prestringtable') then
        utMain.fmMain.StatusBar1.Panels[0].Text :=
          '* ошибка удаления папки prestringtable';

    // Копирование исходных файлов
    patchDirName := GetNewestDir(ExtractFilePath(ParamStr(0)) + '\patch\');
    patchDir := ExtractFilePath(ParamStr(0)) + '\patch\' + patchDirName;
    //ShowMessage(patchDir);
    if DirectoryExists(patchDir) then
    begin
      if FileExists(patchDir + '\paz\PAD00001.PAZ') and
        FileExists(patchDir + '\paz\pad00000.meta') and
        FileExists(patchDir + '\service.ini') then
      begin
        if CopyFile(PChar(patchDir + '\paz\PAD00001.PAZ'),
          PChar(utMain.fmMain.gamePath + 'paz\PAD00001.PAZ'), false) and
          CopyFile(PChar(patchDir + '\paz\pad00000.meta'),
          PChar(utMain.fmMain.gamePath + 'paz\pad00000.meta'), false) and
          CopyFile(PChar(patchDir + '\service.ini'), PChar(utMain.fmMain.gamePath
          + 'service.ini'), false) then
        begin
          Result := true;
        end
        else
        begin
          MessageBox(utMain.fmMain.Handle,
            PChar('Не удалось скопировать исходные файлы. У вас нет прав, или еще что-то...'
            + #13#10),
            PChar('Ошибка'), 16);
        end;
      end
      else
      begin
        MessageBox(utMain.fmMain.Handle,
          PChar('Последняя созданная папка с исходными файлами пуста или в ней нехватает некоторых файлов!'
          + #13#10 +
          'Удалите эту папку, если она была создана ваши вручную, или паникуйте! =)' +
          #13#10), PChar('Ошибка'), 16);
      end;
    end
    else
    begin
      MessageBox(utMain.fmMain.Handle,
        PChar('Не удалось найти папку с исходными файлами!' + #13#10 +
        'Все очень плохо=)' + #13#10), PChar('Ошибка'), 16);
    end;
  end
  else
  begin
    MessageBox(utMain.fmMain.Handle,
      PChar('Восстановить можно только русифицированную версию игры!' +
      #13#10),
      PChar('Ошибка'), 16);
  end;
end;

function GetNewestDir(const path: string): string;
var
  sr: TSearchRec;
  lastDir, currDir: string;
  lastTime, currTime: TDateTime;
begin
  Result := '';
  if FindFirst(Path + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Attr and faDirectory) <> 0 then // если найденный файл - папка
      begin
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          currDir := sr.Name;
          currTime := GetDirTime(path + currDir);
          if currTime > lastTime then
          begin
            lastTime := currTime;
            lastDir := currDir;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
  end;
  FindClose(sr.FindHandle);
  Result := lastDir;
end;

end.


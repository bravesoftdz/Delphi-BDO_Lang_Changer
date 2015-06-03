unit utFuncs;

interface

uses utMain, sevenzlib, Dialogs, SysUtils, Classes;

procedure Init;
function CheckRUS(const ruspath: string): boolean;

var
  gameFiles: array[0..2] of string = ('\paz\PAD00001.PAZ', '\paz\pad00000.meta',
    '\service.ini');

implementation

// Инициализация

procedure Init;
begin
  utMain.fmMain.gPCorrect := false;
  utMain.fmMain.rPCorrect := false;
  utMain.fmMain.oPCorrect := false;
end;

// Проверка файла русификации на структуру

function CheckRUS(const ruspath: string): boolean;
var
  outer: string;
  i: integer;
  stream: TFileStream;
begin
  result := false;
  try
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + '\temp') then
    	CreateDir(ExtractFilePath(ParamStr(0)) + '\temp');
  stream := TFileStream.Create(ExtractFilePath(ParamStr(0)) + '\temp\file.paz' ,fmCreate);
  try

    with CreateInArchive(CLSID_CFormatZip) do
    begin
      OpenFile(ruspath);
      for i := 0 to NumberOfItems - 1 do
      begin
      	if not ItemIsFolder[i] then
        begin
        	if (pos('prestringtable\kr', ItemPath[i]) > 1) then
          begin
          	outer := outer + #13#10 + ItemPath[i];
            ExtractFileName(ItemPath[i]);
          	//ExtractItem(i, stream, false);
          end
          //else if
        end;
        {if ItemIsFolder[i] then
        begin
          if (pos('prestringtable\kr', ItemPath[i]) > 1) then begin
            outer := outer + #13#10 + ItemPath[i];
            //ExtractItem(i, stream, false);
          end
          else if (pos('prestringtable', ItemPath[i]) > 1) then
            outer := outer + #13#10 + ItemPath[i]
          else if (pos('paz', ItemPath[i]) > 1) then
            outer := outer + #13#10 + ItemPath[i];
        end;}
      end;
    end;
  except

  end;
  finally
  	stream.Free;
  end;
  ShowMessage(outer);
end;

end.


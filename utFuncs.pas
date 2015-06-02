unit utFuncs;

interface

uses utMain;

procedure Init;

implementation


// Инициализация
procedure Init;
begin
	utMain.fmMain.gPCorrect:= false;
  utMain.fmMain.rPCorrect:= false;
  utMain.fmMain.oPCorrect:= false;
end;

end.

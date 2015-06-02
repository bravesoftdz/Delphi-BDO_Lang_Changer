unit utMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FileCtrl, IniFiles;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnSelect1Click(Sender: TObject);
var
  dir: string;
begin
	if SelectDirectory('', '', dir)
  then ShowMessage('Выбранный каталог = '+dir)
  else ShowMessage('Выбор каталога прервался');
end;

end.

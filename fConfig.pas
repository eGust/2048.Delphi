unit fConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fMain;

type
  TfrmConfig = class(TForm)
    txtUp: TEdit;
    txtDown: TEdit;
    txtLeft: TEdit;
    txtRight: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnYes: TButton;
    btnNo: TButton;
    procedure Keys_onKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
  private
    FActCfg	: TActionConfig;
  public
    procedure ConfigAction;
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

var
	KeysName	: array[0..127]of string;

procedure SetupKeyNames;
var
	i	: Integer;
begin
	KeysName[VK_LEFT]		:= 'Left';
	KeysName[VK_RIGHT]	:= 'Right';
	KeysName[VK_UP]			:= 'Up';
	KeysName[VK_DOWN]		:= 'Down';
	for i:=65 to 90 do
		KeysName[i]	:= AnsiChar(i);
	for i:=97 to 105 do
		KeysName[i]	:= AnsiChar(Ord('1')+i-97);
end;

{ TfrmConfig }

procedure TfrmConfig.ConfigAction;
begin
	FActCfg	:= frmMain.FActCfg;
	ShowModal;
end;

procedure TfrmConfig.Keys_onKeyDown(Sender: TObject; var Key: Word;
	Shift: TShiftState);
var
	txtKey	: TEdit;
begin
	if(Key=VK_RETURN)then
	begin
		btnYes.Click;
		Exit;
	end;

	if(Key=VK_ESCAPE)then
	begin
		btnNo.Click;
		Exit;
	end;

	if(Key>127)or(Pointer(KeysName[Key])=nil)then
		Exit;
	txtKey	:= TEdit(Sender);
	txtKey.Text	:= KeysName[Key];
	txtKey.Tag	:= Key;
end;

procedure TfrmConfig.btnYesClick(Sender: TObject);
begin
	FActCfg.Keys[gaKeyUp]			:= txtUp.Tag;
	FActCfg.Keys[gaKeyDown]		:= txtDown.Tag;
	FActCfg.Keys[gaKeyLeft]		:= txtLeft.Tag;
	FActCfg.Keys[gaKeyRight]	:= txtRight.Tag;
	frmMain.SetupActionKeys(FActCfg);
	Close;
end;

procedure TfrmConfig.btnNoClick(Sender: TObject);
begin
  Close;
end;

begin
	SetupKeyNames;
end.

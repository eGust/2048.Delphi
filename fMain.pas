unit fMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ExtCtrls, StdCtrls, GameModules, Menus, ActnList, Buttons;

type
	TGameAction	= ( gaNone, gaRestart, gaKeyUp, gaKeyDown, gaKeyLeft, gaKeyRight );
	TActionConfig	= record
		Keys	: array[TGameAction] of Byte;
	end;
	
  TfrmMain = class(TForm)
    pnlInfo: TPanel;
    pnlGame: TPanel;
    imgMap: TImage;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    Help1: TMenuItem;
    mnNewGame: TMenuItem;
    mnAbout: TMenuItem;
    mnConfigure: TMenuItem;
    mnExit: TMenuItem;
    lblScore: TStaticText;
    StaticText2: TStaticText;
    ActionList1: TActionList;
    actNewGame: TAction;
    actConfig: TAction;
    actExit: TAction;
    actAbout: TAction;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
		procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actNewGameExecute(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
  private
		FGame	: TGameController;
		FKeyActions	: array[0..127] of TGameAction;
		FActionStack	: Integer;
		
		procedure UpdateScore(Score: Integer);
		procedure PlayAction(Action: TGameAction);
	public
		FActCfg	: TActionConfig;

		procedure SetupActionKeys(const ActCfg: TActionConfig);
  end;

var
	frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  fConfig;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
	ClientWidth		:= 800;
	ClientHeight	:= 600;
	FGame	:= TGameController.Create(imgMap.Canvas, imgMap.Height);
	FGame.DrawBackground;
	FGame.DrawTiles;
	with FActCfg do
	begin
		Keys[gaKeyUp]			:= VK_UP;
		Keys[gaKeyDown]		:= VK_DOWN;
		Keys[gaKeyLeft]		:= VK_LEFT;
		Keys[gaKeyRight]	:= VK_RIGHT;
	end;
	SetupActionKeys(FActCfg);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

procedure TfrmMain.UpdateScore(Score: Integer);
begin
	lblScore.Caption	:= Format('%d', [Score]);
	FGame.DrawTiles;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
	if(Key<127)then
	begin
		PlayAction(FKeyActions[Key]);
  end;  
end;

procedure TfrmMain.SetupActionKeys(const ActCfg: TActionConfig);
var
	ga	: TGameAction;
begin
	FActCfg	:= ActCfg;
	FillChar(FKeyActions, SizeOf(FKeyActions), gaNone);
	for ga:=gaKeyUp to High(TGameAction) do
	begin
		FKeyActions[ActCfg.Keys[ga]]	:= ga;
  end;  
end;

procedure TfrmMain.PlayAction(Action: TGameAction);
begin
	if (FActionStack>1) then
		Exit;

	Inc(FActionStack);
	case Action of
		gaKeyUp	:
			FGame.MoveTiles(maUp);
		gaKeyDown	:
			FGame.MoveTiles(maDown);
		gaKeyLeft	:
			FGame.MoveTiles(maLeft);
		gaKeyRight	:
			FGame.MoveTiles(maRight);
		else
		begin
			Dec(FActionStack);
			Exit;
		end;
	end;
	UpdateScore(FGame.Score);
	Dec(FActionStack);
end;

procedure TfrmMain.actNewGameExecute(Sender: TObject);
begin
	FGame.RestartGame;
	UpdateScore(FGame.Score);
end;

procedure TfrmMain.actConfigExecute(Sender: TObject);
begin
	frmConfig.ConfigAction;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
	Close;
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
begin
	MessageBox(Handle, 'By eGust', 'About', 0);
end;

end.

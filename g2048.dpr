program g2048;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  GameModules in 'GameModules.pas',
  fConfig in 'fConfig.pas' {frmConfig};

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.Run;
end.

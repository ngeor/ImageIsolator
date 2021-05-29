program ImageIsolator;

{$MODE Delphi}

uses
  Forms,
  Interfaces,
  ImageIsolatorMain in 'ImageIsolatorMain.pas' {MainForm},
  frmAreaCapture in 'frmAreaCapture.pas' {AreaCapturer},
  ScrnCap in 'ScrnCap.pas',
  CanvasSize in 'CanvasSize.pas' {frmCanvasSize};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmCanvasSize, frmCanvasSize);
  Application.Run;
end.

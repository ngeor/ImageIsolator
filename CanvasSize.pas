unit CanvasSize;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Spin;

type
  TfrmCanvasSize = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    txtWidth: TSpinEdit;
    txtHeight: TSpinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCanvasSize: TfrmCanvasSize;

function GetNewCanvasSize(var AWidth, AHeight: integer): boolean;

implementation

{$R *.lfm}

function GetNewCanvasSize(var AWidth, AHeight: integer): boolean;
begin
  with frmCanvasSize do
  begin
    txtWidth.Value := AWidth;
    txtHeight.Value := AHeight;
    Result := ShowModal = mrOk;
    if Result then
    begin
      AWidth := txtWidth.Value;
      AHeight := txtHeight.Value;
    end;
  end;
end;

end.

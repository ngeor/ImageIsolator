unit frmAreaCapture;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs;

type
  TAreaCapturer = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fDragging: boolean;
    X1, Y1, X2, Y2: integer;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure UpdateRect;
  public
    { Public declarations }
    fRect: TRect;
    fBmp: TBitmap;
  end;

implementation

{$R *.lfm}

function Max(x, y: integer): integer;
begin
  if x > y then
    Result := x
  else
    Result := y;
end;

function Min(x, y: integer): integer;
begin
  if x < y then
    Result := x
  else
    Result := y;
end;

procedure Swap(var x, y: integer);
var
  z: integer;
begin
  z := x;
  x := y;
  y := z;
end;

procedure CheckRect(var R: TRect);
begin
  if R.Right < R.Left then
    Swap(R.Left, R.Right);
  if R.Bottom < R.Top then
    Swap(R.Bottom, R.Top);
end;

procedure TAreaCapturer.UpdateRect;
begin
  SetRect(fRect, X1, Y1, X2, Y2);
  CheckRect(fRect);
  Canvas.DrawFocusrect(fRect);
end;

procedure TAreaCapturer.FormCreate(Sender: TObject);
var
  aDC: HDC;
begin
  fBMP := TBitmap.Create;
  fBMP.Width := Screen.Width;
  fBMP.Height := Screen.Height;
  aDC := GetDC(0);
  BitBlt(fBMP.Canvas.handle, 0, 0, Screen.Width, Screen.Height,
    aDC, 0, 0, srcCopy);
  ReleaseDC(0, aDC);
  SetBounds(0, 0, Screen.Width, Screen.Height);
end;

procedure TAreaCapturer.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if mbLeft = Button then
  begin
    fDragging := True;
    X1 := X;
    Y1 := Y;
    X2 := X;
    Y2 := Y;
    UpdateRect;
  end;
end;

procedure TAreaCapturer.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if fDragging then
  begin
    Canvas.DrawFocusrect(fRect);
    X2 := X;
    Y2 := Y;
    UpdateRect;
  end;
end;

procedure TAreaCapturer.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if fDragging then
  begin
    Canvas.DrawFocusrect(fRect);
    fDragging := False;
  end;
  ModalResult := mrOk;
end;

procedure TAreaCapturer.FormPaint(Sender: TObject);
begin
  Canvas.Draw(0, 0, fBMP);
end;

procedure TAreaCapturer.FormDestroy(Sender: TObject);
begin
  fBMP.Free;
end;

procedure TAreaCapturer.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;

end.

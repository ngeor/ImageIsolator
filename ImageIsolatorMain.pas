unit ImageIsolatorMain;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  ClipBrd, ExtCtrls, Buttons, ExtDlgs, Menus, StdCtrls, ComCtrls,
  ToolWin;

const
  DelayTime = 2000;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    mnuOptions: TMenuItem;
    OptionsCapturing: TMenuItem;
    OptionBGColor: TMenuItem;
    ColorDialog1: TColorDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    Panel2: TPanel;
    BGColor: TShape;
    Label1: TLabel;
    CurrColor: TShape;
    Label2: TLabel;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    ActionsMenu: TMenuItem;
    ActionIsolate: TMenuItem;
    ActionAlign: TMenuItem;
    ActionTile: TMenuItem;
    EditMenu: TMenuItem;
    EditUndo: TMenuItem;
    EditRedo: TMenuItem;
    EditCut: TMenuItem;
    EditCopy: TMenuItem;
    EditPaste: TMenuItem;
    EditCopyToFile: TMenuItem;
    EditPasteFromFile: TMenuItem;
    EditCapture: TMenuItem;
    procedure OptionBGColorClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ActionIsolateClick(Sender: TObject);
    procedure ActionAlignClick(Sender: TObject);
    procedure ActionTileClick(Sender: TObject);
    procedure EditUndoClick(Sender: TObject);
    procedure EditRedoClick(Sender: TObject);
    procedure EditCutClick(Sender: TObject);
    procedure EditCopyClick(Sender: TObject);
    procedure EditCopyToFileClick(Sender: TObject);
    procedure EditPasteClick(Sender: TObject);
    procedure EditPasteFromFileClick(Sender: TObject);
    procedure EditCaptureClick(Sender: TObject);
  private
    procedure AssignBitmap(b: TBitmap);
    procedure AssignPicture(b: TPicture);
    procedure CaptureArea;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses frmAreaCapture, ScrnCap, CanvasSize;

{$R *.lfm}

procedure TMainForm.AssignBitmap(b: TBitmap);
begin
  with ScrollBox1 do
  begin
    HorzScrollBar.Range := b.Width;
    VertScrollBar.Range := b.Height;
  end;
  Image1.SetBounds(0, 0, b.Width, b.Height);
  Image1.Picture.Assign(b);
end;

procedure TMainForm.AssignPicture(b: TPicture);
begin
  with ScrollBox1 do
  begin
    HorzScrollBar.Range := b.Width;
    VertScrollBar.Range := b.Height;
  end;
  Image1.SetBounds(0, 0, b.Width, b.Height);
  Image1.Picture.Assign(b);
end;

procedure TMainForm.CaptureArea;
var
  ABitmap: TBitmap;
begin
  with TAreaCapturer.Create(Application) do
    try
      if ShowModal = mrOk then
        with fRect do
        begin
          if (Right > Left) and (Bottom > Top) then
          begin
            Sleep(DelayTime div 2);
            ABitmap := TBitmap.Create;
            ABitmap.Assign(CaptureScreenRect(fRect));
            AssignBitmap(ABitmap);
            ABitmap.Free;
          end;
        end;
    finally
      Free;
    end;
end;

procedure TMainForm.OptionBGColorClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
    BGColor.Brush.Color := ColorDialog1.Color;
end;

procedure TMainForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  CurrColor.Brush.Color := Image1.Picture.Bitmap.Canvas.Pixels[x, y];
end;

procedure TMainForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  BGColor.Brush.Color := Image1.Picture.Bitmap.Canvas.Pixels[x, y];
end;

procedure TMainForm.ActionIsolateClick(Sender: TObject);
var
  R, Q: TRect;
  x, y: integer;
  Found: boolean;
  b: TBitmap;
begin
  { search for left side }
  Found := False;
  x := 0;
  repeat
    y := 0;
    repeat
      if Image1.Canvas.Pixels[x, y] <> BGColor.Brush.Color then
        Found := True
      else
        y := y + 1;
    until Found or (y >= Image1.Picture.Height);
    if not Found then
      x := x + 1;
  until Found or (x >= Image1.Picture.Width);
  if not Found then
    MessageDlg('Η εικόνα είναι κενή...', mtError, [mbOK], 0)
  else
  begin
    R.Left := x;

    { search for top side }
    Found := False;
    y := 0;
    repeat
      x := 0;
      repeat
        if Image1.Canvas.Pixels[x, y] <> BGColor.Brush.Color then
          Found := True
        else
          x := x + 1;
      until Found or (x >= Image1.Picture.Width);
      if not Found then
        y := y + 1;
    until Found or (y >= Image1.Picture.Height);
    R.Top := y;

    { search for right side }
    Found := False;
    x := Image1.Width - 1;
    repeat
      y := 0;
      repeat
        if Image1.Canvas.Pixels[x, y] <> BGColor.Brush.Color then
          Found := True
        else
          y := y + 1;
      until Found or (y >= Image1.Picture.Height);
      if not Found then
        x := x - 1;
    until Found or (x < 0);
    R.Right := x + 1;

    { search for bottom side }
    Found := False;
    y := Image1.Height - 1;
    repeat
      x := 0;
      repeat
        if Image1.Canvas.Pixels[x, y] <> BGColor.Brush.Color then
          Found := True
        else
          x := x + 1;
      until Found or (x >= Image1.Picture.Width);
      if not Found then
        y := y - 1;
    until Found or (y < 0);
    R.Bottom := y + 1;
    Q := Rect(0, 0, R.Right - R.Left, R.Bottom - R.Top);
    b := TBitmap.Create;
    b.Width := Q.Right;
    b.Height := Q.Bottom;
    b.Canvas.CopyRect(Q, Image1.Picture.Bitmap.Canvas, R);
    AssignBitmap(b);
{      ScrollBox2.VertScrollBar.Position :=0;
      ScrollBox2.HorzScrollBar.Position :=0;

      Image2.SetBounds(0, 0, Q.Right, Q.Bottom);
      Image2.Picture.Assign(b);}
    b.Free;
  end;
end;

procedure TMainForm.ActionAlignClick(Sender: TObject);
var
  w, h: integer;
  b: TBitmap;
  R1: TRect;
  R2: TRect;
begin
  w := Image1.Width;
  h := Image1.Height;
  if GetNewCanvasSize(w, h) then
  begin
    b := TBitmap.Create;
    b.Width := w;
    b.Height := h;
    b.Canvas.Brush.Color := BGColor.Brush.Color;
    b.Canvas.FillRect(Bounds(0, 0, w, h));
    R2 := Bounds(0, 0, Image1.Width, Image1.Height);
    R1 := Rect((w - Image1.Width) div 2, (h - Image1.Height) div 2,
      (w + Image1.Width) div 2, (h + Image1.Height) div 2);
    b.Canvas.CopyRect(R1, Image1.Canvas, R2);
    AssignBitmap(b);
    b.Free;
  end;
end;

procedure TMainForm.ActionTileClick(Sender: TObject);
var
  w, h: integer;
  b: TBitmap;
  R1: TRect;
  R2: TRect;
begin
  w := Image1.Width;
  h := Image1.Height;
  if GetNewCanvasSize(w, h) then
  begin
    b := TBitmap.Create;
    b.Width := w;
    b.Height := h;
    R2 := Bounds(0, 0, Image1.Width, Image1.Height);
    R1 := R2;
    repeat
      repeat
        b.Canvas.CopyRect(R1, Image1.Canvas, R2);
        R1.Left := R1.Left + Image1.Width;
        R1.Right := R1.Left + Image1.Width;
      until R1.Left > w;
      R1 := Rect(0, R1.Top + Image1.Height, Image1.Width, R1.Bottom + Image1.Height);
    until R1.Top > h;
    AssignBitmap(b);
    b.Free;
  end;
end;

procedure TMainForm.EditUndoClick(Sender: TObject);
begin

end;

procedure TMainForm.EditRedoClick(Sender: TObject);
begin

end;

procedure TMainForm.EditCutClick(Sender: TObject);
begin

end;

procedure TMainForm.EditCopyClick(Sender: TObject);
begin
  Clipboard.Assign(Image1.Picture);
end;

procedure TMainForm.EditCopyToFileClick(Sender: TObject);
begin
  with SavePictureDialog1 do
    if Execute then
      Image1.Picture.SaveToFile(FileName);
end;

procedure TMainForm.EditPasteClick(Sender: TObject);
var
  bmp1: TBitmap;
begin
  if Clipboard.HasPictureFormat then
  begin
    bmp1 := TBitmap.Create;
    try
      bmp1.Assign(Clipboard);
      AssignBitmap(bmp1);
    finally
      bmp1.Free;
    end;
  end
  else
    MessageDlg('Το πρόχειρο δεν έχει εικόνα', mtError, [mbOk], 0);
end;

procedure TMainForm.EditPasteFromFileClick(Sender: TObject);
var
  p1: TPicture;
begin
  with OpenPictureDialog1 do
    if Execute then
    begin
      p1 := TPicture.Create;
      try
        p1.LoadFromFile(FileName);
        AssignPicture(p1);
      finally
        p1.Free;
      end;
    end;
end;

procedure TMainForm.EditCaptureClick(Sender: TObject);
begin
  Application.Minimize;
  Sleep(DelayTime div 2);
  CaptureArea;
  Application.Restore;
end;

end.

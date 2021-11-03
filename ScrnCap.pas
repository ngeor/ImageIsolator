unit ScrnCap;

{$MODE Delphi}

interface

uses LCLIntf, LCLType, LMessages, Graphics, Types;

function CaptureScreenRect(ARect: TRect): TBitmap;

implementation

function CaptureScreenRect(ARect: TRect): TBitmap;
var
  ScreenDC: HDC;
begin
  Result := TBitmap.Create;
  with Result, ARect do
  begin
    Width := Right - Left;
    Height := Bottom - Top;
    ScreenDC := GetDC(0);
    try
      BitBlt(Canvas.Handle, 0, 0, Width, Height, ScreenDC,
        Left, Top, SRCCOPY);
    finally
      ReleaseDC(0, ScreenDC);
    end;
  end;
end;

end.

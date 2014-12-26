unit uMain;

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, Buttons, CheckLst, ComCtrls;

type
  TMoveMapsForm = class(TForm)
    cbFilesList: TCheckListBox;
    Label1: TLabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Bevel1: TBevel;
    lbPath: TLabel;
    ProgressBar: TProgressBar;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    sTAPath : String;
    sMapsPath : String;
    procedure ListFileDir(Ext: string; Path: string; FileList: TStrings);
  end;

var
  MoveMapsForm: TMoveMapsForm;

type
  PProgressBar = ^TProgressBar;

implementation

{$R *.dfm}

procedure TurboCopyFile( const SourceFile, DestinationFile: String; Display: PProgressBar);
type
  TurboBuffer = array[1..4096] of Byte;
const
  szBuffer = sizeof(TurboBuffer);
var
  InStream,
  OutStream: TFileStream;
  CanCopy: Boolean;
  BytesLeft: Integer;
  Buffer: TurboBuffer;
begin
  if FileExists(SourceFile) then
  begin
    InStream := TFileStream.Create(SourceFile, fmOpenRead);
    OutStream := TFileStream.Create(DestinationFile, fmCreate);

    if Assigned(Display) then
      Display^.Max := InStream.Size;

    CanCopy :=
      (InStream.Size > InStream.Position) and
      ((InStream.Size -InStream.Position) >= szBuffer);

    Application.ProcessMessages;

    while CanCopy do
    begin
      InStream.ReadBuffer(Buffer, szBuffer);
      OutStream.WriteBuffer(Buffer, szBuffer);
      if Assigned(Display) then
        Display^.Position := InStream.Position;
      CanCopy :=
        (InStream.Size > InStream.Position) and
        ((InStream.Size -InStream.Position) >= szBuffer);
    end;

    BytesLeft := InStream.Size -InStream.Position;

    if BytesLeft > 0 then
    begin
      InStream.ReadBuffer(Buffer, BytesLeft);
      OutStream.WriteBuffer(Buffer, BytesLeft);
    end;

    if Assigned(Display) then
      Display^.Position := Display^.Max;

    FreeAndNil(InStream);
    FreeAndNil(OutStream);

    DeleteFile(SourceFile);
  end;
end;

procedure TMoveMapsForm.ListFileDir(Ext: string; Path: string; FileList: TStrings);
var
  SR: TSearchRec;
begin
 if FindFirst(Path + Ext, faAnyFile, SR) = 0 then
 begin
   repeat
     if (Pos(UpperCase('AFlea'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('AScarab'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('corplas'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('AFark'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('AScarab'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('CHedgehog'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('CImmolator'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('CResurreKbot'), UpperCase(Sr.Name)) <> 0) or
        (Pos(UpperCase('Cormabm'), UpperCase(Sr.Name)) <> 0) then
       Continue;

     FileList.Add(SR.Name);
   until FindNext(SR) <> 0;
   FindClose(SR);
   end;
end;

procedure TMoveMapsForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMoveMapsForm.btnOKClick(Sender: TObject);
var
  i : Integer;
begin
  // copy files
  Screen.Cursor := crHourGlass;
  if not DirectoryExists(Self.sMapsPath) then
    if not CreateDir(PAnsiChar(Self.sMapsPath)) then
    begin
      ModalResult := mrAbort;
      Exit;
    end;
  for i := 0 to cbFilesList.Items.Count - 1 do
    if cbFilesList.Checked[i] then
      TurboCopyFile(Self.sTAPath + cbFilesList.Items[i], Self.sMapsPath + cbFilesList.Items[i], @ProgressBar);
  Screen.Cursor := crDefault;
  ModalResult := mrOk;
end;

procedure TMoveMapsForm.FormShow(Sender: TObject);
begin
  lbpath.Caption := Self.sMapsPath;
end;

end.

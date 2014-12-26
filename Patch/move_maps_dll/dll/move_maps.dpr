library move_maps;

uses
  SysUtils,
  Classes,
  Windows,
  uMain in 'uMain.pas' {MoveMapsForm};

{$R *.res}

function ShowMoveMapsDialog(TAPath, CommonMapsPath: PChar): Integer; stdcall;
begin
  MoveMapsForm := TMoveMapsForm.Create(nil);
  MoveMapsForm.sTAPath := IncludeTrailingPathDelimiter(String(TAPath));
  MoveMapsForm.sMapsPath := IncludeTrailingPathDelimiter(String(CommonMapsPath));
  MoveMapsForm.ListFileDir('*.ufo', MoveMapsForm.sTAPath, MoveMapsForm.cbFilesList.Items);
  if MoveMapsForm.cbFilesList.Items.Count <> 0 then
    Result := MoveMapsForm.ShowModal
  else
    Result := IDIGNORE;
end;

exports
  ShowMoveMapsDialog;

begin

end.

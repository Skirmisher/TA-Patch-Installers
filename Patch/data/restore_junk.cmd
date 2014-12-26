del "%~dp0\junk\_README_JUNK.txt"
IF EXIST "%~dp0\music" (
  MD "%~dp0\newjunk"
  MOVE /Y "%~dp0\music" "%~dp0\newjunk"
  MOVE /Y "%~dp0\junk\music" "%~dp0"
) ELSE (
  MOVE /Y "%~dp0\junk\music" "%~dp0"
)
IF EXIST "%~dp0\bitmaps" (
  MD "%~dp0\newjunk"
  MOVE /Y "%~dp0\bitmaps" "%~dp0\newjunk"
  MOVE /Y "%~dp0\junk\bitmaps" "%~dp0"
) ELSE (
  MOVE /Y "%~dp0\junk\bitmaps" "%~dp0"
)
IF EXIST "%~dp0\guis" (
  MD "%~dp0\newjunk"
  MOVE /Y "%~dp0\guis" "%~dp0\newjunk"
  MOVE /Y "%~dp0\junk\guis" "%~dp0"
) ELSE (
  MOVE /Y "%~dp0\junk\guis" "%~dp0"
)
IF EXIST "%~dp0\gamedata" (
  MD "%~dp0\newjunk"
  MOVE /Y "%~dp0\gamedata" "%~dp0\newjunk"
  MOVE /Y "%~dp0\junk\gamedata" "%~dp0"
) ELSE (
  MOVE /Y "%~dp0\junk\gamedata" "%~dp0"
)
IF EXIST "%~dp0\newjunk" (
  ATTRIB -H "%~dp0\_README_NEWJUNK.txt"
  MOVE /Y "%~dp0\_README_NEWJUNK.txt" "%~dp0\newjunk"
) ELSE (
  DEL "%~dp0\_README_NEWJUNK.txt"
  DEL /A:H "%~dp0\_README_NEWJUNK.txt"
)
move /Y "%~dp0\junk\*.*" "%~dp0"
rd "%~dp0\junk"
del "%~dp0\restore_junk.cmd"
del /A:H "%~dp0\restore_junk.cmd"
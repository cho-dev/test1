@echo off
rem ================================================
rem FFmpeg-jwmod test.bat
rem     play movie with various infomation
rem              by Coffey 2014.06.08  mod 2014.12.26
rem ================================================

setlocal

rem ================================================
rem ffplayPath  : filepath to modified ffplay.exe
rem fontFile    : filepath to font file
rem dHeight     : height of play size
rem motionVector: show motion vector from encorder [yes/no]
rem ================================================
set ffplayPath=ffplay.exe
set fontFile=C:\Windows\Fonts\arial.ttf
set dHeight=540
set motionVector=no
set volumeParams=1

set monitorWidth=1920
set monitorHeight=1200

set scaleParams=scale=%dHeight%*dar:%dHeight%
rem set scaleParams=null
set histogramParams=histogram=levels_mode=linear
rem set histogramParams=histogram=levels_mode=logarithmic
rem set histogramParams=null
rem set ffplayOptions=-noosd -notoggle_adisp -analyzeduration 30000000 -probesize 30M
set ffplayOptions=-notoggle_adisp -analyzeduration 30000000 -probesize 30M

if "%~1"=="" goto end

rem # escape special character
set fontFile=%fontFile:\=\\%
set fontFile=%fontFile::=\:%
set fontFile=%fontFile:,=\,%
set fontFile=%fontFile:'=\'%
set fontFile=%fontFile:[=\[%
set fontFile=%fontFile:]=\]%

rem ***** parse command line *****
set args=%*
set args=%args:,=$comma$%
set args=%args:;=$semicolon$%
set args=%args:Å@=$fullspace$%
call :loop1 %%args%%
goto end

:loop1
  set argument="%~1"
  if %argument%=="" goto loop1end
  set argument=%argument:$comma$=,%
  set argument=%argument:$semicolon$=;%
  set argument=%argument:$fullspace$=Å@%
  call :play %%argument%%
  shift
  goto loop1
:loop1end
  exit /b

:play
set inFile="%~1"
set inFile=%inFile:\=\\\\%
set inFile=%inFile::=\\\:%
set inFile=%inFile:,=\\\,%
set inFile=%inFile:'=\\\'%
set inFile=%inFile:[=\\\[%
set inFile=%inFile:]=\\\]%

set motionVectorParams1=
set motionVectorParams2=null
if "%motionVector%"=="yes" (
  set motionVectorParams1=-flags2 +export_mvs
  set motionVectorParams2=codecview=mv=pf+bf+bb
)

set autoExit=-autoexit
if "%~x1" == ".jpg"  (set autoExit=)
if "%~x1" == ".JPG"  (set autoExit=)
if "%~x1" == ".jpeg" (set autoExit=)
if "%~x1" == ".JPEG" (set autoExit=)
if "%~x1" == ".bmp"  (set autoExit=)
if "%~x1" == ".BMP"  (set autoExit=)
if "%~x1" == ".png"  (set autoExit=)
if "%~x1" == ".PNG"  (set autoExit=)
if "%~x1" == ".tif"  (set autoExit=)
if "%~x1" == ".TIF"  (set autoExit=)
if "%~x1" == ".tiff" (set autoExit=)
if "%~x1" == ".TIFF" (set autoExit=)
if "%~x1" == ".gif"  (set autoExit=)
if "%~x1" == ".GIF"  (set autoExit=)
if "%~x1" == ".webp" (set autoExit=)
if "%~x1" == ".WEBP" (set autoExit=)
if "%~x1" == ".tga" (set autoExit=)
if "%~x1" == ".TGA" (set autoExit=)

"%ffplayPath%" %autoExit% %ffplayOptions% %motionVectorParams1% -i "%~1"^
 -vf showinfo=mode=metadata,^
%motionVectorParams2%,%scaleParams%,^
split=2[v10][v11],[v11]%histogramParams%,scale=256:120,^
drawbox=16:0:220:38:c=white@0.5:t=1,drawbox=213:1:1:3:c=white@0.5:t=1,drawbox=191:1:1:3:c=white@0.5:t=1,^
drawbox=16:40:224:38:c=white@0.5:t=1,drawbox=16:80:224:38:c=white@0.5:t=1,^
split[v13],drawbox=c='#666666':t=ih,[v13]alphamerge[v12],[v10][v12]overlay=0:%dHeight%-120,^
drawtext=fontfile='%fontFile%':x=2:y=2:fontsize=24:fontcolor=white:^
text='%%{metadata\:lavfi.showinfo.T.HMS}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=26:fontsize=20:fontcolor=yellow:^
text='%%{metadata\:lavfi.showinfo.T_DELTA.FORM}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=50:fontsize=20:fontcolor=yellow:^
text='%%{metadata\:lavfi.showinfo.FRAME_TYPE.L}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=74:fontsize=20:fontcolor=yellow:^
text='"Repeat Pict="%%{metadata\:lavfi.showinfo.REPEAT_PICT}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=98:fontsize=20:fontcolor=yellow:^
text='"Timebase="%%{metadata\:lavfi.showinfo.TIMEBASE.FORM}(%%{metadata\:lavfi.showinfo.TIMEBASE.NUM}/%%{metadata\:lavfi.showinfo.TIMEBASE.DEN})':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=122:fontsize=20:fontcolor=yellow:^
text='"PTS="%%{metadata\:lavfi.showinfo.PTS}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=146:fontsize=20:fontcolor=yellow:^
text='"SAR="%%{metadata\:lavfi.showinfo.SAR}(%%{metadata\:lavfi.showinfo.SAR.NUM}\:%%{metadata\:lavfi.showinfo.SAR.DEN})':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=170:fontsize=20:fontcolor=yellow:^
text='"Size="%%{metadata\:lavfi.showinfo.WIDTH}x%%{metadata\:lavfi.showinfo.HEIGHT}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=194:fontsize=20:fontcolor=yellow:^
text='"Format="%%{metadata\:lavfi.showinfo.FORMAT}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=218:fontsize=20:fontcolor=yellow:^
text='"Stream Pos="%%{metadata\:lavfi.showinfo.POS.SEP3}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=242:fontsize=20:fontcolor=yellow:^
text='"Video Bitrate="%%{metadata\:lavfi.showinfo.BITRATE.FORM}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=266:fontsize=20:fontcolor=yellow:^
text='"Key Frame="%%{metadata\:lavfi.showinfo.ISKEY}(%%{metadata\:lavfi.showinfo.PICT_TYPE})':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=290:fontsize=20:fontcolor=yellow:^
text='"Key Interval="%%{metadata\:lavfi.showinfo.KEY_INTERVAL}':box=1:boxcolor=black@0.4,^
drawtext=fontfile='%fontFile%':x=2:y=314:fontsize=20:fontcolor=yellow:^
text='"N="%%{metadata\:lavfi.showinfo.N}':box=1:boxcolor=black@0.4 ^
 -vf scale=min(%monitorHeight%*dar\,%monitorWidth%):ow/dar:flags=lanczos -af volume=%volumeParams%

exit /b

:end
rem pause
endlocal

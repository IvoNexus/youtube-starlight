@echo off
for /f "tokens=1,2 delims==" %%a in (.\core\config.ini) do (
if %%a==color set color=%%b
if %%a==color_n set color_n=%%b
if %%a==atype set atype=%%b
if %%a==vtype set vtype=%%b
if %%a==dtype set dtype=%%b
if %%a==fork set fork=%%b
if %%a==ffmpeg_mode set ffmpeg_mode=%%b
if %%a==ffmpeg_vbr set ffmpeg_vbr=%%b
if %%a==ffmpeg_cbr set ffmpeg_cbr=%%b
if %%a==ffmpeg_mp3 set ffmpeg_mp3=%%b
if %%a==vid_audio set vid_audio=%%b
if %%a==downld_dir set downld_dir=%%b
if %%a==tmp_dir set tmp_dir=%%b
)

set app_dir=%cd%
set ffmpeg_vbr=4
set ffmpeg_cbr=96k
color %color%

:START
echo.
echo.
echo                                         .:'                                  `:.                                    
echo                                        ::'                                    `::                                   
echo                                       :: :.                                  .: ::                                  
echo                                        `:. `:.             .              .:'  .:'                                  
echo                                          `::. `::          !           ::' .::'                                     
echo                                             `::.`::.    .' ! `.     .::'.::'                                        
echo                                               `:.  `::::'':!:``::::'   ::'                                          
echo                                               :'*:::.  .:' ! `:.  .:::*`:                                           
echo                                              :: HHH::.   ` ! '   .::HHH ::                                          
echo                                             ::: `H TH::.  `!'  .::HT H' :::                                         
echo                                             ::..  `THHH:`:   :':HHHT'  ..::                                         
echo                                             `::      `T: `. .' :T'      ::'                                         
echo                                               `:. .   :         :   . .:'                                           
echo                                                 `::'               `::'                                             
echo                                                   :'  .`.  .  .'.  `:                                               
echo                                                   :' ::.       .:: `:                                               
echo                                                   :' `:::     :::' `:                                               
echo                                                    `.  ``     ''  .'                                                
echo                                                     :`...........':                                                 
echo                                                     ` :`.     .': '                                                 
echo                                                      `:  `"""'  :'
echo                                                    Youtube-Starlight
echo                                                        #IvoNexus
echo.
echo                                                        Loading..
timeout 4 >nul
if exist %app_dir%\core\ffmpeg.exe (
echo                                                        FFmpeg found
) else (
echo                                                        FFmpeg not found
echo.
pause
exit
)
if exist %app_dir%\core\%fork%.exe (
echo                                                        %fork% found
) else (
echo                                                        %fork% not found
echo                                                        Check your settings!
echo.
pause
)
if exist %app_dir%\tmp\*.m4a (
del %app_dir%\tmp\*.m4a
) else (
echo.
)
if exist %app_dir%\tmp\*.mp3 (
del %app_dir%\tmp\*.mp3
) else (
echo.
)
echo.
timeout 1 >nul
goto MENU

:MENU
cls
set map=MENU
color %color%
echo ===============================================
echo        Youtube-Starlight
echo ===============================================
echo.
echo   1  + Download audio only
echo      2  + Download audio as mp3
echo         - current %ffmpeg_mp3%
echo.
echo   3  + Download video only
echo      4  + Download video with audio
echo         - current %vid_audio%
echo.
echo   5  + %fork% settings
echo      - audio code = %atype%
echo      - video code = %vtype%
echo      - downld type = %dtype%
echo.
echo   6  + FFmpeg settings
echo      - encoding = %ffmpeg_mode%
echo      - CBR rate = %ffmpeg_cbr%
echo      - VBR rate = %ffmpeg_vbr%
echo.
echo   7  - Settings
echo   A  - About
echo.
echo   X  - EXIT
echo.
echo ===============================================
echo.

set M=0
set /P M=Type 1, 2, 3 .. A or X then press ENTER:
if %M%==1 goto DOWNLD_AUDIO
if %M%==2 goto OPT_AUDIO_MP3
if %M%==3 goto DOWNLD_VIDEO
if %M%==4 goto OPT_VIDEO_AUDIO
if %M%==5 goto YTDL
if %M%==6 goto FFMPEG
if %M%==7 goto SETTINGS
if %M%==A goto ABOUT
if %M%==a goto ABOUT
if %M%==X goto EXIT
if %M%==x goto EXIT
echo.
echo "%M%" is not valid, try again
echo.
pause
goto MENU

:DOWNLD_AUDIO
echo.
if %ffmpeg_mp3%==no (
    if %dtype%==file (
        goto DOWNLD_AUDIO_M4A
    ) else (
        goto DOWNLD_AUDIO_M4A_PLST
    )
) else (
    if %dtype%==file (
        goto DOWNLD_AUDIO_MP3
    ) else (
        goto DOWNLD_AUDIO_MP3_PLST
    )
)
goto MENU

:DOWNLD_AUDIO_M4A
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe -f %atype% %link% --output %downld_dir%%%(title)s.%%(ext)s
echo.
echo Download complete!
pause
goto MENU

:DOWNLD_AUDIO_M4A_PLST
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe-i -f %atype% --yes-playlist %link% --output %downld_dir%%%(title)s.%%(ext)s
echo.
echo Download complete!
pause
goto MENU

:DOWNLD_AUDIO_MP3
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe -f %atype% %link% --output %tmp_dir%%%(title)s.%%(ext)s
for %%i in (.\tmp\*.m4a) do (.\core\ffmpeg.exe -i "%%i" -c:a libmp3lame -q:a 4 "%downld_dir%%%~ni.mp3")
del /q %tmp_dir%*.*
echo.
echo Download complete!
pause
goto MENU

:DOWNLD_AUDIO_MP3_PLST
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe -f %atype% --yes-playlist %link% --output %tmp_dir%%%(title)s.%%(ext)s
for %%i in (.\tmp\*.m4a) do (.\core\ffmpeg.exe -i "%%i" -c:a libmp3lame -q:a 4 "%downld_dir%%%~ni.mp3")
del /q %tmp_dir%*.*
echo.
echo Download complete!
pause
goto MENU

:DOWNLD_VIDEO
echo.
if %vid_audio%==no (
    if %dtype%==file (
        goto DOWNLD_VIDEO_NA
    ) else (
        goto DOWNLD_VIDEO_NA_PLST
    )
) else (
    if %dtype%==file (
        goto DOWNLD_VIDEO_A
    ) else (
        goto DOWNLD_VIDEO_A_PLST
    )
)
goto MENU

:DOWNLD_VIDEO_NA
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe -f %vtype% %link% --output %app_dir%\downld\%%(title)s.%%(ext)s
echo.
echo Download complete!
pause
goto MENU

:DOWNLD_VIDEO_NA_PLST
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe -f %vtype% --yes-playlist %link% --output %app_dir%\downld\%%(title)s.%%(ext)s
echo.
echo Download complete!
pause
goto MENU

:DOWNLD_VIDEO_A
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe -f %vtype%+%atype% %link% --output %app_dir%\downld\%%(title)s.%%(ext)s
echo.
echo Download complete!
pause
goto MENU

:DOWNLD_VIDEO_A_PLST
echo.
set /p link="Enter URL: "
cls
echo [youtube] Downloading %link% please wait.
%app_dir%\core\%fork%.exe -f %vtype%+%atype% --yes-playlist %link% --output %app_dir%\downld\%%(title)s.%%(ext)s
echo.
echo Download complete!
pause
goto MENU

:OPT_AUDIO_MP3
set map=MENU
echo.
if %ffmpeg_mp3%==no (
    set ffmpeg_mp3=yes
) else (
    set ffmpeg_mp3=no
)
goto SAVE

:OPT_VIDEO_AUDIO
set map=MENU
echo.
if %vid_audio%==yes (
    set vid_audio=no
) else (
    set vid_audio=yes
)
goto SAVE

:YTDL
cls
color %color%
echo ===============================================
echo       %fork% advanced settings
echo ===============================================
echo.
echo   1 + Select custom audio code 
echo     - current %atype%
echo.
echo   2 + Select custom video code 
echo     - current %vtype%
echo.
echo   3 + Download as playlist or file 
echo     - current as %dtype%
echo.
echo   4 - Check for available files
echo   5 - Browser ID
echo   6 - Version
echo   7 - Update
echo.
echo   B - BACK
echo.
echo ===============================================
echo.

set M=0
set /P M=Type 1, 2, 3 .. 7 or B then press ENTER:
if %M%==1 goto YTDL_ACODE
if %M%==2 goto YTDL_VCODE
if %M%==3 goto YTDL_DTYPE
if %M%==4 goto YTDL_CHE_FILE
if %M%==5 goto YTDL_AGENT
if %M%==6 goto YTDL_VER
if %M%==7 goto YTDL_UPDT
if %M%==B goto MENU
if %M%==b goto MENU
echo.
echo "%M%" is not valid, try again
echo.
pause
goto YTDL

:YTDL_ACODE
set map=YTDL
echo.
echo Warning! Change this only if necessary, default is m4a.
echo.
set /p ifatype="Write filetype: "
set atype=%ifatype%
echo.
goto SAVE

:YTDL_VCODE
set map=YTDL
echo.
echo Some of the currently used formats, however this
echo can change in future, so check for available 
echo files from time to time. Not all videos
echo has support up to 4K!
echo.
echo 134 - 360P AVC1 / 396 - 360P AV01 / 135 - 480P AVC1
echo 397 - 480P AV01 / 136 - 720P AVC1 / 398 - 720P AV01
echo 137 - 1080P AVC1 / 399 - 1080P AV01 / 400 - 2K AV01
echo 401 - 4K AV01
echo.
set /p ifvtype="Write filetype: "
set vtype=%ifvtype%
echo.
goto SAVE

:YTDL_DTYPE
set map=YTDL
echo.
if %dtype%==file (
    set dtype=playlist
) else (
    set dtype=file
)
goto SAVE

:YTDL_CHE_FILE
echo.
set /p link="Enter URL: "
cls
echo Checking %link% for available files...
%app_dir%\core\%fork%.exe -F %link%
echo.
pause
goto YTDL

:YTDL_AGENT
echo.
%app_dir%\core\%fork%.exe --dump-user-agent
echo.
pause
goto YTDL

:YTDL_VER
echo.
%app_dir%\core\%fork%.exe --version
echo.
pause
goto YTDL

:YTDL_UPDT
echo.
%app_dir%\core\%fork%.exe -U
timeout 7 >nul
echo.
pause
goto YTDL

:FFMPEG
cls
color %color%
echo ===============================================
echo       FFMPEG advanced settings
echo ===============================================
echo.
echo   1 + Switch encoding mode 
echo     - current %ffmpeg_mode%
echo.
echo   2 + CBR bitrate
echo     - current %ffmpeg_cbr%
echo.
echo   3 + VBR bitrate 
echo     - current %ffmpeg_vbr%
echo.
echo   4 - Version
echo.
echo   B - BACK
echo.
echo ===============================================
echo.

set M=0
set /P M=Type 1, 2, 3 .. 4 or B then press ENTER:
if %M%==1 goto FFMPEG_TYPE
if %M%==2 goto FFMPEG_CBR_TYPE
if %M%==3 goto FFMPEG_VBR_TYPE
if %M%==4 goto FFMPEG_VER
if %M%==B goto MENU
if %M%==b goto MENU
echo.
echo "%M%" is not valid, try again
echo.
pause
goto FFMPEG

:FFMPEG_TYPE
set map=FFMPEG
echo.
if %ffmpeg_mode%==VBR (
    set ffmpeg_mode=CBR
) else (
    set ffmpeg_mode=VBR
)
goto SAVE

:FFMPEG_VBR_TYPE
echo.
echo *Can be a number between 1 and 8.
echo.
set /p type_bitrate="Write bitrate: "
set ffmpeg_vbr=%type_bitrate%
echo.
goto FFMPEG

:FFMPEG_CBR_TYPE
echo.
echo *Can be a number between 64 and 128.
echo.
set /p type_bitrate="Write bitrate: "
set ffmpeg_cbr=%type_bitrate%k
echo.
goto FFMPEG

:FFMPEG_VER
echo.
%app_dir%\core\ffmpeg.exe -version
echo.
pause
goto FFMPEG

:SETTINGS
cls
color %color%
echo ===============================================
echo       Settings
echo ===============================================
echo.
echo   1 + Change theme color
echo     - current %color_n%
echo.
echo   2 + Change fork name
echo     - current %fork%
echo.
echo   3 + Change download folder 
echo     - current %downld_dir%*.*
echo.
echo   4 + Change temp folder
echo     - current %tmp_dir%*.*
echo.
echo   5 - Restore settings to default
echo.
echo   B - BACK
echo.
echo ===============================================
echo.

set M=0
set /P M=Type 1, 2 .. 3 or B then press ENTER:
if %M%==1 goto THEME_COLOR
if %M%==2 goto FORK_NAME
if %M%==3 goto DOWNLD_DIR
if %M%==4 goto TMP_DIR
if %M%==5 goto DEFAULT
if %M%==B goto MENU
if %M%==b goto MENU
echo.
echo "%M%" is not valid, try again
echo.
pause
goto SETTINGS

:THEME_COLOR
cls
color %color%
echo ===============================================
echo       Color (current %color_n%)
echo ===============================================
echo.
echo   1 - White
echo   2 - Blue
echo   3 - Aqua
echo   4 - Green
echo   5 - Red
echo   6 - Yellow
echo   7 - Purple
echo   8 - Custom
echo.
echo   B - Back
echo.
echo ===============================================
echo.

set M=0
set /P M=Type 1, 2 .. 3 or B then press ENTER:
if %M%==1 goto THEME_COLOR_WHITE
if %M%==2 goto THEME_COLOR_BLUE
if %M%==3 goto THEME_COLOR_AQUA
if %M%==4 goto THEME_COLOR_GREEN
if %M%==5 goto THEME_COLOR_RED
if %M%==6 goto THEME_COLOR_YELLOW
if %M%==7 goto THEME_COLOR_PURPLE
if %M%==8 goto THEME_COLOR_CUSTOM
if %M%==B goto MENU
if %M%==b goto MENU
echo.
echo "%M%" is not valid, try again
echo.
pause
goto SETTINGS

:THEME_COLOR_WHITE
set map=SETTINGS
echo.
set color=0F
set color_n=White
goto SAVE

:THEME_COLOR_BLUE
set map=SETTINGS
echo.
set color=09
set color_n=Blue
goto SAVE

:THEME_COLOR_AQUA
set map=SETTINGS
echo.
set color=0B
set color_n=Aqua
goto SAVE

:THEME_COLOR_GREEN
set map=SETTINGS
echo.
set color=0A
set color_n=Green
goto SAVE

:THEME_COLOR_RED
set map=SETTINGS
echo.
set color=0C
set color_n=Red
goto SAVE

:THEME_COLOR_YELLOW
set map=SETTINGS
echo.
set color=0E
set color_n=Yellow
goto SAVE

:THEME_COLOR_PURPLE
set map=SETTINGS
echo.
set color=0D
set color_n=Purple
goto SAVE

:THEME_COLOR_CUSTOM
set map=SETTINGS
echo.
set /p type_color="Write color number: "
set color=%type_color%
set color_n=Custom
goto SAVE

:FORK_NAME
set map=SETTINGS
echo.
echo Warning! Has to be exact as *.exe
echo name, without the extension!
echo.
set /p type_fork="Type fork name: "
set fork=%type_fork%
goto SAVE

:DOWNLD_DIR
set map=SETTINGS
echo.
echo Default: ./downld/
echo.
set /p type_downld_dir="Download location: "
set downld_dir=%type_downld_dir%
goto SAVE

:TMP_DIR
set map=SETTINGS
echo.
echo Warning! Be careful where you set this location,
echo because all *.m4a and *.mp3 files will be purged
echo from this directory!
echo.
echo Default: ./tmp/
echo.
set /p type_tmp_dir="Temp location: "
set downld_dir=%type_tmp_dir%
goto SAVE

:ABOUT
cls
color %color%
echo ===============================================
echo      Youtube-Starlight
echo ===============================================
echo.
echo      It's made for testing purposes only!
echo      Please, respect the artists, if you like
echo      their work and talent, support them by
echo      purchasing it from official e-store.
echo.
echo      github.com/IvoNexus/youtube-starlight
echo.
echo      Licensed under GNU GPLv3
echo      Version 0.2 - 07-18-2022
echo      Written by #IvoNexus aka Specter
echo.
echo ===============================================
echo.
pause
goto MENU

:DEFAULT
DEL .\core\config.ini
echo color=0c> .\core\config.ini
echo color_n=Red>> .\core\config.ini
echo atype=m4a>> .\core\config.ini
echo vtype=136>> .\core\config.ini
echo dtype=file>> .\core\config.ini
echo fork=youtube-dl>> .\core\config.ini
echo ffmpeg_mode=VBR>> .\core\config.ini
echo ffmpeg_mp3=yes>> .\core\config.ini
echo vid_audio=yes>> .\core\config.ini
echo downld_dir=.\downld\>> .\core\config.ini
echo tmp_dir=.\tmp\>> .\core\config.ini
echo.
echo Default settings has been restored!
echo.
pause
goto EXIT

:SAVE
echo color=%color%> .\core\config.ini
echo color_n=%color_n%>> .\core\config.ini
echo atype=%atype%>> .\core\config.ini
echo vtype=%vtype%>> .\core\config.ini
echo dtype=%dtype%>> .\core\config.ini
echo fork=%fork%>> .\core\config.ini
echo ffmpeg_mode=%ffmpeg_mode%>> .\core\config.ini
echo ffmpeg_mp3=%ffmpeg_mp3%>> .\core\config.ini
echo vid_audio=%vid_audio%>> .\core\config.ini
echo downld_dir=%downld_dir%>> .\core\config.ini
echo tmp_dir=%tmp_dir%>> .\core\config.ini
goto %map%

:EXIT
exit
chcp 65001

@echo off

cd images

echo Markdown用の画像リンク一覧:

for %%F in (*.png *.jpg *.jpeg *.gif) do (
    call :processFile "%%~nF" "%%~xF"
)
pause
exit /b

:processFile
echo ![](/images/%~1%~2)
exit /b


@echo off

where /Q docker
if errorlevel 0 goto PRE_STEP1
echo Docker service and client are required to run this setup.
exit /b 1
:PRE_STEP1

setlocal
set VHOME=%~dp0
set VOL1=%VHOME:~0,-6%:/v/t/:ro

if exist tmp rd /S /Q tmp
md tmp
set VARTICLES=%1
if "%VARTICLES%"=="" set VARTICLES=%VHOME:~0,-6%\tmp
set VOL2=%VARTICLES%:/v/a/

set CONTAINER=jekyll
set IMAGE=danmaq/jekyll-git-redcarpet:github-pages
docker run -d -p 4000:4000 -v %VOL1% -v %VOL2% --name %CONTAINER% %IMAGE% sh -c "mkdir /root/.ssh;while true; do sleep 1; done"
echo "Please open via browser: http://localhost:4000"

docker exec -it %CONTAINER% /v/test/incontainer
docker exec -it %CONTAINER% ash
docker rm -f %CONTAINER%
endlocal
exit /b 0

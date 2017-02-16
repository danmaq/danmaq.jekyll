@echo off

where /Q docker
if errorlevel 0 goto PRE_STEP1
echo Docker service and client are required to run this setup.
exit /b 1
:PRE_STEP1

if exist tmp rd /S /Q tmp
md tmp
if exist _site rd /S /Q _site
md _site

setlocal
set PWD=%~dp0
set PJHOME=%PWD:~0,-6%

rem ==== SET VOL1 ====
set VOL1=%PJHOME%:/v/t/:ro

rem ==== SET VOL2 ====
set VARTICLES=%1
if "%VARTICLES%"=="" set VARTICLES=%PJHOME%\tmp
set VOL2=%VARTICLES%:/v/a/

rem ==== SET VOL3 ====
set VOL3=%PJHOME%\_site:/srv/jekyll/_site

set CONTAINER=jekyll
set IMAGE=danmaq/jekyll-git-redcarpet:github-pages
set GIT_NAME="Jekyll bot by Shuhei Nomura"
set GIT_EMAIL="info@danmaq.com"
set LOOP="mkdir /root/.ssh; while true; do sleep 1; done"

docker run -d -p 4000:4000 -v %VOL1% -v %VOL2% -v %VOL3% -v %VOL4% -e GIT_NAME=%GIT_NAME% -e GIT_EMAIL=%GIT_EMAIL% --name %CONTAINER% %IMAGE% sh -c %LOOP%
echo "Please open via browser: http://localhost:4000"

docker exec -it %CONTAINER% /v/t/test/incontainer
docker exec -it %CONTAINER% ash
docker rm -f %CONTAINER%
endlocal
exit /b 0

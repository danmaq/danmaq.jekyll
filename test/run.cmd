@echo off

rem ==== VALIDATE ====
where /Q docker
if errorlevel 0 goto PRE_STEP1
echo Docker service and client are required to run this setup.
exit /b 1
:PRE_STEP1

rem ==== CREATE WORKDIR ====
if not exist tmp md tmp
if not exist _site md _site

setlocal
set PWD=%~dp0
set PJHOME=%PWD:~0,-6%

rem ==== SET VOL1 ====
set DEST=/v/danmaq.jekyll
set VOL1=%PJHOME%:%DEST%:ro

rem ==== SET VOL2 ====
set VARTICLES=%1
if "%VARTICLES%"=="" set VARTICLES=%PJHOME%\tmp
set VOL2=%VARTICLES%:/v/danmaq.articles

rem ==== SET VOL3 ====
set VOL3=%PJHOME%\_site:/srv/jekyll/_site

rem ==== SET VOL4 ====
set VOL4=%USERPROFILE%\.ssh\id_rsa:/root/.ssh/id_rsa:ro

rem ==== SET VOL3 ====
set VOL3=%PJHOME%\_site:/srv/jekyll/_site

set CONTAINER=jekyll
set IMAGE=danmaq/jekyll-git-redcarpet:github-pages
set GIT_NAME="jekyll bot by Shuhei Nomura"
set GIT_EMAIL="info@danmaq.com"
set LOOP="while true; do sleep 1; done"

docker run -d -p 4000:4000 ^
    -v %VOL1% -v %VOL2% -v %VOL3% -v %VOL4% ^
    -e GIT_NAME=%GIT_NAME% -e GIT_EMAIL=%GIT_EMAIL% ^
    --name %CONTAINER% %IMAGE% sh -c %LOOP%
echo "Please open via browser: http://localhost:4000"

docker exec -it %CONTAINER% %DEST%/test/incontainer
rem docker exec -it %CONTAINER% ash
docker rm -f %CONTAINER%
endlocal
exit /b 0

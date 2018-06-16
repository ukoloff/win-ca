@echo off
cd %~dp0
for %%a in (x86 x64) do (
  call nvm$ install 8 %%a
  call npm install
  node test
  node deploy
)

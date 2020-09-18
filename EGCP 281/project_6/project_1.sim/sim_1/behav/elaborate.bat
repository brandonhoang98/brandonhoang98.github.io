@echo off
set xv_path=D:\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto e912b55187e24eafa11fd3d50bb891b1 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot FBC_tb_behav xil_defaultlib.FBC_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

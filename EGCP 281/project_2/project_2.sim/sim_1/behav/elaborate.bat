@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto a26682a7af5a4059b684eac7dba56d2c -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot RCA2C_tb_behav xil_defaultlib.RCA2C_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto 365979d6f0f9455793dbf1efaee3cabb -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot p1_tb_behav xil_defaultlib.p1_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

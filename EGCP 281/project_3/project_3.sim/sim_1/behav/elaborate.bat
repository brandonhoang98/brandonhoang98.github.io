@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto 027dda87b38644eca915aadb120ebab3 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot ALU_B_tb_behav xil_defaultlib.ALU_B_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

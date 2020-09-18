@echo off
set xv_path=D:\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto 460beb7f3bfc4746b1f342cc8e322d5a -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot AcuTB_behav xil_defaultlib.AcuTB -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

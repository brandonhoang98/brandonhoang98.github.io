-- Xilinx Vhdl netlist produced by netgen application (version G.26)
-- Command       : -intstyle ise -rpw 100 -tpw 0 -ar Structure -xon true -w -ofmt vhdl -sim scanff.ngd scanff_translate.vhd 
-- Input file    : scanff.ngd
-- Output file   : scanff_translate.vhd
-- Design name   : scanff
-- # of Entities : 1
-- Xilinx        : C:/XilinxISE6
-- Device        : 3s50pq208-4

-- This vhdl netlist is a simulation model and uses simulation 
-- primitives which may not represent the true implementation of the 
-- device, however the netlist is functionally correct and should not 
-- be modified. This file cannot be synthesized and should only be used 
-- with supported simulation tools.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library SIMPRIM;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity scanff is
  port (
    clk : in STD_LOGIC := 'X'; 
    rst : in STD_LOGIC := 'X'; 
    scan : in STD_LOGIC := 'X'; 
    input : in STD_LOGIC := 'X'; 
    sel : in STD_LOGIC := 'X'; 
    output : out STD_LOGIC 
  );
end scanff;

architecture Structure of scanff is
  signal clk_BUFGP : STD_LOGIC; 
  signal rst_IBUF : STD_LOGIC; 
  signal scan_IBUF : STD_LOGIC; 
  signal output_OBUF : STD_LOGIC; 
  signal input_IBUF : STD_LOGIC; 
  signal sel_IBUF : STD_LOGIC; 
  signal Q_n0001 : STD_LOGIC; 
  signal clk_BUFGP_IBUFG : STD_LOGIC; 
  signal GSR : STD_LOGIC; 
  signal output_GSR_OR : STD_LOGIC; 
  signal output_OBUF_GTS_TRI : STD_LOGIC; 
  signal GTS : STD_LOGIC; 
  signal VCC : STD_LOGIC; 
  signal GND : STD_LOGIC; 
  signal NlwInverterSignal_output_OBUF_GTS_TRI_CTL : STD_LOGIC; 
begin
  output_0 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => Q_n0001,
      RST => output_GSR_OR,
      CLK => clk_BUFGP,
      O => output_OBUF,
      CE => VCC,
      SET => GND
    );
  Mmux_n0001_Result1 : X_LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      ADR0 => sel_IBUF,
      ADR1 => scan_IBUF,
      ADR2 => input_IBUF,
      O => Q_n0001
    );
  rst_IBUF_1 : X_BUF
    port map (
      I => rst,
      O => rst_IBUF
    );
  scan_IBUF_2 : X_BUF
    port map (
      I => scan,
      O => scan_IBUF
    );
  input_IBUF_3 : X_BUF
    port map (
      I => input,
      O => input_IBUF
    );
  sel_IBUF_4 : X_BUF
    port map (
      I => sel,
      O => sel_IBUF
    );
  output_OBUF_5 : X_BUF
    port map (
      I => output_OBUF,
      O => output_OBUF_GTS_TRI
    );
  clk_BUFGP_BUFG : X_CKBUF
    port map (
      I => clk_BUFGP_IBUFG,
      O => clk_BUFGP
    );
  clk_BUFGP_IBUFG_11 : X_CKBUF
    port map (
      I => clk,
      O => clk_BUFGP_IBUFG
    );
  output_GSR_OR_12 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => output_GSR_OR
    );
  output_OBUF_GTS_TRI_13 : X_TRI
    port map (
      I => output_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_output_OBUF_GTS_TRI_CTL,
      O => output
    );
  NlwBlock_scanff_VCC : X_ONE
    port map (
      O => VCC
    );
  NlwBlock_scanff_GND : X_ZERO
    port map (
      O => GND
    );
  NlwInverterBlock_output_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_output_OBUF_GTS_TRI_CTL
    );
  NlwBlockROC : X_ROC
    generic map (ROC_WIDTH => 100 ns)
    port map (O => GSR);
  NlwBlockTOC : X_TOC
    port map (O => GTS);

end Structure;


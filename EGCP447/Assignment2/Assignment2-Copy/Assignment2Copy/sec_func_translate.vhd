-- Xilinx Vhdl netlist produced by netgen application (version G.26)
-- Command       : -intstyle ise -rpw 100 -tpw 0 -ar Structure -xon true -w -ofmt vhdl -sim sec_func.ngd sec_func_translate.vhd 
-- Input file    : sec_func.ngd
-- Output file   : sec_func_translate.vhd
-- Design name   : sec_func
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

entity sec_func is
  port (
    clk : in STD_LOGIC := 'X'; 
    rst : in STD_LOGIC := 'X'; 
    scanin : in STD_LOGIC := 'X'; 
    sel : in STD_LOGIC := 'X'; 
    scanout : out STD_LOGIC; 
    min : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    dataout : out STD_LOGIC_VECTOR ( 6 downto 0 ) 
  );
end sec_func;

architecture Structure of sec_func is
  signal clk_BUFGP : STD_LOGIC; 
  signal rst_IBUF : STD_LOGIC; 
  signal min_3_IBUF : STD_LOGIC; 
  signal dataout_1 : STD_LOGIC; 
  signal scanin_IBUF : STD_LOGIC; 
  signal sel_IBUF : STD_LOGIC; 
  signal Q_n0000 : STD_LOGIC; 
  signal Q_n0001 : STD_LOGIC; 
  signal Q_n0002 : STD_LOGIC; 
  signal min_0_IBUF : STD_LOGIC; 
  signal dataout_4 : STD_LOGIC; 
  signal dataout_3 : STD_LOGIC; 
  signal dataout_5 : STD_LOGIC; 
  signal FF1_output : STD_LOGIC; 
  signal FF3_output : STD_LOGIC; 
  signal FF1_n0001 : STD_LOGIC; 
  signal dataout_0 : STD_LOGIC; 
  signal FF2_output : STD_LOGIC; 
  signal FF4_output : STD_LOGIC; 
  signal dataout_2 : STD_LOGIC; 
  signal min_1_IBUF : STD_LOGIC; 
  signal dataout_6 : STD_LOGIC; 
  signal min_2_IBUF : STD_LOGIC; 
  signal dataout_4_N46 : STD_LOGIC; 
  signal FF4_n0001 : STD_LOGIC; 
  signal FF2_n0001 : STD_LOGIC; 
  signal FF3_n0001 : STD_LOGIC; 
  signal FF1_Mmux_n0001_Result1_O : STD_LOGIC; 
  signal Mxor_n0002_Xo_1_1_O : STD_LOGIC; 
  signal FF3_Mmux_n0001_Result1_O : STD_LOGIC; 
  signal Mxor_n0001_Result1_O : STD_LOGIC; 
  signal FF2_Mmux_n0001_Result1_O : STD_LOGIC; 
  signal Mxor_n0000_Result1_O : STD_LOGIC; 
  signal clk_BUFGP_IBUFG : STD_LOGIC; 
  signal GSR : STD_LOGIC; 
  signal FF1_output_GSR_OR : STD_LOGIC; 
  signal FF2_output_GSR_OR : STD_LOGIC; 
  signal FF3_output_GSR_OR : STD_LOGIC; 
  signal FF4_output_GSR_OR : STD_LOGIC; 
  signal k_2_GSR_OR : STD_LOGIC; 
  signal k_1_GSR_OR : STD_LOGIC; 
  signal k_0_GSR_OR : STD_LOGIC; 
  signal scanout_OBUF_GTS_TRI : STD_LOGIC; 
  signal GTS : STD_LOGIC; 
  signal dataout_6_OBUF_GTS_TRI : STD_LOGIC; 
  signal dataout_5_OBUF_GTS_TRI : STD_LOGIC; 
  signal dataout_4_OBUF_GTS_TRI : STD_LOGIC; 
  signal dataout_3_OBUF_GTS_TRI : STD_LOGIC; 
  signal dataout_2_OBUF_GTS_TRI : STD_LOGIC; 
  signal dataout_1_OBUF_GTS_TRI : STD_LOGIC; 
  signal dataout_0_OBUF_GTS_TRI : STD_LOGIC; 
  signal GND : STD_LOGIC; 
  signal VCC : STD_LOGIC; 
  signal NlwInverterSignal_scanout_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal NlwInverterSignal_dataout_6_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal NlwInverterSignal_dataout_5_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal NlwInverterSignal_dataout_4_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal NlwInverterSignal_dataout_3_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal NlwInverterSignal_dataout_2_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal NlwInverterSignal_dataout_1_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal NlwInverterSignal_dataout_0_OBUF_GTS_TRI_CTL : STD_LOGIC; 
  signal k : STD_LOGIC_VECTOR ( 2 downto 0 ); 
begin
  dataout_4_0 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF2_output,
      CE => dataout_4_N46,
      CLK => clk_BUFGP,
      O => dataout_4,
      SET => GND,
      RST => GSR
    );
  dataout_5_1 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF3_output,
      CE => dataout_4_N46,
      CLK => clk_BUFGP,
      O => dataout_5,
      SET => GND,
      RST => GSR
    );
  dataout_6_2 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF4_output,
      CE => dataout_4_N46,
      CLK => clk_BUFGP,
      O => dataout_6,
      SET => GND,
      RST => GSR
    );
  dataout_3_3 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => k(2),
      CE => dataout_4_N46,
      CLK => clk_BUFGP,
      O => dataout_3,
      SET => GND,
      RST => GSR
    );
  dataout_2_4 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF1_output,
      CE => dataout_4_N46,
      CLK => clk_BUFGP,
      O => dataout_2,
      SET => GND,
      RST => GSR
    );
  dataout_0_5 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => k(0),
      CE => dataout_4_N46,
      CLK => clk_BUFGP,
      O => dataout_0,
      SET => GND,
      RST => GSR
    );
  dataout_1_6 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => k(1),
      CE => dataout_4_N46,
      CLK => clk_BUFGP,
      O => dataout_1,
      SET => GND,
      RST => GSR
    );
  FF1_output_7 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF1_n0001,
      RST => FF1_output_GSR_OR,
      CLK => clk_BUFGP,
      O => FF1_output,
      CE => VCC,
      SET => GND
    );
  FF2_output_8 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF2_n0001,
      RST => FF2_output_GSR_OR,
      CLK => clk_BUFGP,
      O => FF2_output,
      CE => VCC,
      SET => GND
    );
  FF3_output_9 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF3_n0001,
      RST => FF3_output_GSR_OR,
      CLK => clk_BUFGP,
      O => FF3_output,
      CE => VCC,
      SET => GND
    );
  FF4_output_10 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => FF4_n0001,
      RST => FF4_output_GSR_OR,
      CLK => clk_BUFGP,
      O => FF4_output,
      CE => VCC,
      SET => GND
    );
  k_2 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => Q_n0000,
      RST => k_2_GSR_OR,
      CLK => clk_BUFGP,
      O => k(2),
      CE => VCC,
      SET => GND
    );
  k_1 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => Q_n0001,
      RST => k_1_GSR_OR,
      CLK => clk_BUFGP,
      O => k(1),
      CE => VCC,
      SET => GND
    );
  k_0 : X_FF
    generic map(
      INIT => '0'
    )
    port map (
      I => Q_n0002,
      RST => k_0_GSR_OR,
      CLK => clk_BUFGP,
      O => k(0),
      CE => VCC,
      SET => GND
    );
  dataout_4_N461 : X_LUT2
    generic map(
      INIT => X"5"
    )
    port map (
      ADR0 => rst_IBUF,
      O => dataout_4_N46,
      ADR1 => GND
    );
  FF4_Mmux_n0001_Result1 : X_LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      ADR0 => sel_IBUF,
      ADR1 => scanin_IBUF,
      ADR2 => min_3_IBUF,
      O => FF4_n0001
    );
  rst_IBUF_11 : X_BUF
    port map (
      I => rst,
      O => rst_IBUF
    );
  scanin_IBUF_12 : X_BUF
    port map (
      I => scanin,
      O => scanin_IBUF
    );
  sel_IBUF_13 : X_BUF
    port map (
      I => sel,
      O => sel_IBUF
    );
  min_3_IBUF_14 : X_BUF
    port map (
      I => min(3),
      O => min_3_IBUF
    );
  min_2_IBUF_15 : X_BUF
    port map (
      I => min(2),
      O => min_2_IBUF
    );
  min_1_IBUF_16 : X_BUF
    port map (
      I => min(1),
      O => min_1_IBUF
    );
  min_0_IBUF_17 : X_BUF
    port map (
      I => min(0),
      O => min_0_IBUF
    );
  scanout_OBUF : X_BUF
    port map (
      I => dataout_2,
      O => scanout_OBUF_GTS_TRI
    );
  dataout_6_OBUF : X_BUF
    port map (
      I => dataout_6,
      O => dataout_6_OBUF_GTS_TRI
    );
  dataout_5_OBUF : X_BUF
    port map (
      I => dataout_5,
      O => dataout_5_OBUF_GTS_TRI
    );
  dataout_4_OBUF : X_BUF
    port map (
      I => dataout_4,
      O => dataout_4_OBUF_GTS_TRI
    );
  dataout_3_OBUF : X_BUF
    port map (
      I => dataout_3,
      O => dataout_3_OBUF_GTS_TRI
    );
  dataout_2_OBUF : X_BUF
    port map (
      I => dataout_2,
      O => dataout_2_OBUF_GTS_TRI
    );
  dataout_1_OBUF : X_BUF
    port map (
      I => dataout_1,
      O => dataout_1_OBUF_GTS_TRI
    );
  dataout_0_OBUF : X_BUF
    port map (
      I => dataout_0,
      O => dataout_0_OBUF_GTS_TRI
    );
  FF1_Mmux_n0001_Result1_LUT3_L_BUF : X_BUF
    port map (
      I => FF1_Mmux_n0001_Result1_O,
      O => FF1_n0001
    );
  FF1_Mmux_n0001_Result1 : X_LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      ADR0 => sel_IBUF,
      ADR1 => FF2_output,
      ADR2 => min_0_IBUF,
      O => FF1_Mmux_n0001_Result1_O
    );
  Mxor_n0002_Xo_1_1_LUT3_L_BUF : X_BUF
    port map (
      I => Mxor_n0002_Xo_1_1_O,
      O => Q_n0002
    );
  Mxor_n0002_Xo_1_1 : X_LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      ADR0 => FF1_output,
      ADR1 => FF4_output,
      ADR2 => FF2_output,
      O => Mxor_n0002_Xo_1_1_O
    );
  FF3_Mmux_n0001_Result1_LUT3_L_BUF : X_BUF
    port map (
      I => FF3_Mmux_n0001_Result1_O,
      O => FF3_n0001
    );
  FF3_Mmux_n0001_Result1 : X_LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      ADR0 => sel_IBUF,
      ADR1 => FF4_output,
      ADR2 => min_2_IBUF,
      O => FF3_Mmux_n0001_Result1_O
    );
  Mxor_n0001_Result1_LUT3_L_BUF : X_BUF
    port map (
      I => Mxor_n0001_Result1_O,
      O => Q_n0001
    );
  Mxor_n0001_Result1 : X_LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      ADR0 => FF4_output,
      ADR1 => FF3_output,
      ADR2 => FF1_output,
      O => Mxor_n0001_Result1_O
    );
  FF2_Mmux_n0001_Result1_LUT3_L_BUF : X_BUF
    port map (
      I => FF2_Mmux_n0001_Result1_O,
      O => FF2_n0001
    );
  FF2_Mmux_n0001_Result1 : X_LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      ADR0 => sel_IBUF,
      ADR1 => FF3_output,
      ADR2 => min_1_IBUF,
      O => FF2_Mmux_n0001_Result1_O
    );
  Mxor_n0000_Result1_LUT3_L_BUF : X_BUF
    port map (
      I => Mxor_n0000_Result1_O,
      O => Q_n0000
    );
  Mxor_n0000_Result1 : X_LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      ADR0 => FF4_output,
      ADR1 => FF3_output,
      ADR2 => FF2_output,
      O => Mxor_n0000_Result1_O
    );
  clk_BUFGP_BUFG : X_CKBUF
    port map (
      I => clk_BUFGP_IBUFG,
      O => clk_BUFGP
    );
  clk_BUFGP_IBUFG_23 : X_CKBUF
    port map (
      I => clk,
      O => clk_BUFGP_IBUFG
    );
  FF1_output_GSR_OR_24 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => FF1_output_GSR_OR
    );
  FF2_output_GSR_OR_25 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => FF2_output_GSR_OR
    );
  FF3_output_GSR_OR_26 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => FF3_output_GSR_OR
    );
  FF4_output_GSR_OR_27 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => FF4_output_GSR_OR
    );
  k_2_GSR_OR_28 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => k_2_GSR_OR
    );
  k_1_GSR_OR_29 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => k_1_GSR_OR
    );
  k_0_GSR_OR_30 : X_OR2
    port map (
      I0 => rst_IBUF,
      I1 => GSR,
      O => k_0_GSR_OR
    );
  scanout_OBUF_GTS_TRI_31 : X_TRI
    port map (
      I => scanout_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_scanout_OBUF_GTS_TRI_CTL,
      O => scanout
    );
  dataout_6_OBUF_GTS_TRI_32 : X_TRI
    port map (
      I => dataout_6_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_dataout_6_OBUF_GTS_TRI_CTL,
      O => dataout(6)
    );
  dataout_5_OBUF_GTS_TRI_33 : X_TRI
    port map (
      I => dataout_5_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_dataout_5_OBUF_GTS_TRI_CTL,
      O => dataout(5)
    );
  dataout_4_OBUF_GTS_TRI_34 : X_TRI
    port map (
      I => dataout_4_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_dataout_4_OBUF_GTS_TRI_CTL,
      O => dataout(4)
    );
  dataout_3_OBUF_GTS_TRI_35 : X_TRI
    port map (
      I => dataout_3_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_dataout_3_OBUF_GTS_TRI_CTL,
      O => dataout(3)
    );
  dataout_2_OBUF_GTS_TRI_36 : X_TRI
    port map (
      I => dataout_2_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_dataout_2_OBUF_GTS_TRI_CTL,
      O => dataout(2)
    );
  dataout_1_OBUF_GTS_TRI_37 : X_TRI
    port map (
      I => dataout_1_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_dataout_1_OBUF_GTS_TRI_CTL,
      O => dataout(1)
    );
  dataout_0_OBUF_GTS_TRI_38 : X_TRI
    port map (
      I => dataout_0_OBUF_GTS_TRI,
      CTL => NlwInverterSignal_dataout_0_OBUF_GTS_TRI_CTL,
      O => dataout(0)
    );
  NlwBlock_sec_func_GND : X_ZERO
    port map (
      O => GND
    );
  NlwBlock_sec_func_VCC : X_ONE
    port map (
      O => VCC
    );
  NlwInverterBlock_scanout_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_scanout_OBUF_GTS_TRI_CTL
    );
  NlwInverterBlock_dataout_6_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_dataout_6_OBUF_GTS_TRI_CTL
    );
  NlwInverterBlock_dataout_5_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_dataout_5_OBUF_GTS_TRI_CTL
    );
  NlwInverterBlock_dataout_4_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_dataout_4_OBUF_GTS_TRI_CTL
    );
  NlwInverterBlock_dataout_3_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_dataout_3_OBUF_GTS_TRI_CTL
    );
  NlwInverterBlock_dataout_2_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_dataout_2_OBUF_GTS_TRI_CTL
    );
  NlwInverterBlock_dataout_1_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_dataout_1_OBUF_GTS_TRI_CTL
    );
  NlwInverterBlock_dataout_0_OBUF_GTS_TRI_CTL : X_INV
    port map (
      I => GTS,
      O => NlwInverterSignal_dataout_0_OBUF_GTS_TRI_CTL
    );
  NlwBlockROC : X_ROC
    generic map (ROC_WIDTH => 100 ns)
    port map (O => GSR);
  NlwBlockTOC : X_TOC
    port map (O => GTS);

end Structure;


// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -w -ofmt verilog -sim mealy.ngd mealy_translate.v 
// Input file   : mealy.ngd
// Output file  : mealy_translate.v
// Design name  : mealy
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module mealy (
  clk, rst, up, W
);
  input clk;
  input rst;
  input up;
  output [1 : 0] W;
  wire clk_BUFGP;
  wire rst_IBUF;
  wire W_0_OBUF;
  wire up_IBUF;
  wire state_reg_FFd2;
  wire state_reg_FFd1;
  wire state_reg_FFd3;
  wire W_1_OBUF;
  wire \state_reg_FFd3-In ;
  wire \state_reg_FFd4-In ;
  wire \state_reg_FFd2-In ;
  wire state_reg_FFd4;
  wire \state_reg_FFd1-In ;
  wire \state_reg_FFd4-In1/O ;
  wire \state_reg_FFd3-In1/O ;
  wire \state_reg_FFd2-In1/O ;
  wire \state_reg_FFd1-In1/O ;
  wire \clk_BUFGP/IBUFG ;
  wire GSR = glbl.GSR;
  wire \state_reg_FFd4.GSR.OR ;
  wire \state_reg_FFd1.GSR.OR ;
  wire \state_reg_FFd2.GSR.OR ;
  wire \state_reg_FFd3.GSR.OR ;
  wire \W_1_OBUF.GTS.TRI ;
  wire GTS = glbl.GTS;
  wire \W_0_OBUF.GTS.TRI ;
  wire VCC;
  wire GND;
  wire \NlwInverterSignal_W_1_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_W_0_OBUF.GTS.TRI/CTL ;
  defparam _n00041.INIT = 4'hE;
  X_LUT2 _n00041 (
    .ADR0(state_reg_FFd3),
    .ADR1(state_reg_FFd2),
    .O(W_0_OBUF)
  );
  defparam _n00031.INIT = 4'hE;
  X_LUT2 _n00031 (
    .ADR0(state_reg_FFd2),
    .ADR1(state_reg_FFd1),
    .O(W_1_OBUF)
  );
  defparam state_reg_FFd4_0.INIT = 1'b1;
  X_FF state_reg_FFd4_0 (
    .I(\state_reg_FFd4-In ),
    .SET(\state_reg_FFd4.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd4),
    .CE(VCC),
    .RST(GND)
  );
  defparam state_reg_FFd1_1.INIT = 1'b0;
  X_FF state_reg_FFd1_1 (
    .I(\state_reg_FFd1-In ),
    .RST(\state_reg_FFd1.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd1),
    .CE(VCC),
    .SET(GND)
  );
  defparam state_reg_FFd2_2.INIT = 1'b0;
  X_FF state_reg_FFd2_2 (
    .I(\state_reg_FFd2-In ),
    .RST(\state_reg_FFd2.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd2),
    .CE(VCC),
    .SET(GND)
  );
  defparam state_reg_FFd3_3.INIT = 1'b0;
  X_FF state_reg_FFd3_3 (
    .I(\state_reg_FFd3-In ),
    .RST(\state_reg_FFd3.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd3),
    .CE(VCC),
    .SET(GND)
  );
  X_BUF rst_IBUF_4 (
    .I(rst),
    .O(rst_IBUF)
  );
  X_BUF up_IBUF_5 (
    .I(up),
    .O(up_IBUF)
  );
  X_BUF W_1_OBUF_6 (
    .I(W_1_OBUF),
    .O(\W_1_OBUF.GTS.TRI )
  );
  X_BUF W_0_OBUF_7 (
    .I(W_0_OBUF),
    .O(\W_0_OBUF.GTS.TRI )
  );
  X_IPAD clk_8 (
    .PAD(clk)
  );
  X_IPAD rst_9 (
    .PAD(rst)
  );
  X_IPAD up_10 (
    .PAD(up)
  );
  X_OPAD \W<1>  (
    .PAD(W[1])
  );
  X_OPAD \W<0>  (
    .PAD(W[0])
  );
  X_BUF \state_reg_FFd4-In1/LUT3_L_BUF  (
    .I(\state_reg_FFd4-In1/O ),
    .O(\state_reg_FFd4-In )
  );
  defparam \state_reg_FFd4-In1 .INIT = 8'hD8;
  X_LUT3 \state_reg_FFd4-In1  (
    .ADR0(up_IBUF),
    .ADR1(state_reg_FFd2),
    .ADR2(state_reg_FFd3),
    .O(\state_reg_FFd4-In1/O )
  );
  X_BUF \state_reg_FFd3-In1/LUT3_L_BUF  (
    .I(\state_reg_FFd3-In1/O ),
    .O(\state_reg_FFd3-In )
  );
  defparam \state_reg_FFd3-In1 .INIT = 8'hD8;
  X_LUT3 \state_reg_FFd3-In1  (
    .ADR0(up_IBUF),
    .ADR1(state_reg_FFd4),
    .ADR2(state_reg_FFd1),
    .O(\state_reg_FFd3-In1/O )
  );
  X_BUF \state_reg_FFd2-In1/LUT3_L_BUF  (
    .I(\state_reg_FFd2-In1/O ),
    .O(\state_reg_FFd2-In )
  );
  defparam \state_reg_FFd2-In1 .INIT = 8'hD8;
  X_LUT3 \state_reg_FFd2-In1  (
    .ADR0(up_IBUF),
    .ADR1(state_reg_FFd1),
    .ADR2(state_reg_FFd4),
    .O(\state_reg_FFd2-In1/O )
  );
  X_BUF \state_reg_FFd1-In1/LUT3_L_BUF  (
    .I(\state_reg_FFd1-In1/O ),
    .O(\state_reg_FFd1-In )
  );
  defparam \state_reg_FFd1-In1 .INIT = 8'hD8;
  X_LUT3 \state_reg_FFd1-In1  (
    .ADR0(up_IBUF),
    .ADR1(state_reg_FFd3),
    .ADR2(state_reg_FFd2),
    .O(\state_reg_FFd1-In1/O )
  );
  X_CKBUF \clk_BUFGP/BUFG  (
    .I(\clk_BUFGP/IBUFG ),
    .O(clk_BUFGP)
  );
  X_CKBUF \clk_BUFGP/IBUFG_11  (
    .I(clk),
    .O(\clk_BUFGP/IBUFG )
  );
  X_OR2 \state_reg_FFd4.GSR.OR_12  (
    .I0(rst_IBUF),
    .I1(GSR),
    .O(\state_reg_FFd4.GSR.OR )
  );
  X_OR2 \state_reg_FFd1.GSR.OR_13  (
    .I0(rst_IBUF),
    .I1(GSR),
    .O(\state_reg_FFd1.GSR.OR )
  );
  X_OR2 \state_reg_FFd2.GSR.OR_14  (
    .I0(rst_IBUF),
    .I1(GSR),
    .O(\state_reg_FFd2.GSR.OR )
  );
  X_OR2 \state_reg_FFd3.GSR.OR_15  (
    .I0(rst_IBUF),
    .I1(GSR),
    .O(\state_reg_FFd3.GSR.OR )
  );
  X_TRI \W_1_OBUF.GTS.TRI_16  (
    .I(\W_1_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_W_1_OBUF.GTS.TRI/CTL ),
    .O(W[1])
  );
  X_TRI \W_0_OBUF.GTS.TRI_17  (
    .I(\W_0_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_W_0_OBUF.GTS.TRI/CTL ),
    .O(W[0])
  );
  X_ONE NlwBlock_mealy_VCC (
    .O(VCC)
  );
  X_ZERO NlwBlock_mealy_GND (
    .O(GND)
  );
  X_INV \NlwInverterBlock_W_1_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_W_1_OBUF.GTS.TRI/CTL )
  );
  X_INV \NlwInverterBlock_W_0_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_W_0_OBUF.GTS.TRI/CTL )
  );
endmodule


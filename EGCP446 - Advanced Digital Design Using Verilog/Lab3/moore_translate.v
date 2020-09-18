// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -w -ofmt verilog -sim moore.ngd moore_translate.v 
// Input file   : moore.ngd
// Output file  : moore_translate.v
// Design name  : moore
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module moore (
  clk, rst, W
);
  input clk;
  input rst;
  output [3 : 0] W;
  wire clk_BUFGP;
  wire rst_IBUF;
  wire state_reg_FFd6;
  wire W_1_OBUF;
  wire state_reg_FFd4;
  wire state_reg_FFd2;
  wire state_reg_FFd5;
  wire state_reg_FFd1;
  wire state_reg_FFd3;
  wire W_2_OBUF;
  wire \clk_BUFGP/IBUFG ;
  wire GSR = glbl.GSR;
  wire \state_reg_FFd6.GSR.OR ;
  wire \state_reg_FFd1.GSR.OR ;
  wire \state_reg_FFd2.GSR.OR ;
  wire \state_reg_FFd3.GSR.OR ;
  wire \state_reg_FFd4.GSR.OR ;
  wire \state_reg_FFd5.GSR.OR ;
  wire \W_3_OBUF.GTS.TRI ;
  wire GTS = glbl.GTS;
  wire \W_2_OBUF.GTS.TRI ;
  wire \W_1_OBUF.GTS.TRI ;
  wire \W_0_OBUF.GTS.TRI ;
  wire VCC;
  wire GND;
  wire \NlwInverterSignal_W_3_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_W_2_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_W_1_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_W_0_OBUF.GTS.TRI/CTL ;
  defparam _n00071.INIT = 4'hE;
  X_LUT2 _n00071 (
    .ADR0(state_reg_FFd5),
    .ADR1(state_reg_FFd1),
    .O(W_1_OBUF)
  );
  defparam _n00061.INIT = 4'hE;
  X_LUT2 _n00061 (
    .ADR0(state_reg_FFd4),
    .ADR1(state_reg_FFd2),
    .O(W_2_OBUF)
  );
  defparam state_reg_FFd6_0.INIT = 1'b1;
  X_FF state_reg_FFd6_0 (
    .I(state_reg_FFd1),
    .SET(\state_reg_FFd6.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd6),
    .CE(VCC),
    .RST(GND)
  );
  defparam state_reg_FFd1_1.INIT = 1'b0;
  X_FF state_reg_FFd1_1 (
    .I(state_reg_FFd2),
    .RST(\state_reg_FFd1.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd1),
    .CE(VCC),
    .SET(GND)
  );
  defparam state_reg_FFd2_2.INIT = 1'b0;
  X_FF state_reg_FFd2_2 (
    .I(state_reg_FFd3),
    .RST(\state_reg_FFd2.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd2),
    .CE(VCC),
    .SET(GND)
  );
  defparam state_reg_FFd3_3.INIT = 1'b0;
  X_FF state_reg_FFd3_3 (
    .I(state_reg_FFd4),
    .RST(\state_reg_FFd3.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd3),
    .CE(VCC),
    .SET(GND)
  );
  defparam state_reg_FFd4_4.INIT = 1'b0;
  X_FF state_reg_FFd4_4 (
    .I(state_reg_FFd5),
    .RST(\state_reg_FFd4.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd4),
    .CE(VCC),
    .SET(GND)
  );
  defparam state_reg_FFd5_5.INIT = 1'b0;
  X_FF state_reg_FFd5_5 (
    .I(state_reg_FFd6),
    .RST(\state_reg_FFd5.GSR.OR ),
    .CLK(clk_BUFGP),
    .O(state_reg_FFd5),
    .CE(VCC),
    .SET(GND)
  );
  X_BUF rst_IBUF_6 (
    .I(rst),
    .O(rst_IBUF)
  );
  X_BUF W_3_OBUF (
    .I(state_reg_FFd3),
    .O(\W_3_OBUF.GTS.TRI )
  );
  X_BUF W_2_OBUF_7 (
    .I(W_2_OBUF),
    .O(\W_2_OBUF.GTS.TRI )
  );
  X_BUF W_1_OBUF_8 (
    .I(W_1_OBUF),
    .O(\W_1_OBUF.GTS.TRI )
  );
  X_BUF W_0_OBUF (
    .I(state_reg_FFd6),
    .O(\W_0_OBUF.GTS.TRI )
  );
  X_IPAD clk_9 (
    .PAD(clk)
  );
  X_IPAD rst_10 (
    .PAD(rst)
  );
  X_OPAD \W<3>  (
    .PAD(W[3])
  );
  X_OPAD \W<2>  (
    .PAD(W[2])
  );
  X_OPAD \W<1>  (
    .PAD(W[1])
  );
  X_OPAD \W<0>  (
    .PAD(W[0])
  );
  X_CKBUF \clk_BUFGP/BUFG  (
    .I(\clk_BUFGP/IBUFG ),
    .O(clk_BUFGP)
  );
  X_CKBUF \clk_BUFGP/IBUFG_11  (
    .I(clk),
    .O(\clk_BUFGP/IBUFG )
  );
  X_OR2 \state_reg_FFd6.GSR.OR_12  (
    .I0(rst_IBUF),
    .I1(GSR),
    .O(\state_reg_FFd6.GSR.OR )
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
  X_OR2 \state_reg_FFd4.GSR.OR_16  (
    .I0(rst_IBUF),
    .I1(GSR),
    .O(\state_reg_FFd4.GSR.OR )
  );
  X_OR2 \state_reg_FFd5.GSR.OR_17  (
    .I0(rst_IBUF),
    .I1(GSR),
    .O(\state_reg_FFd5.GSR.OR )
  );
  X_TRI \W_3_OBUF.GTS.TRI_18  (
    .I(\W_3_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_W_3_OBUF.GTS.TRI/CTL ),
    .O(W[3])
  );
  X_TRI \W_2_OBUF.GTS.TRI_19  (
    .I(\W_2_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_W_2_OBUF.GTS.TRI/CTL ),
    .O(W[2])
  );
  X_TRI \W_1_OBUF.GTS.TRI_20  (
    .I(\W_1_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_W_1_OBUF.GTS.TRI/CTL ),
    .O(W[1])
  );
  X_TRI \W_0_OBUF.GTS.TRI_21  (
    .I(\W_0_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_W_0_OBUF.GTS.TRI/CTL ),
    .O(W[0])
  );
  X_ONE NlwBlock_moore_VCC (
    .O(VCC)
  );
  X_ZERO NlwBlock_moore_GND (
    .O(GND)
  );
  X_INV \NlwInverterBlock_W_3_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_W_3_OBUF.GTS.TRI/CTL )
  );
  X_INV \NlwInverterBlock_W_2_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_W_2_OBUF.GTS.TRI/CTL )
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


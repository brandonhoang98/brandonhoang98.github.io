//------------------------------------------------------------------------------
//  Copyright(C) 2003 by Xilinx, Inc. All rights reserved.
//  This text/file contains proprietary, confidential
//  information of Xilinx, Inc., is distributed under license
//  from Xilinx, Inc., and may be used, copied and/or
//  disclosed only pursuant to the terms of a valid license
//  agreement with Xilinx, Inc.  Xilinx hereby grants you
//  a license to use this text/file solely for design, simulation,
//  implementation and creation of design files limited
//  to Xilinx devices or technologies. Use with non-Xilinx
//  devices or technologies is expressly prohibited and
//  immediately terminates your license unless covered by
//  a separate agreement.
//
//  Xilinx is providing this design, code, or information
//  "as is" solely for use in developing programs and
//  solutions for Xilinx devices.  By providing this design,
//  code, or information as one possible implementation of
//  this feature, application or standard, Xilinx is making no
//  representation that this implementation is free from any
//  claims of infringement.  You are responsible for
//  obtaining any rights you may require for your implementation.
//  Xilinx expressly disclaims any warranty whatsoever with
//  respect to the adequacy of the implementation, including
//  but not limited to any warranties or representations that this
//  implementation is free from claims of infringement, implied
//  warranties of merchantability or fitness for a particular
//  purpose.
//
//  Xilinx products are not intended for use in life support
//  appliances, devices, or systems. Use in such applications are
//  expressly prohibited.
//
//  This copyright and support notice must be retained as part
//  of this text at all times. (c) Copyright 1995-2003 Xilinx, Inc.
//  All rights reserved.
//
// $RCSfile: rs_decoder_unobf_v4_0.v,v $ $Revision: 1.2 $ $Date: 2003/03/26 21:13:45 $
//------------------------------------------------------------------------------

`timescale 1ns/10ps
module RS_DECODER_V4_0(DATA_IN,SYNC,CLK,CE,ERASE,RESET,SR,ERR_CNT,ERR_FOUND,FAIL,BLK_STRT,BLK_END,ERASE_CNT,READY,DATA_OUT,DATA_DEL
);parameter C_CLKS_PER_SYM=1,C_GEN_START=0,C_H=1,C_HAS_CE=0,C_HAS_DATA_DEL=0,C_HAS_ERASE=0,C_HAS_SR=0,C_HUSET="MOD",C_K=188,C_MEMSTYLE=2,C_N=204,
C_OPTIMISATION=0,C_POLYNOMIAL=0,C_SPEC=0,C_SYMBOL_WIDTH=8,C_SYNC_MODE=0,C_USEHUSET=1,C_USERPM=1;
// synopsys_translate_off 
parameter IIIIl00OII0lOOL0010L1OOLOI=C_N-C_K;parameter IOOlO1OlllI111L0I1lL1OLO1l=(IIIIl00OII0lOOL0010L1OOLOI>127)?8:(IIIIl00OII0lOOL0010L1OOLOI>63)?7:(IIIIl00OII0lOOL0010L1OOLOI>31)?6:(IIIIl00OII0lOOL0010L1OOLOI>15)?5:(IIIIl00OII0lOOL0010L1OOLOI>7)?4:(IIIIl00OII0lOOL0010L1OOLOI>3)?3:(IIIIl00OII0lOOL0010L1OOLOI>1)?2
:1;parameter IOI1IlOl1IOL0O0IO01L1lIOOO=(C_N>2047)?12:(C_N>1023)?11:(C_N>511)?10:(C_N>255)?9:(C_N>127)?8:(C_N>63)?7:(C_N>31)?6:(C_N>15)?5:(C_N>7)?4:(C_N>3)?3:(C_N
>1)?2:1;input[C_SYMBOL_WIDTH-1:0]DATA_IN;input SYNC,CLK,CE,ERASE,RESET,SR;output[IOOlO1OlllI111L0I1lL1OLO1l-1:0]ERR_CNT;output[IOI1IlOl1IOL0O0IO01L1lIOOO-1:0]ERASE_CNT;output
 ERR_FOUND,FAIL,BLK_STRT,BLK_END,READY;output[C_SYMBOL_WIDTH-1:0]DATA_OUT;output[C_SYMBOL_WIDTH-1:0]DATA_DEL;parameter IIl0II0O0LII0LlLlIl1LO1O0I=1;parameter IOO1ILIL10LLl0IO0O01OII000=C_N-
C_K;parameter IO1OI1LOIIllIlI00IIlIOI1LO=IOO1ILIL10LLl0IO0O01OII000/2;parameter IIlLlLL1O1l0I0Ll0lLILlIOO1={C_SYMBOL_WIDTH{1'b0}};parameter IO10IIlO0III0LO01lLI0L1I10=(C_SPEC==1)?1'b1:1'b0;parameter IIlLLL10LllllLO0I1ILIIIO0L=(1<<C_SYMBOL_WIDTH)-1;parameter
 IIIl11l1OlLLLO1OLIO01lLl01=(C_HAS_ERASE==0)?((IO1OI1LOIIllIlI00IIlIOI1LO*IO1OI1LOIIllIlI00IIlIOI1LO)+2*(3*IO1OI1LOIIllIlI00IIlIOI1LO+((IO1OI1LOIIllIlI00IIlIOI1LO+1)*(IO1OI1LOIIllIlI00IIlIOI1LO+2)/2))+2)/C_CLKS_PER_SYM+((C_CLKS_PER_SYM>1)?1:0):((3*IOO1ILIL10LLl0IO0O01OII000)+2*(((IOO1ILIL10LLl0IO0O01OII000+1)*(IOO1ILIL10LLl0IO0O01OII000+2)/2))+3)/
C_CLKS_PER_SYM+((C_CLKS_PER_SYM>1)?1:0);parameter IILL10000OllL0OI1lLI0I0IO0=IIIl11l1OlLLLO1OLIO01lLl01+C_N+((C_SYMBOL_WIDTH==8)?6:5)-((C_CLKS_PER_SYM>1)?1:0);parameter
 IIO1lL0IOL000IOOl11IL11IlI=(IO10IIlO0III0LO01lLI0L1I10==1'b1)?IILL10000OllL0OI1lLI0I0IO0-1:IILL10000OllL0OI1lLI0I0IO0-3;parameter IOOLLI0OlILIOIO10lIlL11L1O=(IO10IIlO0III0LO01lLI0L1I10==1'b1)?IILL10000OllL0OI1lLI0I0IO0-(C_N+1):IILL10000OllL0OI1lLI0I0IO0-(C_N+2);parameter IO1L000LOl0OIOOlLO11IILlIO=(IO10IIlO0III0LO01lLI0L1I10
==1'b1)?IILL10000OllL0OI1lLI0I0IO0:IILL10000OllL0OI1lLI0I0IO0-2;parameter II0000OII1l1LLLOI1LL0Ll1OO=(IO10IIlO0III0LO01lLI0L1I10==1'b1)?IILL10000OllL0OI1lLI0I0IO0+1:IILL10000OllL0OI1lLI0I0IO0-1;parameter IOI1L1I1OlLLOO1I1l011l0I1l=(IO10IIlO0III0LO01lLI0L1I10==1'b1)?C_N-IILL10000OllL0OI1lLI0I0IO0-1:C_N-IILL10000OllL0OI1lLI0I0IO0+1;
parameter IOO0LOILl1lO0I1010L0LOI00O=C_SYMBOL_WIDTH-2;parameter IIL10OOIlIIL1lOIOLOllOOILl=C_SYMBOL_WIDTH-1;parameter II0O1l1lOLl01LO1O0LI1OLlOI=IIIl11l1OlLLLO1OLIO01lLl01-C_N;parameter IIII0Ll1l1OI010L1llLll1L0L=(
IO10IIlO0III0LO01lLI0L1I10==1'b1)?IILL10000OllL0OI1lLI0I0IO0+1:IILL10000OllL0OI1lLI0I0IO0-1;parameter IOLOIL0I0lIL0I0lO11IOL1110=(C_HAS_ERASE==0)?IO1OI1LOIIllIlI00IIlIOI1LO:IOO1ILIL10LLl0IO0O01OII000;parameter II0I1OL0IOll111L0llLI10IL1=IOLOIL0I0lIL0I0lO11IOL1110-1;parameter IOOlI0l1lIO1llOIL00LLIL101=12;
integer i;integer index_last;reg[C_SYMBOL_WIDTH-1:0]data_out_shift[IILL10000OllL0OI1lLI0I0IO0-C_N:0];reg shift_cnt;reg sync_bit;reg flag_funny;reg flag_funnv;reg
 flag_funny_d;reg flag_funnv_d;reg funnv_shift[IILL10000OllL0OI1lLI0I0IO0+1:0];reg funny_shift[IILL10000OllL0OI1lLI0I0IO0+1:0];wire FAIL;reg fail_out;wire ERR_FOUND;reg err_found_out;wire[
IOOlO1OlllI111L0I1lL1OLO1l-1:0]ERR_CNT;reg[IOOlO1OlllI111L0I1lL1OLO1l-1:0]err_cnt_out;wire[IOI1IlOl1IOL0O0IO01L1lIOOO-1:0]ERASE_CNT;reg[IOI1IlOl1IOL0O0IO01L1lIOOO-1:0]erase_cnt_out;wire BLK_STRT;reg
 blk_strt_out;wire BLK_END;reg blk_end_out;wire READY;reg ready_out;wire[C_SYMBOL_WIDTH-1:0]DATA_OUT;reg[C_SYMBOL_WIDTH-1:0]data_out_out;reg[
C_SYMBOL_WIDTH-1:0]data_del_out;reg[C_SYMBOL_WIDTH-1:0]data_out_db;reg[C_SYMBOL_WIDTH-1:0]data_out_db_var;reg[C_SYMBOL_WIDTH-1:0]data_del_db;reg ce_d;
reg[C_SYMBOL_WIDTH-1:0]data_in_d;wire[C_SYMBOL_WIDTH-1:0]data_in_d_sig;reg[C_SYMBOL_WIDTH-1:0]data_in_db;reg[C_SYMBOL_WIDTH-1:0]data_in_d_var;reg[
C_SYMBOL_WIDTH-1:0]gf_field[-1:(1<<C_SYMBOL_WIDTH)-2];reg start;reg sr_flag;reg sr_d;integer sym_clk;integer gf_ap[0:(1<<C_SYMBOL_WIDTH)-1];integer
 r_ap[C_N-1:0];integer reset_cnt;integer reset_high_cnt;integer input_count;integer sym_int[C_N-1:0];integer errors[C_N-1:0];integer symbol_corrected[
C_N-1:0];integer lambda_var[IOLOIL0I0lIL0I0lO11IOL1110:0];integer corrected_message[C_N-1:0];integer b_var[IOLOIL0I0lIL0I0lO11IOL1110:0];integer temp_poly[IOLOIL0I0lIL0I0lO11IOL1110:0];
integer temp7;integer discrep;integer temp;integer temp2;integer temp3;integer temp4;integer delta;integer gamma;integer l;integer num_errors_var;
integer num_erasures;integer deg_cnt;integer index_var;integer temp8;integer omega_var[II0I1OL0IOll111L0llLI10IL1:0];integer erase_locator[IOO1ILIL10LLl0IO0O01OII000:0];integer error_locator
[IOLOIL0I0lIL0I0lO11IOL1110:0];integer error_evaluator[II0I1OL0IOll111L0llLI10IL1:0];integer lambda_diff_var[IOLOIL0I0lIL0I0lO11IOL1110:0];integer deg_lambda;integer deg_omega;integer
 reciprocal;integer lambda_value;integer lambda_diff_value;integer omega_value;integer substitute;integer index_out;integer ready_dc;integer index;
integer gf_int;integer p;integer scaler;integer j;integer z;reg[C_SYMBOL_WIDTH-1:0]code_buff_in[IILL10000OllL0OI1lLI0I0IO0:0];reg blk_strt_shift[IILL10000OllL0OI1lLI0I0IO0:0];reg
 blk_strt_sig;reg blk_end_shift[IILL10000OllL0OI1lLI0I0IO0:0];reg blk_end_sig;reg erase_d;wire erase_d_sig;reg erase_db;reg[IOI1IlOl1IOL0O0IO01L1lIOOO-1:0]erase_cnt_shift[IILL10000OllL0OI1lLI0I0IO0:0
];reg[IOI1IlOl1IOL0O0IO01L1lIOOO-1:0]erase_cnt_sig;reg[IOOlO1OlllI111L0I1lL1OLO1l-1:0]err_cnt_sig;reg[IOOlO1OlllI111L0I1lL1OLO1l-1:0]err_cnt_shift[IILL10000OllL0OI1lLI0I0IO0:0];reg err_found_sig;reg
 err_found_shift[IILL10000OllL0OI1lLI0I0IO0:0];reg fail_sig;reg fail_shift[IILL10000OllL0OI1lLI0I0IO0:0];reg sync_db;reg sync_d;reg sync_dd;wire sync_d_sig;integer syndromes[(C_N-C_K)-1:0];
reg pwr_on_reset;reg[7:0]db_to_normal[255:0];reg[7:0]normal_to_db[255:0];initial begin#1;gen_field;gen_ap;if(IO10IIlO0III0LO01lLI0L1I10==1'b1)begin gen_db_roms;end
 power_on_reset;pwr_on_reset<=1;#1 pwr_on_reset<=0;end task power_on_reset;begin data_in_db<=IIlLlLL1O1l0I0Ll0lLILlIOO1;data_out_db<=IIlLlLL1O1l0I0Ll0lLILlIOO1;data_del_db<=IIlLlLL1O1l0I0Ll0lLILlIOO1;
data_out_out<=IIlLlLL1O1l0I0Ll0lLILlIOO1;data_del_out<=IIlLlLL1O1l0I0Ll0lLILlIOO1;err_cnt_out<=0;err_found_out<=0;erase_cnt_out<=0;fail_out<=0;fail_sig<=0;blk_strt_out<=0;blk_strt_sig<=0;
blk_end_out<=0;blk_end_sig<=0;ready_out<=1;reset_cnt<=0;reset_high_cnt<=0;input_count<=-1;index<=-1;err_found_sig<=0;fail_sig<=0;start<=0;index_out<=0
;index_last<=0;sym_clk<=0;flag_funny<=0;flag_funnv<=0;flag_funny_d<=0;flag_funnv_d<=0;reset_code_buf;end endtask task calc_db_array;input[63:0]
conv_bit_array;inout[2047:0]basis_contents;reg[7:0]and_val;reg[7:0]comp_val;reg[8:0]sym;reg[4:0]j,k,bit;begin basis_contents={2048{1'b0}};for(sym=0;sym
<256;sym=sym+1)begin for(j=0;j<8;j=j+1)begin for(k=0;k<8;k=k+1)begin comp_val=1<<k;if(sym[k]==1'b1&&comp_val[k]==1'b1)begin and_val=1<<j;for(bit=0;bit
<8;bit=bit+1)basis_contents[(sym*8)+bit]=basis_contents[(sym*8)+bit]^(conv_bit_array[((7-k)*8)+bit]&and_val[bit]);end end end end end endtask task
 gen_db_roms;reg[63:0]ccsds_basis_conv;reg[2047:0]db_array;reg[7:0]db_symbol;integer i,bit;begin ccsds_basis_conv={8'd123,8'd175,8'd153,8'd250,8'd134,
8'd236,8'd239,8'd141};calc_db_array(ccsds_basis_conv,db_array);for(i=0;i<256;i=i+1)begin for(bit=0;bit<8;bit=bit+1)db_symbol[bit]=db_array[i*8+bit];
normal_to_db[i]=db_symbol;end ccsds_basis_conv={8'd204,8'd172,8'd121,8'd240,8'd253,8'd46,8'd66,8'd197};calc_db_array(ccsds_basis_conv,db_array);for(i=0
;i<256;i=i+1)begin for(bit=0;bit<8;bit=bit+1)db_symbol[bit]=db_array[i*8+bit];db_to_normal[i]=db_symbol;end end endtask task gen_field;integer use_poly
;reg shift_out;reg[IIL10OOIlIIL1lOIOLOllOOILl:0]field_poly;reg[IIL10OOIlIIL1lOIOLOllOOILl:0]gfelement;integer i,j;integer field;begin if(C_POLYNOMIAL==0)begin if(
C_SYMBOL_WIDTH==12)use_poly=4179;if(C_SYMBOL_WIDTH==11)use_poly=2053;if(C_SYMBOL_WIDTH==10)use_poly=1033;if(C_SYMBOL_WIDTH==9)use_poly=529;if(
C_SYMBOL_WIDTH==8)use_poly=285;if(C_SYMBOL_WIDTH==7)use_poly=137;if(C_SYMBOL_WIDTH==6)use_poly=67;if(C_SYMBOL_WIDTH==5)use_poly=37;if(C_SYMBOL_WIDTH==4
)use_poly=19;if(C_SYMBOL_WIDTH==3)use_poly=11;if(C_SYMBOL_WIDTH==2)use_poly=7;if(C_SYMBOL_WIDTH==1)use_poly=0;if(C_SYMBOL_WIDTH==0)use_poly=0;end else
 use_poly=C_POLYNOMIAL;gfelement=0;field=(1<<(IIL10OOIlIIL1lOIOLOllOOILl+1))-1;for(i=0;i<=field;i=i+1)begin shift_out=gfelement[IIL10OOIlIIL1lOIOLOllOOILl];gfelement={
gfelement[IOO0LOILl1lO0I1010L0LOI00O:0],1'b0};if(i==1)begin gfelement=0;gfelement[0]=1;end else if(shift_out==1)begin gfelement=gfelement^use_poly;end gf_field[i-1
]=gfelement;end gf_field[-1]=0;end endtask task gen_ap;reg shift_out;reg[IIL10OOIlIIL1lOIOLOllOOILl:0]field_poly;reg[IIL10OOIlIIL1lOIOLOllOOILl:0]gfelement;integer i,j,num;
integer field;integer use_poly;begin if(C_POLYNOMIAL==0)begin if(C_SYMBOL_WIDTH==12)use_poly=4179;if(C_SYMBOL_WIDTH==11)use_poly=2053;if(C_SYMBOL_WIDTH
==10)use_poly=1033;if(C_SYMBOL_WIDTH==9)use_poly=529;if(C_SYMBOL_WIDTH==8)use_poly=285;if(C_SYMBOL_WIDTH==7)use_poly=137;if(C_SYMBOL_WIDTH==6)use_poly
=67;if(C_SYMBOL_WIDTH==5)use_poly=37;if(C_SYMBOL_WIDTH==4)use_poly=19;if(C_SYMBOL_WIDTH==3)use_poly=11;if(C_SYMBOL_WIDTH==2)use_poly=7;if(
C_SYMBOL_WIDTH==1)use_poly=0;if(C_SYMBOL_WIDTH==0)use_poly=0;end else use_poly=C_POLYNOMIAL;gfelement=0;field=(1<<(IIL10OOIlIIL1lOIOLOllOOILl+1))-1;for(i=0;i<=
field;i=i+1)begin shift_out=gfelement[IIL10OOIlIIL1lOIOLOllOOILl];gfelement={gfelement[IOO0LOILl1lO0I1010L0LOI00O:0],1'b0};if(i==1)begin gfelement=0;gfelement[0]=1;end else if
(shift_out==1)gfelement=gfelement^use_poly;num=gfelement;gf_ap[num]=i-1;end end endtask function integer gf_add;input[15:0]a,b;reg[IIL10OOIlIIL1lOIOLOllOOILl:0]
bin_a;reg[IIL10OOIlIIL1lOIOLOllOOILl:0]bin_b;reg[IIL10OOIlIIL1lOIOLOllOOILl:0]result_bin;integer result_int;begin if(a==65535)bin_a=0;else bin_a=gf_field[a];if(b==65535)bin_b
=0;else bin_b=gf_field[b];result_bin=bin_a^bin_b;if(result_bin==0)result_int=0;else result_int=result_bin;gf_add=gf_ap[result_int];end endfunction task
 get_syndromes;integer mult_out[0:IIIIl00OII0lOOL0010L1OOLOI-1];integer syndromes_var[0:IIIIl00OII0lOOL0010L1OOLOI-1];integer j,i;begin for(i=0;i<=IIIIl00OII0lOOL0010L1OOLOI-1;i=i+1)syndromes_var[i]=-1;for(i
=C_N-1;i>=0;i=i-1)begin for(j=IIIIl00OII0lOOL0010L1OOLOI-1;j>=0;j=j-1)begin mult_out[j]=gf_mult(C_H*(j+C_GEN_START),syndromes_var[j]);syndromes_var[j]=gf_add(r_ap[i],
mult_out[j]);end end for(i=0;i<=IIIIl00OII0lOOL0010L1OOLOI-1;i=i+1)syndromes[i]=syndromes_var[i];end endtask task update_erase_locator;begin for(i=C_N-C_K;i>0;i=i-1)
erase_locator[i]=gf_add(erase_locator[i],gf_mult(erase_locator[i-1],(C_H*index_var)%IIlLLL10LllllLO0I1ILIIIO0L));erase_locator[0]=0;end endtask function integer gf_mult;
input[15:0]a;input[15:0]b;integer result_var;integer field;begin field=(1<<(IIL10OOIlIIL1lOIOLOllOOILl+1))-1;if(a==65535)result_var=-1;else if(b==65535)result_var
=-1;else begin result_var=a+b;while(result_var>(field-1))result_var=result_var-field;end gf_mult=result_var;end endfunction task init_erase_locator;
integer i1;begin for(i1=C_N-C_K;i1>0;i1=i1-1)erase_locator[i1]=-1;erase_locator[0]=0;end endtask task reset_proc3;integer i;begin for(i=C_N-1;i>=0;i=i
-1)begin errors[i]=-1;symbol_corrected[i]=-1;corrected_message[i]=-1;end for(i=IOLOIL0I0lIL0I0lO11IOL1110;i>=0;i=i-1)begin lambda_var[i]=-1;b_var[i]=-1;temp_poly[i
]=-1;error_locator[i]=-1;lambda_diff_var[i]=-1;end for(i=II0I1OL0IOll111L0llLI10IL1;i>=0;i=i-1)begin omega_var[i]=-1;error_evaluator[i]=-1;end for(i=IIIIl00OII0lOOL0010L1OOLOI-1;i>=0;i
=i-1)syndromes[i]=-1;sync_dd<=0;deg_lambda=0;deg_omega=0;reciprocal=-1;lambda_value=-1;lambda_diff_value=-1;omega_value=-1;substitute=-1;num_errors_var
=0;num_erasures=0;discrep=-1;temp=-1;temp2=-1;temp3=-1;temp4=-1;temp7=-1;temp8=-1;delta=-1;gamma=-1;l=0;deg_cnt=0;err_cnt_out<=0;err_cnt_sig<=0;if(
C_HAS_ERASE!=0)begin erase_cnt_out<=0;erase_cnt_sig<=0;end err_found_out<=0;err_found_sig<=0;fail_out<=0;fail_sig<=0;blk_strt_out<=0;blk_strt_sig<=0;
blk_end_out<=0;blk_end_sig<=0;ready_out<=1;ready_dc=0;index<=-1;input_count<=-1;init_erase_locator;end endtask task reset_proc2;integer i;begin for(i=
C_N-1;i>=0;i=i-1)begin sym_int[i]=0;r_ap[i]=-1;errors[i]=-1;symbol_corrected[i]=-1;corrected_message[i]=-1;end for(i=IOLOIL0I0lIL0I0lO11IOL1110;i>=0;i=i-1)begin
 lambda_var[i]=-1;b_var[i]=-1;temp_poly[i]=-1;error_locator[i]=-1;lambda_diff_var[i]=-1;end for(i=II0I1OL0IOll111L0llLI10IL1;i>=0;i=i-1)begin omega_var[i]=-1;
error_evaluator[i]=-1;end for(i=IIIIl00OII0lOOL0010L1OOLOI-1;i>=0;i=i-1)syndromes[i]=-1;sync_dd<=0;deg_lambda=0;deg_omega=0;reciprocal=-1;lambda_value=-1;
lambda_diff_value=-1;omega_value=-1;substitute=-1;num_errors_var=0;num_erasures=0;discrep=-1;temp=-1;temp2=-1;temp3=-1;temp4=-1;temp7=-1;temp8=-1;delta
=-1;gamma=-1;l=0;deg_cnt=0;index_var=0;data_out_out<=0;if(C_HAS_DATA_DEL!=0)data_del_out<=0;if(C_HAS_ERASE!=0)begin erase_cnt_out<=0;erase_cnt_sig<=0;
end err_cnt_out<=0;err_cnt_sig<=0;err_found_out<=0;err_found_sig<=0;fail_out<=0;fail_sig<=0;blk_strt_out<=0;blk_strt_sig<=0;blk_end_out<=0;blk_end_sig
<=0;ready_out<=1;ready_dc=0;index<=-1;index_out<=0;input_count<=-1;init_erase_locator;for(i=0;i<=IILL10000OllL0OI1lLI0I0IO0+1;i=i+1)begin funnv_shift[i]<=1'b0;funny_shift
[i]<=1'b0;end end endtask task reset_code_buf;integer i;begin for(i=0;i<=IILL10000OllL0OI1lLI0I0IO0;i=i+1)code_buff_in[i]<=0;end endtask task reset_proc;begin ce_d<=0;
erase_d<=0;data_in_d<=0;sync_d<=0;sync_db<=0;start<=0;end endtask assign#(IIl0II0O0LII0LlLlIl1LO1O0I)ERR_CNT=err_cnt_out;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)ERR_FOUND=err_found_out
;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)FAIL=fail_out;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)BLK_STRT=blk_strt_out;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)BLK_END=blk_end_out;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)ERASE_CNT
=erase_cnt_out;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)READY=ready_out;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)DATA_OUT=data_out_out;assign#(IIl0II0O0LII0LlLlIl1LO1O0I)DATA_DEL=data_del_out;always@(CLK
 or posedge RESET or pwr_on_reset)begin if(RESET||pwr_on_reset)begin sync_bit<=0;sym_clk<=0;flag_funny<=0;flag_funnv<=0;flag_funny_d<=0;flag_funnv_d<=0
;end else if(C_CLKS_PER_SYM==1)begin flag_funny<=0;flag_funnv<=0;end else begin if(CLK)begin sync_bit<=SYNC;if(sync_bit==0&&SYNC==1)begin if(sym_clk!=0
)begin if(input_count!=-1)begin if(input_count<IILL10000OllL0OI1lLI0I0IO0-1)$display(
"** Warning in %m at %dns. Resynchronization before code word output! Accuracy of model not guaranteed. Expect erroneous behavior in real circuit!",$time
);end end if(sym_clk==C_CLKS_PER_SYM-2)begin if(C_CLKS_PER_SYM==2)flag_funnv<=0;else flag_funny<=1;end else if(sym_clk==C_CLKS_PER_SYM-1&&(CE==1||
C_HAS_CE==0))flag_funnv<=1;else flag_funnv<=0;if(ce_d==1||C_HAS_CE==0)begin sym_clk<=1;end end else begin flag_funny<=0;if(sym_clk==C_CLKS_PER_SYM-1&&(
CE==1||C_HAS_CE==0))flag_funnv<=0;if(sym_clk==C_CLKS_PER_SYM-1)sym_clk<=0;else sym_clk<=sym_clk+1;end end end end always@(CLK or posedge RESET or
 pwr_on_reset)begin if(RESET||pwr_on_reset)begin reset_proc;if(IO10IIlO0III0LO01lLI0L1I10==1'b0)code_buff_in[0]<=0;else begin code_buff_in[IILL10000OllL0OI1lLI0I0IO0]<=0;end if(C_HAS_CE==0)
begin@(RESET or pwr_on_reset or posedge CLK)if((RESET||pwr_on_reset)&&CLK)begin if((sym_clk==C_CLKS_PER_SYM-1)||flag_funny||(C_CLKS_PER_SYM==1))begin
 if(IO10IIlO0III0LO01lLI0L1I10==1'b0)for(i=0;i<=IILL10000OllL0OI1lLI0I0IO0-1;i=i+1)code_buff_in[i+1]<=code_buff_in[i];else begin for(i=0;i<IILL10000OllL0OI1lLI0I0IO0-1;i=i+1)code_buff_in[i+1]<=code_buff_in[i];
code_buff_in[0]<=db_to_normal[data_in_d];end end end else if(RESET==0)begin start<=1;end end end else begin start<=1;if(CLK)begin if((sym_clk==
C_CLKS_PER_SYM-1)||flag_funny||(C_CLKS_PER_SYM==1))begin data_in_d<=DATA_IN;sync_d<=SYNC;ce_d<=CE;sr_d<=SR;if(C_HAS_ERASE!=0)erase_d<=ERASE;if(IO10IIlO0III0LO01lLI0L1I10==
1'b0)code_buff_in[0]<=DATA_IN;if(ce_d==1||C_HAS_CE==0)begin if(sr_d==1&&C_HAS_SR==1)sync_db<=0;else sync_db<=sync_d;if(IO10IIlO0III0LO01lLI0L1I10==1'b1)begin data_in_d_var
=db_to_normal[data_in_d];code_buff_in[0]<=data_in_d_var;data_in_db<=data_in_d_var;if(C_HAS_ERASE!=0)erase_db<=erase_d;end for(i=0;i<=IILL10000OllL0OI1lLI0I0IO0-1;i=i+1)
code_buff_in[i+1]<=code_buff_in[i];end end end end end assign data_in_d_sig=(IO10IIlO0III0LO01lLI0L1I10==1'b1)?data_in_db:data_in_d;assign sync_d_sig=(IO10IIlO0III0LO01lLI0L1I10==1'b1)?sync_db
:sync_d;assign erase_d_sig=(IO10IIlO0III0LO01lLI0L1I10==1'b1)?erase_db:erase_d;always@(CLK or RESET or pwr_on_reset)begin if(RESET||pwr_on_reset)begin reset_proc2;reset_cnt
<=C_N;if(C_HAS_CE==0)begin@(RESET or pwr_on_reset or posedge CLK)if((RESET||pwr_on_reset)&&CLK)begin if((sym_clk==C_CLKS_PER_SYM-1)||flag_funny||(
C_CLKS_PER_SYM==1))begin data_out_db<=code_buff_in[IILL10000OllL0OI1lLI0I0IO0];data_del_db<=code_buff_in[IILL10000OllL0OI1lLI0I0IO0];end end end end else begin if(start)begin if(CLK==1)
begin if(ce_d==1||C_HAS_CE==0)begin if((sym_clk==C_CLKS_PER_SYM-1)||(flag_funny==1)||(C_CLKS_PER_SYM==1))begin if(sr_d==1&&C_HAS_SR==1)begin
 reset_proc3;index<=-1;sr_flag=1;if(IO10IIlO0III0LO01lLI0L1I10==1'b1)begin data_out_out<=normal_to_db[data_out_db];if(reset_high_cnt>1)begin data_out_db<=code_buff_in[
IILL10000OllL0OI1lLI0I0IO0];end else begin data_out_db<=data_out_shift[0];end if(C_HAS_DATA_DEL!=0)begin data_del_out<=normal_to_db[data_del_db];data_del_db<=code_buff_in
[IILL10000OllL0OI1lLI0I0IO0];end end else begin if(reset_high_cnt>0)begin data_out_out<=code_buff_in[IILL10000OllL0OI1lLI0I0IO0-1];end else begin data_out_out<=data_out_shift[0];end if(
C_HAS_DATA_DEL!=0)data_del_out<=code_buff_in[IILL10000OllL0OI1lLI0I0IO0-1];end if(index_out>0)index_out<=index_out-1;reset_cnt<=C_N;reset_high_cnt<=reset_high_cnt+1;end
 else begin reset_high_cnt<=0;if(CE==1||C_HAS_CE==0)flag_funny_d<=flag_funny;flag_funnv_d<=flag_funnv;if(flag_funnv==1&&flag_funnv_d==0)funnv_shift[0]
<=1;else funnv_shift[0]<=0;if((flag_funny==1)&&(flag_funny_d==0)&&((CE==1)||C_HAS_CE==0))funny_shift[0]<=1;else funny_shift[0]<=0;for(i=0;i<=IILL10000OllL0OI1lLI0I0IO0;i
=i+1)begin funnv_shift[i+1]<=funnv_shift[i];funny_shift[i+1]<=funny_shift[i];end if((index==0)&&(index_out==0))index_out<=C_N-1;else begin if(index_out
>0)index_out<=index_out-1;else index_out<=0;end if(IO10IIlO0III0LO01lLI0L1I10==1'b1)begin if((flag_funnv_d==0)&&(funny_shift[1]==0))sync_dd<=sync_d_sig;end else begin if((
flag_funnv==0)&&(flag_funny_d==0))sync_dd<=sync_d_sig;end if(index_out==0)sr_flag=0;if(reset_cnt<=-2000000000)reset_cnt<=reset_cnt;else reset_cnt<=
reset_cnt-1;if((sync_dd==0)&&(sync_d_sig==1))begin index_var=C_N-1;if(((IO10IIlO0III0LO01lLI0L1I10==1'b0)&&(!(flag_funnv_d==0&&flag_funnv==1)&&!(flag_funny_d==1)))||((IO10IIlO0III0LO01lLI0L1I10
==1'b1)&&(flag_funnv_d==0&&funny_shift[1]==0)))begin blk_strt_sig<=1;input_count<=1;end init_erase_locator;num_erasures=0;end else begin if(index>=0)
index_var=index;else index_var=0;blk_strt_sig<=0;if(!(sync_dd==0&&sync_d==1)||(IO10IIlO0III0LO01lLI0L1I10==1'b0))begin if(input_count>-1&&input_count<2000000000)input_count
<=input_count+1;end end fail_out<=fail_shift[0];err_found_out<=err_found_shift[0];err_cnt_out<=err_cnt_shift[0];blk_strt_out<=blk_strt_shift[0];
blk_end_out<=blk_end_shift[0];if(C_HAS_ERASE!=0)erase_cnt_out<=erase_cnt_shift[0];gf_int=data_in_d_sig;r_ap[index_var]=gf_ap[gf_int];if(reset_cnt>
IOI1L1I1OlLLOO1I1l011l0I1l)begin if(IO10IIlO0III0LO01lLI0L1I10==1'b1)begin if(reset_cnt<=C_N)begin data_out_db_var=code_buff_in[IILL10000OllL0OI1lLI0I0IO0];end else begin data_out_db_var=data_out_shift[0];
end end else data_out_db_var=code_buff_in[IILL10000OllL0OI1lLI0I0IO0-1];end else if(funnv_shift[IO1L000LOl0OIOOlLO11IILlIO]==1||funny_shift[II0000OII1l1LLLOI1LL0Ll1OO]==1)data_out_db_var=
code_buff_in[IILL10000OllL0OI1lLI0I0IO0-1];else data_out_db_var=data_out_shift[0];if(IO10IIlO0III0LO01lLI0L1I10==1'b1)begin data_out_out<=normal_to_db[data_out_db];data_out_db<=
data_out_db_var;if(C_HAS_DATA_DEL!=0)begin data_del_out<=normal_to_db[data_del_db];data_del_db<=code_buff_in[IILL10000OllL0OI1lLI0I0IO0];end end else begin data_out_out
<=data_out_db_var;if(C_HAS_DATA_DEL!=0)data_del_out<=code_buff_in[IILL10000OllL0OI1lLI0I0IO0-1];end if(erase_d_sig==1)begin update_erase_locator;num_erasures=num_erasures
+1;end if(II0O1l1lOLl01LO1O0LI1OLlOI>0)begin if(((IO10IIlO0III0LO01lLI0L1I10==1'b1&&index==2)||(IO10IIlO0III0LO01lLI0L1I10==1'b0&&index==1))&&sync_d==0)ready_dc=II0O1l1lOLl01LO1O0LI1OLlOI;if(ready_dc>0)ready_out<=0;else
 ready_out<=1;ready_dc=ready_dc-1;end else ready_out<=1;if(index==0&&index_out==0)begin if(sr_flag==0||C_HAS_SR==0)get_syndromes;temp=0;temp2=0;temp3=0
;temp4=0;temp7=0;temp8=0;gamma=0;num_errors_var=0;l=num_erasures;for(i=IOLOIL0I0lIL0I0lO11IOL1110;i>=0;i=i-1)begin lambda_var[i]=erase_locator[i];b_var[i]=
erase_locator[i];end for(i=1+num_erasures;i<=IIIIl00OII0lOOL0010L1OOLOI;i=i+1)begin discrep=-1;for(j=0;j<=(i-1);j=j+1)begin if(j<=IOLOIL0I0lIL0I0lO11IOL1110)begin temp=gf_mult(
lambda_var[j],syndromes[i-1-j]);discrep=gf_add(discrep,temp);end end if((discrep!=-1)&&(2*l<=i-1+num_erasures))delta=1;else delta=0;for(j=IOLOIL0I0lIL0I0lO11IOL1110
;j>=0;j=j-1)begin if(j==0)temp2=-1;else temp2=gf_mult(b_var[j-1],discrep);temp3=gf_mult(lambda_var[j],gamma);temp_poly[j]=gf_add(temp3,temp2);end for(j
=IOLOIL0I0lIL0I0lO11IOL1110;j>=0;j=j-1)begin if(delta==1)b_var[j]=lambda_var[j];else if(delta==0)begin if(j==0)b_var[j]=-1;else b_var[j]=b_var[j-1];end end for(z=0
;z<=IOLOIL0I0lIL0I0lO11IOL1110;z=z+1)lambda_var[z]=temp_poly[z];if(delta==1)begin gamma=discrep;l=i+num_erasures-l;end end for(i=0;i<=II0I1OL0IOll111L0llLI10IL1;i=i+1)begin
 omega_var[i]=-1;for(j=0;j<=i;j=j+1)begin temp4=gf_mult(lambda_var[j],syndromes[i-j]);omega_var[i]=gf_add(omega_var[i],temp4);end end for(z=0;z<=
II0I1OL0IOll111L0llLI10IL1;z=z+1)error_evaluator[z]=omega_var[z];for(z=0;z<=IOLOIL0I0lIL0I0lO11IOL1110;z=z+1)error_locator[z]=lambda_var[z];deg_cnt=l;for(z=0;z<=IOLOIL0I0lIL0I0lO11IOL1110;z=z
+1)lambda_diff_var[z]=error_locator[z];for(i=0;i<=IOLOIL0I0lIL0I0lO11IOL1110;i=i+1)begin if(i%2==0)lambda_diff_var[i]=-1;end for(i=C_N-1;i>=0;i=i-1)begin deg_lambda
=IOLOIL0I0lIL0I0lO11IOL1110;deg_omega=II0I1OL0IOll111L0llLI10IL1;lambda_value=-1;lambda_diff_value=-1;omega_value=-1;if(i==0)reciprocal=0;else reciprocal=IIlLLL10LllllLO0I1ILIIIO0L-i;reciprocal=(C_H
*reciprocal)%IIlLLL10LllllLO0I1ILIIIO0L;while(deg_lambda>=0)begin substitute=0;for(j=deg_lambda;j>=1;j=j-1)substitute=gf_mult(substitute,reciprocal);temp7=gf_mult(
substitute,lambda_diff_var[deg_lambda]);temp8=gf_mult(substitute,error_locator[deg_lambda]);lambda_diff_value=gf_add(lambda_diff_value,temp7);
lambda_value=gf_add(lambda_value,temp8);deg_lambda=deg_lambda-1;end while(deg_omega>=0)begin substitute=0;for(j=deg_omega;j>=1;j=j-1)substitute=gf_mult
(substitute,reciprocal);temp7=gf_mult(substitute,error_evaluator[deg_omega]);omega_value=gf_add(omega_value,temp7);deg_omega=deg_omega-1;end scaler=C_H
*i*(-C_GEN_START);while(scaler<0)begin scaler=scaler+(1<<C_SYMBOL_WIDTH)-1;end omega_value=gf_mult(omega_value,scaler);if(lambda_value==-1)begin
 num_errors_var=num_errors_var+1;if(lambda_diff_value==0)reciprocal=0;else if(lambda_diff_value==-1)reciprocal=-1;else reciprocal=IIlLLL10LllllLO0I1ILIIIO0L-
lambda_diff_value;errors[i]=gf_mult(omega_value,reciprocal);symbol_corrected[i]=1;end else begin errors[i]=-1;symbol_corrected[i]=0;end end if(sr_flag
==0||C_HAS_SR==0)for(i=C_N-1;i>=0;i=i-1)begin corrected_message[i]=gf_add(r_ap[i],errors[i]);sym_int[i]<=gf_field[corrected_message[i]];end else for(i
=C_N-1;i>=0;i=i-1)begin corrected_message[i]=r_ap[i];sym_int[i]<=gf_field[corrected_message[i]];end end else begin index<=index_var-1;end index_last<=
index_out;if(index_out==0&&index==0)begin if(reset_cnt<2)begin err_cnt_sig<=num_errors_var;erase_cnt_sig<=num_erasures;if(deg_cnt!=0)err_found_sig<=1;
else err_found_sig<=0;if((num_errors_var!=deg_cnt)&&(deg_cnt!=-1))fail_sig<=1;else fail_sig<=0;end else begin fail_sig<=0;err_found_sig<=0;end
 blk_end_sig<=1;end else blk_end_sig<=0;end end end end end end end always@(CLK or RESET or pwr_on_reset)begin if(RESET==1||pwr_on_reset)begin if(IO10IIlO0III0LO01lLI0L1I10
==1'b1)data_out_shift[0]=IIlLlLL1O1l0I0Ll0lLILlIOO1;for(i=IIO1lL0IOL000IOOl11IL11IlI;i>=0;i=i-1)begin blk_strt_shift[i]<=0;blk_end_shift[i]<=0;fail_shift[i]<=0;err_found_shift[i]<=0;
err_cnt_shift[i]<=0;erase_cnt_shift[i]<=0;end end else begin if(CLK==1&&(ce_d==1||C_HAS_CE==0))begin if(sym_clk==C_CLKS_PER_SYM-1||flag_funny==1||
C_CLKS_PER_SYM==1)begin if(sr_d&&C_HAS_SR==1)begin for(i=IIO1lL0IOL000IOOl11IL11IlI;i>=0;i=i-1)begin blk_strt_shift[i]<=0;blk_end_shift[i]<=0;fail_shift[i]<=0;
err_found_shift[i]<=0;err_cnt_shift[i]<=0;erase_cnt_shift[i]<=0;end data_out_shift[IOOLLI0OlILIOIO10lIlL11L1O]<=code_buff_in[C_N];for(i=IOOLLI0OlILIOIO10lIlL11L1O;i>0;i=i-1)
data_out_shift[i-1]<=data_out_shift[i];end else begin if(index_out==0&&index_last==0)data_out_shift[IOOLLI0OlILIOIO10lIlL11L1O]<=code_buff_in[C_N];else
 data_out_shift[IOOLLI0OlILIOIO10lIlL11L1O]<=sym_int[index_out];blk_strt_shift[IIO1lL0IOL000IOOl11IL11IlI]<=blk_strt_sig;blk_end_shift[IIO1lL0IOL000IOOl11IL11IlI]<=blk_end_sig;
err_found_shift[IIO1lL0IOL000IOOl11IL11IlI]<=err_found_sig;fail_shift[IIO1lL0IOL000IOOl11IL11IlI]<=fail_sig;err_cnt_shift[IIO1lL0IOL000IOOl11IL11IlI]<=err_cnt_sig;erase_cnt_shift[
IIO1lL0IOL000IOOl11IL11IlI]<=erase_cnt_sig;for(i=IOOLLI0OlILIOIO10lIlL11L1O;i>0;i=i-1)data_out_shift[i-1]<=data_out_shift[i];for(i=IIO1lL0IOL000IOOl11IL11IlI;i>0;i=i-1)begin blk_strt_shift
[i-1]<=blk_strt_shift[i];err_cnt_shift[i-1]<=err_cnt_shift[i];erase_cnt_shift[i-1]<=erase_cnt_shift[i];fail_shift[i-1]<=fail_shift[i];err_found_shift[i
-1]<=err_found_shift[i];blk_end_shift[i-1]<=blk_end_shift[i];end end end end end end
// synopsys_translate_on 
// synthesis attribute GENERATOR_DEFAULT of RS_DECODER_V4_0 is "generatecore com.xilinx.ip.rs_decoder_v4_0.rs_decoder_v4_0" 
// box_type "black_box"  
// synthesis attribute box_type of RS_DECODER_V4_0 is "black_box" 
 endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Behavorial simulation model for parallel Reed-Solomon encoder
//
// File name    : rs_encoder_unobf_v3_0.v
//
// Version      : 3.0
// 
// Copyright 2001 Xilinx, Inc. All rights reserved.
//
// $Id: rs_encoder_unobf_v3_0.v,v 1.4 2002/03/29 16:01:09 janeh Exp $
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
module RS_ENCODER_V3_0(BYPASS,CLK,DATA_IN,DATA_OUT,ENABLE,INFO,RESET,START);parameter C_GEN_START=0;parameter C_H=1;parameter C_K=
188;parameter C_MEMSTYLE=2;parameter C_N=204;parameter C_OPTIMIZATION=1;parameter C_POLYNOMIAL=0;parameter C_SPEC=0;parameter C_SYMBOL_WIDTH=8;
parameter C_USERPM=1;
// synopsys_translate_off 
parameter GEN_START=C_GEN_START;parameter H=C_H;parameter K=C_K;parameter N=C_N;parameter OPTIMIZATION=C_OPTIMIZATION;parameter POLYNOMIAL=C_POLYNOMIAL
;parameter SYMBOL_WIDTH=C_SYMBOL_WIDTH;parameter output_delay=1;input BYPASS;input CLK;input ENABLE;input[(SYMBOL_WIDTH-1):0]DATA_IN;output[(
SYMBOL_WIDTH-1):0]DATA_OUT;output INFO;input RESET;input START;wire[(SYMBOL_WIDTH-1):0]DATA_OUT;wire INFO;reg info_tmp;reg[(SYMBOL_WIDTH-1):0]
data_tmp_out;parameter IIIIl00OII0lOOL0010L1OOLOI=GEN_START;parameter IOOlO1OlllI111L0I1lL1OLO1l=H;parameter IOI1IlOl1IOL0O0IO01L1lIOOO=K;parameter IIl0II0O0LII0LlLlIl1LO1O0I=N;parameter IOO1ILIL10LLl0IO0O01OII000=OPTIMIZATION;parameter IO1OI1LOIIllIlI00IIlIOI1LO=POLYNOMIAL;
parameter IIlLlLL1O1l0I0Ll0lLILlIOO1=SYMBOL_WIDTH;parameter IO10IIlO0III0LO01lLI0L1I10=IIlLlLL1O1l0I0Ll0lLILlIOO1-1;parameter IIlLLL10LllllLO0I1ILIIIO0L=IIl0II0O0LII0LlLlIl1LO1O0I-IOI1IlOl1IOL0O0IO01L1lIOOO;parameter IIIl11l1OlLLLO1OLIO01lLl01=IIlLLL10LllllLO0I1ILIIIO0L-1;parameter IILL10000OllL0OI1lLI0I0IO0=2<<(IIlLlLL1O1l0I0Ll0lLILlIOO1-1);parameter IIO1lL0IOL000IOOl11IL11IlI=IILL10000OllL0OI1lLI0I0IO0-1;parameter IOOLLI0OlILIOIO10lIlL11L1O
=IILL10000OllL0OI1lLI0I0IO0-2;parameter IO1L000LOl0OIOOlLO11IILlIO=IILL10000OllL0OI1lLI0I0IO0-3;parameter II0000OII1l1LLLOI1LL0Ll1OO=OPTIMIZATION-1+(2*C_SPEC);integer i,j,kk;integer default_polynomial[0:12];reg[IO10IIlO0III0LO01lLI0L1I10:0]
field_polynomial;reg[IO10IIlO0III0LO01lLI0L1I10:0]mask;reg[IO10IIlO0III0LO01lLI0L1I10:0]temp;reg[IO10IIlO0III0LO01lLI0L1I10:0]alpha_to[0:IOOLLI0OlILIOIO10lIlL11L1O];reg[IO10IIlO0III0LO01lLI0L1I10:0]index_of[0:IIO1lL0IOL000IOOl11IL11IlI];reg is_primitive;reg[IO10IIlO0III0LO01lLI0L1I10:0]inner_index;
reg[IO10IIlO0III0LO01lLI0L1I10:0]index;reg[IO10IIlO0III0LO01lLI0L1I10:0]lalpha_to;reg[IO10IIlO0III0LO01lLI0L1I10:0]gc[0:IIIl11l1OlLLLO1OLIO01lLl01];reg[IO10IIlO0III0LO01lLI0L1I10:0]symbol_count;reg[IO10IIlO0III0LO01lLI0L1I10:0]data_next;reg[IO10IIlO0III0LO01lLI0L1I10:0]parity_buffer[0:IIIl11l1OlLLLO1OLIO01lLl01];reg
 info_next;reg[IO10IIlO0III0LO01lLI0L1I10:0]data_pipe_in;reg info_pipe_in;reg[IO10IIlO0III0LO01lLI0L1I10:0]data_pipe[0:II0000OII1l1LLLOI1LL0Ll1OO];reg info_pipe[0:II0000OII1l1LLLOI1LL0Ll1OO];parameter
 IOI1L1I1OlLLOO1I1l011l0I1l=1;parameter IOO0LOILl1lO0I1010L0LOI00O=0;parameter IIL10OOIlIIL1lOIOLOllOOILl=0;parameter II0O1l1lOLl01LO1O0LI1OLlOI=1;parameter IIII0Ll1l1OI010L1llLll1L0L=12;reg[IO10IIlO0III0LO01lLI0L1I10:0]normal_to_db[0:IIO1lL0IOL000IOOl11IL11IlI];reg
[IO10IIlO0III0LO01lLI0L1I10:0]db_to_normal[0:IIO1lL0IOL000IOOl11IL11IlI];reg[IO10IIlO0III0LO01lLI0L1I10:0]and_val;reg[IO10IIlO0III0LO01lLI0L1I10:0]i_count;reg[IO10IIlO0III0LO01lLI0L1I10:0]kk_val;reg[IO10IIlO0III0LO01lLI0L1I10:0]ccsds_basis_conv[0:IIII0Ll1l1OI010L1llLll1L0L-1];reg[IO10IIlO0III0LO01lLI0L1I10:0]
ccsds_basis_conv_inv[0:IIII0Ll1l1OI010L1llLll1L0L-1];reg[IO10IIlO0III0LO01lLI0L1I10:0]data_in_sel;reg[IO10IIlO0III0LO01lLI0L1I10:0]data_out_sel;reg parameters_ok;initial begin parameters_ok=1'b1;if(IOI1IlOl1IOL0O0IO01L1lIOOO<1||IOI1IlOl1IOL0O0IO01L1lIOOO
>(IIO1lL0IOL000IOOl11IL11IlI-2))begin parameters_ok=1'b0;$display("ERROR in %m at time %dns: K must be between 1 and (2<<SYMBOL_WIDTH - 3).",$time);end if(IIl0II0O0LII0LlLlIl1LO1O0I<3||IIl0II0O0LII0LlLlIl1LO1O0I>IIO1lL0IOL000IOOl11IL11IlI)
begin parameters_ok=1'b0;$display("ERROR in %m at time %dns: N must be between 3 and (2<<SYMBOL_WIDTH - 1).",$time);end if(IIlLlLL1O1l0I0Ll0lLILlIOO1<3||IIlLlLL1O1l0I0Ll0lLILlIOO1>12)begin
 parameters_ok=1'b0;$display("ERROR in %m at time %dns: SYMBOL_WIDTH must be between 3 and 12.",$time);end else if(IIlLlLL1O1l0I0Ll0lLILlIOO1>8)begin if(IIlLLL10LllllLO0I1ILIIIO0L<2||IIlLLL10LllllLO0I1ILIIIO0L>256)begin
 parameters_ok=1'b0;$display("ERROR in %m at time %dns: Number of stages (N - K) must be between 2 and 256.",$time);end end else begin if(IIlLLL10LllllLO0I1ILIIIO0L<2||IIlLLL10LllllLO0I1ILIIIO0L>
IOOLLI0OlILIOIO10lIlL11L1O)begin parameters_ok=1'b0;$display("ERROR in %m at time %dns: Number of stages (N - K) must be between 2 and (2<<SYMBOL_WIDTH - 1).",$time);end
 end if(IIIIl00OII0lOOL0010L1OOLOI<0)begin parameters_ok=1'b0;$display("ERROR in %m at time %dns: GEN_START must be greater than or equal to 0.",$time);end if(IOOlO1OlllI111L0I1lL1OLO1l==0)begin
 parameters_ok=1'b0;$display("ERROR in %m at time %dns: H must be greater than 0.",$time);end if(IOO1ILIL10LLl0IO0O01OII000<1||IOO1ILIL10LLl0IO0O01OII000>2)begin parameters_ok=
1'b0;$display("ERROR in %m at time %dns: OPTIMIZATION must be set to 1(area) or 2(speed).",$time);end if(parameters_ok==1'b0)begin $stop;end
 default_polynomial[0]=0;default_polynomial[1]=0;default_polynomial[2]=7;default_polynomial[3]=11;default_polynomial[4]=19;default_polynomial[5]=37;
default_polynomial[6]=67;default_polynomial[7]=137;default_polynomial[8]=285;default_polynomial[9]=529;default_polynomial[10]=1033;default_polynomial[
11]=2053;default_polynomial[12]=4179;if(IO1OI1LOIIllIlI00IIlIOI1LO==0)begin field_polynomial=default_polynomial[IIlLlLL1O1l0I0Ll0lLILlIOO1]%IILL10000OllL0OI1lLI0I0IO0;end else begin field_polynomial=IO1OI1LOIIllIlI00IIlIOI1LO%
IILL10000OllL0OI1lLI0I0IO0;end if(field_polynomial==0)begin $display("ERROR in %m at time %dns: No polynomial supplied and no default available for specified symbol width.",
$time);$stop;end ccsds_basis_conv[0]=141;ccsds_basis_conv[1]=239;ccsds_basis_conv[2]=236;ccsds_basis_conv[3]=134;ccsds_basis_conv[4]=250;
ccsds_basis_conv[5]=153;ccsds_basis_conv[6]=175;ccsds_basis_conv[7]=123;ccsds_basis_conv[8]=0;ccsds_basis_conv[9]=0;ccsds_basis_conv[10]=0;
ccsds_basis_conv[11]=0;ccsds_basis_conv_inv[0]=197;ccsds_basis_conv_inv[1]=66;ccsds_basis_conv_inv[2]=46;ccsds_basis_conv_inv[3]=253;
ccsds_basis_conv_inv[4]=240;ccsds_basis_conv_inv[5]=121;ccsds_basis_conv_inv[6]=172;ccsds_basis_conv_inv[7]=204;ccsds_basis_conv_inv[8]=0;
ccsds_basis_conv_inv[9]=0;ccsds_basis_conv_inv[10]=0;ccsds_basis_conv_inv[11]=0;if(C_SPEC==IOI1L1I1OlLLOO1I1l011l0I1l)begin for(i=0;i<=IIO1lL0IOL000IOOl11IL11IlI;i=i+1)begin i_count=i;
normal_to_db[i]=0;db_to_normal[i]=0;for(j=0;j<=IO10IIlO0III0LO01lLI0L1I10;j=j+1)begin and_val=1<<j;for(kk=0;kk<=IO10IIlO0III0LO01lLI0L1I10;kk=kk+1)begin kk_val=1<<kk;if(kk_val[kk]==1&&i_count[kk
]==1)begin normal_to_db[i]=normal_to_db[i]^(ccsds_basis_conv[IO10IIlO0III0LO01lLI0L1I10-kk]&and_val);db_to_normal[i]=db_to_normal[i]^(ccsds_basis_conv_inv[IO10IIlO0III0LO01lLI0L1I10-kk]&and_val);
end end end end end mask={(IO10IIlO0III0LO01lLI0L1I10){1'b0}};mask[0]=1'b1;for(i=0;i<IO10IIlO0III0LO01lLI0L1I10;i=i+1)begin alpha_to[i]=mask;mask=mask<<1;end alpha_to[IO10IIlO0III0LO01lLI0L1I10]=mask;alpha_to[IIlLlLL1O1l0I0Ll0lLILlIOO1]=
field_polynomial;for(j=IIlLlLL1O1l0I0Ll0lLILlIOO1+1;j<IIO1lL0IOL000IOOl11IL11IlI;j=j+1)begin if(alpha_to[j-1]>=mask)begin temp=(alpha_to[j-1]^mask)<<1;alpha_to[j]=alpha_to[IIlLlLL1O1l0I0Ll0lLILlIOO1]^temp;end else begin
 alpha_to[j]=alpha_to[j-1]<<1;end end for(i=0;i<IILL10000OllL0OI1lLI0I0IO0;i=i+1)begin index_of[i]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'b0}};end for(i=0;i<IIO1lL0IOL000IOOl11IL11IlI;i=i+1)begin index_of[alpha_to[i]]=i;end
 is_primitive=1'b1;for(i=2;i<IILL10000OllL0OI1lLI0I0IO0;i=i+1)begin:keep_checking if(index_of[i]==0)begin is_primitive=1'b0;disable keep_checking;end end if(is_primitive==
1'b0)begin $display("ERROR in %m at time %dns: Specified polynomial is not primitive for specified symbol width!",$time);$stop;end gc[0]=alpha_to[(IIIIl00OII0lOOL0010L1OOLOI*IOOlO1OlllI111L0I1lL1OLO1l
)%IIO1lL0IOL000IOOl11IL11IlI];for(i=1;i<IIlLLL10LllllLO0I1ILIIIO0L;i=i+1)begin gc[i]=1;end for(i=2;i<=IIlLLL10LllllLO0I1ILIIIO0L;i=i+1)begin for(j=i-1;j>0;j=j-1)begin inner_index=gc[j];if(inner_index!=0)begin index=(
index_of[inner_index]+(IIIIl00OII0lOOL0010L1OOLOI+i-1)*IOOlO1OlllI111L0I1lL1OLO1l)%IIO1lL0IOL000IOOl11IL11IlI;lalpha_to=alpha_to[index];gc[j]=gc[j-1]^lalpha_to;end else begin gc[j]=gc[j-1];end end inner_index=gc[0];index
=(index_of[inner_index]+(IIIIl00OII0lOOL0010L1OOLOI+i-1)*IOOlO1OlllI111L0I1lL1OLO1l)%IIO1lL0IOL000IOOl11IL11IlI;gc[0]=alpha_to[index];end end task update_parity_buffer;reg[IO10IIlO0III0LO01lLI0L1I10:0]feedback;reg[IO10IIlO0III0LO01lLI0L1I10:0]product;begin feedback
=data_in_sel^parity_buffer[IIIl11l1OlLLLO1OLIO01lLl01];for(i=IIIl11l1OlLLLO1OLIO01lLl01;i>0;i=i-1)begin product=gfmul(gc[i],feedback);parity_buffer[i]=parity_buffer[i-1]^product;end product=
gfmul(gc[0],feedback);parity_buffer[0]=product;end endtask task set_generator_variables_to;input set_value;begin symbol_count={(IIlLlLL1O1l0I0Ll0lLILlIOO1){set_value}};for(i=0
;i<IIlLLL10LllllLO0I1ILIIIO0L;i=i+1)begin parity_buffer[i]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){set_value}};end data_next={(IIlLlLL1O1l0I0Ll0lLILlIOO1){set_value}};end endtask assign#(output_delay)DATA_OUT=data_out_sel;assign#(
output_delay)INFO=info_tmp;always@(DATA_IN)begin if(C_SPEC==IOI1L1I1OlLLOO1I1l011l0I1l)begin data_in_sel=db_to_normal[DATA_IN];end else begin data_in_sel=DATA_IN;end
 end always@(RESET or posedge CLK)begin if(RESET===1'bx||RESET===1'bz)begin set_generator_variables_to(1'bx);data_pipe_in=data_next;info_pipe_in=1'bx;
end else if(RESET===1'b1)begin set_generator_variables_to(1'b0);symbol_count=IIl0II0O0LII0LlLlIl1LO1O0I;data_pipe_in=data_next;info_pipe_in=1'b0;end else if(CLK===1'b1)begin if
(ENABLE===1'b1)begin if(BYPASS===1'b0)begin if(START===1'b0)begin if(anyX(symbol_count))begin set_generator_variables_to(1'bx);info_next=1'bx;end else
 if(symbol_count<IOI1IlOl1IOL0O0IO01L1lIOOO)begin update_parity_buffer;data_next=data_in_sel;info_next=1'b1;symbol_count=symbol_count+1;end else if(symbol_count<IIl0II0O0LII0LlLlIl1LO1O0I)begin
 data_next=parity_buffer[IIl0II0O0LII0LlLlIl1LO1O0I-1-symbol_count];info_next=1'b0;symbol_count=symbol_count+1;end else begin data_next={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'b0}};info_next=1'b0;end end else
 if(START===1'b1)begin set_generator_variables_to(1'b0);update_parity_buffer;data_next=data_in_sel;info_next=1'b1;symbol_count=symbol_count+1;end else
 begin set_generator_variables_to(1'bx);info_next=1'bx;end end else if(BYPASS===1'b1)begin data_next=data_in_sel;info_next=1'b1;end else begin
 set_generator_variables_to(1'bx);info_next=1'bx;end data_pipe_in<=data_next;info_pipe_in<=info_next;end else if(ENABLE===1'bx)begin
 set_generator_variables_to(1'bx);data_pipe_in<=data_next;info_pipe_in<=1'bx;end end else if(CLK===1'bx)begin set_generator_variables_to(1'bx);
data_pipe_in<=data_next;info_pipe_in<=1'bx;end end always@(RESET or posedge CLK)begin if(RESET===1'bx)begin data_tmp_out={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'bx}};info_tmp=1'bx;if
(II0000OII1l1LLLOI1LL0Ll1OO>0)begin for(i=II0000OII1l1LLLOI1LL0Ll1OO;i>0;i=i-1)begin data_pipe[i]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'bx}};info_pipe[i]=1'bx;end end data_pipe[0]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'bx}};
info_pipe[0]=1'bx;end else if(RESET===1'b1)begin data_tmp_out={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'b0}};info_tmp=1'b0;if(II0000OII1l1LLLOI1LL0Ll1OO>0)begin for(i=II0000OII1l1LLLOI1LL0Ll1OO;i>0
;i=i-1)begin data_pipe[i]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'b0}};info_pipe[i]=1'b0;end end data_pipe[0]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'b0}};info_pipe[0]=1'b0;end else if(CLK===1'b1)begin data_tmp_out
=data_pipe[II0000OII1l1LLLOI1LL0Ll1OO];info_tmp=info_pipe[II0000OII1l1LLLOI1LL0Ll1OO];if(II0000OII1l1LLLOI1LL0Ll1OO>0)begin for(i=II0000OII1l1LLLOI1LL0Ll1OO;i>0;i=i-1)begin
 data_pipe[i]=data_pipe[i-1];info_pipe[i]=info_pipe[i-1];end end data_pipe[0]=data_pipe_in;info_pipe[0]=info_pipe_in;end if(CLK===1'bx)begin
 data_tmp_out={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'bx}};info_tmp=1'bx;if(II0000OII1l1LLLOI1LL0Ll1OO>0)begin for(i=II0000OII1l1LLLOI1LL0Ll1OO;i>0;i=i-1)begin data_pipe[i]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'bx}};info_pipe
[i]=1'bx;end end data_pipe[0]={(IIlLlLL1O1l0I0Ll0lLILlIOO1){1'bx}};info_pipe[0]=1'bx;end end always@(data_tmp_out)begin if(C_SPEC==IOI1L1I1OlLLOO1I1l011l0I1l)begin data_out_sel=normal_to_db[
data_tmp_out];end else begin data_out_sel=data_tmp_out;end end function[IO10IIlO0III0LO01lLI0L1I10:0]gfmul;input[IO10IIlO0III0LO01lLI0L1I10:0]aa;input[IO10IIlO0III0LO01lLI0L1I10:0]bb;reg[IO10IIlO0III0LO01lLI0L1I10:0]cc_index;begin if(aa==0
||bb==0)begin gfmul=0;end else begin cc_index=(index_of[aa]+index_of[bb])%IIO1lL0IOL000IOOl11IL11IlI;gfmul=alpha_to[cc_index];end end endfunction function anyX;input[IO10IIlO0III0LO01lLI0L1I10
:0]input_value;integer ii;begin:finish_early anyX=1'b0;for(ii=0;ii<IIlLlLL1O1l0I0Ll0lLILlIOO1;ii=ii+1)begin if(input_value[ii]===1'bx||input_value[ii]===1'bz)begin anyX=1'b1;
disable finish_early;end end end endfunction
// synopsys_translate_on 
// synthesis attribute GENERATOR_DEFAULT of RS_ENCODER_V3_0 is "generatecore com.xilinx.ip.rs_encoder_v3_0.rs_encoder_v3_0" 
// box_type "black_box"  
// synthesis attribute box_type of RS_ENCODER_V3_0 is "black_box" 
 endmodule

//IN
//Signals
`define S0 in_bus[0]
`define S1 in_bus[1]
`define S2 in_bus[2]
`define S3 in_bus[3]
`define S4 in_bus[4]
`define S5 in_bus[5]
`define S6 in_bus[6]
`define S7 in_bus[7]
`define S8 in_bus[8]
//Instruction
`define RD in_bus[13:9]
`define RS1 in_bus[18:14]
`define RS2 in_bus[23:19]
`define IMM_7 in_bus[30:24]
`define IMM_12 in_bus[30:19]
//Data
`define RD_DM in_bus[62:31]
//OUT
`define A_IM out_bus[31:0]
`define A_DM out_bus[63:32]
`define WD_DM out_bus[95:64]
module Datapath(in_bus, out_bus, clk, reset);

 input [61:0] in_bus;//control: 8, instruction:22, data:32
 output reg [95:0] out_bus;//IMA, DMA, DMWD
 input clk, reset;

 //IF
 //PC
 reg [31:0] PC;
 wire [31:0] MUX1;
 wire [31:0] PC_4;
 assign PC4=PC+32'd4;
 assign MUX1 = `S1 ? PC4 : 0;//***
 always @(posedge clk) begin
  PC = MUX1;
  `A_IM = PC;
 end
 
 //IF/DEC
 wire [31:0] PC_D, RD_IM_D, PC4D;
 PIPE IFDEC(.in({PC,`RD_IM, PC4}), .out({PC_D, RD_IM_D, PC4D}), .clk(clk));
 defparam IFDEC.L=96;

 //DEC

 

endmodule

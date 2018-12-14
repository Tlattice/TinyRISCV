//Inputs
`define IM_RD in[31:0]
`define DM_RD in[63:32]
//Outputs
`define IM_A out[31:0]
`define DM_A out[63:32]
`define DM_WD out[95:64]
`define DM_WE out[96]

module CORE(in, out, clk, reset);

 input [63:0] in;
 output [96:0] out;
 input clk, reset;

 //IF
 //PC
 reg [31:0] PC;
 wire [31:0] PC4;
 wire [31:0] MUX1;
 wire S1;
 assign PC4 = PC + 32'd4;
 assign MUX1 = S1 ? MUX6 : PC4;
 assign `IM_A = PC;
 always @(posedge clk or posedge reset) 
  if(reset) PC=0;
  else PC = MUX1;
 //IF_DEC
 wire [31:0] PC4_D, IM_RD_D, PC_D;
 PIPE IFDEC(.in({PC, `IM_RD, PC4}), .out({PC_D, IM_RD_D, PC4_D}), .clk(clk));
 defparam IFDEC.L = 96;

 //DEC
 wire S2, S0, S9;
 wire [31:0] RD1, RD2;
 wire [31:0] MUX0;
 wire [31:0] MUX9;
 wire [31:0] Imm;
 assign MUX0 = S0 ? { {25{IM_RD_D[31]}}, IM_RD_D[31:25]  }: { {20{IM_RD_D[31]}}, IM_RD_D[31:20]};
 assign MUX9 = S9 ? { {12{IM_RD_D[31]}}, IM_RD_D[31:12]  } : MUX0;
 assign Imm = MUX9;
 RegisterFile RF(.A1(IM_RD_D[19:15]), .A2(IM_RD_D[24:20]), .A3(Rd_W), .WD3(MUX8), .WE3(S2), .clk(clk), .reset(reset), .RD1(RD1), .RD2(RD2));
 //SignExtend SE(.in(MUX9), .out(Imm));

 //DEC/EX
 wire [31:0] PC_E, Imm_E, RD2_E, RD1_E, PC4_E;
 wire [4:0] Rd_E;
 PIPE DECEX(.in({PC_D, Imm, RD2, RD1, IM_RD_D[11:7], PC4_D}), .out({PC_E, Imm_E, RD2_E, RD1_E, Rd_E, PC4_E}), .clk(clk));
 defparam DECEX.L = 165;
 
 //EX
 wire S3;
 wire [2:0] S4;
 wire [3:0] Flags_E;
 wire [31:0] MUX3, ADDPC_E, ALUResult_E;
 assign MUX3 = S3 ? Imm_E : RD2_E;
 assign ADDPC_E = (Imm_E + PC_E)<<2;
 ALU ALUB(.SrcA(RD1_E), .SrcB(MUX3), .ALUControl(S4), .Flags(Flags_E), .ALUResult(ALUResult_E));

 //EX/MEM
 wire [31:0] ADDPC_M, RD2_M, ALUResult_M, PC4_M;
 wire [3:0] Flags_M;
 wire [4:0] Rd_M;
 PIPE EXMEM(.in({ADDPC_E, RD2_E, ALUResult_E, Flags_E, Rd_E, PC4_E}), .out({ADDPC_M, RD2_M, ALUResult_M, Flags_M, Rd_M, PC4_M}), .clk(clk));
 defparam EXMEM.L = 137;

 //MEM
 wire S5, S6;
 wire [31:0] MUX6;
 assign MUX6 = S6 ? ADDPC_M : ALUResult_M;
 assign `DM_A = ALUResult_M;
 assign `DM_WD = RD2_M;
 assign `DM_WE = S5;
 
 //MEM/WB
 wire [31:0] DM_RD_W, ALUResult_W, PC4_W;
 wire [4:0] Rd_W;
 PIPE MEMWB(.in({`DM_RD, ALUResult_M, Rd_M, PC4_M}), .out({DM_RD_W, ALUResult_W, Rd_W, PC4_W}), .clk(clk));
 defparam MEMWB.L = 101;

 //WB
 wire S7, S8;
 wire [31:0] MUX7, MUX8;
 assign MUX7 = S7 ? DM_RD_W: ALUResult_W;
 assign MUX8 = S8 ? MUX7 : PC4_W;

endmodule

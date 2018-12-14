module ALU(SrcA, SrcB, ALUControl, Flags, ALUResult);
 
 parameter ADD=3'b000, SUB=3'b001, MUL=3'b010,
           OR=3'b011, XOR=3'b100, SLT=3'b101,
           SRA=3'b110, SRL=3'b111;
 
 input [31:0] SrcA, SrcB;
 input [2:0] ALUControl;
 output reg [31:0] ALUResult;
 output [3:0] Flags;
  
 assign Flags = { SrcA==SrcB, SrcA!=SrcB, SrcA<SrcB, !(SrcA<SrcB) };//EQ, NEQ, BLT, BGE

 always @*
  case(ALUControl)
   ADD: ALUResult=SrcA+SrcB;
   SUB: ALUResult=SrcA-SrcB;
   MUL: ALUResult=SrcA*SrcB;
   XOR: ALUResult=SrcA^SrcB;
   SLT: ALUResult=SrcA<SrcB;
   SRA: ALUResult=SrcA>>>SrcB;
   SRL: ALUResult=SrcA>>SrcB;
   default: ALUResult=32'bx;
  endcase

endmodule

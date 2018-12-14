module Memory(A1, A2, A3, WD3, RD1, RD2, WE3, clk);
 parameter D = 1;
 input WE3, clk;
 input [31:0] A1, A2, A3, WD3;
 output reg [31:0] RD1, RD2;

 reg [7:0] mem [D-1:0];
 
 always @* begin
  RD1<={mem[A1], mem[A1+1], mem[A1+2], mem[A1+3]};
  RD2<={mem[A2], mem[A2+1], mem[A2+2], mem[A2+3]};
 end

 always @(posedge clk)
  if(WE3==1) {mem[A3], mem[A3+1]}=WD3;

endmodule

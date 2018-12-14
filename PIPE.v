module PIPE(in, out, clk);
 parameter L=1;
 input [L-1:0] in;
 input clk;
 output reg [L-1:0] out;
 
 always @(negedge clk)
  out=in;

endmodule

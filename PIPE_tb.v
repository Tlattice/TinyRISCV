module PIPE_tb;
 
 reg [2:0] in;
 reg clk;
 wire [2:0] out;
 
 PIPE DUT(in, out, clk);
 defparam DUT.L=3;

 initial begin
  clk=1;
  in=3'b101;
  #1;
  $display("in=%b, out=%b", in, out);
  #1;
  clk=0;
  #1;
  $display("in=%b, out=%b", in, out);
  $finish;
 end

endmodule

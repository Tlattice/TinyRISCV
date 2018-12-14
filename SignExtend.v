module SignExtend(in, out);
 input [11:0] in;
 output [31:0] out;

 assign out = {{19{in[11]}} , in};

endmodule

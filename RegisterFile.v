module RegisterFile(A1, A2, A3, WD3, WE3, clk, reset, RD1, RD2);
 input clk, WE3, reset;
 input [4:0] A1, A2, A3;
 input [31:0] WD3;
 output [31:0] RD1, RD2; 
 
 reg [31:0] RD1_t, RD2_t;
  
 reg [31:0] bank [31:0];

 reg [5:0] counter;
 
 assign RD1 = A1!=0 ? RD1_t: 32'b0;
 assign RD2 = A2!=0 ? RD2_t: 32'b0;
 
 always@*
  if(!reset) begin
   RD1_t<=bank[A1];
   RD2_t<=bank[A2];
  end
 
 always @(posedge clk or posedge reset)
  if(reset)
    for(counter=0; counter<32; counter=counter+1)
     bank[counter]=32'd0;
  else
   if(WE3 && A3!=0)
    bank[A3]=WD3;
   else;

endmodule

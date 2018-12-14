module CORE_tb;
 parameter C = 4*2;//5*2
 reg clk, reset;
 wire [63:0] in;
 wire [96:0] out;

 CORE DUT(.in(in), .out(out), .clk(clk), .reset(reset));
 Memory MEM(.A1(out[31:0]), .A2(out[63:32]), .A3(out[63:32]), .WD3(out[95:64]), .RD1(in[31:0]), .RD2(in[63:32]), .WE3(out[96]), .clk(clk));
 defparam MEM.D = 8;
 //Load memory
 initial $readmemb("mem_JAL.txt", MEM.mem);
 //Load registers
 initial begin
  #2;
  DUT.RF.bank[1]=32'habcd;
  DUT.RF.bank[2]=32'd2;
  MEM.mem[4]=8'b0;
  MEM.mem[5]=8'b0;
  MEM.mem[6]=8'b0;
  MEM.mem[7]=8'b0;
  //DUT.RF.bank[2]=32'd4;
 end
 //Assign signals
 assign DUT.S0 = 0;
 assign DUT.S1 = 1;
 assign DUT.S2 = 1;
 assign DUT.S3 = 1'bx;
 assign DUT.S4 = 3'b000;
 assign DUT.S5 = 0;
 assign DUT.S6 = 1'b1;
 assign DUT.S7 = 1'bx;
 assign DUT.S8 = 1'b0;
 assign DUT.S9 = 1'b1;
 
 always #1 clk=!clk;
 //always #1 $display("***IM_RD=%b", DUT.IM_RD_D);
 initial begin
  $dumpfile("core.vcd");
  $dumpvars(0,CORE_tb);
  //$monitor("A2=%h, WD3=%h", out[63:32], out[95:64]);
  $monitor("PC=%b", DUT.PC);
  //$monitor("MUX9=%b", DUT.MUX9);
  print_register();
  print_mem();
  clk=0;
  reset=1;#2;
  reset=0;
  //#C;
  #12;
  print_register();
  print_mem();
  $finish;
  end

  task print_register;
   integer i;
   begin
    $display("Registers:");
    for(i=0; i<32; i=i+1) $display("%s%d=%d","R", i, DUT.RF.bank[i]);
   end
  endtask
  
  task print_mem;
   integer i;
   begin
    $display("MEM:");
    for(i=0; i<C; i=i+1) $display("%s%d=%h","M", i, MEM.mem[i]);
   end
  endtask

endmodule

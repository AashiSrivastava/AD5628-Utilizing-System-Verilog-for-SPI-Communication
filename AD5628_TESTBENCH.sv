module tb();
  reg clk=0;
  reg st_wrt=0;
  reg [11:0] data_in=0;
  wire sclk;
  wire cs;
  wire mosi;
  wire done;
  
  AD5628DAC dut(clk,st_wrt,data_in,sclk,cs, mosi,done);
  
  always 
    #5 clk=~clk;
  
  initial begin
    st_wrt=1;
    data_in=12'b101010101010;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    #1000000; $finish;
  end
  
endmodule
    
  
  
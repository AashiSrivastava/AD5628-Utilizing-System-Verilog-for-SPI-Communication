//TITLE: AD5628 (ANALOG DEVICES) DIGITAL TO ANALOG CONVERTOR
//DEVELOPED BY: AASHI SRIVASTAVA
//------------------------------------------------

module AD5628DAC(input clk,st_wrt, input [11:0] data_in, output reg sclk, output reg cs,output reg mosi,output reg done);
  
  reg [31:0] data=32'h0;
  reg [31:0] data_init=32'h08000001;
  reg init_d=0;
  reg sclk_t=0;
  //---------GENERATION OF SCLK--------------------------
  integer clk_div=0;
  always @(posedge clk)
    begin
      if(clk_div==49) begin
        clk_div<=0;
        sclk_t= ~sclk_t;
      end
      else
        clk_div<=clk_div+1;
    end
  assign sclk=sclk_t;
  
  //---------FINITE STATE MACHINE--------------------------
  typedef enum logic [1:0] {idle=0, init_dac=1, dac_data=2, send_data=3} state_type;
  state_type state;
  
  integer count=0;
  
  always @(posedge sclk_t or negedge  st_wrt)
    begin
      if (!st_wrt)
        begin
          done<=0;
          mosi<=0;
          cs<=1'b1;
          state<=idle;
        end
      else
        case (state)
          idle:
            begin
              done<=0;
              mosi<=0;
              cs<=1'b1;
              count<=0;
              
              if(!init_d)
                begin
                  state<=init_dac;
                  cs<=1'b0;
                end
              
              else
                begin
                  state<=dac_data;
                  cs<=1'b1;
                end
            end
          
          init_dac:
            begin
              cs<=1'b0;
              if(count<32)
                begin
                  mosi<=data_init[31-count];
                  count<=count+1;
                  state<=init_dac;
                end
              else
                begin
                  count<=0;
                  state<=dac_data;
                  init_d<=1;
                  cs<=1'b1;
                end
            end
          
          dac_data:
            begin
              cs<=1'b1;
              mosi<=0;
              data<={12'h030,data_in,8'h00};
              state<=send_data;
            end
          
          send_data:
            begin
              if(count<32)
                begin
                  cs<=1'b0;
                  mosi<=data[31-count];
                  count<=count+1;
                  state<=send_data;
                end
              else
                begin
                done<=1'b1;
                  state<=idle;
                  count<=0;
                  cs<=1;
                end
            end
          
          default:
            state<=idle;
        endcase
    end
endmodule
          
              
              
              
              
      
  
  
      
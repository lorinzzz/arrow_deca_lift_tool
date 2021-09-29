module LEVEL_CAMP (
input  [17:0]PS_DATA,
output [7:0] LEVEL
); 
wire [15:0]DAT ; 

assign DAT = (16'h4000 - 16'h200)/8 ; 
//--LEVEL COMP ---

// added more sensitivity values
assign  LEVEL  = 
  ( PS_DATA < 16'h 200  ) ? 8'd10: (
  ( PS_DATA < 16'h 200+DAT*1  ) ? 8'd9: (
  ( PS_DATA < 16'h 200+DAT*2  ) ? 8'd8: (
  ( PS_DATA < 16'h 200+DAT*3  ) ? 8'd7: (
  ( PS_DATA < 16'h 200+DAT*4  ) ? 8'd6: (
  ( PS_DATA < 16'h 200+DAT*5  ) ? 8'd5: (
  ( PS_DATA < 16'h 200+DAT*6  ) ? 8'd4: (
  ( PS_DATA < 16'h 200+DAT*7  ) ? 8'd3: (
  ( PS_DATA < 16'h 200+DAT*8  ) ? 8'd2: (
  ( PS_DATA < 16'h 200+DAT*9  ) ? 8'd1: (
  ( PS_DATA < 16'h 200+DAT*10  ) ? 8'd0: 8'd0
  ))))))))));
  
 endmodule
  
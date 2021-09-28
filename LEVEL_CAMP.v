module LEVEL_CAMP (
input  [17:0]PS_DATA,
output [7:0] LEVEL
); 
wire [15:0]DAT ; 

assign DAT = (16'h4000 - 16'h200)/8 ; 
//--LEVEL COMP ---
assign  LEVEL  = 
  ( PS_DATA < 16'h 200  ) ? 8'h00: (
  ( PS_DATA < 16'h 200+DAT*1  ) ? 8'h01: (
  ( PS_DATA < 16'h 200+DAT*2  ) ? 8'h03: (
  ( PS_DATA < 16'h 200+DAT*3  ) ? 8'h07: (
  ( PS_DATA < 16'h 200+DAT*4  ) ? 8'h0F: (
  ( PS_DATA < 16'h 200+DAT*5  ) ? 8'h1F: (
  ( PS_DATA < 16'h 200+DAT*6  ) ? 8'h3F: (
  ( PS_DATA < 16'h 200+DAT*7  ) ? 8'h7F: (
  ( PS_DATA < 16'h 200+DAT*8  ) ? 8'hFF: 8'hFF
  ))))))));
  
 endmodule
  
  
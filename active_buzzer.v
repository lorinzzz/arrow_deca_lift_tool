module active_buzzer(
	input clk,
	input slower_clk, 
	input slow_clk, 
	input moderate_clk, 
	input fast_clk,
	input [7:0] distance,
	output reg alarm);	
	
	
	// 4 different clocks to implement 4 different rate of beeping

	// sound off when a certain value exceeds threshhold
	
	always@(clk)
	begin
		if(distance == 8'd5 && slower_clk == 1'b1) // slow beep
		begin	
			alarm <= ~alarm;
		end
		
		else if(distance == 8'd4 && slow_clk == 1'b1) // slighty faster beep
		begin	
			alarm <= ~alarm;
		end	
		else if(distance == 8'd3 && moderate_clk == 1'b1) //  faster beep
		begin	
			alarm <= ~alarm;
		end	
		else if(distance <= 8'd2 && fast_clk == 1'b1) // fast  beep
		begin	
			alarm <= ~alarm;
		end	
		
		else
		begin
			alarm <= 1'b0;
		end
		
	end
	
endmodule
	
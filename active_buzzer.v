module active_buzzer(
	input clk,
	input select,
	input slower_clk, 
	input slow_clk, 
	input moderate_clk, 
	input fast_clk,
	input [15:0] data,
	output reg alarm);	
	
	
	// 4 different clocks to implement 4 different rate of beeping

	// sound off when a certain value exceeds threshhold
	
	always@(clk)
	begin
		// for gsensor 
		// x value in [11:8] , y value in [3:0] 
		if(select == 1'b0) 
		begin
			if( (data[11:8] == 16'd3 || data[3:0]  == 16'd3) && fast_clk == 1'b1)
			begin
				alarm <= ~alarm;
			end
			
			else if( (data[11:8] == 16'd2 || data[3:0]  == 16'd2) && moderate_clk == 1'b1)
			begin
				alarm <= ~alarm;
			end	
			
			else if( (data[11:8] == 16'd1 || data[3:0]  == 16'd1) && slow_clk == 1'b1)
			begin
				alarm <= ~alarm;
			end
			
			else if( (data[11:8] >= 16'd4 && data[3:0]  >= 16'd4) || (data[11:8] == 16'd0 && data[3:0]  == 16'd0) )
			begin
				alarm = 1'b0;
			end
					
		end
			
		// for light sensor
		else if(select == 1'b1)
		begin
			if(data == 16'd5 && slower_clk == 1'b1) // slow beep
			begin	
				alarm <= ~alarm;
			end
			
			else if(data == 16'd4 && slow_clk == 1'b1) // slighty faster beep
			begin	
				alarm <= ~alarm;
			end	
			else if(data == 16'd3 && moderate_clk == 1'b1) //  faster beep
			begin	
				alarm <= ~alarm;
			end	
			else if(data <= 16'd2 && fast_clk == 1'b1) // fast  beep
			begin	
				alarm <= ~alarm;
			end	
			
			else if(data >= 16'd6)
			begin
				alarm <= 1'b0;
			end
		end
		
	end
	
endmodule
	
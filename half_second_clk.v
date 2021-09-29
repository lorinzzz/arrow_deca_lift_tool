module generateClocks(
	input clk,
	output reg slower_clk, // 2 beeps/sec => divide by 25 million cycles 
	output reg slow_clk, // 3 beeps/sec => "           " 16.66 "    "
	output reg moderate_clk, // 4 beeps/sec => "        " 12.5 "     "
	output reg fast_clk); // 8 beeps/sec   "           " 6.25 "    "
	
	reg[26:0] slower_counter; 
	reg[26:0] slow_counter; 
	reg[26:0] moderate_counter; 
	reg[26:0] fast_counter; 
	
	always@(posedge clk) 
	begin
		if(slower_counter == 27'd25_000_000)
		begin
			slower_counter <= 0;
			slower_clk <= ~slower_clk;
		end
		else
		begin
			slower_counter <= slower_counter + 1'b1;
		end
		if(slow_counter == 27'd16_666_666)
		begin
			slow_counter <= 0;
			slow_clk <= ~slow_clk;
		end
		else
		begin
			slow_counter <= slow_counter + 1'b1;
		end
		if(moderate_counter == 27'd12_500_000)
		begin
			moderate_counter <= 0;
			moderate_clk <= ~moderate_clk;
		end
		else
		begin
			moderate_counter <= moderate_counter + 1'b1;
		end
		if(fast_counter == 27'd5_000_000) // made it just a bit faster => 10 beeps a sec
		begin
			fast_counter <= 0;
			fast_clk <= ~fast_clk;
		end
		else
		begin
			fast_counter <= fast_counter + 1'b1;
		end

	end
	
endmodule
	
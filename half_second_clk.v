module half_second_clock(
	input clk,
	output reg slow_clk);
	
	// for half second, take one high clock cycle every 25 million cycles
	
	reg[26:0] counter; 
	reg edge_det; 
	
	always@(posedge clk) 
	begin
		if(counter == 27'd25_000_000 )
		begin
			counter <= 0;
			slow_clk <= ~slow_clk;
		end
		else
		begin
			counter <= counter + 1'b1;
		end
	end
	
endmodule
	
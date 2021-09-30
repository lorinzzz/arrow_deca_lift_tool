module clk_500hz(
	input clk,
	output reg slow_clk);
	
	// 500Hz clock
	
	reg[26:0] counter; 
	
	always@(posedge clk) 
	begin
		if(counter == 27'd100_000)
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
	
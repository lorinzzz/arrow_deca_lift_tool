// selects between the x and y values from gsensor

module x_y_gsensor_multiplexer(
	input [7:0] gsensor_x, gsensor_y,
	input [1:0] select,
	output reg [7:0] gsensor_data
	);
	
	always@(select)
	begin
		if(select == 1'b0)
		begin
			gsensor_data = gsensor_x;
		end
		if(select == 1'b1)
		begin
			gsensor_data = gsensor_y;
		end
	end
	
endmodule
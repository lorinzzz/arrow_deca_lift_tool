module gsensor_led_to_hex(
	input clk,
	input [7:0] gsensor_led_x_data,
	input [7:0] gsensor_led_y_data,
	output [15:0] gsensor_hex_data 
);

	reg [7:0] gsensor_hex_x_data;
	reg [7:0] gsensor_hex_y_data; 

	always@(clk)
	begin
		// for x values
		if(gsensor_led_x_data == 8'b0001_1000)
		begin
			gsensor_hex_x_data <= 8'b0000_0000;
		end
		else if(gsensor_led_x_data == 8'b0010_0000)
		begin
			gsensor_hex_x_data <= 8'b1011_0001; // -1 on HEX
		end
		else if(gsensor_led_x_data == 8'b0000_0100)
		begin
			gsensor_hex_x_data <= 8'b1010_0001; // +1 on HEX
		end	
		else if(gsensor_led_x_data == 8'b0100_0000)
		begin
			gsensor_hex_x_data <= 8'b1011_0010; // -2 on HEX
		end
		else if(gsensor_led_x_data == 8'b0000_0010)
		begin
			gsensor_hex_x_data <= 8'b1010_0010; // +2 on HEX
		end	
		else if(gsensor_led_x_data == 8'b1000_0000)
		begin
			gsensor_hex_x_data <= 8'b1011_0011; // -3 on HEX
		end
		else if(gsensor_led_x_data == 8'b0000_0001)
		begin
			gsensor_hex_x_data <= 8'b1010_0011; // +3 on HEX
		end
	
		// for y values
		if(gsensor_led_y_data == 8'b0001_1000)
		begin
			gsensor_hex_y_data <= 8'b0000_0000;
		end
		else if(gsensor_led_y_data == 8'b0010_0000)
		begin
			gsensor_hex_y_data <= 8'b1011_0001; // -1 on HEX
		end
		else if(gsensor_led_y_data == 8'b0000_0100)
		begin
			gsensor_hex_y_data <= 8'b1010_0001; // +1 on HEX
		end	
		else if(gsensor_led_y_data == 8'b0100_0000)
		begin
			gsensor_hex_y_data <= 8'b1011_0010; // -2 on HEX
		end
		else if(gsensor_led_y_data == 8'b0000_0010)
		begin
			gsensor_hex_y_data <= 8'b1010_0010; // +2 on HEX
		end	
		else if(gsensor_led_y_data == 8'b1000_0000)
		begin
			gsensor_hex_y_data <= 8'b1011_0011; // -3 on HEX
		end
		else if(gsensor_led_y_data == 8'b0000_0001)
		begin
			gsensor_hex_y_data <= 8'b1010_0011; // +3 on HEX
		end	
		
		
	end

	// assign gsensor_hex_data = {gsensor_hex_x_data, gsensor_hex_y_data}
assign gsensor_hex_data = {gsensor_hex_x_data, gsensor_hex_y_data};

endmodule

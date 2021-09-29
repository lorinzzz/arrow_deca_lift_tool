// selects whether to output data from gsensor or light sensor to the hex displays and buzzer

module display_alarm_multiplexer(
	input [7:0] gsensor_data, light_sensor_data,
	input [1:0] select,
	output reg [7:0] selected_data
	);
	
	always@(select)
	begin
		if(select == 1'b0)
		begin
			selected_data = gsensor_data;
		end
		if(select == 1'b1)
		begin
			selected_data = light_sensor_data;
		end
	end
	
endmodule
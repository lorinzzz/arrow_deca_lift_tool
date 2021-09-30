// selects whether to output data from gsensor or light sensor to the hex displays and buzzer

module display_alarm_multiplexer(
	input [15:0] light_sensor_data,
	input [15:0] gsensor_data,
	input  select,
	output reg [15:0] selected_data,
	output buzzer_mode
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

assign buzzer_mode = select;	
	
endmodule

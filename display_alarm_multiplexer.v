// selects whether to output data from gsensor or light sensor to the hex displays and buzzer

module display_alarm_multiplexer(
	input [15:0] light_sensor_data,
	input [15:0] gsensor_data,
	input  select,
	output reg [15:0] selected_data
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


// NOTES: the gsensor_data passed in is from the gsensor_led_to_hex module, meaning 00 is parallel, and 01 or -1 is tilted,
// => make the alarms sound when it is 2 or above
// currently alarm buzzes when >= 5 for the hexes, but the values are opposite and different for the gsensor

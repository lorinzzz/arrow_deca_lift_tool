
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module tool_box(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// G-Sensor //////////
	output		          		G_SENSOR_CS_n,
	input 		          		G_SENSOR_INT1,
	input 		          		G_SENSOR_INT2,
	inout 		          		G_SENSOR_SCLK,
	inout 		          		G_SENSOR_SDI,
	inout 		          		G_SENSOR_SDO,

	//////////// Light Sensor //////////
	output		          		LIGHT_I2C_SCL,
	inout 		          		LIGHT_I2C_SDA,
	inout 		          		LIGHT_INT,

	//////////// SW //////////
	input 		     [1:0]		SW,

	//////////// BBB Conector //////////
	input 		          		BBB_PWR_BUT,
	input 		          		BBB_SYS_RESET_n,
	inout 		    [43:0]		GPIO0_D,
	inout 		    [22:0]		GPIO1_D
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
// for hex
wire five_hundred_hertz_clk;
wire [11:0] hex_displays;

// for pos lead of buzzer
wire alarm;

// clks for each threshold alarm
wire slower_clk;
wire slow_clk;
wire moderate_clk;
wire fast_clk;

// for light sensor
wire [7:0] light_sensor_data; 
wire [15:0]DAT; 
wire [15:0]PS1_DATA;
wire [15:0]PS2_DATA;
wire [15:0]PS3_DATA;
wire [17:0]PS_DATA;

// g sensor
wire [15:0]   OUT_X; 
wire [15:0]   OUT_Y; 
wire [15:0]   OUT_Z; 
wire [7:0]    WHO_AM_I;
wire  [16:0]  s_data_x;  
wire  [16:0]  data_x;
wire  [16:0]  s_data_y;  
wire  [16:0]  data_y;
wire  [7:0]   gsensor_x;
wire  [7:0]   gsensor_y;
wire  [7:0] 	gsensor_led_data;
wire  [15:0]   gsensor_hex_data ;
wire          reset_n; 
wire          DATA_RDY; 


// for display_alarm mux
wire [15:0] selected_data;
wire buzzer_mode;
//=======================================================
//  Structural coding
//=======================================================
 
seg7 display(five_hundred_hertz_clk, selected_data, hex_displays);
generate_clocks gen_clocks(MAX10_CLK1_50, slower_clk, slow_clk, moderate_clk, fast_clk);
clk_500hz display_clock(MAX10_CLK1_50, five_hundred_hertz_clk);
active_buzzer active_buzzer(MAX10_CLK1_50, buzzer_mode, slower_clk, slow_clk, moderate_clk, fast_clk, selected_data, alarm);
display_alarm_multiplexer disp_alarm_mux(light_sensor_data, gsensor_hex_data, SW[0], selected_data, buzzer_mode);
x_y_gsensor_multiplexer x_y_gsens_mux(gsensor_x, gsensor_y, SW[1], gsensor_led_data);
gsensor_led_to_hex gsens_led_to_hex(MAX10_CLK1_50, gsensor_x, gsensor_y, gsensor_hex_data);


//---Light_Sensor Controller--  
LSEN_CTRL  lsen( 
   .RESET_N      (reset_n) , 
   .CLK_50       (MAX10_CLK1_50),
	.LIGHT_I2C_SCL(LIGHT_I2C_SCL),
	.LIGHT_I2C_SDA(LIGHT_I2C_SDA),
	.LIGHT_INT    (LIGHT_INT),	
	.PS1_DATA     (PS1_DATA),		
	.PS2_DATA     (PS2_DATA),		
	.PS3_DATA     (PS3_DATA)	
	);

LEVEL_CAMP  cmp(
 .PS_DATA (PS_DATA) ,
 .LEVEL   (light_sensor_data)
);	

//---G-Sensor for SPI Controller ----  
SPI_CTL spi(
 .DATA_RDY (DATA_RDY),
 .RESET_N  (reset_n ), 
 .CLK_50   (MAX10_CLK1_50), 
 .OUT_X    (OUT_X   ) ,
 .OUT_Y    (OUT_Y   ) ,
 .OUT_Z    (OUT_Z   ) ,
 .WHO_AM_I (WHO_AM_I) ,
 .CS     (G_SENSOR_CS_n),
 .SCLK   (G_SENSOR_SCLK ) ,
 .DIN    (G_SENSOR_SDI),
 .DO     (G_SENSOR_SDO)
 );  


//get level values
// x
led_driver get_x_gsensor_data	(
    .iRSTN    ( reset_n),
    .iCLK     ( MAX10_CLK1_50 ),
    .iDIG     ( data_x[10:1]),
    .iG_INT2  ( DATA_RDY ) ,
    .oLED     ( gsensor_x),
    .fine_tune( ~KEY[0] )  );
// y
led_driver get_y_gsensor_data	(
    .iRSTN    ( reset_n),
    .iCLK     ( MAX10_CLK1_50 ),
    .iDIG     ( data_y[10:1]),
    .iG_INT2  ( DATA_RDY ) ,
    .oLED     ( gsensor_y),
    .fine_tune( ~KEY[0] )  );
	 
assign PS_DATA	= (PS1_DATA+PS2_DATA+PS3_DATA)/3; 
assign GPIO0_D[11:0] = hex_displays;
assign GPIO0_D[12] = alarm;
assign LED[7:0] = 8'hff ^ {gsensor_led_data[0],gsensor_led_data[1],gsensor_led_data[2],gsensor_led_data[3]
									,gsensor_led_data[4],gsensor_led_data[5],gsensor_led_data[6],gsensor_led_data[7] };
assign  reset_n = KEY[0]; 									
assign s_data_x      = 32768  +   OUT_X ;
assign data_x [11:0] = s_data_x[15:4]; 
assign s_data_y      = 32768  +   OUT_Y;
assign data_y [11:0] = s_data_y[15:4]; 

	 
endmodule

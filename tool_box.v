
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

	//////////// CapSense Button //////////
	inout 		          		CAP_SENSE_I2C_SCL,
	inout 		          		CAP_SENSE_I2C_SDA,

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

	//////////// Humidity and Temperature Sensor //////////
	input 		          		RH_TEMP_DRDY_n,
	output		          		RH_TEMP_I2C_SCL,
	inout 		          		RH_TEMP_I2C_SDA,

	//////////// SW //////////
	input 		     [1:0]		SW,

	//////////// Board Temperature Sensor //////////
	output		          		TEMP_CS_n,
	output		          		TEMP_SC,
	inout 		          		TEMP_SIO,

	//////////// BBB Conector //////////
	input 		          		BBB_PWR_BUT,
	input 		          		BBB_SYS_RESET_n,
	inout 		    [43:0]		GPIO0_D,
	inout 		    [22:0]		GPIO1_D
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [15:0] bits = 16'b1010_1011_1100_1101;
wire one_second_clock;
wire five_hertz_clk;

// for light sensor
wire [7:0] distance ; 
wire [15:0]DAT ; 
wire [15:0]PS1_DATA;
wire [15:0]PS2_DATA;
wire [15:0]PS3_DATA;
wire [17:0]PS_DATA;
wire       RESET_N ; 
//=======================================================
//  Structural coding
//=======================================================


assign RESET_N = KEY[0] ;

//---Light_Sensor Controller--  
LSEN_CTRL  lsen( 
   .RESET_N      (RESET_N) , 
   .CLK_50       (MAX10_CLK1_50),
	.LIGHT_I2C_SCL(LIGHT_I2C_SCL),
	.LIGHT_I2C_SDA(LIGHT_I2C_SDA),
	.LIGHT_INT    (LIGHT_INT),	
	.PS1_DATA     (PS1_DATA),		
	.PS2_DATA     (PS2_DATA),		
	.PS3_DATA     (PS3_DATA)	
	);

assign PS_DATA	= (PS1_DATA+PS2_DATA+PS3_DATA)/3  ; 

//--LEVEL Processor---
LEVEL_CAMP  cmp(
 .PS_DATA (PS_DATA) ,
 .LEVEL   (distance)
);
 

//LED DISPLAY
assign LED [7:0]  = 8'hff ^  distance ; 






seg7 module1(five_hertz_clk, bits, GPIO0_D[11:0]);
half_second_clock module2(MAX10_CLK1_50, one_second_clock);
clk_500hz module3(MAX10_CLK1_50, five_hertz_clk);

endmodule

// module to display values on the 4 digit 7 segment display

module seg7(
	input clk,
	input [15:0] bits,
	output reg [11:0] HEX
);

// turning on digits is active low
// turning on segments is active high

// |D1|D2|D3|D4|
// D1 = HEX[11]; 11;  
// D2 = HEX[8];	10; 
// D3 = HEX[7]; 01;	 
// D4 = HEX[5]; 00;   

// to turn on a specific digit, XOR with specific bit to toggle

reg [11:0] digit_on;
reg [3:0] curr_digit;
reg [1:0] curr_display = 2'b00;

always@(posedge clk)
begin
		
		case(curr_display)
			2'b00: digit_on <= 12'b0000_0010_0000; // D4
			2'b01: digit_on <= 12'b0000_1000_0000; // D3
			2'b10: digit_on <= 12'b0001_0000_0000; // D2
			2'b11: digit_on <= 12'b1000_0000_0000; // D1
		endcase	
		
		case(curr_display)
			2'b00: curr_digit <= bits[3:0]; // D1
			2'b01: curr_digit <= bits[7:4]; // D2
			2'b10: curr_digit <= bits[11:8]; // D3
			2'b11: curr_digit <= bits[15:12]; // D4
		endcase	
		
		case(curr_digit[3:0])
			4'b0000: HEX <= 12'b1111_1110_1011 ^ digit_on; // 0
			4'b0001: HEX <= 12'b1001_1110_1000 ^ digit_on; // 1
			4'b0010: HEX <= 12'b1101_1111_0011 ^ digit_on; // 2
			4'b0011: HEX <= 12'b1101_1111_1010 ^ digit_on; // 3
			4'b0100: HEX <= 12'b1011_1111_1000 ^ digit_on; // 4
			4'b0101: HEX <= 12'b1111_1011_1010 ^ digit_on; // 5
			4'b0110: HEX <= 12'b1111_1011_1011 ^ digit_on; // 6
			4'b0111: HEX <= 12'b1101_1110_1000 ^ digit_on; // 7
			4'b1000: HEX <= 12'b1111_1111_1011 ^ digit_on; // 8
			4'b1001: HEX <= 12'b1111_1111_1010 ^ digit_on; // 9
			4'b1010: HEX <= 12'b1111_1111_1001 ^ digit_on; // 10 A
			4'b1011: HEX <= 12'b1011_1011_1011 ^ digit_on; // 11 B
			4'b1100: HEX <= 12'b1111_1010_0011 ^ digit_on; // 12 C
			4'b1101: HEX <= 12'b1001_1111_1011 ^ digit_on; // 13 D
			4'b1110: HEX <= 12'b1111_1011_0011 ^ digit_on; // 14 E
			4'b1111: HEX <= 12'b1111_1011_0001 ^ digit_on; // 15 F
		endcase
	
		if(curr_display == 2'b11)
		begin
			curr_display = 2'b00;
		end
		else
		begin
		curr_display = curr_display + 1'b1;
		end

end

endmodule





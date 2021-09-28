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
reg [3:0] shifted_bits;
reg [1:0] digits = 2'b00;

always@(posedge clk)
begin
		
		case(digits)
			2'b00: digit_on <= 12'b0000_0010_0000; // D4
			2'b01: digit_on <= 12'b0000_1000_0000; // D3
			2'b10: digit_on <= 12'b0001_0000_0000; // D2
			2'b11: digit_on <= 12'b1000_0000_0000; // D1
		endcase	
		
		case(digits)
			2'b00: shifted_bits <= bits[3:0]; // D1
			2'b01: shifted_bits <= bits[7:4]; // D2
			2'b10: shifted_bits <= bits[11:8]; // D3
			2'b11: shifted_bits <= bits[15:12]; // D4
		endcase	
		
		case(shifted_bits[3:0])
			4'b0000: HEX <= (12'b1111_1110_1011 ^ digit_on); // 0
			4'b0001: HEX <= (12'b1001_1110_1000 ^ digit_on); // 1
			4'b0010: HEX <= (12'b1101_1111_0011 ^ digit_on); // 2
			4'b0011: HEX <= (12'b1101_1111_1010 ^ digit_on); // 3
			4'b0100: HEX <= (12'b1011_1111_1000 ^ digit_on); // 4
			4'b0101: HEX <= (12'b1111_1011_1010 ^ digit_on); // 5
			4'b0110: HEX <= (12'b1111_1011_1011 ^ digit_on); // 6
			4'b0111: HEX <= (12'b1101_1110_1000 ^ digit_on); // 7
			4'b1000: HEX <= (12'b1111_1111_1011 ^ digit_on); // 8
			4'b1001: HEX <= (12'b1111_1111_1010 ^ digit_on); // 9
		endcase
	
		if(digits == 2'b11)
		begin
			digits = 2'b00;
		end
		else
		begin
		digits = digits + 1'b1;
		end

end

endmodule



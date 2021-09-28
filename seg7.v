// module to display values on the 4 digit 7 segment display

module seg7(
	input clk,
	input [15:0] bits,
	output reg [7:0] HEX
);

// turning on digits is active low -> grounded with 220ohm resistor in series
// turning on segments is active high


reg [3:0] shifted_bits;
reg [1:0] digits = 2'b00;

always@(posedge clk)
begin
		
		case(digits)
			2'b00: shifted_bits <= bits[3:0]; // D1
			2'b01: shifted_bits <= bits[7:4]; // D2
			2'b10: shifted_bits <= bits[11:8]; // D3
			2'b11: shifted_bits <= bits[15:12]; // D4
		endcase	
		
		case(shifted_bits[3:0])
			4'b0000: HEX <= 8'b1110_1011; // 0
			4'b0001: HEX <= 8'b0010_1000; // 1
			4'b0010: HEX <= 8'b1011_0011; // 2
			4'b0011: HEX <= 8'b1011_1010; // 3
			4'b0100: HEX <= 8'b0111_1000; // 4
			4'b0101: HEX <= 8'b1101_1010; // 5
			4'b0110: HEX <= 8'b1101_1011; // 6
			4'b0111: HEX <= 8'b1010_1000; // 7
			4'b1000: HEX <= 8'b1111_1011; // 8
			4'b1001: HEX <= 8'b1111_1010; // 9
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



// CPE 3101L - INTRODUCTION TO HDL
// Group 1		F 7:30 - 10:30 AM LB285TC
// Lab Exercise #6.2
// Sarcol, Joshua S.		BS CpE - 3		2025/10/20

//
// Verilog HDL code for a 4-bit binary up/down counter
// negative edge triggered, active low asyncronous reset
//
module Counter_4bit (
	input wire			Clk, nReset, Load, Count_en, Up,
	input wire [3:0]	Count_in,
	output reg [3:0]	Count_out, 
	output reg 			clk_div										);
											// new clock frequency of 1Hz
	
	//
	// Clock divider logic
	// Assuming that the input clock frequency is 10MHz
	// and desired frequency is 1Hz
	//
	// Counter
	reg [22:0] cntr;		// 10,000,000 / 2 < 2^23
	
	// Comparator
	wire cmpr;
	assign cmpr = (cntr == 5_000_000 - 1);
	
	// Counter increment and reset logic
	always @(posedge Clk, posedge nReset)
	begin
		if (nReset)			// asyncronous reset
			cntr <= 23'b0;
		else if (cmpr)		// reset if counter reached 4_999_999
			cntr <= 23'b0;
		else					// increment by 1
			cntr <= cntr + 1'b1;
	end
	
	// new clock frequency generator
	always @(posedge Clk, posedge nReset)
	begin
		if (nReset)
			clk_div <= 1'b0;
		else if (cmpr)
			clk_div <= !clk_div;
	end
	
	//
	// Counter logic
	//
	always @(negedge clk_div, negedge nReset)
	begin
		if (!nReset)					// asyncronous reset
			Count_out <= 4'b0000;
		else if (Load)					// load inputs
			Count_out <= Count_in;
		else if (Count_en & Up)		// count up
			Count_out <= Count_out + 1'b1;
		else if (Count_en & ~Up)	// count down
			Count_out <= Count_out - 1'b1;
											// else no change (latch)
	end
endmodule

// CPE 3101L - INTRODUCTION TO HDL
// Group 1		F 7:30 - 10:30 AM LB285TC
// Lab Exercise #6.2
// Sarcol, Joshua S.		BS CpE - 3		2025/10/20

//
// Verilog HDL code for a JK Flip-flop
// negative edge triggered, active high asyncronous reset
//
module JK_FF (
	input wire J, K, Reset, Clk,
	output reg Q, clk_div,	// new clock frequency of 1Hz
	output wire Q_bar						);
	
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
	always @(posedge Clk, posedge Reset)
	begin
		if (Reset)			// asyncronous reset
			cntr <= 23'b0;
		else if (cmpr)		// reset if counter reached 4_999_999
			cntr <= 23'b0;
		else					// increment by 1
			cntr <= cntr + 1'b1;
	end
	
	// new clock frequency generator
	always @(posedge Clk, posedge Reset)
	begin
		if (Reset)
			clk_div <= 1'b0;
		else if (cmpr)
			clk_div <= !clk_div;
	end
	
	//
	// JK Flip-flop logic
	//
	assign Q_bar = ~Q;
	
	always @(negedge clk_div, posedge Reset)
	begin
		if (Reset)		// asyncronous reset
			Q <= 1'b0;	
		else 				// JK flip-flop characteristic equation
			Q <= (J & ~Q) | (~K & Q);
	end
endmodule

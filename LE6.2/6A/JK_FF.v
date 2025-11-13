// CPE 3101L - INTRODUCTION TO HDL
// Group 1		F 7:30 - 10:30 AM LB285TC
// Lab Exercise #6.2
// Sarcol, Joshua S.		BS CpE - 3		2025/11/14

//
// Verilog HDL code for a JK Flip-flop
// negative edge triggered, active high asyncronous reset
//
module JK_FF #(parameter cycle = 10_000_000)	( // Maximum clock cycle count to be divided by
	input wire J, K, Reset, Clk,
	output reg Q, clk_div,	// new clock frequency of 1Hz
	output wire Q_bar									);
	
	//
	// Clock divider logic
	// Assuming that the input clock frequency is 10MHz
	// and desired frequency is 1Hz
	//
	
	// Counter
	reg [22:0] cntr;		// (10,000,000 / 2) < 2^23
	
	// Comparator for half of the counter states
	wire cmpr;
	assign cmpr = (cntr == (cycle / 2) - 1);
	
	// Counter increment and reset logic
	always @(posedge Clk, posedge Reset)
	begin
		if (Reset)			// asyncronous reset
			cntr <= 23'b0;
		else if (cmpr)		// reset if counter reached half of the counter states
			cntr <= 23'b0;
		else					// increment by 1
			cntr <= cntr + 1'b1;
	end
	
	// new clock frequency generator
	// 2 full comparator hits == 1 full period
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

// CPE 3101L - INTRODUCTION TO HDL
// Group 1		F 7:30 - 10:30 AM LB285TC
// Lab Exercise #6
// Sarcol, Joshua S.		BS CpE - 3		2025/10/05

// 
// Testbench file for JK_FF.v (unit test)
// 
`timescale 10 ns / 10 ns			
module tb_JK_FF ();
	reg	iJ, iK, iClk, iReset;
	wire	oQ, oclk_div, oQ_bar;
	
	JK_FF UUT (	iJ, iK, iReset, iClk, oQ, oclk_div, oQ_bar);
	
	// initial value for clock
	initial
		iClk = 1'b0;
	
	// clock generator
	always
		#5	iClk = ~iClk;			// 50 ns * 2 = 100 ns = 10MHz
	
	// reset held high for a few clock cycles
	initial begin
		$display("| rst J K | Q ~Q");
		$display("Reset enabled");
		iReset = 1'b1;			repeat (2) @(negedge oclk_div);
		$display("Reset disabled");
		iReset = 1'b0;
	end
	
	// random test inputs
	initial begin
		{iJ, iK} = 2'b01;		repeat (3) @(negedge oclk_div);
		{iJ, iK} = 2'b10; 	repeat (2) @(negedge oclk_div);
		{iJ, iK} = 2'b11; 	repeat (3) @(negedge oclk_div);
		{iJ, iK} = 2'b00; 	repeat (2) @(negedge oclk_div);
		
		$display("Simulation finished at %0d ns", $time);
		$stop;
	end
	
	// monitor display
	// print for each change of input
	always @(iJ, iK, iReset)
		// $display(" %3d |   %1b %1b %1b | %1b %1b", $time, iReset, iJ, iK, oQ, oQ_bar);
		#1 $display("|   %1b %1b %1b | %1b %1b", iReset, iJ, iK, oQ, oQ_bar);
	
	// indicate negedge by >
	// wait for a brief delay before print-out
	always @(negedge oclk_div)
		// #0.1 $display(" %3d |   %1b %1b %1b > %1b %1b", $time - 0.1, iReset, iJ, iK, oQ, oQ_bar);
		#1 $display("|   %1b %1b %1b > %1b %1b", iReset, iJ, iK, oQ, oQ_bar);
		
endmodule
	
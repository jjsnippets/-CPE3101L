// CPE 3101L - INTRODUCTION TO HDL
// Group 1		F 7:30 - 10:30 AM LB285TC
// Lab Exercise #6.2
// Sarcol, Joshua S.		BS CpE - 3		2025/11/14

// 
// Testbench file for JK_FF.v (unit test)
// 
`timescale 1 ns / 1 ps			
module tb_JK_FF ();
	reg	iJ, iK, iClk, iReset;
	wire	oQ, oclk_div, oQ_bar;
	
	localparam div = 10;			// Divide simulation clock cycles by 10
										// not 10,000,000 as it will take forever to fully simulate
	
	JK_FF #(div) UUT (iJ, iK, iReset, iClk, oQ, oclk_div, oQ_bar);
	
	// initial value for clock
	initial
		iClk = 1'b0;
	
	// clock generator
	always
		#2.5	iClk = ~iClk;
	
	// reset held high for a few clock cycles
	initial begin
		$display("time | rst J K | Q ~Q");
		$display("Reset enabled");
		iReset = 1'b1;		#(17*div)
		$display("Reset disabled");
		iReset = 1'b0;
	end
	
	// random test inputs
	initial begin
		{iJ, iK} = 2'b01;	#(3*div)
		{iJ, iK} = 2'b01; #(5*div)
		{iJ, iK} = 2'b11; #(7*div)
		{iJ, iK} = 2'b00; #(9*div)
		{iJ, iK} = 2'b10; #(5*div)
		{iJ, iK} = 2'b01; #(6*div)
		{iJ, iK} = 2'b11; #(8*div)
		{iJ, iK} = 2'b00; #(4*div)
		{iJ, iK} = 2'b10; #(7*div)
		{iJ, iK} = 2'b11; #(5*div)
		{iJ, iK} = 2'b01; #(9*div)
		
		$display("Simulation finished at %0d ns", $time);
		$stop;
	end
	
	// monitor display
	// print for each change of input
	always @(iJ, iK, iReset)
		#0.1 $display(" %3d |   %1b %1b %1b | %1b %1b", $time - 0.1, iReset, iJ, iK, oQ, oQ_bar);
	
	// indicate falling-edge divded clock by >
	always @(negedge oclk_div)
		#0.1 $display(" %3d |   %1b %1b %1b > %1b %1b", $time - 0.1, iReset, iJ, iK, oQ, oQ_bar);
		
endmodule

	
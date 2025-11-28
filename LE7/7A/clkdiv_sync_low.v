// CPE 3101L - INTRODUCTION TO HDL
// Group 1                  F 7:30 - 10:30 AM LB285TC
// Lab Exercise #7
// Sarcol, Joshua S.        BS CpE - 3      2025/11/14

// Clock divider support module for LE7A and LE7B
// Syncronous active low
module clkdiv_sync_low #(parameter oldHz = 50_000_000, newHz = 2) (
    input wire  clk_in, rst,
    output reg  clk_out         );
    
    // Counter
    reg [25:0] cntr;        // (50,000,000 / 2) < 2^26
    
    // Comparator for half of the counter states
    wire cmpr;
    assign cmpr = (cntr == (oldHz / (newHz * 2)) - 1);
     
    // Counter increment and reset logic
    always @(negedge clk_in)
    begin
        // syncronous reset 
        if (!rst)       cntr <= 26'b0;

        // also reset if counter reached half of the counter states
        else if (cmpr)  cntr <= 26'b0;
        
        // increment by 1
        else            cntr <= cntr + 1'b1;
    end
    
    // 2 full comparator hits == 1 full period
    always @(negedge clk_in)
    begin
        if (!rst)       clk_out <= 1'b0;
        else if (cmpr)  clk_out <= !clk_out;
    end

endmodule

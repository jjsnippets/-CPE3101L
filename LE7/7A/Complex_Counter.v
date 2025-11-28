// CPE 3101L - INTRODUCTION TO HDL
// Group 1                  F 7:30 - 10:30 AM LB285TC
// Lab Exercise #7
// Sarcol, Joshua S.        BS CpE - 3      2025/11/14

//
// Verilog HDL code for a 3-bit binary/gray counter (Moore)
// Negative edge triggered, active low syncronous reset
//
module Complex_Counter #(parameter oldHz = 50_000_000, newHz = 1)   ( 
    input wire          CLOCK, nRESET, M,
    output reg [2:0]    COUNT, nstate,
    output wire         new_clk                                     );
    
    // Divided clock signal
    clkdiv_sync_low #(oldHz, newHz) (CLOCK, nRESET, new_clk);
    
    // State transitions and output assignment
    always  @(negedge new_clk)
        if (!nRESET)    COUNT <= 3'b000;
        else            COUNT <= nstate;
    
    // Next state assignments
    // M == 0: binary sequence
    // M == 1: gray code sequence
    always @(*)
        case (COUNT)
            3'b000:     nstate <=       3'b001         ;
            3'b001:     nstate <= (M) ? 3'b011 : 3'b010;
            3'b010:     nstate <= (M) ? 3'b110 : 3'b011;
            3'b011:     nstate <= (M) ? 3'b010 : 3'b100;
            3'b100:     nstate <= (M) ? 3'b000 : 3'b101;
            3'b101:     nstate <= (M) ? 3'b100 : 3'b110;
            3'b110:     nstate <= (M) ? 3'b111 : 3'b111;
            default:    nstate <= (M) ? 3'b101 : 3'b000;
        endcase   
        
endmodule

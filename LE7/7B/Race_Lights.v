// CPE 3101L - INTRODUCTION TO HDL
// Group 1                  F 7:30 - 10:30 AM LB285TC
// Lab Exercise #7
// Sarcol, Joshua S.        BS CpE - 3      2025/11/14

//
// Verilog HDL code for a race light (Mealy)
// Negative edge triggered, active low syncronous reset
//
module Race_Lights #(parameter oldHz = 50_000_000, newHz = 1)   (
    input wire          CLOCK, nRESET, START,
    output reg [2:0]    lights, cstate, nstate,
    output wire         new_clk                                 );
    
    // Light assignments:
    // RED    = lights[2]
    // YELLOW = lights[1]
    // GREEN  = lights[0]
    
    // Divided clock signal
    clkdiv_sync_low #(oldHz, newHz) (CLOCK, nRESET, new_clk);

    // State parmeters
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;
    localparam G = 3'b110;
              
    // State transistions
    always  @(negedge new_clk, negedge nRESET)
        if (!nRESET)    cstate <= A;
        else            cstate <= nstate;
    
    // Next state transitions
    always @(*)
        case (cstate)
            A:          nstate <= (START) ? B : A;
            B:          nstate <=           C    ;
            C:          nstate <=           D    ;
            D:          nstate <=           E    ;
            E:          nstate <=           F    ;
            default:    nstate <=           A    ;
        endcase
    
    // Output assignments
    always @(*)
        case (cstate)
            A:          lights <= 3'b100;
            B:          lights <= 3'b100;
            C:          lights <= 3'b010;
            D:          lights <= 3'b001;
            E:          lights <= 3'b001;
            F:          lights <= 3'b001;
            default:    lights <= 3'b100;
        endcase

endmodule

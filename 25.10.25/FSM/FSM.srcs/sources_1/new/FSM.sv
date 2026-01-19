`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 13:50:53
// Design Name: 
// Module Name: FSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// finish Start machine
module FSM(
    input clk, // clock
    input arst, // asynhrone reset
    input srst,// synhrone reset
    input ud,// up down
    output [3:0] q // output
    );
    
enum logic [3:0] { st0, st1, st2, st3} state;

always @(posedge clk or posedge arst)
    if (arst) state <= st0;
    else 
        case (state)
            st0: 
                if (srst)     state <= st0;
                else if (!ud) state <= st3; 
                else          state <= st1;
            st1: 
                if (srst)     state <= st0;
                else if (!ud) state <= st2; 
                else          state <= st0;
            st2: 
                if (srst)     state <= st0;
                else if (!ud) state <= st1; 
                else          state <= st3;
            st3: 
                if (srst)     state <= st0;
                else if (!ud) state <= st2; 
                else          state <= st0;         
        endcase

assign q[0] = (state == st0);
assign q[1] = (state == st1);
assign q[2] = (state == st2);
assign q[3] = (state == st3);
 
endmodule

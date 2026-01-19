`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 18:37:50
// Design Name: 
// Module Name: ShiftReg
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


module ShiftReg(
    input clk,
    input load,
    input sin,
    input [3:0] d,
    output logic [3:0] q
    );

always_ff @(posedge clk)
    if(load) q <= d;
    else q <= {q[2:0] ,sin};     
 
endmodule




`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 14:41:02
// Design Name: 
// Module Name: ttt
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

module ttt(
    input clk,
    input load,
    input sin,
    input [3:0] d,
    output logic [3:0] q
    );
    
always_ff @(posedge clk)
    if(load) q <= d;
    else q <= {q[2:0] , sin};
//    begin
//        q[3] <= q[2];
//        q[2] <= q[1];
//        q[1] <= q[0];
//        q[0] <= sin;
//    end
    
endmodule

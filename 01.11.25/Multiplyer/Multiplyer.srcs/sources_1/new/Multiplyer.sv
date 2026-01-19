`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2025 13:02:55
// Design Name: 
// Module Name: Multiplyer
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


module Multiplyer(
    input clk,
    input [3:0] a,
    input [3:0] b,
    output logic [7:0] m
    );

logic [3:0] pp [3:0];
logic [7:0] ppp [1:0];

assign pp[0] = {4{a[0]}} & b;
assign pp[1] = {4{a[1]}} & b;
assign pp[2] = {4{a[2]}} & b;
assign pp[3] = {4{a[3]}} & b;


// assign ppp[0] = {4'b0000, pp[0]}
//     + {3'b000, pp[1], 1'b0};
// assign ppp[1] = {2'b00, pp[2], 2'b00}
//     + {1'b0, pp[3], 3'b000};

// assign m = ppp[0] + ppp[1];

always_ff @(posedge clk) begin
    ppp[0] <= {4'b0000, pp[0]} + {3'b000, pp[1], 1'b0};
    ppp[1] <= {2'b00, pp[2], 2'b00} + {1'b0, pp[3], 3'b000};
    m <= ppp[0] + ppp[1];
end
// assign m = {4'b0000, pp[0]}
//         +   {3'b000, pp[1], 1'b0}
//         +   {2'b00, pp[2], 2'b00}
//         +   {1'b0, pp[3], 3'b000};

endmodule

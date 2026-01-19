`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 14:15:19
// Design Name: 
// Module Name: TB_ddd
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


module TB_ddd();

logic clk,d,q;

dddd DFF(.clk(clk), .d(d), .q(q));

always begin
    clk = 1'b1; #5;
    clk = 1'b0; #5;
end

initial begin
    d = 0; #10;
    d = 1; #10;
    d = 0; #10;
    d = 1; #10;

$finish;
end

endmodule

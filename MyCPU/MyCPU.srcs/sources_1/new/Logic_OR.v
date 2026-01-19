`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 10:56:22
// Design Name: 
// Module Name: Logic_OR
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


module Logic_OR(
input a,b,//sw1 and sw2
output c,d,osc
    );
    
assign c =~(a&b);
assign d = ~c;
assign osc = c; // out oscilograph
    
endmodule

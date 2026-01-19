`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 14:06:38
// Design Name: 
// Module Name: dddd
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


module dddd(
    input d,
    input clk,
    output bit q
    );
     
/// Это происходит всегда
//always_comb begin
  //  q = d;
//end
     
/// Данное событие происходит только при положительно clk
always @(posedge clk) begin
    q <= d;
end
    
endmodule

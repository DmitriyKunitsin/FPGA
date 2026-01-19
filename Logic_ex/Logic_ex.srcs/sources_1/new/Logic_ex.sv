`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 13:34:10
// Design Name: 
// Module Name: Logic_ex
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


module Logic_ex(
    input wire [1:0] SW,
    output logic [3:0] LED
    );
    
assign LED[0] = !SW[0];
assign LED[1] = SW[1] && SW[0];
assign LED[2] = SW[1] || SW[0];
assign LED[3] = SW[1] ^ SW[0];

endmodule

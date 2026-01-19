`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2025 14:01:57
// Design Name: 
// Module Name: TB_Multiplyer_reg
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



module TB_Multiplyer();

logic [3:0] a,b;
logic [7:0] m;

logic start, ready,clk;

Multiplyer DUT(.clk(clk), .start(start), .a(a), .b(b), .ready(ready), .m(m));

always begin
    clk = 1'b0; #5;
    clk = 1'b1; #5;
end

initial begin 
    a = 0; b = 0; #10;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            a = i[3:0];  
            b = j[3:0];  
            #10;         
        end
    end
$finish;
end

endmodule
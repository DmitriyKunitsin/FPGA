`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 14:50:42
// Design Name: 
// Module Name: TB_ttt
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


module TB_ttt();

logic       clk, sin, load;
logic [3:0] d,q;

ttt DUT(.clk(clk), .load(load), .sin(sin), .d(d), .q(q));


always begin
    clk = 1'b0; #5;
    clk = 1'b1; #5;
end

initial begin
    d = 4'h5; load = 1'b1;  #10;
    sin = 1'b0; load = 1'b0;  #10;
    sin = 1'b1; load = 1'b0;  #10;
    sin = 1'b0; load = 1'b0;  #10;
    sin = 1'b1; load = 1'b0;  #10;

$finish;
end

endmodule

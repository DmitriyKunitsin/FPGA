`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 14:01:18
// Design Name: 
// Module Name: TB_FSM
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


module TB_FSM();

wire [3:0] q;
reg clk, arst, srst, ud;

FSM DUT(.clk(clk), .arst(arst), .srst(srst), .ud(ud), .q(q));

always begin // запуск тактового сигнала всегда
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
    arst = 1; srst = 0; #10;
    ud = 0;   arst = 0; #50;
              srst = 1; #10;
              srst = 0; #50;
    ud = 1;             #50;
$finish;
end

endmodule





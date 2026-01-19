`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 15:09:35
// Design Name: 
// Module Name: TB_FSM_Variable
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


module TB_FSM_Variable();

logic clk;
logic [2:0] div; 

logic q;

FSM_Variable DUT(
    .clk(clk),
    .div(div),
    .q(q)
);

always begin
    clk = 1; #5;
    clk = 0; #5;
end 

initial begin
    div = 3'd0 ; #10; // 1 CLOCK CICLE
    
    div = 3'd1;
    repeat(5) begin
        #10;
    end
    
    div = 3'd2;
    repeat(6) begin
        #10;
    end
    
    div = 3'd3;
    repeat(9) begin
        #10;
    end
    
    div = 3'd4;
    repeat(12) begin
        #10;
    end
    
    div = 3'd5;
    repeat(15) begin
        #10;
    end
    
    div = 3'd6;
    repeat(18) begin
        #10;
    end
    
    div = 3'd7;
    repeat(21) begin
        #10;
    end
    
    div = 3'd8; // our of range, q not change
    repeat(15) begin
        #10;
    end
$finish;
end

endmodule

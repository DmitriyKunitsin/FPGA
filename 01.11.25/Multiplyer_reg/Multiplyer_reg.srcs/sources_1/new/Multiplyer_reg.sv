`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2025 13:44:22
// Design Name: 
// Module Name: Multiplyer_reg
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


module Multiplyer_reg(
    input clk,
    input start,
    input [3:0] a,
    input [3:0] b,
    output logic ready,
    output logic [7:0] m
    );

logic [3:0] a_reg, b_reg, mh_reg, ml_reg;
logic [3:0] pp [3:0];
logic [4:0] summ;

enum logic [2:0] { idle, pp0, pp1, pp2, pp3 } state = idle;

always_ff @(posedge clk) begin
    if(start) begin
        a_reg <= a;
        b_reg <= b;
    end else 
        a_reg <= {1'b0, a_reg[3:1]};
end 

assign pp = {4{a_reg[0]}} & b_reg; 
assign summ = {1'b0, pp} + ((state == pp0) ? 4'b0000 : summ[4:1]);

always_ff @(posedge clk) begin
    mh_reg <= summ[4:1];
    ml_reg <= {summ[0], ml_reg[3:1]}; 
end

always_ff @(posedge clk) begin
    case (state)
        idle: if (start)  state <= pp0; else state <= idle;
        pp0:              state <= pp1;
        pp1:              state <= pp2;
        pp2:              state <= pp3;
        pp3:  if (start)  state <= pp0; else state <= idle; 
    endcase
end

always_ff @(posedge clk) begin
    if (state == pp3) ready <=  1'b1;
    else              ready <=  1'b0;
end

assign m = {mh_reg , ml_reg};

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 14:51:13
// Design Name: 
// Module Name: FSM_Variable
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


module FSM_Variable(
    input clk,
    input [2:0] div,
    output logic q
    );

logic [2:0] cnt_clk = 2; // conter for clk
logic q_reg = 0; // register for q

assign q = q_reg;



always @(posedge clk)
    if(div >= 3'd2 && div <= 3'd7) begin // between 2 to 7
        if(cnt_clk <= div) begin  // if next div cnt++
            cnt_clk <= cnt_clk + 1;
            q_reg <= 1;
        end else begin // else cnt == 2
            cnt_clk <= 2;
            q_reg <= ~q_reg;
        end
    end else begin 
        cnt_clk <= cnt_clk;  // else leave cnt and q 
        q_reg <= q_reg;
    end
endmodule

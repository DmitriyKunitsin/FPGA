`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 14:11:34
// Design Name: 
// Module Name: pl_blink
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


module pl_blink(
    input logic sys_clk,
    input logic btn_reset,
    output logic led1,
    output logic led2,
    output logic led3,
    output logic led4
    );

    logic state_led; // State led
    logic[31:0] counter;

    always_ff @( posedge sys_clk or posedge btn_reset ) begin : blockName
        if ( btn_reset ) begin
            counter <= 32'b0;
            state_led <= !state_led;
        end
        else begin
            if(counter > 12000000) begin
                state_led <= !state_led;
                counter <= 32'b0;
            end else begin
                counter <= counter + 1;
            end
        end 
    end

    assign led1 = state_led;
    assign led2 = state_led;
    assign led3 = state_led;
    assign led4 = state_led;

endmodule

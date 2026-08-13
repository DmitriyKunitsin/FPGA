`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.08.2026 16:56:18
// Design Name:
// Module Name: breath_led_tb
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


`timescale 1ns / 1ns
module breath_led_tb ();

  logic clk_reg;
  logic rstn_reg;
  logic [3:0] led;

  logic clk;
  logic rstn;

  initial begin
    clk_reg  = 0;
    rstn_reg = 0;
    #10 rstn_reg = 1;
  end

  always #1 clk_reg = ~clk_reg;
  assign rstn = rstn_reg;
  assign clk  = clk_reg;
  breath_led #(
      .CLOCK_FRQ(1000000)
  ) breath_led_inst (
      .clk (clk),
      .rstn(rstn),
      .led (led)
  );
endmodule


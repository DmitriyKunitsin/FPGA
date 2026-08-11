`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 15:46:02
// Design Name: 
// Module Name: breath_led
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

module breath_led #(
    parameter CLOCK_FRQ = 50000000,  // Частота тактового генератора 50M
    parameter PWM_FRQ = 1000,  // Частота ШИМ 1кГц
    parameter BREATH_PERIOD = 2,  // Период дыхания 2 секунды
    parameter   SET_COMPARE_FRQ=1000,// Частота обновления яркости 1 кГц
    parameter   PWM_COUNTER_MAX=CLOCK_FRQ/PWM_FRQ,// шагов ШИМ за один период
    parameter BREATH_COUNTER_MAX = CLOCK_FRQ * BREATH_PERIOD,  // тактов за 2 секунды
    parameter SET_COMPARE_COUNTER_MAX = CLOCK_FRQ / SET_COMPARE_FRQ,  // 
    parameter  	COMPARE_VALUE_STEP=PWM_COUNTER_MAX/SET_COMPARE_FRQ// шаг изменения яркости за 1 мс
) (
    input logic clk,
    input logic rstn,
    output logic [3:0] led
);
  logic [31:0] counter_pwm;
  logic [31:0] counter_breath;
  logic [31:0] counter_compare;
  logic [31:0] compare_value;
  logic pwm_period_clk_view;
  logic breath_period_clk_view;
  logic compare_period_clk_view;
  logic [3:0] led_number;

  logic led_breath_view;
  logic breath_dir;
  logic [3:0] led_logic;
  assign led = led_logic;

  // led
  always @(posedge clk) begin
    if (rstn == 0) led_logic <= 0;
    case (led_number)
      8'b000:  led_logic[0] <= led_breath_view;
      8'b001:  led_logic[1] <= led_breath_view;
      8'b010:  led_logic[2] <= led_breath_view;
      8'b011:  led_logic[3] <= led_breath_view;
      default: led_logic[0] <= led_breath_view;
    endcase
  end

  // ШИМ 
  always @(posedge clk or negedge rstn) begin
    if (rstn == 0) begin
      counter_pwm <= 0;
      pwm_period_clk_view <= 0;
    end else begin
      counter_pwm <= counter_pwm + 1;
      if (counter_pwm < compare_value) begin
        led_breath_view <= 1;
      end else begin
        led_breath_view <= 0;
      end
      if (counter_pwm > PWM_COUNTER_MAX - 1) begin
        counter_pwm <= 0;
        pwm_period_clk_view <= ~pwm_period_clk_view;
      end
    end
  end

  //led
  logic [3:0] led_number_state;
  always @(posedge clk or negedge rstn) begin
    if (rstn == 0) begin
      led_number = 0;
      counter_breath <= 0;
      breath_period_clk_view <= 0;
      breath_dir <= 0;
      led_number_state <= 0;
    end else begin
      counter_breath <= counter_breath + 1;
      if (counter_breath > BREATH_COUNTER_MAX - 1) begin
        counter_breath <= 0;
        breath_period_clk_view <= ~breath_period_clk_view;
        breath_dir <= ~breath_dir;
        if (breath_dir == 1) begin
          case (led_number_state)
            0: begin
              led_number_state = 1;
              led_number = 0;
            end
            1: begin
              led_number_state = 2;
              led_number = 1;
            end
            2: begin
              led_number_state = 3;
              led_number = 2;
            end
            3: begin
              led_number_state = 4;
              led_number = 3;
            end
            4: begin
              led_number_state = 5;
              led_number = 2;
            end
            5: begin
              led_number_state = 6;
              led_number = 1;
            end
            6: begin
              led_number_state = 0;
              led_number = 0;
            end
            default: begin
              led_number_state = 0;
              led_number = 0;
            end
          endcase
        end
      end
    end
  end

  //?????????????
  always @(posedge clk or negedge rstn) begin
    if (rstn == 0) begin
      counter_compare <= 0;
      compare_period_clk_view <= 0;
      compare_value <= 0;
    end else begin
      counter_compare <= counter_compare + 1;
      if (counter_compare > SET_COMPARE_COUNTER_MAX - 1) begin
        counter_compare <= 0;
        if (breath_dir == 0) begin
          if (compare_value < PWM_COUNTER_MAX) compare_value <= compare_value + COMPARE_VALUE_STEP;
        end else if (breath_dir == 1) begin
          if (compare_value > 0) compare_value <= compare_value - COMPARE_VALUE_STEP;
        end
        compare_period_clk_view <= ~compare_period_clk_view;
      end
    end
  end
endmodule



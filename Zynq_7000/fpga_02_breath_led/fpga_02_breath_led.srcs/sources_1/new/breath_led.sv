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
    parameter int CLOCK_FRQ = 50000000,  // Чаѝтота тактового генератора 50M
    parameter int PWM_FRQ = 1000,  // Чаѝтота ШИМ 1кГц
    parameter int BREATH_PERIOD = 2,  // Период дыханиѝ 2 ѝекунды
    parameter int SET_COMPARE_FRQ=1000,// Чаѝтота обновлениѝ ѝркоѝти 1 кГц
    parameter int PWM_COUNTER_MAX=CLOCK_FRQ/PWM_FRQ,// шагов ШИМ за один период
    parameter int BREATH_COUNTER_MAX = CLOCK_FRQ * BREATH_PERIOD,  // тактов за 2 ѝекунды
    parameter int SET_COMPARE_COUNTER_MAX = CLOCK_FRQ / SET_COMPARE_FRQ,  //
    parameter int COMPARE_VALUE_STEP=PWM_COUNTER_MAX/SET_COMPARE_FRQ// шаг ѝркоѝти за 1 мѝ
) (
    input logic clk,  // тактирование
    input logic rstn,  // Кнопка сброса
    output logic [3:0] led
);
  bit [31:0] counter_pwm;  // счетчик шим
  bit [31:0] counter_breath;  // счетчик дыхания
  bit [31:0] counter_compare;  // счетчик шага ШИМ
  bit [31:0] compare_value;
  bit [3:0] led_number;

  logic led_breath_view;
  logic breath_dir;
  bit [3:0] led_logic;  // Выбор led, который будет светиться
  assign led = led_logic;

  // led
  always @(posedge clk) begin
    if (rstn == 0) led_logic <= 0;  // Обнуляем если ресет кнопка
    case (led_number)  // Обовляем состояние выбранного led
      2'b000:  led_logic[0] <= led_breath_view;
      2'b001:  led_logic[1] <= led_breath_view;
      2'b010:  led_logic[2] <= led_breath_view;
      2'b011:  led_logic[3] <= led_breath_view;
      default: led_logic[0] <= led_breath_view;
    endcase
  end

  // ШИМ
  always @(posedge clk or negedge rstn) begin
    if (rstn == 0) begin  // Обнуляем шип и период
      counter_pwm <= 0;
    end else begin
      counter_pwm <= counter_pwm + 1;  // инекрементируем счетчик шима
      if (counter_pwm < compare_value) begin
        // включаем пока счетчик меньше порога
        led_breath_view <= 1;  // включаем
      end else begin
        led_breath_view <= 0;  // выключаем
      end
      if (counter_pwm > PWM_COUNTER_MAX - 1) begin  // Если счетчик перещелкал
        counter_pwm <= 0;  // обнуляем счетчик
      end
    end
  end

  // Логика управления дыханием led
  logic [3:0] led_number_state;
  always @(posedge clk or negedge rstn) begin
    if (rstn == 0) begin  // кнопка сброса
      led_number = 0;
      counter_breath <= 0;
      breath_dir <= 0;
      led_number_state <= 0;
    end else begin
      counter_breath <= counter_breath + 1;  // инекрементируем дыхание
      if (counter_breath > BREATH_COUNTER_MAX - 1) begin  // если вышли за MAX_VALUE
        counter_breath <= 0;  // Обнуляем дыхание
        breath_dir <= ~breath_dir;  // направление дыхания
        if (breath_dir == 1) begin
          case (led_number_state)  // led для дыхания
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

  // Блок счетчика для шага ШИМ (шаг изменения яркости)
  always @(posedge clk or negedge rstn) begin
    if (rstn == 0) begin  // кнопка сброса
      counter_compare <= 0;
      compare_value   <= 0;
    end else begin
      counter_compare <= counter_compare + 1;  // счетчик
      if (counter_compare > SET_COMPARE_COUNTER_MAX - 1) begin
        counter_compare <= 0;
        if (breath_dir == 0) begin
          if (compare_value < PWM_COUNTER_MAX) begin  // Шаг дыхания ярче
            compare_value <= compare_value + COMPARE_VALUE_STEP;
          end
        end else if (breath_dir == 1) begin
          if (compare_value > 0) begin  // Шаг дыхания затухание
            compare_value <= compare_value - COMPARE_VALUE_STEP;
          end
        end
      end
    end
  end
endmodule



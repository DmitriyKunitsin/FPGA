`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2026 10:17:15
// Design Name: 
// Module Name: alu
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

module alu (
    input  [7:0] a,        // input A
    input  [7:0] b,        // input B
    input  [1:0] op,       // operation 00=ADD, 01=SUB, 10=INC, 11=DEC
    output [7:0] result,   // Result
    output       zero,      // flag ZERO
    output       overflow // out between 8-bit
);

parameter ADD = 2'b00; 
parameter SUB = 2'b01;
parameter INC = 2'b10; // Increment by 1
parameter DEC = 2'b11; // Decrement bt 1

logic [7:0] result_int; // local variable for ariphmetic

always @(*) begin
    case (op)
    ADD : begin
        result_int <= a + b;
    end
    SUB : begin
        result_int <= a - b;
    end
    INC : begin
        result_int <= a + b;
    end
    DEC : begin
        result_int <= a - b;
    end
    default : begin  // Fault Recovery
        result_int <= 8'd0;
    end
    endcase
end        

assign result = result_int;
assign zero = (result_int == 8'd0);
assign overflow = 
    (op == ADD) ? (a + b < a) : 
    (op == SUB) ? (a - b > a) :
    (op == INC) ? (a == 8'hFF) :  // overflow by incremente 255 → 0
    (op == DEC) ? (a == 8'd0)  :  // overflow by dicremente 0 → 255
    1'b0;

endmodule

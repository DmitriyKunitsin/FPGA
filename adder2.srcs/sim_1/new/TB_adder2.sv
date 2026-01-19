`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2025 13:04:51
// Design Name: 
// Module Name: TB_adder2
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


module TB_adder2();
logic a, b, cin, cout, s;

adder2 DUT(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

initial begin
    {cin, a, b} = 3'b000;   #10;
    repeat (7) begin
        {cin, a, b} = {cin, a, b} + 1;  #10;
    end
$finish;
end

endmodule

module TB_adder4();
logic   [3:0]   a, b, s;
logic           cin, cout; 

adder4 DUT(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

initial begin
    {cin, a, b} = 9'b0_0000_0000;   #10;
    repeat (511) begin
        {cin, a, b} = {cin, a, b} + 1;  #10;
    end
$finish;
end

endmodule

module TB_adder16();
logic   [15:0]   a, b, s;
logic           cin, cout; 

adder16 DUT(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

initial begin
    a = 16'h0000; b = 16'h0000; cin = 0;  #10;
    a = 16'hffff; b = 16'h0000; cin = 0;  #10;
    a = 16'h0000; b = 16'hffff; cin = 0;  #10;
    a = 16'hffff; b = 16'hffff; cin = 0;  #10;
    a = 16'h0000; b = 16'h0000; cin = 1;  #10;
    a = 16'hffff; b = 16'h0000; cin = 1;  #10;
    a = 16'h0000; b = 16'hffff; cin = 1;  #10;
    a = 16'hffff; b = 16'hffff; cin = 1;  #10;
    a = 16'h5555; b = 16'h5555; cin = 0;  #10;
    a = 16'haaaa; b = 16'haaaa; cin = 0;  #10;
    a = 16'h5555; b = 16'haaaa; cin = 0;  #10;
$finish;
end

endmodule

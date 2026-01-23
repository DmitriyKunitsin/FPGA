`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2026 10:43:10
// Design Name: 
// Module Name: tb_simple_cpu
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


module tb_simple_cpu();


reg clk, reset;

initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
end

initial begin
    reset = 1;
    #10 reset = 0;  //  Reset 10 ns, after let go
end
// Init memory
initial begin
    $readmemb("memory.mem", simple_cpu.ram, 0 ,3);
end

initial begin
    $dumpfile("tb_simple_cpu.vcd");
    $dumpvars(0, tb_simple_cpu);

    #1000 $finish; // Finish simulation after 1000 ns
end


// Out Console
initial begin
    $monitor("[%0t] acc=%0d, ip=%0d, state=%d, num_cycles=%0d, d_out=%0d",
                $time, simple_cpu.acc, simple_cpu.ip, simple_cpu.state, 
                simple_cpu.num_cycles, simple_cpu.d_out);
end

simple_cpu dut(
    .clk(clk),
    .reset(reset)
);



endmodule

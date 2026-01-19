`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2025 13:01:00
// Design Name: 
// Module Name: adder2
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


module adder2(
    input a,
    input b,
    input cin,
    output s,
    output cout
    );
    
assign s = a ^ b ^ cin;    
assign cout = (a & b) | ((a ^ b) & cin);     
    
endmodule

module adder4(
    input   [3:0]   a,
    input   [3:0]   b,
    input           cin,
    output  [3:0]   s,
    output          cout,
    output          p_g,
    output          g_g
    );
logic   [3:0]   p, g;
logic   [4:0]   c;

assign c[0] = cin;
    
//assign s[0] = a[0] ^ b[0] ^ c[0];    
//assign c[1] = (a[0] & b[0]) | ((a[0] ^ b[0]) & c[0]);     
//assign s[1] = a[1] ^ b[1] ^ c[1];    
//assign c[2] = (a[1] & b[1]) | ((a[1] ^ b[1]) & c[1]);     
//assign s[2] = a[2] ^ b[2] ^ c[2];    
//assign c[3] = (a[2] & b[2]) | ((a[2] ^ b[2]) & c[2]);     
//assign s[3] = a[3] ^ b[3] ^ c[3];     
//assign c[4] = (a[3] & b[3]) | ((a[3] ^ b[3]) & c[3]);     

genvar i;
generate
    for (i=0; i < 4; i=i+1)
    begin: label
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] ^ b[i]; 
        assign s[i] = a[i] ^ b[i] ^ c[i];    
//        assign c[i+1] = (a[i] & b[i]) | ((a[i] ^ b[i]) & c[i]);     
//        assign c[i+1] = g[i] | (p[i] & c[i]);     
    end
endgenerate

//assign c[1] = g[0] | (p[0] & c[0]);
//assign c[2] = g[1] | (p[1] & c[1]);
//assign c[3] = g[2] | (p[2] & c[2]);
//assign c[4] = g[3] | (p[3] & c[3]);

assign c[1] = g[0] 
            | p[0] & c[0];
assign c[2] = g[1] 
            | p[1] & g[0] 
            | p[1] & p[0] & c[0];
assign c[3] = g[2] 
            | p[2] & g[1] 
            | p[2] & p[1] & g[0] 
            | p[2] & p[1] & p[0] & c[0];
assign c[4] = g[3] 
            | p[3] & g[2] 
            | p[3] & p[2] & g[1] 
            | p[3] & p[2] & p[1] & g[0] 
            | p[3] & p[2] & p[1] & p[0] & c[0];

assign cout = c[4]; 
assign g_g = g[3] 
         | p[3] & g[2] 
         | p[3] & p[2] & g[1] 
         | p[3] & p[2] & p[1] & g[0];
assign p_g = p[3] & p[2] & p[1] & p[0];
         
//assign {cout, s} = a + b + cin;
    
endmodule

module adder16(
    input   [15:0]   a,
    input   [15:0]   b,
    input           cin,
    output  [15:0]   s,
    output          cout
    );
logic   [3:0]   p, g;
logic   [4:0]   c;

assign c[0] = cin;  

genvar i;
generate
    for (i=0; i < 4; i=i+1)
    begin: label
        adder4 ADDER4(.a(a[4*i+3:4*i]), .b(b[4*i+3:4*i]), .cin(c[i]),
               .s(s[4*i+3:4*i]), .cout(), .p_g(p[i]), .g_g(g[i]));
                
    end
endgenerate

assign c[1] = g[0] 
            | p[0] & c[0];
assign c[2] = g[1] 
            | p[1] & g[0] 
            | p[1] & p[0] & c[0];
assign c[3] = g[2] 
            | p[2] & g[1] 
            | p[2] & p[1] & g[0] 
            | p[2] & p[1] & p[0] & c[0];
assign c[4] = g[3] 
            | p[3] & g[2] 
            | p[3] & p[2] & g[1] 
            | p[3] & p[2] & p[1] & g[0] 
            | p[3] & p[2] & p[1] & p[0] & c[0];

assign cout = c[4]; 

//assign {cout, s} = a + b + cin;
    
endmodule

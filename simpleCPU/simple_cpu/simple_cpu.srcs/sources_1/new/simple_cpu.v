`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 14:27:57
// Design Name: 
// Module Name: simple_cpu
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

// lOGIC CPU Fetch -> Decode -> Execute;
module simple_cpu(
    input wire clk,
    input wire reset
    );
    
// ---------Variable---------   
logic [7:0] acc; // Accumulator (8 bit) A Register for saved of data during calculate
logic [1:0] ip; // Pointer on currented instruct 
logic [7:0] instr_reg; // Register instructhn - save readed command
logic [7:0] d_out; // Data from ram

// ---Microcontroller - just two state ---
enum logic { FETCH, DECODE ,EXECUTE } state; // FETCH - freeding , DECODE - analitic ,EXECUTE - worked command


// =============== Mictrocontroller ================
always @(posedge clk or posedge reset) begin
    if(reset) begin // if pressed reset
        state <= FETCH;
    end
    else
        case(state)
            FETCH : state <= EXECUTE;
            DECODE : state <= DECODE;
            EXECUTE : state <= FETCH;
        endcase
end

// ================Poninter ont instruct ===============
always @(posedge clk or posedge reset) begin
    if(reset) begin // if pressed reset
        ip <= 'b0;
    end
    else if(state == FETCH || state == EXECUTE || state == DECODE) begin
        ip <= 'b1 + ip; // increment tact
    end
end

// =============== ACCUMULATOR ========================
always @(posedge clk or posedge reset) begin
    if(reset) begin // if pressed reset
        acc <= 8'b00000000;
    end
end

// =============== Instruction Register ========================
always @(posedge clk or posedge reset) begin
    if(reset) begin // if pressed reset
        instr_reg <= 8'b00000000;
    end
    if(state == FETCH) begin // if read FETCH it read data
        instr_reg <= d_out;
    end
end
// ============== MEMORY ===================

// --- Memory instruct - jusg four cell by one byte ---
logic [7:0] ram[3:0];

initial begin
    $readmemb("memory.mem", ram, 0 , 3);
end

always @(posedge clk) begin
    d_out <= ram[ip]; // Read data for ram
end


endmodule

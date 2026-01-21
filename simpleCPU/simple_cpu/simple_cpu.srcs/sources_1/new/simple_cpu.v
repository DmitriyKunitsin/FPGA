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
// ============== Variable =================   
logic [7:0] acc; // Accumulator (8 bit) A Register for saved of data during calculate
logic [1:0] ip; // Pointer on currented instruct 
logic [2:0] AddresInstruction; // Adress instruction
logic [2:0] insturctionReading; // select Instruction
logic [1:0] NumCyclesPerfomInstrution; // Numer of cycles on done instruction 
logic [7:0] d_out; // Data from ram
logic [7:0] num_cycles; // Counter Cycles
    
// ============== MEMORY ===================
// ============== Memory instruct ==========
logic [7:0] ram[3:0];

initial begin
    $readmemb("memory.mem", ram, 0 , 3);
end



// =============== Mictrocontroller ================
enum logic [2:0] {FETCH = 3'b000, // FETCH - freeding
                 DECODE = 3'b001,// DECODE - analitic
                 EXECUTE = 3'b010, // EXECUTE - worked command
                 LOAD = 3'b011,// LOAD DATA for RAM
                 ADD = 3'b100,// +++ plus
                 DIMINISH = 3'b101,// ---- minus
                 BUS_FREE = 3'b110,// Data bus free 
                 FREE = 3'b111} state;
                 
parameter ld    = 3'b000; // CMD LOAD
parameter ad    = 3'b010; // CMD ADD
parameter minus = 3'b001; // DIMINISH

// lOGIC FSM Fetch -> Decode -> Execute;
always @(posedge clk or posedge reset) begin
    if(reset) begin // if pressed reset
        ip = 'b0;
        state <= FETCH;
        num_cycles <= 0;
        AddresInstruction <= 3'b000;
        insturctionReading <= 3'b000;
        NumCyclesPerfomInstrution <= 2'b00;
    end
    else
        case(state)
            FETCH : begin 
                // =============== FETCH ==================
                // 1. Reading instruction
                // 2. Entered next status
                // 3. Saved Numeric clock cycles for done instruction
                // 4. If num_cycles >= 1, flags free bus on
                // 5. num_cycles decrement 
                if(num_cycles == 0) begin
                    d_out <= ram[ip];
                    ip <= ip + 1;
                    num_cycles <= NumCyclesPerfomInstrution;
                    state <= DECODE;
                    // TODO READ NEXT INSTRUCT
                end
            end
            DECODE : begin
                NumCyclesPerfomInstrution <= d_out[1:0]; // reading clock cycles for done instruction
                AddresInstruction <= d_out[4:2]; // read adress
                insturctionReading <= d_out[7:5]; // read command
                state <= EXECUTE;
            end
            EXECUTE : begin
                if(num_cycles > 0) begin
                    num_cycles <= num_cycles - 1; // Waited done instruction
                end else begin
                    case(insturctionReading)
                            ld : state <= LOAD;
                            ad : state <= ADD;
                            minus : state <= DIMINISH;
                    endcase
                    state <= BUS_FREE;
                end
            end
            BUS_FREE : begin
                state <= FETCH;
            end
        endcase
end
// always @(posedge clk or posedge reset) begin
//     if(reset) begin
//         ip = 'b0;
//         state <= FETCH;
//         num_cycles <= 0;
//     end
//     else if(state == FETCH && num_cycles == 0) begin
//         d_out <= ram[ip];
//         ip <= ip + 1;
//         num_cycles <= NumCyclesPerfomInstrution;
//         state <= DECODE;
//         // TODO READ NEXT INSTRUCT
//     end
// end

// =============== DECODE =================
// always @(posedge clk or posedge reset) begin
//     if(reset) begin // if pressed reset
//         AddresInstruction <= 3'b000;
//         insturctionReading <= 3'b000;
//         NumCyclesPerfomInstrution <= 2'b00;
//     end
//     if(state == DECODE) begin // if read DECODE it read data
//         NumCyclesPerfomInstrution <= d_out[1:0]; // reading clock cycles for done instruction
//         AddresInstruction <= d_out[4:2]; // read adress
//         insturctionReading <= d_out[7:5]; // read command
//         state <= EXECUTE;
//     end
// end

// ================ EXECUTE ===============
// always @(posedge clk or posedge reset) begin
//     if(reset) begin// if pressed reset
//         acc <= 8'd0;
//     end
//     else if(state == LOAD) begin
//         acc <= d_out;
//         num_cycles <= 1 - num_cycles;
//         state <= BUS_FREE;
//     end
//     else if(state == ADD) begin
//         acc <= acc + d_out;
//     end
//     else if(state == DIMINISH) begin
//         acc <= acc - d_out;
//     end
//     else if(state == BUS_FREE) begin
//         state <= FETCH;
//         // TODO 
//     end
// end



endmodule

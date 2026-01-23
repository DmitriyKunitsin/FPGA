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
logic [7:0] alu_b;
logic [7:0] alu_result;
logic [1:0] alu_zero;
logic [1:0] alu_overflow;
logic [1:0] ip; // Pointer on currented instruct 
logic [2:0] AddresInstruction; // Adress instruction
logic [2:0] insturctionReading; // select Instruction
logic [1:0] NumCyclesPerfomInstrution; // Numer of cycles on done instruction 
logic [7:0] d_out; // Data from ram
logic [7:0] num_cycles; // Counter Cycles
    
alu my_alu(.a(acc), .b(alu_b), .op(insturctionReading), .result(alu_result), .zero(alu_zero), .overflow(alu_overflow));    

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
                 SUB = 3'b101,// ---- minus
                 ADD_WAIT = 3'b110,// Data bus free 
                 SUB_WAIT = 3'b111} state;
                 
parameter ld    = 3'b011; // CMD LOAD
parameter ad    = 3'b100; // CMD ADD
parameter sub   = 3'b101; // DIMINISH

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
                //if(num_cycles == 0) begin
                d_out <= ram[ip];
                ip <= ip + 1;
                num_cycles <= NumCyclesPerfomInstrution;
                state <= DECODE;
                // TODO READ NEXT INSTRUCT
                //end
            end
            DECODE : begin
                NumCyclesPerfomInstrution <= d_out[1:0]; // reading clock cycles for done instruction
                AddresInstruction <= d_out[4:2]; // read adress
                insturctionReading <= d_out[7:5]; // read command
                state <= EXECUTE;
            end
            EXECUTE : begin
                // if(num_cycles > 0) begin
                //     num_cycles <= num_cycles - 1; // Waited done instruction
                // end else begin
                case(insturctionReading)
                        ld : state <= LOAD;
                        ad : state <= ADD;
                        sub : state <= SUB;
                endcase
                //end
            end
            LOAD : begin
                //$monitor("[%0t] LOAD: d_out <= %0d (from RAM[%0d])", $time, d_out, AddresInstruction);
                acc <= AddresInstruction; // read Data in adress
                state <= FETCH;
                //$monitor("Result CMD_LOAD :acc = %d", acc);
            end
            ADD : begin
                //$monitor("[%0t] ADD: acc = %0d + %0d = %0d", $time, acc, alu_b, acc + alu_b);
                insturctionReading <= ad;
                alu_b <= AddresInstruction;
                state <= ADD_WAIT;
            end
            ADD_WAIT: begin
                acc <= alu_result;
                state <= FETCH;
                //$monitor("Alu_ADD result : %d", acc);
            end
            SUB : begin
                //$monitor("[%0t] SUB: acc = %0d - %0d = %0d", $time, acc, alu_b, acc - alu_b);
                //insturctionReading <= sub;
                alu_b <= AddresInstruction;
                state <= SUB_WAIT;
            end
            SUB_WAIT : begin
                acc <= alu_result;
                state <= FETCH;
                //$monitor("Alu_SUB result : %d", acc);
            end
        endcase
end

endmodule

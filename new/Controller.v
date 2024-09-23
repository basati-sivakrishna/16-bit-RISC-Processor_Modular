`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 15:30:19
// Design Name: 
// Module Name: Controller
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


module Controller(
input clk, rst_n,
input [15:0] instr,
output reg IPR_en, IPR_latch, IR_latch, wrd_sel, rd_sel, rs1_sel, A_latch, A_en, B_latch, B_en, ALU_latch, ALU_en, PC_latch, Reg_wr_en, Mem_wr_en, PC_mux_en,
output reg [1:0] rs2_sel, ALU_sel);

parameter RESET = 0, FETCH = 1, RR = 2, EXE = 3, WB_ALUR = 4, RI = 5, WB_ALUI = 6, WB_MEM = 7, STORE = 8, BRT = 9, PC_SUM = 10; 
reg [3:0] state, next_state; 

always @(posedge clk) begin
    if(!rst_n) state <= RESET;
    else state <= next_state;
end
//All registers are initially enabled and are not latched.
//The select muxes have PC and +1 selected.
//Register bank and data memory are not wr_enabled.

always @(*) begin
    IPR_latch = 1'b0; IPR_en = 1'b1; IR_latch = 1'b0; PC_latch = 1'b0; PC_mux_en = 1'b0;
    wrd_sel = 1'b0; rd_sel = 1'b1; rs1_sel = 1'b1; rs2_sel = 2'b11;
    A_latch = 1'b0; B_latch = 1'b0; A_en = 1'b1; B_en = 1'b1; ALU_latch = 1'b0; ALU_en = 1'b1;  
    Reg_wr_en = 1'b0; Mem_wr_en = 1'b0; ALU_sel = 2'b00;
    case(state)
        RESET: begin
                next_state = FETCH;        
//                if(!((instr[2:0] == 3'b111)||(instr[2:0] == 3'b100)||(instr[2:0] == 3'b101)||(instr[2:0] == 3'b110))) begin 
                PC_mux_en = 1'b1;
                IPR_en = 1'b0; IPR_latch = 1'b1; 
//                end
                A_en = 1'b0; A_latch = 1'b1;
                B_en = 1'b0; B_latch = 1'b1;
        end
        FETCH: begin
                IR_latch = 1'b1;
                ALU_latch = 1'b1; ALU_en = 1'b0;
                if(instr[2:0] == 3'b000) next_state = RR;
                else if((instr[2:0] == 3'b111)||(instr[2:0] == 3'b100)||(instr[2:0] == 3'b101)||(instr[2:0] == 3'b110)) next_state = BRT;
                else next_state = RI;
        end
        RR: begin
                if((instr[2:0] == 3'b100)||(instr[2:0] == 3'b101)||(instr[2:0] == 3'b110)) next_state = PC_SUM;
                else begin
                next_state = EXE;
                PC_latch = 1'b1;  
                end                
                rs1_sel = 1'b0;
                rs2_sel = 2'b00;
                A_en = 1'b0; A_latch = 1'b1;  
                B_en = 1'b0; B_latch = 1'b1;
        end
        EXE: begin
                case(instr[2:0])
                    3'b000: begin
                            next_state = WB_ALUR;
                            ALU_sel = 2'b01;
                            end
                    3'b001: begin
                            next_state = WB_ALUI;
                            ALU_sel = 2'b00;
                            end
                    3'b010: next_state = WB_MEM;
                    3'b011: next_state = STORE;
                    3'b100: next_state = RR;
                    3'b101: next_state = RR;
                    3'b110: next_state = RR;
                    3'b111: next_state = RESET;
 //                   default: next_state = RESET;
                endcase
                 ALU_en = 1'b0; ALU_latch = 1'b1;
        end
        WB_ALUR: begin
                next_state = RESET;
                Reg_wr_en = 1'b1;
        end
        RI: begin
                next_state = EXE;
                rs1_sel = 1'b0;
                rs2_sel = 2'b01;
                PC_latch = 1'b1;
                A_en = 1'b0; A_latch = 1'b1;  
                B_en = 1'b0; B_latch = 1'b1;         
        end
        WB_ALUI: begin
                next_state = RESET;
                rd_sel = 1'b0;
                Reg_wr_en = 1'b1;
        end
        WB_MEM: begin
                next_state = RESET;
                rd_sel = 1'b0;
                wrd_sel = 1'b1;
                Reg_wr_en = 1'b1;
        end
        STORE: begin
                next_state = RESET;
                Mem_wr_en = 1'b1;
        end
        BRT: begin
                next_state = EXE;
                rs1_sel = 1'b1;
                rs2_sel = 2'b01;
                A_en = 1'b0; A_latch = 1'b1;  
                B_en = 1'b0; B_latch = 1'b1;
                PC_latch = 1'b1;
        end
        PC_SUM: begin
                PC_mux_en = 1'b1;
                next_state = FETCH;
                ALU_sel = 2'b10;
                IPR_en = 1'b0; IPR_latch = 1'b1; 
                A_en = 1'b0; A_latch = 1'b1;
                B_en = 1'b0; B_latch = 1'b1;
        end
    endcase
end                 
endmodule

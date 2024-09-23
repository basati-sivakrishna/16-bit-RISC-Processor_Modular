`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 19:00:19
// Design Name: 
// Module Name: Datapath
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


module Datapath(
input clk, rst_n,
input [15:0] instr, Mem_to_Reg,
input [1:0] rs2_sel, ALU_sel,
input IPR_en, IPR_latch, IR_latch, wrd_sel, rd_sel, rs1_sel, A_latch, A_en, B_latch, B_en, ALU_latch, ALU_en, PC_latch, Reg_wr_en, PC_mux_en,
output [15:0] ALU_out, next_IP, data_out, instr_cntrl, Reg_out
);
wire Br_sel;
wire [15:0] IPR_instr, IR_instr, Reg_data_in, Reg_A, Reg_B, ALU_to_Reg, Reg_to_A, Reg_to_B, ALU_in_A, ALU_in_B, PC_inc, PC_to_mux, next_PC;
wire [2:0] Reg_rs1, Reg_rs2, Reg_rd;
wire [3:0] ALU_label;

assign instr_cntrl = IPR_instr; //fixed
//wires from IR to Register bank
assign Reg_rs1 = IR_instr[5:3];
assign Reg_rs2 = IR_instr[8:6];

//input and output muxes to and from Register bank
assign Reg_rd = rd_sel ? IR_instr[15:13]: IR_instr[8:6];
assign Reg_data_in = wrd_sel ? Mem_to_Reg : PC_inc;

//Muxes towards input of A and B registers
assign Reg_to_A = rs1_sel ? next_IP : Reg_A;
assign Reg_to_B = rs2_sel[1] ? 8'b00000001 : (rs2_sel[0] ? {{9{IR_instr[15]}},IR_instr[15:9]} : Reg_B);   

//branch logic
assign Br_sel = ((IR_instr[2]&((~IR_instr[1])|(~IR_instr[0]))) & ALU_out[0]) | (&(IR_instr[2:0]));

//Mux for selecting PC
assign next_IP = PC_mux_en ? (Br_sel ? PC_inc : PC_to_mux) : next_IP;

//data input for store operations
assign data_out = Reg_B;

//module definitions
//IPR
Reg_latch IPR(.clk(clk), .rst_n(rst_n), .latch(IPR_latch), .data_in(instr), .data_out(IPR_instr)); 
//IR
Reg_latch IR(.clk(clk), .rst_n(rst_n), .latch(IR_latch), .data_in(IPR_instr), .data_out(IR_instr));
//reg_bank module 
Reg_bank bank(.clk(clk), .wr_en(Reg_wr_en), .rst_n(rst_n), .rs1(Reg_rs1), .rs2(Reg_rs2), .rd(Reg_rd), .data_in(Reg_data_in), .A(Reg_A), .B(Reg_B), .Reg_out(Reg_out));
// A and B registers
Reg_latch RegA(.clk(clk), .rst_n(rst_n), .latch(A_latch), .data_in(Reg_to_A), .data_out(ALU_in_A));
Reg_latch RegB(.clk(clk), .rst_n(rst_n), .latch(B_latch), .data_in(Reg_to_B), .data_out(ALU_in_B));
//ALU decoder and ALU operations
ALU_Decoder AD0(.instr(IR_instr), .ALU_sel(ALU_sel), .label(ALU_label));
ALU ALU(.A(ALU_in_A), .B(ALU_in_B), .label(ALU_label), .ALU_out(ALU_out));
//register at ALU output
Reg_latch ALU_reg(.clk(clk), .rst_n(rst_n), .latch(ALU_latch), .data_in(ALU_out), .data_out(PC_inc)); 
//PC register that stores PC+4 and Power on PC at reset -> make a new module but here PO_PC and 16x0000 are same
Reg_latch PC(.clk(clk), .rst_n(rst_n), .latch(PC_latch), .data_in(PC_inc), .data_out(PC_to_mux));
endmodule

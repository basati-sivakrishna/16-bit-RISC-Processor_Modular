`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 15:17:44
// Design Name: 
// Module Name: CPU_Top
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


module CPU_Top(clk, rst_n, instr, data_in, instr_addr, Mem_wr_en, data_out, data_addr, Reg_out);
input clk, rst_n;
input [15:0] instr, data_in;
output Mem_wr_en;
output [15:0] instr_addr, data_addr, data_out, Reg_out; 
//control signals
wire [1:0] rs2_sel, ALU_sel;
wire IPR_en, IPR_latch, IR_latch, wrd_sel, rd_sel, rs1_sel, A_latch, A_en, B_latch, B_en, ALU_latch, ALU_en, PC_latch, Reg_wr_en, PC_mux_en;
wire [15:0] IR_instr;
//controller module
Controller CNTRLR (.clk(clk), .rst_n(rst_n), .instr(IR_instr), .IPR_en(IPR_en), .IPR_latch(IPR_latch), .IR_latch(IR_latch), .rs1_sel(rs1_sel), .rs2_sel(rs2_sel),
                   .rd_sel(rd_sel), .wrd_sel(wrd_sel), .A_latch(A_latch), .B_latch(B_latch), .A_en(A_en), .B_en(B_en), .ALU_latch(ALU_latch), .ALU_en(ALU_en),
                   .ALU_sel(ALU_sel), .Reg_wr_en(Reg_wr_en), .Mem_wr_en(Mem_wr_en), .PC_mux_en(PC_mux_en), .PC_latch(PC_latch)); 
//data_path module
Datapath DTPTH(.clk(clk), .rst_n(rst_n), .instr(instr), .Mem_to_Reg(data_in), .IPR_en(IPR_en), .IPR_latch(IPR_latch), .IR_latch(IR_latch), .rs1_sel(rs1_sel), 
               .rs2_sel(rs2_sel), .rd_sel(rd_sel), .wrd_sel(wrd_sel), .A_latch(A_latch), .B_latch(B_latch), .A_en(A_en), .B_en(B_en), .ALU_latch(ALU_latch), 
               .ALU_en(ALU_en), .ALU_sel(ALU_sel), .Reg_wr_en(Reg_wr_en), .ALU_out(data_addr), .next_IP(instr_addr), .data_out(data_out), .PC_mux_en(PC_mux_en), .instr_cntrl(IR_instr),
               .PC_latch(PC_latch), .Reg_out(Reg_out));

endmodule

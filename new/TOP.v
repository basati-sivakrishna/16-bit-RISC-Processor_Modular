`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2024 18:57:04
// Design Name: 
// Module Name: TOP
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


module TOP(clk, rst_n, Reg_out);
input clk, rst_n;
output [15:0] Reg_out;
wire Mem_wr_en;
wire [15:0] instr, instr_addr, data_in, data_out, data_addr;
//processor
CPU_Top CPU(.clk(clk), .rst_n(rst_n), .instr(instr), .data_in(data_in), .instr_addr(instr_addr), .Mem_wr_en(Mem_wr_en),
            .data_out(data_out), .data_addr(data_addr), .Reg_out(Reg_out));
//instruction memory            
blk_mem_gen_0 INSTR_MEM(.clka(!clk), .rsta(!rst_n), .addra(instr_addr), .douta(instr));
//data memory
blk_mem_gen_1 DATA_MEM(.clka(!clk), .rstb(!rst_n), .addra(data_addr), .doutb(data_in), .dina(data_out), .ena(Mem_wr_en),
            .addrb(data_addr));
endmodule

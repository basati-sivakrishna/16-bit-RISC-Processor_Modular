`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 21:11:35
// Design Name: 
// Module Name: Reg_bank
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


module Reg_bank(
input clk, wr_en, rst_n,
input [2:0] rs1, rs2, rd,
input [15:0] data_in,
output [15:0] A, B, Reg_out);

reg [15:0] bank [0:7];
integer i;

assign Reg_out = bank[3];
assign A = bank[rs1];
assign B = bank[rs2];

always @(posedge clk) begin
    if(!rst_n) begin
        for(i=0;i<8;i=i+1) bank[i] <= 16'b0000000000000000;
    end
    else if(wr_en) bank[rd] <= data_in;
end

endmodule

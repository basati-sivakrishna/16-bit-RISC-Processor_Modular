`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2024 00:32:25
// Design Name: 
// Module Name: Reg_latch_en_b
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


module Reg_latch_en_b(
input clk, rst_n, latch, en,
input [7:0] data_in,
output reg [7:0] data_out);

reg [7:0] temp;
always @(posedge clk) begin
    if(!rst_n) temp <= 8'b00000000;
    else begin
        if(latch) temp <= data_in;
        else if(en) data_out <= temp;
    end
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 23:50:05
// Design Name: 
// Module Name: Reg_latch
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


module Reg_latch(
input clk, rst_n, latch,
input [15:0] data_in,
output [15:0] data_out);

reg [15:0] temp;
assign data_out = temp;

always @(posedge clk) begin
    if(!rst_n) temp <= 16'b0000000000000000;
    else if(latch) temp <= data_in;
end    
endmodule

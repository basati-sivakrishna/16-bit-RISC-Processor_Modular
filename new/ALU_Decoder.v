`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 18:30:46
// Design Name: 
// Module Name: ALU_Decoder
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


module ALU_Decoder(instr, ALU_sel, label);

input [15:0] instr;
input [1:0] ALU_sel;
output reg [3:0] label;

always @(*) begin
    case(ALU_sel) 
        2'b00: label = 4'b0000;
        2'b01: label = instr[12:9];
        2'b10: label = {instr[2:0],1'b0};
    endcase
end

endmodule

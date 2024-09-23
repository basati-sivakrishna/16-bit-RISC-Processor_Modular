`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 17:36:39
// Design Name: 
// Module Name: ALU
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


module ALU(A, B, label, ALU_out);
input [15:0] A, B;
input [3:0] label;
output reg [15:0] ALU_out;

parameter ADD = 0, SUB = 1, AND = 2, OR = 3, XOR = 4, NAND = 5, NOR = 6, XNOR = 7, LS = 8, GR = 10, EQ = 12, LRS = 13, LLS = 14, ARS = 15;
//funct = 9 and 11 are reserved.
always @(*) begin
    case(label)
        ADD: ALU_out = A+B;
        SUB: ALU_out = A-B;
        AND: ALU_out = A&B;
        OR: ALU_out = A|B;
        XOR: ALU_out = A^B;
        NAND: ALU_out = ~(A&B);
        NOR: ALU_out = ~(A|B);
        XNOR: ALU_out = ~(A^B);
        LS: ALU_out = (A<B)?16'b0000000000000001:0;
        GR: ALU_out = (A>B)?16'b0000000000000001:0;
        EQ: ALU_out = (A==B);
        LRS: ALU_out = A>>B;
        LLS: ALU_out = A<<B;
        ARS: ALU_out = A>>>B;
    endcase
end
endmodule

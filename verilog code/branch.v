`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:08:44
// Design Name: 
// Module Name: branch
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


module branch
    (
    input               clk,
    input      [31:0]   brain1,
    input      [31:0]   brain2,
    input      [6:0]    opcode,
    input      [2:0]    funct3,
    input      [6:0]    funct7,
    input      [31:0]   immbj,
    output reg [31:0]   braout
    );
    always @(posedge clk) begin
        case({funct3,opcode})
            10'b0001100011:  braout = ( (brain1 == brain2) ? immbj : 4 );                         // BEQ
            10'b0011100011:  braout = ( (brain1 != brain2) ? immbj : 4 );                         // BNE
            10'b1001100011:  braout = ( ($signed(brain1) < $signed(brain2) ) ? immbj : 4 );       // BLT
            10'b1011100011:  braout = ( ($signed(brain1) >= $signed(brain2)) ? immbj : 4);        // BGE
            10'b1101100011:  braout = ( (brain1 < brain2)  ? immbj : 4 );                         // BLTU 
            10'b1111100011:  braout = ( (brain1 >= brain2) ? immbj : 4 );                         // BGEU
            default: braout = 1'bx;                                                               // Default - Dont Care
        endcase
    end
    
    
endmodule

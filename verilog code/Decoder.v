`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:06:37
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input  wire     [31:0]    instr,
    input  wire     [31:0]    immi,
    input  wire     [31:0]    imms,
    output wire     [6:0]     opcode,
    output wire     [4:0]     rd,
    output wire     [2:0]     funct3,
    output wire     [4:0]     rs1,
    output wire     [4:0]     rs2,    
    output wire     [6:0]     funct7,
    output wire               store_enable,
    output wire               load_enable,
    output wire               enable_for_registerfile
    );
    
    assign rd = instr[11:7];
    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign funct7 = instr[31:25];
    //assign loadaddress = rs1 + immi ;
    //assign storeaddress = rs1 + imms ; 
    assign store_enable = ( (opcode == 7'b0100011) ? 1'b1 : 1'b0 );
    assign load_enable  = ( (opcode == 7'b0000011) ? 1'b1 : 1'b0 );
    assign enable_for_registerfile = ( (opcode == 7'b0100011 | opcode == 7'b1100011 ) ? 1'b0 : 1'b1 );
    
endmodule

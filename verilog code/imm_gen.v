`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:10:14
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:0] instr,
    output reg [31:0] immi,
    output reg [31:0] imms,
    output reg [31:0] immbj,
    output reg [31:0] immu,
    output reg [31:0] immj
    );
    
    always@(*)
    begin
    immi  <=  {{21{instr[31]}}, instr[30:20]};
    imms  <=  {{21{instr[31]}}, instr[30:25], instr[11:7]};
    immbj <=  {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; 
    immu  <=  {instr[31:12], 12'b0};
    immj  <=  {11'b0,instr[31],instr[19:12],instr[20],instr[30:21], 1'b0};
    
    end
endmodule

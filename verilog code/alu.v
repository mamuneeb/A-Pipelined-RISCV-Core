`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:03:28
// Design Name: 
// Module Name: alu
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


module alu
    (
      input [31:0]       aluin1,
      input [31:0]       aluin2,
      input [6:0]        opcode,
      input [2:0]        funct3,
      input [6:0]        funct7,
      //input [31:0]       immi,
      //input [31:0]       imms,
      output reg [31:0]  aluout
    );
      reg [31:0] imm ;   // Sign extension operation of immediate vaueperformed in imm_gen 
      reg [31:0] loadaddress  ;
      reg [31:0] storeaddress ;
     // reg [31:0] mem [1023:0] ;
    
//  always@(*)
//   begin
//    loadaddress  <=  aluin1 + imm ;
//    storeaddress <=  aluin1 + imm ;
//    end
  always@(*)

    begin
      case(opcode) 
        // Register Type Instructions 
        7'b0110011 : begin
                          //  ADD
                          if({funct7,funct3} == 10'b0000000000) 
                         aluout = aluin1 + aluin2 ;
                          // SUB
                     else if({funct7,funct3} == 10'b0100000000)
                         aluout = aluin1 - aluin2 ;
                          //SLL
                     else if({funct7,funct3} == 10'b0000000001)
                         aluout = aluin1 << aluin2 ;
                          //  SLT
                     else if({funct7,funct3} == 10'b0000000010)
                         aluout = ($signed(aluin1) < $signed(aluin2)) ? 32'b1 : 32'b0 ;
                          // SLTU
                     else if({funct7,funct3} == 10'b0000000011)
                         aluout = (aluin1 < aluin2) ? 32'b1 : 32'b0 ;
                          //  XOR
                     else if({funct7,funct3} == 10'b0000000100)
                         aluout = aluin1 ^ aluin2 ;
                          //  SRL
                     else if({funct7,funct3} == 10'b0000000101)
                         aluout = aluin1 >> aluin2 ;
                          // SRA
                     else if({funct7,funct3} == 10'b0100000101)
                         aluout = aluin1 >> aluin2 ;
                          // OR
                     else if({funct7,funct3} == 10'b0000000110)
                         aluout = aluin1 | aluin2 ;
                          // AND
                     else if({funct7,funct3} == 10'b0000000111)
                         aluout = aluin1 & aluin2 ;
                     end
        // Immediate Type Instructions 
        7'b0010011 : begin
                          //  addi
                          if({funct3} == 3'b000) 
                         aluout = aluin1 + aluin2 ;
                          // xori
                     else if({funct3} == 3'b100)
                         aluout = aluin1 ^ aluin2 ;
                         // ori
                     else if({funct3} == 3'b110)
                         aluout = aluin1 | aluin2 ;
                         // andi
                     else if({funct3} == 3'b111)
                         aluout = aluin1 & aluin2 ;
                         // slli
                     else if({funct3} == 3'b001)
                         aluout = aluin1 << aluin2 ;
                         // srli
                     else if({funct3} == 3'b101)
                         aluout = aluin1 >> aluin2 ;
                         // srai
                     else if({funct7,funct3} == 10'b0100000101)
                         aluout = aluin1 >> aluin2[4:0] ;
                         // slti
                     else if({funct3} == 3'b010)
                         aluout = (aluin1 < aluin2) ? 1 : 0 ;
                         // sltiu
                     else if({funct3} == 3'b011)
                         aluout = (aluin1 < aluin2) ? 1 : 0 ;                                                     
                     end
        // Load Type Instructions ( comes under I Type )  immediate value = immi
        7'b0000011 : begin
                          //  lb Load Byte
                          if({funct3} == 3'b000) 
                         aluout  = aluin1 + aluin2 ;
                          // lh
                     else if({funct3} == 3'b001)
                         aluout = aluin1 + aluin2 ;
                         // lw
                     else if({funct3} == 3'b010)
                         aluout = aluin1 + aluin2 ;
                         // lbu
                     else if({funct3} == 3'b100)
                         aluout  = aluin1 + aluin2 ;
                         // lhu
                     else if({funct3} == 3'b101)
                         aluout = aluin1 + aluin2 ;
                     end
        // Store Type Instructions ( comes under S Type ) immediate value = imms
        7'b0100011 : begin
                          //  sb Store Byte
                          if({funct3} == 3'b000) 
                         aluout  = aluin1 + aluin2 ;
                          // sh Store Half Word
                     else if({funct3} == 3'b001)
                         aluout  = aluin1 + aluin2 ;
                         // sw store word
                     else if({funct3} == 3'b010)
                         aluout  = aluin1 + aluin2 ;
                     end 
        // Jump and Link 
        7'b1101111 : begin
                         aluout  = aluin1 + 4 ;
                     end   
        // Jump and Link Register
        7'b1100111 : begin
                         aluout  = aluin1 + 4 ;
                     end  
        // Load Upper Immediate
        7'b0110111 : begin
                         aluout  = aluin2 ;
                     end 
        // Add Upper Immediate to PC
        7'b0010111 : begin
                         aluout  = aluin1 + aluin2 ;
                     end                                                   
       endcase
    end
    
    
    
endmodule

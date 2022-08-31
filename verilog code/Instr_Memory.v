`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:05:51
// Design Name: 
// Module Name: Instr_Memory
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


module Instr_Memory
    (
    input              clk,
    input  wire [31:0] addr,
    output reg  [31:0] instr
    );
    integer i;
    reg [31:0]instrmem[1023:0];
    
    ///////     Used for storing the instructions 
/*    initial
        begin
          for(i=0;i<1024;i=i+1)
          instrmem[i] = i;
        end                    */  
        initial
        begin
          instrmem[0] = 32'h00110533 ; ////   add x10 x2 x1
//          instrmem[4] = 32'h403205B3 ; //// SUB  sub x11 x4 x3
          instrmem[4] = 32'h403205B3 ; //// sub x11 x4 x3
//          instrmem[12] = 32'h00110533 ; //// ADD  add x10 x2 x1
          instrmem[8] = 32'h00114633 ; //// xor x12 x2 x1
//          instrmem[20] = 32'h00530633 ; //// AND  add x12 x6 x5
          instrmem[12] = 32'h003266B3 ; //// or x13 x4 x3
//          instrmem[28] = 32'h403205B3 ; //// SUB  sub x11 x4 x3
          instrmem[16] = 32'h00117733 ; //// and x14 x2 x1
//          instrmem[36] = 32'h00110533 ; //// ADD  add x10 x2 x1
          instrmem[20] = 32'h003217B3 ; //// sll x15 x4 x3
//          instrmem[44] = 32'h00530633 ; //// AND  add x12 x6 x5
          instrmem[24] = 32'h00115833 ; //// srl x16 x2 x1
//          instrmem[52] = 32'h403205B3 ; //// SUB  sub x11 x4 x3
          instrmem[28] = 32'h403258B3 ; //// sra x17 x4 x3
//          instrmem[60] = 32'h00110533 ; //// ADD  add x10 x2 x1
          instrmem[32] = 32'h00112933 ; //// slt x18 x2 x1
//          instrmem[68] = 32'h00530633 ; //// AND  add x12 x6 x5
          instrmem[36] = 32'h003239B3 ; //// sltu x19 x4 x3
//          instrmem[68] = 32'h00530633 ; //// AND  add x12 x6 x5 
        end                    
    
    always@(posedge clk)
      begin
       instr[31:0] <= instrmem[addr];
    
      end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:04:31
// Design Name: 
// Module Name: Memory
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


module Memory(
    input clk,
    input store_enable,
    input wire [31:0] address,
    input wire [31:0] data_in,
    output     [31:0] data_out
    );
    reg [31:0] mem [1023:0];
     initial
        begin
         mem[7] = 32'hFFFFFFFF;
        end  
    always@(store_enable)
    begin
    mem[address] <= data_in;
    end
    assign data_out = mem[address];
endmodule

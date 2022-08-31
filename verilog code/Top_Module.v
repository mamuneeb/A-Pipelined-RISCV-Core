`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:13:21
// Design Name: 
// Module Name: Top_Module
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



`include "Decoder.v" 
`include "Instr_Memory.v"
`include "Memory.v"  
`include "RegFile.v" 
`include "alu.v"     
`include "branch.v" 
`include "imm_gen.v" 


module Top_Module(
    input clk,
    input reset
    );
  //  reg [31:0] PC = 32'b0;
    reg  [31:0] PC_incremented  ;
    reg  [31:0] PC_incremented_Late  ;
    wire [31:0] PC_incremented_wire = PC_incremented;
   
    wire [31:0] PC_wire = PC_incremented_wire;
    reg  [31:0] PC_wire_IF;
    //reg [31:0] PC_insmem;
    wire [31:0] instr_IF;
    reg [31:0] instr_IF_ID;
    //////////////////////////////////////////////////////////////////
    ///////////////////// Instruction Memory /////////////////////////
    //////////////////////////////////////////////////////////////////
    Instr_Memory insmem
    (
    .clk(clk),
    .addr(PC_incremented_Late),
    .instr(instr_IF)
    );
    
    
    reg  [31:0] PC_wire_IF_ID;
    reg  [31:0] PC_wire_ID_EX;
    
   //reg   [31:0] IF_ID_instr ;
   wire  [6:0] opcode;
   wire  [4:0] rd;
   wire  [2:0] funct3;
   wire  [4:0] rs1;
   wire  [4:0] rs2;
   wire  [6:0] funct7;
   wire        store_enable;
   wire        load_enable ;
   wire enable_for_registerfile;
   
   
   ///////////////////////////////////////////////////////////////////
   ////////////////////// Decoder ////////////////////////////////////
   ///////////////////////////////////////////////////////////////////
   Decoder decoder
   (.instr(instr_IF_ID),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .store_enable(store_enable),
    .load_enable(load_enable),
    .enable_for_registerfile(enable_for_registerfile)
    );
    
    wire [31:0] immi;
    reg  [31:0] immi_ID_EX;
    wire [31:0] imms;
    reg  [31:0] imms_ID_EX;
    wire [31:0] immbj;
    reg  [31:0] immbj_ID_EX;
    wire [31:0] immu;
    reg  [31:0] immu_ID_EX;
    wire [31:0] immj; 
    reg  [31:0] immj_ID_EX;                    /// immj is not yet calculated in the immediate generator
    
    ///////////////////////////////////////////////////////////////////
   ////////////////////// Immeddiate Generator ////////////////////////
   ///////////////////////////////////////////////////////////////////
    imm_gen immgen
    (.instr(instr_IF_ID),
    .immi(immi),
    .imms(imms),
    .immbj(immbj),
    .immu(immu),
    .immj(immj)
    );
    
   
    wire [31:0] aluout_alu;
    reg  [31:0] aluout_alu_EX_MEM;
    reg  [31:0] aluout_alu_MEM_WB;
    wire [31:0] data_out_mem;
    reg  [31:0] data_out_mem_MEM_WB;
    reg [31:0] data_out_mem_selected ;
   // wire store_enable_mem = ( (opcode == 7'b0100011) ? 1'b1 : 1'b0 );
    reg  [31:0] ALU_IN_1;
    reg  [31:0] ALU_IN_2;
    wire [31:0] data_from_regfile_1;
    reg  [31:0] data_from_regfile_1_ID_EX;
    wire [31:0] data_from_regfile_2;
    reg  [31:0] data_from_regfile_2_ID_EX;
    reg  [31:0] data_from_regfile_2_EX_MEM;
    wire [31:0] writedata_in_mem;
    wire [31:0] writedata_in_regfile = load_enable ? data_out_mem_selected : aluout_alu_MEM_WB ;
    wire [31:0] readdata_frm_mem1;
    wire [31:0] readdata_frm_mem2;
    wire  [4:0]  rd_previous;
    
    
    ///////////////////////////////////////////////////////////////////
   ////////////////////// Register File ///////////////////////////////
   ////////////////////////////////////////////////////////////////////
    RegFile regfile(
    .clock(clk),
    .reset(reset),
    .enable(enable_for_registerfile),
    .writeadd(rd),
    .writedata(writedata_in_regfile),
    .readadd1(rs1),
    .readadd2(rs2),
    .readdata1(data_from_regfile_1),
    .readdata2(data_from_regfile_2)
    );
    
    
    
   // wire [6:0] opcode_alu;
   // wire [2:0] funct3_alu;
   // wire [6:0] funct7_alu;
   // wire [31:0] immi_alu;
   // wire [31:0] imms_alu;
   
   //////////////////////////////////////
   ///// MUX Circuit to take ALU 2nd INPUT
   //////////////////////////////////////
   always@(posedge clk)
   begin
   case(opcode)
   7'b0110011 : ALU_IN_2 = data_from_regfile_2_ID_EX;
   7'b0010011 : ALU_IN_2 = immi_ID_EX;
   7'b0000011 : ALU_IN_2 = immi_ID_EX;
   7'b0100011 : ALU_IN_2 = imms_ID_EX;
   7'b1100011 : ALU_IN_2 = data_from_regfile_2_ID_EX;
   7'b0110111 : ALU_IN_2 = immu_ID_EX;
   7'b0010111 : ALU_IN_2 = immu_ID_EX;
   7'b1101111 : ALU_IN_2 = immj_ID_EX;
   
   endcase
   end
   ///////////////////////////////////////
   ///// MUX Circuit to take ALU 1st INPUT
   ///////////////////////////////////////
   always@(posedge clk)
   begin
   case(opcode)
   7'b0110011 : ALU_IN_1 = data_from_regfile_1_ID_EX;
   7'b0010011 : ALU_IN_1 = data_from_regfile_1_ID_EX;
   7'b0000011 : ALU_IN_1 = data_from_regfile_1_ID_EX;
   7'b0100011 : ALU_IN_1 = data_from_regfile_1_ID_EX;
   7'b1100011 : ALU_IN_1 = data_from_regfile_1_ID_EX;
   7'b1101111 : ALU_IN_1 = PC_wire_ID_EX;
   7'b1100111 : ALU_IN_1 = PC_wire_ID_EX;
   7'b0010111 : ALU_IN_1 = PC_wire_ID_EX;
   7'b1101111 : ALU_IN_1 = PC_wire_ID_EX;
   endcase
   end
   
    
    ///////////////////////////////////////////////////////////////////
   ////////////////////// ALU /////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////
    
    alu ALUunit(
    .aluin1(ALU_IN_1),
    .aluin2(ALU_IN_2),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    //.immi(immi),
    //.imms(imms),
    .aluout(aluout_alu)
    );
    
    wire  [31:0] branchout_branch;
    
    ///////////////////////////////////////////////////////////////////
   ////////////////////// Branch Unit /////////////////////////////////
   ////////////////////////////////////////////////////////////////////
    branch bran(
    .clk(clk),
    .brain1(ALU_IN_1),
    .brain2(ALU_IN_2),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .immbj(immbj_ID_EX),
    .braout(branchout_branch)
    );
    
    
    
    initial
    begin
    PC_incremented = 32'b0;
    end
    //////   Incrementation /////
//    always@(posedge clk)
//   begin
//   case(opcode)
//   7'b0110011 : PC_incremented = PC_incremented + 4;
//   7'b0010011 : PC_incremented = PC_incremented + 4;
//   7'b0000011 : PC_incremented = PC_incremented + 4;
//   7'b0100011 : PC_incremented = PC_incremented + 4;
//   7'b1100011 : PC_incremented = PC_incremented + branchout_branch;
//   7'b1101111 : PC_incremented = PC_incremented + immj_ID_EX;                              /// immj is not yet calculated in the immediate generator 
//   7'b1100111 : PC_incremented = (data_from_regfile_1 + immi_ID_EX)   ;
//   7'b0110111 : PC_incremented = PC_incremented + 4;
//   7'b0010111 : PC_incremented = PC_incremented + 4;
//   endcase
//   end
   
//   always@(*)
//   begin
//   if(opcode==1100011)
//   PC_incremented = PC + branchout_branch;
//   else 
//   PC_incremented = PC + 4;
//   end
    //reg  [31:0] address_for_mem;
    //reg  [31:0] data_in_mem;
    
    //////////////////////////////////////////////////////
    ///// load selection (from memory to register ) //////
    //////////////////////////////////////////////////////
    always@(*)
   begin
   case({funct3,opcode})
   10'b0000000011 : data_out_mem_selected = data_out_mem_MEM_WB[7:0]; /// DOUBT - CAN WE USE $signed 
   10'b0010000011 : data_out_mem_selected = data_out_mem_MEM_WB[15:0];
   10'b0100000011 : data_out_mem_selected = data_out_mem_MEM_WB[31:0];
   10'b1000000011 : data_out_mem_selected = {24'b0,data_out_mem_MEM_WB[7:0]};
   10'b1010000011 : data_out_mem_selected = {16'b0,data_out_mem_MEM_WB[15:0]};
   endcase
   end
   
   ///////////////////////////////////////////////
   ///// Store Selection (Register to memory )////
   ///////////////////////////////////////////////
    reg [31:0] data_from_regfile_2_selected ;
    always@(*)
   begin
   case({funct3,opcode})
   10'b0000100011 : data_from_regfile_2_selected = data_from_regfile_2_EX_MEM[7:0]; 
   10'b0010100011 : data_from_regfile_2_selected = data_from_regfile_2_EX_MEM[15:0];
   10'b0100100011 : data_from_regfile_2_selected = data_from_regfile_2_EX_MEM[31:0];
   endcase
   end
    
    ///////////////////////////////////////////////
   ////////////////////////// Memory //////////////
   ///////////////////////////////////////////////
    Memory memory(
    .clk(clk),
    .store_enable(store_enable),
    .address(aluout_alu_EX_MEM),
    .data_in(data_from_regfile_2_selected),
    .data_out(data_out_mem)
    );
    
    
    
    ////////////////////////////////////////////////////////
    ///////////////////STATE MACHINE ///////////////////////
    ////////////////////////////////////////////////////////

  reg [2:0] state=3'b000;    

    always@(posedge clk)
     begin
     // next = state1 ;
       case(state)
      3'b000 : begin   ////////// FETCH Stage ////////////////
                // PC_insmem <= PC_wire ;
               PC_wire_IF = PC_wire ;
                 begin
                   case(opcode)
                    7'b0110011 : PC_incremented = PC_incremented + 4;
                    7'b0010011 : PC_incremented = PC_incremented + 4;
                    7'b0000011 : PC_incremented = PC_incremented + 4;
                    7'b0100011 : PC_incremented = PC_incremented + 4;
                    7'b1100011 : PC_incremented = PC_incremented + branchout_branch;
                    7'b1101111 : PC_incremented = PC_incremented + immj_ID_EX;                              /// immj is not yet calculated in the immediate generator 
                    7'b1100111 : PC_incremented = (data_from_regfile_1 + immi_ID_EX)   ;
                    7'b0110111 : PC_incremented = PC_incremented + 4;
                    7'b0010111 : PC_incremented = PC_incremented + 4;
                 endcase
                 end
                PC_incremented_Late = PC_incremented_wire;
                state = 3'b001;
                end
       3'b001 : begin   ////////// Decode Stage ////////////////
                instr_IF_ID = instr_IF ;
                PC_wire_IF_ID = PC_wire;
                state = 3'b010;
                end 
       3'b010 : begin   ////////// Execute Stage ////////////////
                data_from_regfile_1_ID_EX = data_from_regfile_1;
                data_from_regfile_2_ID_EX = data_from_regfile_2 ;
                immi_ID_EX   = immi ;
                imms_ID_EX  = imms ;
                immbj_ID_EX = immbj ;
                immu_ID_EX   = immu ;
                immj_ID_EX   = immj ;
                PC_wire_ID_EX = PC_wire_IF_ID;
                state = 3'b011;
                end 
       3'b011 : begin    ////////// Memory Stage ////////////////
                data_from_regfile_2_EX_MEM  = data_from_regfile_2_ID_EX ;
                aluout_alu_EX_MEM = aluout_alu ;
                state = 3'b100;
                end
       3'b100 : begin   ////////// Write Back Stage ////////////////
                data_out_mem_MEM_WB  = data_out_mem ;
                aluout_alu_MEM_WB = aluout_alu_EX_MEM ;
                state = 3'b000;
                 end                                  
                
       endcase
     end        
     
endmodule

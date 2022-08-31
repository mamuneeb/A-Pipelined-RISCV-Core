`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2022 04:09:29
// Design Name: 
// Module Name: RegFile
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


module RegFile
         (
         input              clock,    
         input              reset,
         input              enable,
         input  [4:0]       writeadd,    // Address indicates which register to write back to 
         input  [31:0]      writedata,   // Data to be written into the register
         input  [4:0]       readadd1,    // Register Number for output1
         input  [4:0]       readadd2,    // Register Number for output2
         output reg [31:0]  readdata1,   // Output value 1
         output reg [31:0]  readdata2    // Output value 2
         );
          
          reg [31:0] registerbank [31:0] ;    // Register bank 
          initial
          begin
          registerbank[1] = 32'h00000001;
          registerbank[2] = 32'h00000002;
          registerbank[3] = 32'h00000003;
          registerbank[4] = 32'h00000004;
          registerbank[5] = 32'h00000005;
          registerbank[6] = 32'h00000006;
          end
          
   always@(posedge clock)
   if(reset)
     begin
   registerbank[0] <= 32'h00000000;
   registerbank[1] <= 32'h00000000;
   registerbank[2] <= 32'h00000000;
   registerbank[3] <= 32'h00000000;
   registerbank[4] <= 32'h00000000;
   registerbank[5] <= 32'h00000000;
   registerbank[6] <= 32'h00000000;
   registerbank[7] <= 32'h00000000;
   registerbank[8] <= 32'h00000000;
   registerbank[9] <= 32'h00000000;
   registerbank[10] <= 32'h00000000;
   registerbank[11] <= 32'h00000000;
   registerbank[12] <= 32'h00000000;
   registerbank[13] <= 32'h00000000;
   registerbank[14] <= 32'h00000000;
   registerbank[15] <= 32'h00000000;
   registerbank[16] <= 32'h00000000;
   registerbank[17] <= 32'h00000000;
   registerbank[18] <= 32'h00000000;
   registerbank[19] <= 32'h00000000;
   registerbank[20] <= 32'h00000000;
   registerbank[21] <= 32'h00000000;
   registerbank[22] <= 32'h00000000;
   registerbank[23] <= 32'h00000000;
   registerbank[24] <= 32'h00000000;
   registerbank[25] <= 32'h00000000;
   registerbank[26] <= 32'h00000000;
   registerbank[27] <= 32'h00000000;
   registerbank[28] <= 32'h00000000;
   registerbank[29] <= 32'h00000000;
   registerbank[30] <= 32'h00000000;
   registerbank[31] <= 32'h00000000;
     end
   else
     begin
   // Synchronous Writing value into the register 
   if(enable)
       begin
       if(writeadd !=0)
        begin
          registerbank[writeadd] <= writedata;
        end
       end    
     end
   // Asynchronous Reading values from Register Bank
   always@(*)
   begin
   readdata1 <= registerbank[readadd1] ;
   readdata2 <= registerbank[readadd2] ;
   end  

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2019 05:30:42 PM
// Design Name: 
// Module Name: matrixMultiply
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


module matrixMultiply
    # 
    (parameter PARAMREGNUMBERS = 8'd3  ,
               MATRIXINPUTREGNUMBERS = 8'd20,
               MATRIXOUTPUTREGNUMBERS = 8'd4,
               mat1height = 8'd2,
               mat1width = 8'd2,
               mat2width = 8'd2,
               sizeOfMat1 = 8'd4,
               sizeOfMat2 = 8'd4
    )
    (
    input clk,
//    input [7:0] mat1height,
//    input [7:0] mat1width,
//    input [7:0] mat2width,
//    input signed [31:0] reg1,
//    input signed [31:0] reg2,
//    input signed [31:0] reg3,
//    input signed [31:0] reg4,
    input signed [32*18-1:0] matrixInputs, 
    input [31:0] readySignal, // 8+18+1 = 27
    output reg signed [31:0] out1,
    output reg signed [31:0] out2,
    output reg signed [31:0] out3,
    output reg signed [31:0] out4
    );
//    reg signed[31:0] sizeOfMat1;
//    reg signed[31:0] sizeOfMat2;
    integer	 byte_index1;
    integer  sumIndex1;
    
    integer	 byte_index2;
    integer  sumIndex2;
    
    integer	 byte_index3;
    integer  sumIndex3;
    
    integer	 byte_index4;
    integer  sumIndex4;
    
    initial begin
//        sizeOfMat1 = mat1height*mat1width;
//        sizeOfMat2 = mat1width*mat2width;
        out1 = 0;
        out2 = 0;
        out3 = 0;
        out4 = 0;
    end
    always @(posedge clk) begin
        if(readySignal == 1) begin
            for ( byte_index1 = 0; byte_index1 <= mat1width-1; byte_index1 = byte_index1+1 )
                begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 
                out1 <= out1 + matrixInputs[(0*mat1width+byte_index1)*32 +: 32]*
                               matrixInputs[(sizeOfMat1+byte_index1*mat2width+0)*32 +: 32];
                end 
            for ( byte_index2 = 0; byte_index2 <= mat1width-1; byte_index2 = byte_index2+1 )
                begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 
                out2 <= out2 + matrixInputs[(1*mat1width+byte_index1)*32 +: 32]*
                               matrixInputs[(sizeOfMat1+byte_index1*mat2width+1)*32 +: 32];
                end 
            for ( byte_index3 = 0; byte_index3 <= mat1width-1; byte_index3 = byte_index3+1 )
                begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 
                out3 <= out3 + matrixInputs[(2*mat1width+byte_index1)*32 +: 32]*
                               matrixInputs[(sizeOfMat1+byte_index1*mat2width+2)*32 +: 32];
                end 
            for ( byte_index4 = 0; byte_index4 <= mat1width-1; byte_index4 = byte_index4+1 )
                begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 
                out4 <= out4 + matrixInputs[(3*mat1width+byte_index1)*32 +: 32]*
                               matrixInputs[(sizeOfMat1+byte_index1*mat2width+3)*32 +: 32];
                end 
        end
    end
endmodule

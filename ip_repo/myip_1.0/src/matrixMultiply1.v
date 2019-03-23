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


module matrixMultiply1
    # 
    (parameter PARAMREGNUMBERS = 8'd3  ,
               INPUT_REG_NUM = 8'd20,
               OUTPUT_REG_NUM = 8'd4,
               mat1height = 8'd2,
               mat1width = 8'd2,
               mat2width = 8'd2,
               sizeOfMat1 = 8'd4,
               sizeOfMat2 = 8'd4,
               DATABITS = 8'd32
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
    input signed [DATABITS*(sizeOfMat1+sizeOfMat2)-1:0] matrixInputs, 
    input [DATABITS-1:0] readySignal, // 8+18+1 = 27
    output reg signed [DATABITS*OUTPUT_REG_NUM-1+32:0] matrix_output // +1 is for counter
    );
//    reg signed[31:0] sizeOfMat1;
//    reg signed[31:0] sizeOfMat2;
    integer	 result_row;
    integer  result_column;
    integer  term_number;
    integer  k; // for counting the OUTPUT_REG_NUM
    
    reg [31:0] binary_tree_counter = 0;
    
    reg [DATABITS*mat1width-1:0] sums[OUTPUT_REG_NUM-1:0];
    reg working = 0;
    reg [31:0] counter = 0;
    initial begin
//        sizeOfMat1 = mat1height*mat1width;
//        sizeOfMat2 = mat1width*mat2width;
        matrix_output = 0;
        for (k = 0; k <= OUTPUT_REG_NUM - 1; k = k + 1)
        begin
            sums[k] = 0;
        end
    end
    always @(posedge clk) begin
        if(readySignal == 1 && working == 0) begin
            working <= 1;
            counter <= 2;
            matrix_output[DATABITS*OUTPUT_REG_NUM +: 32] <= counter;
            matrix_output <= 0;
            for (result_row = 0; result_row<=mat1height-1; result_row = result_row +1)
                for (result_column = 0; result_column<=mat2width-1; result_column = result_column +1)
                    for (term_number = 0; term_number <= mat1width-1; term_number = term_number +1)
                    begin
                        sums[result_row*mat2width+result_column] [(term_number)*DATABITS +: DATABITS]
                            = matrixInputs[(result_row*mat1width+term_number)*DATABITS +: DATABITS]*
                              matrixInputs[(sizeOfMat1+term_number*mat2width+result_column)*DATABITS +: DATABITS]; 
                    end
        end
        else if(working == 1) begin 
            counter <= counter +1;
            matrix_output[DATABITS*OUTPUT_REG_NUM +: 32] <= counter;
            if(binary_tree_counter == mat1width) begin // have done all the summation; TO DO: change this part to efficient algorithm!!
                working <= 0;
                binary_tree_counter <= 0;
            end
            else begin // summing algorithm 
                for(k = 0;k < OUTPUT_REG_NUM; k = k+1) begin
                    matrix_output[DATABITS*k +: DATABITS] <= matrix_output[DATABITS*k +: DATABITS] + sums[k][binary_tree_counter*DATABITS +: DATABITS];
                end
                binary_tree_counter <= binary_tree_counter +1;
            end
        end 
    end
endmodule


//            for ( byte_index1 = 0; byte_index1 <= mat1width-1; byte_index1 = byte_index1+1 )
//                begin
//                // Respective byte enables are asserted as per write strobes 
//                // Slave register 
//                sum1[32*byte_index1 +: 32] <= matrixInputs[(0*mat1width+byte_index1)*32 +: 32]*
//                        matrixInputs[(sizeOfMat1+byte_index1*mat2width+0)*32 +: 32];
//                end 
//            for ( byte_index2 = 0; byte_index2 <= mat1width-1; byte_index2 = byte_index2+1 )
//                begin
//                // Respective byte enables are asserted as per write strobes 
//                // Slave register 
//                out2 <= out2 + matrixInputs[(0*mat1width+byte_index2)*32 +: 32]*
//                               matrixInputs[(sizeOfMat1+byte_index2*mat2width+1)*32 +: 32];
//                end 
//            for ( byte_index3 = 0; byte_index3 <= mat1width-1; byte_index3 = byte_index3+1 )
//                begin
//                // Respective byte enables are asserted as per write strobes 
//                // Slave register 
//                out3 <= out3 + matrixInputs[(1*mat1width+byte_index3)*32 +: 32]*
//                               matrixInputs[(sizeOfMat1+byte_index3*mat2width+0)*32 +: 32];
//                end 
//            for ( byte_index4 = 0; byte_index4 <= mat1width-1; byte_index4 = byte_index4+1 )
//                begin
//                // Respective byte enables are asserted as per write strobes 
//                // Slave register 
//                out4 <= out4 + matrixInputs[(1*mat1width+byte_index4)*32 +: 32]*
//                               matrixInputs[(sizeOfMat1+byte_index4*mat2width+1)*32 +: 32];
//                end 
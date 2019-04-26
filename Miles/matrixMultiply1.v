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


//IMPORTANT NOTES:
//input to mat1height must use enough memory to store its square.
//for example, if the height of the matrix is 4, you should assign mat1height=5'd4 because to store 16 you will need 5 bits


module matrixMultiply1
    # 
    (parameter
               mat1height = 32'd2,
               mat1width = mat1height,
               OUTPUT_REG_NUM = mat1height,
               //mat2width = 8'd2,
               sizeOfMat1 = mat1height*mat1width,
               DATABITS = 32'd32,
               
               mat1binary=2**$clog2(mat1height)
    
               
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
    input signed [DATABITS*sizeOfMat1+mat1width-1:0] matrixInputs, 
    input [DATABITS-1:0] readySignal, // 8+18+1 = 27
    output reg signed [DATABITS*OUTPUT_REG_NUM-1:0] matrix_output, // +1 is for counter
    output reg signed [DATABITS*mat1binary*2-1:0] bin1
    );
//    reg signed[31:0] sizeOfMat1;
//    reg signed[31:0] sizeOfMat2;
    integer  term_number;
    integer  k; // for counting the OUTPUT_REG_NUM
    integer  j;
    integer  l;
    
     
     
    
    reg [DATABITS*mat1binary*2-1:0] binadd[OUTPUT_REG_NUM-1:0];
    
    reg working = 0;
    
    initial begin
        matrix_output[DATABITS*OUTPUT_REG_NUM-1:0] = 0;
        for(k=0;k<=mat1height-1;k=k+1)begin
            binadd[k][DATABITS*mat1binary*2-1:0]<=0;
        end
    end
    always @(posedge clk) begin
        if(readySignal == 1 && working == 0) begin
            working <= 1;
            matrix_output <= 0;
            for (k = 0; k<=mat1height-1; k = k +1)
                for (term_number = 0; term_number <= mat1binary-1; term_number = term_number +1) 
                begin
                    if(term_number <=mat1width-1) begin
                        if(matrixInputs[DATABITS*sizeOfMat1+term_number]) begin
                            binadd[k] [(term_number)*DATABITS +: DATABITS]<= matrixInputs[(k*mat1width+term_number)*DATABITS +: DATABITS];
                        end
                        else begin
                             binadd[k] [(term_number)*DATABITS +: DATABITS]<= 0;
                        end
                    end
                    else begin
                        binadd[k] [(term_number)*DATABITS +: DATABITS]<= 0;
                    end
               end     
           
        end
        else if(working == 1) begin 
            // summing algorithm 
            for(k=0; k<OUTPUT_REG_NUM; k=k+1)
                for(j=0; j<$clog2(mat1binary); j=j+1)
                    for(l=0; l<mat1binary/(2**(j+1)); l=l+1)begin
                        binadd[k][2*mat1binary*DATABITS-2**($clog2(mat1binary)-j)*DATABITS + l*DATABITS +: DATABITS] <= 
                        binadd[k][2*mat1binary*DATABITS-2**($clog2(mat1binary)-j+1)*DATABITS +2*l*DATABITS +: DATABITS] +
                        binadd[k][2*mat1binary*DATABITS-2**($clog2(mat1binary)-j+1)*DATABITS +(2*l+1)*DATABITS +: DATABITS];
            end
            for(k=0; k<OUTPUT_REG_NUM; k=k+1) begin
                matrix_output[k*DATABITS +: DATABITS]<=binadd[k][2*mat1binary*DATABITS-2*DATABITS +: DATABITS];
            end
            bin1<=binadd[0];
        end 
    end
endmodule

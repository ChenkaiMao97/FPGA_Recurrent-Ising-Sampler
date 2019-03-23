`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2019 04:40:35 PM
// Design Name: 
// Module Name: math_op
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


module math_op(
    input clk,
    input signed [31:0] a,
    input signed [31:0] b,
    input signed [31:0] c,
    output signed [31:0] d
    );
    reg signed[31:0] d_reg;
    reg signed [31:0] in_between;
    always @(posedge clk) begin
        in_between <= c*c;
        d_reg <= 3 + in_between*(a+b); 
    end
    assign d = d_reg;
endmodule
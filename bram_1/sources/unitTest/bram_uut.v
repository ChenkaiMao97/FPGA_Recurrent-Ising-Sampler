module bram_uut();


reg clock;
initial clock <=0;
reg wea;
reg [6:0] addra=0;
reg [63:0] dina=64'h00;
wire [63:0] douta;
reg [63:0] douta_reg;
reg ena;
design_1_blk_mem_gen_0_0 testBram(
    .clka(clock),
    .ena(ena),
    .regcea(1'b1),
    .wea(wea),
    .addra(addra),
    .dina(dina),
    .douta(douta)
);

always #5 clock <= !clock;

initial begin 
    ena = 1'b0;
    wea = 1'b0;
    #102
    ena = 1'd1;
    wea = 1'h1;
    addra = 4'd4;
    dina = 64'h23;
    #10
    addra = 6'd8;
    dina = 64'h88;
    #10
    wea = 1'b0;
//    ena = 1'b0;
    dina = 64'h00;
    addra = 6'd4;
    #10
    addra = 6'd8;
    end
   
always @(posedge clock) begin
    douta_reg <= douta;
    end

endmodule
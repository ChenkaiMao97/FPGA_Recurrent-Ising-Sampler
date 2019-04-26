import bramInit_axi_vip_0_0_pkg::*;
import axi_vip_pkg::*;
module tb_AXI_VIP_Master(
    );
bit aclk = 0;
bit aresetn=0;
xil_axi_ulong addr1=32'hA0000000, addr2 = 32'hA0000004,addr3 = 32'hA0000008, debug_addr = 32'hA000000c;
xil_axi_prot_t prot = 0;
bit [31:0]  data_wr1=32'h01234567,data_wr2=32'h89ABCDEF;
bit [31:0]  data_wr3=32'h33333333,data_wr4=32'h44444444;
bit [31:0]  data_rd1,data_rd2;
xil_axi_resp_t resp;
always #5ns aclk = ~aclk;
bramInit_wrapper DUT
(

);
// Declare agent
bramInit_axi_vip_0_0_mst_t      master_agent;
initial begin
    //Create an agent
    master_agent = new("master vip agent",DUT.bramInit_i.axi_vip_0.inst.IF);
    // set tag for agents for easy debug
    master_agent.set_agent_tag("Master VIP");
    // set print out verbosity level.
    master_agent.set_verbosity(400);
    //Start the agent
    master_agent.start_master();
    #50ns
    aresetn = 1;
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_wr1,resp);
    #20ns
//    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_wr2,resp);
//    #50ns
//    master_agent.AXI4LITE_READ_BURST(addr1,prot,data_rd1,resp);
//    #20ns
//    master_agent.AXI4LITE_READ_BURST(addr1,prot,data_rd1,resp);
    
//    #20ns
//    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_wr3,resp);
//    #20ns
//    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_wr4,resp);
    #50ns
    master_agent.AXI4LITE_READ_BURST(addr1,prot,data_rd1,resp);
    #20ns
    master_agent.AXI4LITE_READ_BURST(addr2,prot,data_rd1,resp);
    #20ns
    master_agent.AXI4LITE_READ_BURST(addr3,prot,data_rd1,resp);
    #20ns
    master_agent.AXI4LITE_READ_BURST(addr3,prot,data_rd1,resp);
    #20ns
    master_agent.AXI4LITE_READ_BURST(debug_addr,prot,data_rd1,resp);
    #200ns
    if((data_wr1 == data_rd1)&&(data_wr2 == data_rd2))
        $display("Data match, test succeeded");
    else
        $display("Data do not match, test failed");
    $finish;
end
endmodule
import design_1_axi_vip_0_0_pkg::*;
import axi_vip_pkg::*;
module tb_AXI_VIP_Master(
    );
bit aclk = 0;
bit aresetn=0;
xil_axi_ulong addr0 = 32'hA0000000,
              addr1 = 32'hA0000004,
              addr2 = 32'hA0000008,
              addr3 = 32'hA000000c,
              addr4 = 32'hA0000010,
              addr5 = 32'hA0000014,
              addr6 = 32'hA0000018,
              addrF = 32'hA000003c;
xil_axi_prot_t prot = 0;
bit [31:0]  data_wr1=32'h00000001,data_wr2=32'h00000000;
bit [31:0]  data_wr3=32'h00000002,data_wr4=32'h00000003;
bit [31:0]  data_noise1=32'h00000001,data_noise2=32'h00000002,data_noise3=32'h00000003;
bit [31:0]  data_noise4=32'hffffffff,data_noise5=32'hfffffffe,data_noise6=32'hfffffffd;
bit [31:0]  data_th1=32'h02,data_th2=32'h06,data_th3=32'h0a;
bit [31:0]  data_rd1,data_rd2;
xil_axi_resp_t resp;
always #5ns aclk = ~aclk;
design_1_wrapper DUT
(

);
// Declare agent
design_1_axi_vip_0_0_mst_t      master_agent;
initial begin
    //Create an agent
    master_agent = new("master vip agent",DUT.design_1_i.axi_vip_0.inst.IF);
    // set tag for agents for easy debug
    master_agent.set_agent_tag("Master VIP");
    // set print out verbosity level.
    master_agent.set_verbosity(400);
    //Start the agent
    master_agent.start_master();
    #50ns
    aresetn = 1;
    #20ns
    
    //reset, clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    #20ns
    
    //set address
    master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h0,resp);
    #20ns
    
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    
    //reset, clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    #20ns
    
    //set address
    master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h1,resp);
    #20ns
    
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    
    //reset, clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    #20ns
    
    //set address
    master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h4,resp);
    #20ns
    
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    
    //reset, clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    #20ns
    
    //set address
    master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h5,resp);
    #20ns
    
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr0,prot,data_wr3,resp);
    
    //reset, clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    #20ns
    
    //set address for threshold
    master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h400,resp);
    #20ns
    
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr2,prot,data_th2,resp);
    
    //reset, clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    #20ns
    
    //set address for noise
    master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h401,resp);
    #20ns
    
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise2,resp);
    
    //reset, clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    #20ns
    
    //set address for noise
    master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h402,resp);
    #20ns
    
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise1,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise2,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise3,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise4,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise5,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise6,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise4,resp);
    #20ns
    master_agent.AXI4LITE_WRITE_BURST(addr1,prot,data_noise2,resp);

    #20ns // clear
    master_agent.AXI4LITE_WRITE_BURST(addrF,prot,data_wr1,resp);
    
    #50ns // start computation
    master_agent.AXI4LITE_WRITE_BURST(addr5,prot,data_wr1,resp);
    
    
    #2000ns
    master_agent.AXI4LITE_READ_BURST(addr3,prot,data_rd1,resp);
    #2000ns
    master_agent.AXI4LITE_READ_BURST(addr3,prot,data_rd1,resp);
    
    $finish;
end
endmodule
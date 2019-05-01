import numpy as np

def hextobitsvector(a,n):
	output = np.array([0]*n)
	for i in range(n):
		output[n-1-i] = int(bin(a>>i)[-1])
	return output

def bitsvectortohex(x):
	decimal = int(0)
	for i in range(len(x)):
		decimal += int(x[len(x)-1-i]*2**i)
	return decimal

def write_clear():
	f.write("//reset, clear\n\
master_agent.AXI4LITE_WRITE_BURST(addrF,prot,1,resp);\n\
#6ns\n")
	return

def write_addr(addr):
	f.write("//set address\n\
master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h"+hex(addr)[2:]+",resp);\n\
#6ns\n")
	return

def write_ready():
	f.write("//set address\n\
master_agent.AXI4LITE_WRITE_BURST(addr5,prot,32'h3c,resp);\n\
#6ns\n")
	return

def writematrix_onerow(data_row):
	for i in range(len(data_row)):
		f.write("master_agent.AXI4LITE_WRITE_BURST(addr0,prot,32'h"+hex(data_row[i])[2:]+",resp);\n\
#6ns\n")
	return

def writematrix(mat):
	(m_h,m_w) = np.shape(mat)
	for i in range(m_h):
		write_clear()
		write_addr(i)
		writematrix_onerow(mat[i])
	return

def writethreshold_onerow(th):
	for i in range(len(th)):
		f.write("master_agent.AXI4LITE_WRITE_BURST(addr2,prot,32'h"+hex(th[i])[2:]+",resp);\n\
#6ns\n")
	return

def writethreshold(th):
	write_clear()
	write_addr(1024)
	writethreshold_onerow(th)
	return

def writenoise_onerow(noise_row):
	for i in range(len(noise_row)):
		f.write("master_agent.AXI4LITE_WRITE_BURST(addr1,prot,32'h"+hex(noise_row[i])[2:]+",resp);\n\
#6ns\n")
	return

def writenoise(noise):
	(m_h,m_w) = np.shape(noise)
	for i in range(m_h):
		write_clear()
		write_addr(i)
		writenoise_onerow(noise[i])
	return
	return

def realCalculation(a,x,th,noise,n): #a: matrix, x: x[0], state vector, n: loop number
	xtrace=[x]
	for i in range(n):
		x = a.dot(x)+noise[i]
		for j in range(len(x)):
			if(x[j]>=th[j]):
				x[j] = 1
			else:
				x[j] = 0
		xtrace.append(x)
	return xtrace

if __name__ == "__main__":
	n = 100
	mat = np.random.randint(10, size=(100, 100))
	noise = np.random.randint(100, size=(100, 100))
	th = np.random.randint(600, size=(1, 100))[0]
	x = 0x0_f0f0_f0f0_f0f0_f0f0_f0f0_f0f0
	x = hextobitsvector(x,n)
	f = open("sim_sv.txt","w")
	f.write("import design_1_axi_vip_0_0_pkg::*;\n\
import axi_vip_pkg::*;\n\
module tb_AXI_VIP_Master(\n\
);\n\
bit aclk = 0;\n\
bit aresetn=0;\n\
xil_axi_ulong addr0 = 32'hA0000000,\n\
              addr1 = 32'hA0000004,\n\
              addr2 = 32'hA0000008,\n\
              addr3 = 32'hA000000c,\n\
              addr4 = 32'hA0000010,\n\
              addr5 = 32'hA0000014,\n\
              addr6 = 32'hA0000018,\n\
              addrF = 32'hA000003c;\n\
xil_axi_prot_t prot = 0;\n\
bit [31:0]  data_rd1,data_rd2;\n\
xil_axi_resp_t resp;\n\
always #3ns aclk = ~aclk;\n\
design_1_wrapper DUT\n\
(\n\
\n\
);\n\
// Declare agent\n\
design_1_axi_vip_0_0_mst_t      master_agent;\n\
initial begin\n\
    //Create an agent\n\
    master_agent = new(\"master vip agent\",DUT.design_1_i.axi_vip_0.inst.IF);\n\
    // set tag for agents for easy debug\n\
    master_agent.set_agent_tag(\"Master VIP\");\n\
    // set print out verbosity level.\n\
    master_agent.set_verbosity(400);\n\
    //Start the agent\n\
    master_agent.start_master();\n\
    #50ns\n\
    aresetn = 1;\n\
    #6ns\n"
)
	# writematrix(mat)
	# writethreshold(th)
	# writenoise(noise)
	write_ready()
	f.write("\n//first 10 expeted output:\n")
	xtrace = realCalculation(mat,x,th,noise,n)
	for i in range(10):
		f.write("//"+str(i)+": %0x\n" % bitsvectortohex(xtrace[i]))
	f.write("$finish;\n\
end\n\
endmodule")



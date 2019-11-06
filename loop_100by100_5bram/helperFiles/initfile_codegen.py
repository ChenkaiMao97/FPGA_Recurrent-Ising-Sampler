import numpy as np

num_of_bram = 5
problem_bits = 16
N_num = 100
row_length = 1600
zfill_num = row_length//N_num//4
th_addr = 256
noise_addr = 257

def tohex(val, nbits):
  return hex((val + (1 << nbits)) % (1 << nbits))

def tohex_int(val, nbits):
  return (val + (1 << nbits)) % (1 << nbits)

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

def wordsvectortohex(x):
	decimal = int(0)
	# print(x)
	for i in range(len(x)):
		decimal += tohex_int(x[i],problem_bits)*2**(problem_bits*i)
		# print("%0x\n" % decimal)
	return decimal

def bitsvector_to_num(arr):
    str_a = ""
    for i in arr:
        str_a = str_a+str(i)
    return int(str_a,2)

def write_clear():
	f.write("//reset, clear\n\
master_agent.AXI4LITE_WRITE_BURST(addrF,prot,1,resp);\n\
#6ns\n")
	return

def write_addr(addr):
	f.write("//set address\n\
master_agent.AXI4LITE_WRITE_BURST(addr3,prot,32'h"+tohex(addr,32)[2:]+",resp);\n\
#6ns\n")
	return

def write_bram_select(bram_num):
	f.write("//set bram_select\n\
master_agent.AXI4LITE_WRITE_BURST(addr7,prot,32'h"+tohex(bram_num,32)[2:]+",resp);\n\
#6ns\n")
	return

def write_add_loop(n):
	f.write("//set address\n\
master_agent.AXI4LITE_WRITE_BURST(addr5,prot,32'h"+tohex(n,32)[2:]+",resp);\n\
#6ns\n")
	return

def writematrix_onerow(data_row):
	for i in range(len(data_row)//2):
		f.write("master_agent.AXI4LITE_WRITE_BURST(addr0,prot,32'h"+tohex((data_row[2*i]<<16)+data_row[2*i+1],32)[2:]+",resp);\n\
#6ns\n")
	return

def writematrix(mat):
	(m_h,m_w) = np.shape(mat)
	for num_b in range(num_of_bram):
		write_bram_select(num_b)
		for i in range(m_h//num_of_bram):
			write_clear()
			write_addr(i)
			writematrix_onerow(mat[num_b*m_h//num_of_bram+i])
	return

def writethreshold_onerow(th):
	write_bram_select(0)
	for i in range(len(th)//2):
		f.write("master_agent.AXI4LITE_WRITE_BURST(addr2,prot,32'h"+tohex((th[2*i]<<16)+th[2*i+1],32)[2:]+",resp);\n\
#6ns\n")
	return

def writethreshold(th):
	write_clear()
	write_addr(th_addr)
	writethreshold_onerow(th)
	return

def writenoise_onerow(noise_row):
	write_bram_select(0)
	for i in range(len(noise_row)//2):
		f.write("master_agent.AXI4LITE_WRITE_BURST(addr1,prot,32'h"+tohex((noise_row[2*i]<<16)+noise_row[2*i+1],32)[2:]+",resp);\n\
#6ns\n")
	return

def writenoise(noise):
	(m_h,m_w) = np.shape(noise)
	for i in range(m_h):
		write_clear()
		write_addr(noise_addr+i)
		writenoise_onerow(noise[i])
	return

def write_init_x(x):
	for i in range((n+31)//32):
		this_word = bitsvector_to_num(x[max(0,len(x)-32*(i+1)):len(x)-32*i])
		f.write("master_agent.AXI4LITE_WRITE_BURST(addr9,prot,32'h"+tohex(this_word,32)[2:]+",resp);\n\
#6ns\n")
	return

def realCalculation(a,x,th,noise,n): #a: matrix, x: x[0], state vector, n: loop number
	xtrace=[x]
	before_th_trace = []
	for i in range(n):
		x = a.dot(x)
		before_th_trace.append(x.copy())
		x = x+noise[i]
		for j in range(len(x)):
			if(x[j]>=th[j]):
				x[j] = 1
			else:
				x[j] = 0
		xtrace.append(x.copy())
	# print(before_th_trace)
	return xtrace, before_th_trace

def write_coe_matrix_onerow(data_row,f,nextline = True):
	data_string = ""
	for i in range(len(data_row)):
		data_string = data_string+ tohex(data_row[i],problem_bits)[2:].zfill(zfill_num)
	if nextline:
		f.write(data_string+",\n")
	else:
		f.write(data_string+";")
	return

def write_coe_matrix(mat,f_list):
	(m_h,m_w) = np.shape(mat)
	for num_b in range(num_of_bram):
		for i in range(m_h//num_of_bram):
			if (i == m_h//num_of_bram-1 and num_b != 0):
				write_coe_matrix_onerow(mat[m_h-1-num_b*m_h//num_of_bram-i],f_list[num_b],\
										nextline = False)
			else:
			    write_coe_matrix_onerow(mat[m_h-1-num_b*m_h//num_of_bram-i],f_list[num_b],\
										nextline = True)
def write_coe_zeros(rows,f):
	for i in range(rows):
		f.write("0"*(row_length//4)+",\n")

def write_coe_threshold(th,f):
	data_string = ""
	for i in range(len(th)):
		data_string = data_string+ tohex(th[i],problem_bits)[2:].zfill(zfill_num)
	f.write(data_string+",\n")
	return

def write_coe_noise_onerow(noise_row,f,nextline=True):
	data_string = ""
	for i in range(len(noise_row)):
		data_string = data_string+ tohex(noise_row[i],problem_bits)[2:].zfill(zfill_num)
	if(nextline):
		f.write(data_string+",\n")
	else:
		f.write(data_string+";")
	return

def write_coe_noise(noise,f):
	(m_h,m_w) = np.shape(noise)
	for i in range(m_h):
		if (i == m_h-1):
			write_coe_noise_onerow(noise[i],f,nextline = False)
		else:
			write_coe_noise_onerow(noise[i],f)
	return

def write_coe_brams(mat,th,noise):
	f_list = []
	for i in range(num_of_bram):
		f_list.append(open("100by100_bram"+str(i)+".coe","w"))
		f_list[-1].write("memory_initialization_radix=16;\n\
memory_initialization_vector=\n")
	write_coe_matrix(mat,f_list)
	blank_lines = 236
	write_coe_zeros(blank_lines,f_list[0])
	write_coe_threshold(th,f_list[0])
	write_coe_noise(noise,f_list[0])



if __name__ == "__main__":
	n = 100
	np.random.seed(1)
	mat = np.random.randint(10, size=(100, 100))-5
	noise = np.random.randint(100, size=(100, 100))-50
	th = np.random.randint(600, size=(1, 100))[0]-300
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
              addr7 = 32'hA000001c,\n\
              addr8 = 32'hA0000020,\n\
              addr9 = 32'hA0000024,\n\
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
	write_coe_brams(mat,th,noise)


	write_init_x(x)
	write_clear()

	write_add_loop(20)
	f.write("\n//first 20 expected output:\n")
	xtrace,before_th_trace = realCalculation(mat,x,th,noise,50)
	for i in range(20):
		f.write("//"+str(i)+": %0x\n" % bitsvectortohex(xtrace[i]))
		f.write("//"+str(i)+tohex(wordsvectortohex(before_th_trace[i]), 1600)+"\n")
	f.write("$finish;\n\
end\n\
endmodule")



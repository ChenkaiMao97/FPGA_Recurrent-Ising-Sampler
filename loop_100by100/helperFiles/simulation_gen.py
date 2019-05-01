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

def writezeros(rows):
	for i in range(rows):
		f.write("0"*800+",\n")

def writematrix_onerow(data_row):
	data_string = ""
	for i in range(len(data_row)):
		data_string = data_string+ hex(data_row[i])[2:].zfill(8)
	f.write(data_string+",\n")
	return

def writematrix(mat):
	(m_h,m_w) = np.shape(mat)
	for i in range(m_h):
		writematrix_onerow(mat[m_h-1-i])
	return

def writethreshold(th):
	data_string = ""
	for i in range(len(th)):
		data_string = data_string+ hex(th[i])[2:].zfill(8)
	f.write(data_string+",\n")
	return

def writenoise_onerow(noise_row,nextline=True):
	data_string = ""
	for i in range(len(noise_row)):
		data_string = data_string+ hex(noise_row[i])[2:].zfill(8)
	if(nextline):
		f.write(data_string+",\n")
	else:
		f.write(data_string+";")
	return

def writenoise(noise):
	(m_h,m_w) = np.shape(noise)
	for i in range(m_h):
		if (i == m_h-1):
			writenoise_onerow(noise[i],nextline = False)
		else:
			writenoise_onerow(noise[i])
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
	blank_lines = 924
	noise = np.random.randint(100, size=(100, 100))
	th = np.random.randint(600, size=(1, 100))[0]
	x = 0x0_f0f0_f0f0_f0f0_f0f0_f0f0_f0f0
	x = hextobitsvector(x,n)
	f = open("100by100.coe","w")
	f.write("memory_initialization_radix=16;\n\
memory_initialization_vector=\n")
	writematrix(mat)
	writezeros(blank_lines)
	writethreshold(th)
	writenoise(noise)
	# f.write(";")

	f.write("\n;first 10 expeted output:\n")
	xtrace = realCalculation(mat,x,th,noise,n)
	for i in range(10):
		f.write(";"+str(i)+": %0x\n" % bitsvectortohex(xtrace[i]))



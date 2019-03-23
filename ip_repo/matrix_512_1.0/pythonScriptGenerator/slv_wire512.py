with open('slv_wire512.txt', 'a') as file:
    for i in range(512):
    	if(i%64 == 0):
    		file.write("\n")
    	file.write('slv_wire'+str(511-i)+',')



# FPGA_Recurrent-Ising-Sampler

## Introduction
This is an on-going project by Chenkai Mao and Miles Johnson Supervised by Charles Roques-Carmes in [Photonics and Modern Electro-Magnetics Group](http://www.rle.mit.edu/marin/) in MIT Physics department.

Basically, we implemented an Ising sampler algorithm on a Xilinx ZCU 104 ultrascale+ FPGA board to speed up the computation for [Ising Model](https://en.wikipedia.org/wiki/Ising_model)(or [Spin glass](https://en.wikipedia.org/wiki/Spin_glass) to be specific), an NP-hard problem in statitical physics.

We're using [PYNQ](http://www.pynq.io/) architecture in Vivado design suit to speed up prototyping. Basically the workflow is:

1. We first design logic and run the simulation in Xilinx Vivado. 
2. Then we generate output files(.bit and .hwh or .tcl), and load the output files onto FPGA through local Jupyter notebook console.
3. Then run the project while controlling on Jupyter notebook, collecting data and verifying the correctness.

## Algorithm
The algorithm is from the theoretical paper ["Photonic Recurrent Ising Sampler"](https://www.osapublishing.org/abstract.cfm?uri=CLEO_QELS-2019-FTu4C.2) published by Charles Roques-Carmes. 
In which the Recurrent algorithm works as a loop of three operations: 

+ matrix multiplication
+ noise injection 
+ non-linearity thresholding

We keep updating a 1D state vector x consisting of 1s and 0s. We use x<sub>n</sub> to denote the state vector at time step n, then

**x<sub>n+1</sub> = thresholding(A*x<sub>n</sub>+noise, th)**

where A is the n by n correlation matrix, noise is n by one random data(changing every cycle), th is threshold(fixed, not change every cycle), and thresholding is a bit-wise operation, which compares entries of x and th, and turns it to 1 if x is greater than th and 0 otherwise.

Right now given a problem of size N=100 (meaning that state vector is size 100 by 1 and matrix is 100 by 100), we achieved evaluating one loop(three operations) per 19 clock cycles. With a clock of frequency 100 MHz, it takes 0.19us.

## Folder Structure:
Different folders corresponds to the different projects to run on FPGA. Each folder stores the source files and final bit files and tcl or hwh files to be ready to run on the FPGA.

The folders and description:
1. **proj_setup**: Setting up the FPGA board and run a simple math operation controlled by Jupyter Notebook.
2. **matrixMultiplication**: sinple matrix multiplication function realized in FPGA
3. **matrix_512regs**: a test to synthesize a matrix multiplication with 512 registers to see how much memory/logic is used up.
4. **bram_1**: Interface with Bram
5. **bram_initFile**: Using Bram with initialization file and simulation.
6. **loop_8by8**: basic version of the loop, problem size 8 by 8
7. **(Current working on) loop_100by100**: scaled version of the loop, problem size 100 by 100
8. **ip_repo**: custum-designed IPs
9. **Miles**: works from Miles

## How to use this repository:
Since this is a project run on ZCU104 board with PYNQ architecture, it would be hard to copy and adapt on your own machine, but the source files should be of good reference.

If you have the required hardware and want to reproduce the results, the procedures for running the 100 by 100 loop project are:
1. Setup your board to run PYNQ(you need an SD card and copy image [here](http://www.pynq.io/board.html))
2. Setup a wifi that both your computer and FPGA connect to(using a router would help), and use [nmap](https://pynq.readthedocs.io/en/latest/getting_started/zcu104_setup.html)(if you're on Linux or Mac) to find the IP address of the FPGA board, and access that IP address in the web browser on your PC, login to the jupyter notebook interface. See [this](https://pynq.readthedocs.io/en/latest/getting_started/zcu104_setup.html) for detailed setup.
3. Load the .bit and .tcl(or .hwh) file onto the FPGA, which are the only required two files to run a project. In this case we use source code in folder loop_100by100 as an example.
4. Whenever you want to create a new spinglass example, go into script prepareData.Ipynb, in which sections and usage:
    - "Create one spin glass data"： create a test data with all float numbers
    - "Store a running case": store the folat data version state and energy over many loop cycles.
    - "Rescale and store the results": rescale matrix, noise and threhold and round to integer for FPGA calculation.
5. Then if you want to test on one of the scaled sample, go into main.Ipynb:
	  - "Load the bit file and define utility functions": as name suggests 
	  - "Reading and storing the scaled data": load the stored sample data in jupyter notebook
	  - "Writing to FPGA, setup matrix, noise and threshold, init vector": write data to BRAMs and registers in FPGA
	  - "Run simulation and extract state every few cycles; Energy calculation": Running the loop and process data
6. If you want to re-run the program(potentially with a different data choice), we need to evaluate the first block again (loading the Overlay "ol = Overlay('./design_1.bit')"), and then run the sections "Reading and storing the scaled data", "Writing to FPGA, setup matrix, noise and threshold, init vector", and "Run simulation and extract state every few cycles; Energy calculation".


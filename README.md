# FPGA_Recurrent-Ising-Sampler

## Introduction
This is an on-going project by Chenkai Mao and Miles Johnson Supervised by Charles Roques-Carmes in [Photonics and Modern Electro-Magnetics Group](http://www.rle.mit.edu/marin/) in MIT Physics department.

Basically, we implemented an Ising sampler algorithm on a Xilinx ZCU 104 ultrascale+ FPGA board to speed up the computation for [Ising Model](https://en.wikipedia.org/wiki/Ising_model)(or [Spin glass](https://en.wikipedia.org/wiki/Spin_glass) to be specific) in theoretical physics.

We're using [PYNQ](http://www.pynq.io/) architecture in Vivado design suit to speed up prototyping. Basically the workflow is:

1. We first design logic and run the simulation in vivado 
2. Then we generate output files(.bit and .hwh or .tcl), and load the output files onto FPGA through local Jupyter notebook console
3. Then run the project while controlling on Jupyter notebook, collecting data and verifying the correctness.

## Algorithm
The algorithm is from the theoretical paper ["Photonic Recurrent Ising Sampler"](https://www.osapublishing.org/abstract.cfm?uri=CLEO_QELS-2019-FTu4C.2) published by Charles Roques-Carmes. 
In which the Recurrent algorithm works as a loop of three operations: 

+ matrix multiplication
+ noise injection 
+ non-linearity thresholding

We keep updating a 1D state vector x consisting of 1s and 0s. We use x_n to denote the state vector at time step n, then

x<sub>n+1</sub> = thresholding(A*x<sub>n</sub>+noise, th)

where A is the n by n correlation matrix, noise is n by one random data(changing every cycle), th is threshold(fixed, not change every cycle), and thresholding is a bit-wise operation, which compares entries of x and th, and turns it to 1 if x is greater than th and 0 otherwise.

Right now given a problem of size N=100 (meaning that state vector is size 100 by 1 and matrix is 100 by 100), we achieved evaluating one loop(three operations) per 19 clock cycles. With a clock of frequency 100 MHz, it takes 0.19us.

## Folder Structure:
Different folders corresponds to the different projects to run on FPGA. Each folder stores the source files and final bit files and tcl or hwh files to be ready to run on the FPGA.

The folders and description:
1. proj_setup: Setting up the FPGA board and run a simple math operation controlled by Jupyter Notebook.
2. matrixMultiplication: sinple matrix multiplication function realized in FPGA
3. matrix_512regs: a test to synthesize a matrix multiplication with 512 registers to see how much memory/logic is used up.
4. bram_1: Interface with Bram
5. bram_initFile: Using Bram with initialization file and simulation.
6. loop_8by8: basic version of the loop, problem size 8 by 8
7. (Current working on) loop_100by100: scaled version of the loop, problem size 100 by 100
8. ip_repo: custum-designed IPs
9. Miles: works from Miles

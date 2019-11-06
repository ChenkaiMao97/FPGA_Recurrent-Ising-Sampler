
`timescale 1 ns / 1 ps

	module address_op16_100by100_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 6,
		///////////////////////my parameters
		parameter integer URAM_LEN = 72, // make sure URAM_LEN % 72 = 0
        parameter integer MAX_HOLDER_COUNTER = 2, // 64/32
        parameter integer DATA_BIT_COMPUTE = 16,
        parameter integer PROBLEM_N = 100,
        parameter integer HOLDER_COUNTER_BIT = 2,
        parameter integer ADDR_BIT = 9,
        parameter integer num_of_bram = 5,
        parameter integer num_of_bram_select_bits = 2,
        parameter integer num_of_init_state_write = (PROBLEM_N+31)>>5
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY,
		// below are my additionals
		output wire bram_wen0,
		output wire bram_wen1,
		output wire bram_wen2,
		output wire bram_wen3,
		output wire bram_wen4,
		output wire [ADDR_BIT-1:0] bram_addr,
		output wire [URAM_LEN-1:0] bram_wdata,
		output wire start_computation,
		output wire [C_S_AXI_DATA_WIDTH-1:0] loop_number,
		output wire [C_S_AXI_DATA_WIDTH-1:0] result_select,
		output wire [num_of_bram_select_bits-1:0] bram_read_select,
		output wire [PROBLEM_N-1:0] init_state,
		input wire [URAM_LEN-1:0] bram_rdata,
//		input wire resultready,
		input wire [C_S_AXI_DATA_WIDTH-1:0] result1
		
	);
	////////////////////////////////////////////////////////////////
	// my definitions:
	reg [URAM_LEN-1:0] holder = 0;
	reg [HOLDER_COUNTER_BIT-1:0] holder_counter=0; // count where to put new data into holder
	reg uram_counter=0; // used when having multiple URAMS
	reg [URAM_LEN-1:0] pipelined_output = 0;
    reg [num_of_bram-1:0] bram_wen_reg=0;
	reg [C_S_AXI_DATA_WIDTH-1:0] bram_addr_reg=0;
	reg [URAM_LEN-1:0] bram_wdata_reg = 0;
	reg outputReady_bram=0;
	reg outputReady_noise=0;
	reg outputReady_th=0;
	reg read_pipeline_reg1 = 0;
	reg read_pipeline_reg2 = 0;
	reg [C_S_AXI_DATA_WIDTH-1:0] loop_number_reg = 10;
	assign loop_number = loop_number_reg;
//	reg debug_read = 0;
//	wire [URAM_LEN-1:0]debug_wire;
//	assign debug_wire = holder;
//	integer debug_reg_number = 3;
	reg read_addr_assigned=0;
	reg [C_S_AXI_DATA_WIDTH-1:0] read_byte_select=0;
	reg [C_S_AXI_DATA_WIDTH-1:0] result1_reg=0;
	reg start_computation_reg=0;
	assign start_computation = start_computation_reg;
	reg [C_S_AXI_DATA_WIDTH-1:0] result_select_reg=0;
	assign result_select=result_select_reg;
	reg [C_S_AXI_DATA_WIDTH-1:0]bram_selector = 0;
	reg [C_S_AXI_DATA_WIDTH-1:0]bram_read_select_reg =0;
	assign bram_read_select = bram_read_select_reg[num_of_bram_select_bits-1:0];
	reg [num_of_init_state_write*C_S_AXI_DATA_WIDTH-1:0] init_state_holder=0;
	reg [7:0] init_state_counter = 0;
	assign init_state = init_state_holder[PROBLEM_N-1:0];
	/////////////////////////////////////////////////////////////////
	

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 3;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 16
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
//	      slv_reg0 <= 0;
//	      slv_reg1 <= 0;
//	      slv_reg2 <= 0;
//	      slv_reg3 <= 0;
//	      slv_reg4 <= 0;
//	      slv_reg5 <= 0;
//	      slv_reg6 <= 0;
//	      slv_reg7 <= 0;
//	      slv_reg8 <= 0;
//	      slv_reg9 <= 0;
//	      slv_reg10 <= 0;
//	      slv_reg11 <= 0;
//	      slv_reg12 <= 0;
//	      slv_reg13 <= 0;
//	      slv_reg14 <= 0;
//	      slv_reg15 <= 0;
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
                4'h0: // writing to bram_of_matrix
                    begin
                        if(holder_counter == MAX_HOLDER_COUNTER-1) begin
                            holder_counter <= 0;
                            outputReady_bram <=1'b1;
                        end else begin 
//                            outputReady_bram <=1'b0;
                            holder_counter <= holder_counter + 1;
                        end
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                holder[C_S_AXI_DATA_WIDTH*holder_counter+(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h1: // writing to bram_of_noise
                    begin
                        if(holder_counter == MAX_HOLDER_COUNTER-1) begin
                            holder_counter <= 0;
                            outputReady_noise <=1'b1;
                        end else begin 
                            outputReady_noise <=1'b0;
                            holder_counter <= holder_counter + 1;
                        end
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                holder[C_S_AXI_DATA_WIDTH*holder_counter+(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h2: // writing to bram_of_threshold
                    begin
                        if(holder_counter == MAX_HOLDER_COUNTER-1) begin
                            holder_counter <= 0;
                            outputReady_th <=1'b1;
                        end else begin 
                            outputReady_th <=1'b0;
                            holder_counter <= holder_counter + 1;
                        end
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                holder[C_S_AXI_DATA_WIDTH*holder_counter+(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h3: // writing to bram_addr_reg
                    begin
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                bram_addr_reg[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h4: // writing to read_byte_select
                    begin
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                read_byte_select[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h5: // writing to loop_number_reg
                    begin
                        start_computation_reg <= 1'b1;
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                loop_number_reg[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h6: // write to result_select_reg
                    begin
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                result_select_reg[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h7: // write to bram_selector
                    begin
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                bram_selector[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h8: // write to bram_read_select_reg
                    begin
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                bram_read_select_reg[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end
                4'h9: // write to init_state_holder
                    begin
                        if(init_state_counter == num_of_init_state_write-1) begin
                            init_state_counter <= 0;
                        end else begin 
//                            outputReady_bram <=1'b0;
                            init_state_counter <= init_state_counter + 1;
                        end
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                           if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                                init_state_holder[C_S_AXI_DATA_WIDTH*init_state_counter+(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                           end
                    end    
                4'hF: // reset all
                    begin
                       holder <= 0;
                       holder_counter <= 0;
                       outputReady_bram<=0;
                       outputReady_th<=0;
                       outputReady_noise<=0;
                       read_byte_select<=0;
                       bram_addr_reg<=0;
                       loop_number_reg<=0;
//                       bram_selector<=0;
//                       init_state_holder <= 0;
                       init_state_counter <= 0;
                    end
            endcase
	      end
	    else begin
	       start_computation_reg <= 1'b0;
	       outputReady_bram <=1'b0;
	       outputReady_noise <=1'b0;
	       outputReady_th <=1'b0;
	    end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	      read_addr_assigned <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
//	          if(S_AXI_ARADDR[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB]==debug_reg_number) begin
//	             debug_read <=1;
//	          end else begin
//	             debug_read <=0;
//	          end
	          read_addr_assigned <= 1'b1;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	          read_addr_assigned <= 1'b0;
	        end
	    end 
	end        

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
//	always @(*) begin
//	   reg_data_out <= pipelined_output;
//	end
	
	always @(posedge S_AXI_ACLK)
	begin
	      // Address decoding for reading registers
	    if(read_addr_assigned) begin
           bram_wen_reg<=0;
        end else if(axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 4'hf) begin
           bram_wen_reg<=0;
        end else if (outputReady_bram == 1'b1) begin
	       bram_wen_reg[bram_selector]<=1'b1;
	       bram_wdata_reg <= holder;
        end else if (outputReady_noise == 1'b1) begin
           bram_wen_reg[0]<=1'b1;
	       bram_wdata_reg <= holder;
	    end else if (outputReady_th == 1'b1) begin
           bram_wen_reg[0]<=1'b1;
	       bram_wdata_reg <= holder;
        end
        
        //////////////////////////////////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // we need to change the following code in order to do continous read
        else if(bram_wen_reg>0) begin
            bram_wen_reg <=0;
        end
        
        if(bram_wen_reg == 0) read_pipeline_reg1 <= 1'b1;
        else read_pipeline_reg1 <= 1'b0;
        
        read_pipeline_reg2 <= read_pipeline_reg1;
        
        if (read_pipeline_reg2 == 1'b1) begin
            pipelined_output <= bram_rdata[C_S_AXI_DATA_WIDTH*read_byte_select+: C_S_AXI_DATA_WIDTH];
        end
	end
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        4'h0   : reg_data_out <= pipelined_output; // read pipelined bram output
	        4'h1   : reg_data_out <= bram_addr_reg; // see bram_addr_reg
	        4'h2   : reg_data_out <= holder[C_S_AXI_DATA_WIDTH*read_byte_select +: C_S_AXI_DATA_WIDTH]; // see holder with read_byte_select
	        4'h3   : reg_data_out <= result1_reg;// reading results
	        4'h4   : reg_data_out <= init_state_holder[C_S_AXI_DATA_WIDTH-1:0]; //reading init_state_holder
            4'h5   : reg_data_out <= init_state_holder[num_of_init_state_write*C_S_AXI_DATA_WIDTH-1:(num_of_init_state_write-1)*C_S_AXI_DATA_WIDTH]; //reading init_state_holder
	        default : reg_data_out <= 0;
	        
	      endcase
	end
	
	always @( posedge S_AXI_ACLK )
	begin
//	   if(resultready == 1'b1)
	       result1_reg<=result1;
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read data 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	// Add user logic here
    assign bram_wen0 = bram_wen_reg[0];
    assign bram_wen1 = bram_wen_reg[1];
    assign bram_wen2 = bram_wen_reg[2];
    assign bram_wen3 = bram_wen_reg[3];
    assign bram_wen4 = bram_wen_reg[4];
    
    assign bram_addr = bram_addr_reg[ADDR_BIT-1:0];
    assign bram_wdata = bram_wdata_reg;
	// User logic ends

	endmodule

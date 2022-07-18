//`ifdef defines.sv
//Calling the DUT
`include "dpram.sv"
//Calling the DPRAM package
`include "package_dpram.sv"
//Calling the interface
`include "interface.sv"
//Calling the test
`include "test.sv"
//Calling the scoreboard
`include "scoreboard.sv"
module top();
	//Importing the DPRAM package
	import package_dpram ::*;
 	//Declaring variables for clock and reset
 	logic clk;
	//Generating the clock
 	initial
 	begin
 		forever #41.5 clk = ~clk;
 	end
	//Instantiating the interface
 	dpram_if intf(clk);
	//Calling the DUT
	dpram dut(.clk(intf.clk),
		  .enable_port_a(intf.enable_port_a),
		  .enable_port_b(intf.enable_port_b),
		  .write_port_a(intf.write_port_a),
		  .write_port_b(intf.write_port_b),
		  .address_port_a(intf.address_port_a),
		  .address_port_b(intf.address_port_b),
		  .data_in_port_a(intf.data_in_port_a),
		  .data_in_port_b(intf.data_in_port_b),
		  .data_out_port_a(intf.data_out_port_a),
  		  .data_out_port_b(intf.data_out_port_b)
		 );
	//Calling the test
	test tb=new(intf.drv,intf.mon);
	//Calling the run task to start the testbench execution	
	initial 
	begin
		tb.run();
		$finish
	end
endmodule
//`endif

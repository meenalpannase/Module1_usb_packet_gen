interface dpram_if(input logic clk);
	//Signal declaration
	logic enable_port_a;
	logic enable_port_b;
	logic write_port_a;
	logic write_port_b;
	logic [15:0] address_port_a;
	logic [15:0] address_port_b;
	logic [127:0] data_in_port_a;
	logic [127:0] data_in_port_b;
	logic [127:0] data_out_port_a;
	logic [127:0] data_out_port_b;

	//Clocking block for driver
	clocking drv_cb@(posedge clk);
		//Default input and output values
		default input #0 output #0;
		//Signals direction declaration without widths
		output enable_port_a;
		output enable_port_b;
		output write_port_a;
		output write_port_b;
		output address_port_a;
		output address_port_b;
		output data_in_port_a;
		output data_in_port_b;
	endclocking

	//Clocking block for monitor
	clocking mon_cb@(posedge clk);
		//Default input and output values
		default input #0 output #0;
		//Signal direction declaration without widths
		input data_out_port_a;
		input data_out_port_b;
	endclocking

	//Modports for driver and monitor
	modport drv(clocking drv_cb,input clk);
	modport mon(clocking mon_cb,input clk);
endinterface

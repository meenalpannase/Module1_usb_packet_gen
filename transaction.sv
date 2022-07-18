`ifdef defines.sv
class transaction;
	//Randomizing input variables
	rand logic enable_port_a;
	rand logic enable_port_b;
	rand logic write_port_a;
	rand logic write_port_b;
	rand logic [`ADDR_WIDTH-1:0] address_port_a;
	rand logic [`ADDR_WIDTH-1:0] address_port_b;
	rand logic [`DATA_WIDTH-1:0] data_in_port_a;
	rand logic [`DATA_WIDTH-1:0] data_in_port_b;

	//Output variable declaration
	logic [`DATA_WIDTH-1:0] data_out_port_a;
	logic [`DATA_WIDTH-1:0] data_out_port_b;

	//Copying objects to run different test cases using same transaction class
	virtual function transaction copy();
		copy = new();
		copy.enable_port_a = this.enable_port_a;
		copy.enable_port_b = this.enable_port_b;
		copy.write_port_a = this.write_port_a;
		copy.write_port_b = this.write_port_b;
		copy.address_port_a = this.address_port_a;
		copy.address_port_b = this.address_port_b;
		copy.data_in_port_a = this.data_in_port_a;
		copy.data_in_port_b = this.data_in_port_b;
		return copy;
	endfunction
endclass
`endif

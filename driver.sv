`ifdef defines.sv
//Calling the packet generator
`include "packet_generator.sv"
//Calling the transaction class
`include "transaction.sv"
class driver
	//transaction class handle
	transaction drv_trans;
	//Mailbox for generator to driver connection
	mailbox #(transaction) mbx_gd;
	//Mailbox for driver to scoreboard connection
	mailbox #(transaction) mbx_ds;
	//Virtual interface
	virtual dpram_if.DRV vif;

	//Functional coverage for inputs
	covergroup drv_cg;
		ENABLE_A: coverpoint drv_trans.enable_port_a {bins enbl_a[] = {0,1};}
                ENABLE_B: coverpoint drv_trans.enable_port_b {bins enbl_b[] = {0,1};}
                WRITE_A: coverpoint drv_trans.write_port_a {bins wrt_a[] = {0,1};}
                WRITE_B: coverpoint drv_trans.write_port_b {bins wrt_b[] = {0,1};}
                ADDRESS_A: coverpoint drv_trans.address_port_a {bins addr_a[] = {0:15};}
                ADDRESS_B: coverpoint drv_trans.address_port_b {bins addr_b[] = {0:15};}
                DATA_IN_A: coverpoint drv_trans.data_in_port_a {bins din_a[] = {0:127};}
                DATA_IN_B: coverpoint drv_trans.data_in_port_b {bins din_b[] = {0:127};}
	endgroup

	//Function to connect the driver and generator, driver to scoreboard with mailbox and virtual interface 	//from driver to environmnet
	function new (mailbox #(transaction) mbx_gd,
		      mailbox #(transaction) mbx_ds,
		      virtual dpram_if.DRV vif);
		this.mbx_gd = mbx_gd;
		this.mbx_ds = mbx_ds;
		this.vif = vif;
		//Creating object for covergroup
		drv_cg = new();
	endfunction

	//Task to drive the stimulus
	task start();
		repeat(5)@(vif.drv_cb);
			repeat(10)
			begin
				drv_trans = new();
				mbx_gd.get(drv_trans);
				vif.drv_cb.enable_port_a <= drv_trans.enable_port_a;
                                vif.drv_cb.enable_port_b <= drv_trans.enable_port_b;
                                vif.drv_cb.write_port_a <= drv_trans.write_port_a;
                                vif.drv_cb.write_port_b <= drv_trans.write_port_b;
                                vif.drv_cb.address_port_a <= drv_trans.address_port_a;
                                vif.drv_cb.address_port_b <= drv_trans.address_port_b;
                                vif.drv_cb.data_in_port_a <= drv_trans.data_in_port_a;
                                vif.drv_cb.data_in_port_b <= drv_trans.data_in_port_b;
				$display("Data on interface enable_port_a = %0d".vif_cb.enable_port_a);
                                $display("Data on interface enable_port_b = %0d".vif_cb.enable_port_b);
                                $display("Data on interface write_port_a = %0d".vif_cb.write_port_a);
                                $display("Data on interface write_port_b = %0d".vif_cb.write_port_b);
                                $display("Data on interface address_port_a = %0h".vif_cb.address_port_a);
                                $display("Data on interface address_port_b = %0h".vif_cb.address_port_b);
                                $display("Data on interface data_in_port_a = %0h".vif_cb.data_in_port_a);
                                $display("Data on interface data_in_port_b = %0h".vif_cb.data_in_port_b);
				//Put randomized inputs in mailbox from driver to scoreboard			
				mbx_ds.put(drv_trans);
				//Covergroup sampling
				drv_cg.sample();
				$display("Input fucntional coverage = %0d",drv_cg.get_coverage());
			end
	endtask
endclass
`endif

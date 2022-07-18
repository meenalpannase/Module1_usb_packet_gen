`ifdef defines.sv
//Calling the transaction class
`include "transaction.sv"
class monitor;
	//Transaction handle
	transaction mon_trans;
	//Mailbox from monitor to scoreboard
	mailbox #(transaction) mbx_ms;
	//Virtual interfacewith monitor modport
	virtual dpram_if.MON vif;

	//Functional coverage for outputs
	covergroup mon_cg;
		DATA_OUT_A: coverpoint mon_trans.data_out_port_a {bins dout = {0:127};}
		DATA_OUT_B: coverpoint mon_trans.data_out_port_b {bins dout = {0:127};}
	endgroup

	//Function to connect the monitor and scoreboard with mailbox and virtual interface from driver to environmnet
	function new(virtual dpram_if.MON vif,
		     mailbox #(transaction) mbx_ms);
		this.vif = vif;
		this.mbx_ms = mbx_ms;
	//Creating object for covergroup
		mon_cg = new();
	endfunction
	
	//Task to collect output from interface
	task start();
		repeat(5)@(vif.mon_cb)
		begin
		     mon_trans = new();
		     repeat(1)@(vif.mon_cb)
		     begin
			mon_trans.data_out_port_a = vif.mon_cb.data_out_port_a;
			mon_trans.data_out_port_b = vif.mon_cb.data_out_port_b;
		     end
		     $display("Monitor to scoreboard data_out_port_a = %0h",mon_trans.data_out_port_a);
		     $display("Monitor to scoreboard data_out_port_b = %0h",mon_trans.data_out_port_b);
		     //Put collected data from DUT to mailbox
		     mbx_ms.put(mon_trans);
		     //Sample the covergroup
		     mon_cg.sample();
		     $display("Ouput functional coverage = %0d",mon_cg.get_coverage());
		     repeat(1)@(vif.mon_cb);
		end
	endtask
endclass
`endif

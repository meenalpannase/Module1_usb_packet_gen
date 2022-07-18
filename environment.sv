`ifdef defines.sv
//Calling the transaction class
`include "transaction.sv"
//Calling the packet generator
`include "packet_generator.sv"
//Calling the driver
`include "driver.sv"
//Calling the monitor
`include "monitor.sv"
//Calling the scoreboard
`include "scoreboard.sv"
class environment;
	//Virtual interfaces for driver, monitor and reference model
 	virtual dpram_if drv_vif;
 	virtual dpram_if mon_vif;
	//Mailbox for generator to driver connection
	mailbox #(transaction) mbx_gd;
	//Mailbox for driver to scoreboard connection
	mailbox #(transaction) mbx_ds;
	//Mailbox for monitor to scoreboard connection
 	mailbox #(transaction) mbx_ms;
 	//Declaring handles for generator, driver, monitor and scoreboard
 	packet_gen gen;
	driver drv;
 	monitor mon;
 	scoreboard scb;

 	//Function to connect the virtual interfaces from driver and monitor to test
 	function new (virtual dpram_if drv_vif,virtual dpram_if mon_vif);
 		this.drv_vif=drv_vif;
 		this.mon_vif=mon_vif;
 	endfunction
 
	//Task to create objects for all the mailboxes and components
 	task build();
 		begin
 		//Creating objects for mailboxes
	 	mbx_gd=new();
 		mbx_ds=new();
 		mbx_ms=new();
 		//Creating objects for components and passing the arguments in the function new()
 		gen=new(mbx_gd);
 		drv=new(mbx_gd,mbx_ds,drv_vif);
 		mon=new(mon_vif,mbx_ms);
		scb=new(mbx_ds,mbx_ms);
 		end
 	endtask

	//Task to call the start method
 	task start();
 		fork
 		gen.start();
 		drv.start();
 		mon.start();
 		scb.start();
		join
		//Compare the report
 		scb.compare_report();
 	endtask
endclass
`endif

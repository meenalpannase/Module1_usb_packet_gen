//`ifdef defines.sv
//Including the environment
`include "environment.sv"
class test;
	//Virtual interfaces for driver and monitor
 	virtual dpram_if drv_vif;
 	virtual dpram_if mon_vif;
 	//environment handle
 	environment env;
 	
	//Function to connect the virtual interfaces from driver and monitor to test
 	function new(virtual dpram_if drv_vif,virtual dpram_if mon_vif);
 		this.drv_vif=drv_vif;
 		this.mon_vif=mon_vif;
	endfunction
 
	//Task to start the methods of the environment
 	task run();
 		env=new(drv_vif,mon_vif);
 		env.build;
 		env.start;
 	endtask
endclass
//`endif

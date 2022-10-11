`ifdef defines.sv
//Calling the transaction class

//Calling the packet generator

//Calling the driver

//Calling the monitor

//Calling the scoreboard

class environment;
	//Virtual interfaces for driver, monitor and reference model
 	
	//Mailbox for generator to driver connection

	//Mailbox for driver to scoreboard connection
	
	//Mailbox for monitor to scoreboard connection
 	
 	//Declaring handles for generator, driver, monitor and scoreboard
 

 	//Function to connect the virtual interfaces from driver and monitor to test
 	function new (virtual dpram_if drv_vif,virtual dpram_if mon_vif);
 	
 
	//Task to create objects for all the mailboxes and components
 	
 		//Creating objects for mailboxes
	 	
 		//Creating objects for components and passing the arguments in the function new()
 	
 		

	//Task to call the start method
 	task start();
 		
		//Compare the report
 	
 	endtask
endclass
`endif

interface dpram_if(input logic clk);
	//Signal declaration
	

	//Clocking block for driver
	clocking drv_cb@(posedge clk);
		//Default input and output values
		
		//Signals direction declaration without widths
		
	endclocking

	//Clocking block for monitor
	clocking mon_cb@(posedge clk);
		//Default input and output values
		
		//Signal direction declaration without widths
		
	endclocking

	//Modports for driver and monitor
	
endinterface

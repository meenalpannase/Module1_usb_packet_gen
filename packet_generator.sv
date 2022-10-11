//Including the transaction class

// packet generator for USB
class packet_gen;
	//variables declaration
	

	//Adding constriants to the variables
	


	//Mailbox from generator to driver	
	

	//Function to implement CRC5	
	
		// I/O definition
		

		// Registers declaration
		
		
		// CRC logic implementation
		

		//Signal assignment
		

	//Function to implement CRC16
	
		//I/O declaration
		
		//Register declaration
		
		//CRC logic implementation
		
		
		//Signal assignment
		

	//printing the randomized values
	
endclass

//Class to create a bad packet

	//Calling the crc5 fucntion
	

	//Calling the crc16 function
	

	//Function to display the bad crc
	
endclass

class token extends packet_gen;
	//constraints for PID
        
        //Display the packet identifier
       
	//Function to connect generator and driver
	
endclass

class data extends packet_gen;
	//constraints for PID
        
        //Display the packet identifier
        
	
	//Function to connect generator and driver
	
endclass

class handshake extends packet_gen;
        //constraints for PID
       
        //Display the packet identifier
        
	//Function to connect generator and driver
	
endclass

class sof extends packet_gen;
        //constraints for PID
        
        //Display the packet identifier
        

	//Function to connect generator and driver
	
endclass

module usb_trans;
	packet_gen pkt;
	
endmodule
`endif

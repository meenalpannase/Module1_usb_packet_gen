//Including the transaction class
`ifdef transaction.sv
// packet generator for USB
class packet_gen;
	//variables declaration
	rand logic [31:0] sync;
	string sync_field;
	rand logic [7:0] pid;
	string packet_identifier;
	rand logic [6:0] addr;
	rand logic [1023:0] data;
	rand logic [3:0] endp;
	logic [15:0] crc;
	rand logic [3:0] eop;

	//Adding constriants to the variables
	constraint sync_cond {if (sync_field == "high")
				sync == [31:0];
			      else
				sync == [7:0];
			     }
	constraint pid_cond {(pid [7:4] = !pid[3:0])};
	constraint addr_cond {addr > 0};


	//Mailbox from generator to driver	
	mailbox #(transaction) mbx_gd;

	//Function to implement CRC5	
	virtual function crc5;
		// I/O definition
		input int data; 
		output reg [4:0] crc;

		// Registers declaration
		reg crc5_0_in,crc5_2_in;
		
		// CRC logic implementation
		always @(data or crc or crc5_0_in) 
		begin
			crc5_0_in <= (data ^ crc[4]); 
			crc5_2_in <= ~(crc5_0_in ^ crc[1]);
		end

		//Signal assignment
		crc[4:3] <= crc[3:2]; 
		crc[2] <= crc5_2_in; 
		crc[1] <= crc[0]; 
		crc[0] <= crc5_0_in;
	endfunction

	//Function to implement CRC16
	virtual function crc16;
		//I/O declaration
		input int data;
		output reg [15:0] crc;

		//Register declaration
		reg crc16_0_in,crc16_2_in,crc16_15_in;

		//CRC logic implementation
		always @(data or crc or crc16_0_in)
		begin
			crc16_0_in <= (data ^ crc[15]);
			crc16_2_in <= ~(crc16_0_in ^ crc[1]);
			crc16_15_in <= ~(crc16_0_in ^ crc[14]);	
		end
		
		//Signal assignment
		crc[15] <= crc16_15_in;
		crc[14:3] <= crc[13:2];
		crc[2] <= crc16_2_in;
		crc[1] <= crc[0];
		crc[0] <= crc16_0_in;
	endfunction

	//printing the randomized values
	task print();
		$display("sync = %0h",sync);
		$display("pid = %0h",pid);
        	$display("addr = %0h",addr);
		$display("data = %0h",data);
        	$display("endp = %0h",endp);
        	$display("eop = %0b",eop);
	endtask
endclass

//Class to create a bad packet
class bad_pkt extends packet_gen;
	rand bit bad_crc;
	
	//Calling the crc5 fucntion
	virtual function void crc5;
		super.crc5();
		if(bad_crc) crc = ~crc;
	endfunction

	//Calling the crc16 function
	virtual function void crc16;
		super.crc16();
		if(bad_crc) crc = ~crc;
	endfunction

	//Function to display the bad crc
	virtual function void display();
		$display("bad_crc = %b", bad_crc);
		super.display();
	endfunction
endclass

class token extends packet_gen;
	//constraints for PID
        constraint pid_status {if (pid [3:0] == 0001)
                                   packet_identifier == "OUT Token";
                               else if (pid [3:0] == 1001)
                                   packet_identifier == "IN Token";
                               else if (pid [3:0] == 0101)
                                   packet_identifier == "SOF Token";
                               else if (pid [3:0] == 1101)
                                   packet_identifier == "SETUP Token";
                              }
        //Display the packet identifier
        task print ();
                $display("packet_identifier = %s",packet_identifier);
        endtask
	
	//Function to connect generator and driver
	function new(mailbox #(transaction) mbx_gd);
		this.mbx_gd = mbx_gd;
		this.sync = sync;
		this.pid = pid;
		this.addr = addr;
		this.endp = endp;
		this.crc5 = crc5;
		this.eop = eop;
	endfunction
endclass

class data extends packet_gen;
	//constraints for PID
        constraint pid_status {if (pid [3:0] == 0011)
                                   packet_identifier == "DATA0";
                               else if (pid [3:0] == 1011)
                                   packet_identifier == "DATA1";
                               else if (pid [3:0] == 0111)
                                   packet_identifier == "DATA2";
                               else if (pid [3:0] == 1111)
                                   packet_identifier == "MDATA";
                              }
        //Display the packet identifier
        task print ();
                $display("packet_identifier = %s",packet_identifier);
        endtask
	
	//Function to connect generator and driver
	function new(mailbox #(transaction) mbx_gd);
		this.mbx_gd = mbx_gd;
		this.sync = sync;
		this.pid = pid;
		this.data = data;
		this.crc16 = crc16;
		this.eop = eop;
	endfunction
endclass

class handshake extends packet_gen;
        //constraints for PID
        constraint pid_status {if (pid [3:0] == 0010)
                                   packet_identifier == "ACK Handshake";
                               else if (pid [3:0] == 1010)
                                   packet_identifier == "NAK Handshake";
                               else if (pid [3:0] == 1110)
                                   packet_identifier == "STALL Handshake";
                               else if (pid [3:0] == 0110)
                                   packet_identifier == "NYET";
                              }
        //Display the packet identifier
        task print ();
                $display("packet_identifier = %s",packet_identifier);
        endtask
	
	//Function to connect generator and driver
	function new(mailbox #(transaction) mbx_gd);
		this.mbx_gd = mbx_gd;
		this.sync = sync;
		this.pid = pid;
		this.eop = eop;
	endfunction
endclass

class sof extends packet_gen;
        //constraints for PID
        constraint pid_status {if (pid [3:0] == 1100)
                                   packet_identifier == "PREamble";
                               else if (pid [3:0] == 1100)
                                   packet_identifier == "ERR";
                               else if (pid [3:0] == 1000)
                                   packet_identifier == "Split";
                               else if (pid [3:0] == 0100)
                                   packet_identifier == "Ping";
                              }
        //Display the packet identifier
        task print ();
                $display("packet_identifier = %s",packet_identifier);
        endtask

	//Function to connect generator and driver
	function new(mailbox #(transaction) mbx_gd);
		this.mbx_gd = mbx_gd;
		this.sync = sync;
		this.pid = pid;
		this.frame_number = frame_number;
		this.crc5 = crc5;
		this.eof = eof;
	endfunction
endclass

module usb_trans;
	packet_gen pkt;
	initial begin
		pkt = new();
		pkt.randomize();
		pkt.print();
	end
endmodule
`endif

`ifdef defines.sv
//Calling the transaction_DPRAM
`include "transaction.sv"
class generator;
	//Transcation handle
	transaction_DPRAM trans;
	//Mailbox for generator to driver connection
	mailbox #(transaction) mbx_gd;

	//Function to connect generator and driver using mailbox
	function new(mailbox #(transaction) mbx_gd);
		this.mbx_gd = mbx_gd;
		trans = new();
	endfunction

	//Creating a task to generate the random stimuli
	task start();
		repeat(10);
		begin
			assert(trans.randomize() == 1);
			mbx_gd.put(trans.copy());
			$display("Randomized Transaction enable_port_a = %0d", trans.enable_port_a);
                        $display("Randomized Transaction enable_port_b = %0d", trans.enable_port_b);
                        $display("Randomized Transaction write_port_a = %0d", trans.write_port_a);
                        $display("Randomized Transaction write_port_b = %0d", trans.write_port_b);
                        $display("Randomized Transaction address_port_a = %0h", trans.address_port_a);
                        $display("Randomized Transaction address_port_b = %0h", trans.address_port_b);
                        $display("Randomized Transaction data_in_port_a = %0h", trans.data_in_port_a);
                        $display("Randomized Transaction data_in_port_b = %0h", trans.data_in_port_b);
			$display("Randomized time is %0t",$time);
		end
	endtask
`endif
endclass

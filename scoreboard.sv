`ifdef defines.sv
//Include the transaction
`include "transaction.sv"
class scoreboard;
	//Transaction class handle
	transaction drv2sb_trans, mon2sb_trans;
	//Mailbox for driver to scoreboard
	mailbox #(transaction) mbx_ds;
	//Mailbox from monitor to scoreboard
	mailbox #(transaction) mbx_ms;
	//2-D Array for storing data from driver and monitor
	logic ['DATA_WIDTH-1:0] drv_mem ['DATA_DEPTH-1:0];
	logic ['DATA_WIDTH-1:0] mon_mem ['DATA_DEPTH-1:0];
	//Variables to indicates the status
	int MATCH = 0;
	int MISMATCH = 0;
	
	//Connecting driver and scoreboard, monitor and scoreboard with mailboc
	function new(mailbox #(transaction) mbx_ds,
		     mailbox #(transaction) mbx_ms);
		this.mbx_ds = mbx_ds;
		this.mbx_ms = mbx_ms;
	endfunction

	//Task to collect data from driver and monitor and store them in memories
	task start();
		begin
			drv2sb_trans = new();
			mon2sb_trans = new();
			fork
			begin
				//Getting the driver transaction from mailbox		
				mbx_ds.get(drv2sb_trans);
				drv_mem[drv2sb_trans.address_port_a] = drv2sb_trans.data_out_port_a;
				drv_mem[drv2sb_trans.address_port_b] = drv2sb_trans.data_out_port_b;
				$display("-------------------------------------------------------");
				$display("SCOREBOARD-DRIVER address_port_a = %0h \t data_out_port_a = %0h",drv_mem[drv2sb_trans.address_port_a],drv2sb_trans.address_port_a,$time);
				$display("SCOREBOARD-DRIVER address_port_b = %0h \t data_out_port_b = %0h",drv_mem[drv2sb_trans.address_port_b],drv2sb_trans.address_port_b,$time);
				$display("-------------------------------------------------------");
			end
			begin
				//Getting the monitor transaction from mailbox		
				mbx_ms.get(drv2sb_trans);
				mon_mem[drv2sb_trans.address_port_a] = mon2sb_trans.data_out_port_a;
				mon_mem[drv2sb_trans.address_port_b] = mon2sb_trans.data_out_port_b;
				$display("-------------------------------------------------------");
				$display("SCOREBOARD-MONITOR address_port_a = %0h \t data_out_port_a = %0h",mon_mem[mon2sb_trans.address_port_a],mon2sb_trans.address_port_a,$time);
				$display("SCOREBOARD-MONITOR address_port_b = %0h \t data_out_port_b = %0h",mon_mem[mon2sb_trans.address_port_b],mon2sb_trans.address_port_b,$time);
				$display("-------------------------------------------------------");
			end
			join
			if(int i != (num_transactions-1))
			compare_report();
		end
	endtask
	
	//Task to compare memories and generate report
	task compare_report();
		if(drv_mem[drv2sb_trans.address_port_a] === mon_mem[mon2sb_trans.address_port_a])
		   begin
			if(drv_mem[drv2sb_trans.address_port_b] === mon_mem[mon2sb_trans.address_port_b])
			$display("SCOREBOARD DRV data_out_port_a = %0h, MON data_out_port_a = %0h",drv_mem[drv2sb_trans.address_port_a],mon_mem[mon2sb_trans.address_port_a],$time);
			$display("SCOREBOARD DRV data_out_port_b = %0h, MON data_out_port_b = %0h",drv_mem[drv2sb_trans.address_port_b],mon_mem[mon2sb_trans.address_port_b],$time);	
			++MATCH;
			$display("DATA MATCHED.MATCH count = %0d",MATCH);
		   end
		else
		   begin
			$display("SCOREBOARD DRV data_out_port_a = %0h, MON data_out_port_a = %0h",drv_mem[drv2sb_trans.address_port_a],mon_mem[mon2sb_trans.address_port_a],$time);
			$display("SCOREBOARD DRV data_out_port_b = %0h, MON data_out_port_b = %0h",drv_mem[drv2sb_trans.address_port_b],mon_mem[mon2sb_trans.address_port_b],$time);	
			++MISMATCH;
			$display("DATA MISMATCHED.MISMATCH count = %0d",MISMATCH);
		   end
	endtask
endclass
`endif

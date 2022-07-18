`timescale 1ns/100ps
module dpram ( clk, enable_port_a, enable_port_b, write_port_a,write_port_b,address_port_a, address_port_b, data_in_port_a,data_in_port_b,data_out_port_a, data_out_port_b);

// inputs and outputs for the design
input  clk, enable_port_a, enable_port_b, write_port_a,write_port_b;
input  [7:0] address_port_a, address_port_b;
input  [7:0] data_in_port_a,data_in_port_b;
output [7:0] data_out_port_a, data_out_port_b;

//LAB : Insert the right code to make it 256 bytes of memory
reg    [7:0] ram [255:0];

//LAB:  insert the right code segment to complete the Dual port ram as
//         per the specification.
//HINT: always@(???? ) begin ???? end
//HINT: assign ... = (...)? ... : ... ;

always @(posedge clk) 
 begin
   if (enable_port_a) begin
      if (write_port_a) begin
         if (!(address_port_a == address_port_b))
        ram[address_port_a] = data_in_port_a;
         else
            $display("(enable_port_a) RACE condition ... 2 drivers trying to write to the same address location port_a address = %0d, port_b address = %0d", address_port_a, address_port_b);
      end
   end
 end

assign data_out_port_a = (enable_port_a & write_port_a)? ram[address_port_a] : 'h0;

always @(posedge clk) 
 begin
   if (enable_port_b) begin
      if (write_port_b) begin
         if (!(address_port_a == address_port_b))
        ram[address_port_b] = data_in_port_b;
         else
            $display("(enable_port_b) RACE condition ... 2 drivers trying to write to the same address location port_a address = %0d, port_b address = %0d", address_port_a, address_port_b);
      end
   end
 end

assign data_out_port_b = (enable_port_b & write_port_b)? ram[address_port_b] : 'h0;

endmodule

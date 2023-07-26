module mipsTest;

reg clk;
wire[31:0] pc_out;
wire[31:0] alu_result;
wire[31:0] instruction ;
wire[31:0] rs;
wire[31:0] rt;

mips u1(.clk(clk),
	.pc_out(pc_out),
	.alu_result(alu_result),
	.instruction(instruction),
	.rs(ra),
	.rt(rb)
	);

	initial begin
		clk = 0;
		forever #5 clk= ~clk;
		end

endmodule
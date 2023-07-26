module mips(input clk ,
            output[31:0] pc_out, alu_result ,instruction , rs ,rt
  );
reg[31:0] pc_current ;
wire signed[31:0] pc2;
wire [31:0] instr;
wire[2:0] alu_op;
wire reg_dst ,mem_to_reg ,jump ,branch ,mem_read ,mem_write ,alu_src ,reg_write ;  //control signals
wire     [4:0]     MUX_reg_write_dest;
wire     [31:0]    MUX_reg_write_data;
wire     [4:0]     reg_read_addr_1;
wire     [31:0]    reg_read_data_1;
wire     [4:0]     reg_read_addr_2;
wire     [31:0]    reg_read_data_2;
wire [31:0] sign_ext_im, MUX_read_data2;
wire [3:0] ALU_Control;
wire [31:0] ALU_out;
wire zero_flag;
wire lt_flag;
wire gt_flag;
wire signed[31:0] im_shift_1, PC_j, PC_addr_result, MUX_PC_2beq ,MUX_PC_2beqj;
wire beq_control;
wire [27:0] jump_shift_1;
wire [31:0]mem_read_data;


initial
 begin
         pc_current <= 32'b0;
 end
//############################################################################## Implementing PC
always @(posedge clk)
begin
#5
 pc_current <= MUX_PC_2beqj/4;
end

// PC + 4
 assign pc2 = (pc_current+pc_current+pc_current+pc_current) + 32'd4;


//############################################################################## instruction memory

IMemBank instrucion_memory(.memread(1),.address(pc_current),.readdata(instr));

//############################################################################## jump shift left 2

assign jump_shift_1 = {instr[25:0],2'b0};


//############################################################################## control unit

Control control_unit(.opcode(instr[31:26]) ,
       .alu_op(alu_op) ,
       .reg_dst(reg_dst) ,
       .jump(jump),
       .branch(branch),
       .mem_read(mem_read) ,
       .mem_to_reg(mem_to_reg),
       .mem_write(mem_write),
       .alu_src(alu_src),
       .reg_write(reg_write));



//############################################################################## multiplexer regdest

assign MUX_reg_write_dest = (reg_dst==1'b1 ? instr[15:11] : instr[20:16]);


//############################################################################## register file

assign reg_read_addr_1 = instr[25:21];
assign reg_read_addr_2 = instr[20:16];

RegFile reg_file(.clk(clk),
       .RegWrite(reg_write),
       .writereg(MUX_reg_write_dest),
       .writedata(MUX_reg_write_data),
       .readreg1(reg_read_addr_1),
       .readdata1(reg_read_data_1),
       .readreg2(reg_read_addr_2),
       .readdata2(reg_read_data_2)

     );

//############################################################################## sign extend imm

assign sign_ext_im = {{16{instr[15]}},instr[15:0]};



//############################################################################## ALU control unit

ALUControl ALU_Control_unit(.ALU_Control(ALU_Control),
       .ALUOp(alu_op),
       .Function(instr[5:0])
         );


//############################################################################## multiplexer alu_src

assign MUX_read_data2 = (alu_src==1'b1) ? sign_ext_im : reg_read_data_2;


//############################################################################## ALU

ALU alu_unit(.data1(reg_read_data_1),
     .data2(MUX_read_data2),
     .aluoperation(ALU_Control),
     .result(ALU_out),
     .zero(zero_flag),
     .lt(lt_flag),
     .gt(gt_flag)
   );


//############################################################################## imm shift 2  (for calculating branch address)
assign im_shift_1 = {sign_ext_im[29:0],2'b0};


//############################################################################## PC beq adder

 assign PC_addr_result = pc2 +im_shift_1;

//############################################################################## beq control

assign beq_control = branch & zero_flag;


//############################################################################## multiplexer PC_beq

assign  MUX_PC_2beq = (beq_control==1'b1) ? PC_addr_result : pc2;


//############################################################################## PC_j

assign PC_j = {pc2[31:28],jump_shift_1};


//############################################################################## multiplexer PC_2beqj
assign MUX_PC_2beqj = (jump == 1'b1) ? PC_j : MUX_PC_2beq;


//############################################################################## data memory

DMemBank datamem(.memread(mem_read),
     .address(ALU_out),
     .writedata(reg_read_data_2),
     .memwrite(mem_write),
     .readdata(mem_read_data)
    );


//############################################################################## multiplexer write back
assign MUX_reg_write_data = (mem_to_reg == 1'b1) ? mem_read_data : ALU_out;


// ############################################################################# output
assign pc_out = pc_current;
assign alu_result = ALU_out;
assign  instruction = instr;
assign rs = reg_read_data_1;
assign rt = MUX_read_data2;

endmodule

module ALUControl( ALU_Control, ALUOp, Function);
output reg[3:0] ALU_Control;
input [2:0] ALUOp;
input [5:0] Function;
wire [8:0] ALUControlIn;
assign ALUControlIn = {ALUOp,Function};
always @(ALUControlIn)
casex (ALUControlIn)
 9'b100xxxxxx: ALU_Control=4'b0000;
 9'b011xxxxxx: ALU_Control=4'b0001;
 9'b010xxxxxx: ALU_Control=4'b0010;
 9'b001xxxxxx: ALU_Control=4'b0011;
 9'b000100000: ALU_Control=4'b0000;
 9'b000100010: ALU_Control=4'b0001;
 9'b000100100: ALU_Control=4'b0010;
 9'b000100101: ALU_Control=4'b0011;
// 6'b000100: ALU_Control=4'b0100;
// 6'b000101: ALU_Control=4'b0101;
 9'b000101010: ALU_Control=4'b0110;  
 default: ALU_Control=4'b0000;
 endcase
endmodule

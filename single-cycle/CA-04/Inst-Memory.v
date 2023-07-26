//memory unit
module IMemBank(input memread,
		 input [7:0] address, output reg [31:0] readdata);

  reg [31:0] mem_array [127:0];

  integer i;
  initial begin
		mem_array[0] <= 32'b00100000000100000000000000000000; //addi $s0 , $zero , 0
		mem_array[1] <= 32'b00100000000011010000000000000011; //addi $t5, $zero, 3
		mem_array[2] <= 32'b10101110000011010000000000000000; //sw   $t5, 0($s0)
		mem_array[3] <= 32'b00100000000011010000000000000101; //addi $t5, $zero, 5
		mem_array[4] <= 32'b10101110000011010000000000000001; //sw   $t5, 1($s0)
		mem_array[5] <= 32'b00100000000011010000000000000001; //addi $t5, $zero, 1
		mem_array[6] <= 32'b10101110000011010000000000000010; //sw   $t5, 2($s0)
		mem_array[7] <= 32'b00100000000011010000000000001001; //addi $t5, $zero, 9
		mem_array[8] <= 32'b10101110000011010000000000000011; //sw   $t5, 3($s0)
		mem_array[9] <= 32'b00100000000011010000000000001010; //addi $t5, $zero, 10
		mem_array[10] <= 32'b10101110000011010000000000000100; //sw   $t5, 4($s0)
		mem_array[11] <= 32'b00100000000011010000000000001000; //addi $t5, $zero, 8
		mem_array[12] <= 32'b10101110000011010000000000000101; //sw   $t5, 5($s0)
		mem_array[13] <= 32'b00100000000011010000000000000100; //addi $t5, $zero, 4
		mem_array[14] <= 32'b10101110000011010000000000000110; //sw   $t5, 6($s0)
		mem_array[15] <= 32'b00100000000011010000000000000010; //addi $t5, $zero, 2
		mem_array[16] <= 32'b10101110000011010000000000000111; //sw   $t5, 7($s0)
		mem_array[17] <= 32'b00100000000011010000000000000110; //addi $t5, $zero, 6
		mem_array[18] <= 32'b10101110000011010000000000001000; //sw   $t5, 8($s0)
		mem_array[19] <= 32'b00100000000011010000000000000111; //addi $t5, $zero, 7
		mem_array[20] <= 32'b10101110000011010000000000001001; //sw   $t5, 9($s0)
		mem_array[21] <= 32'b00100000000100100000000000001010; //addi $s2 , $zero , 10
		mem_array[22] <= 32'b00100000000110000000000000000000; //addi $t8 , $zero , 0
		mem_array[23] <= 32'b10001110000100010000000000000000; //lw   $s1 , 0($s0)
		mem_array[24] <= 32'b00000000000100011100100000100000; //add $t9 , $zero , $s1
		mem_array[25] <= 32'b00100000000100000000000000000000; //addi $s0 , $zero , 0
		//loop:
		mem_array[26] <= 32'b00010010000100100000000000001011; //beq  $s0 , $s2 , end
		mem_array[27] <= 32'b10001110000100010000000000000000; //lw   $s1 , 0($s0)
		mem_array[28] <= 32'b00000010001110000100000000101010; //slt  $t0 , $s1 , $t8
		mem_array[29] <= 32'b00010000000010000000000000000100; //beq  $zero , $t0 , max
		//lable:
		mem_array[30] <= 32'b00000010001110010100100000101010; //slt  $t1 , $s1 , $t9
		mem_array[31] <= 32'b00010100000010010000000000000100; //bne  $zero , $t1 , min
		//endloop:
		mem_array[32] <= 32'b00100010000100000000000000000001; //addi $s0 , $s0 , 1
		mem_array[33] <= 32'b00001000000100000000000000011010; //j    loop
		//max:
		mem_array[34] <= 32'b00000010001000001100000000100000; //add  $t8 , $s1 , $zero
		mem_array[35] <= 32'b00001000000100000000000000011110; //j    lable
		//min:
		mem_array[36] <= 32'b00000010001000001100100000100000; //add  $t9 , $s1 , $zero
		mem_array[37] <= 32'b00001000000100000000000000100000; //j    endloop
		//end:
		mem_array[38] <= 32'b00100010001100010000000000000001; //addi $s1 , $s1 , 1
		mem_array[39] <= 32'b00100010010100100000000000001010; //addi $s2 , $s2, 10
		mem_array[40] <= 32'b00010010010110000000000000000001; //beq  $s2 , $t8 , lab1
		mem_array[41] <= 32'b00010010001110010000000000000001; //beq  $s1 , $t9 , lab2
		//lab1:
		mem_array[42] <= 32'b00100000000100010000000000011111; //addi $s1 , $zero , 31
		//lab2:
		mem_array[43] <= 32'b00100000000100010000000000101001; //addi $s1 , $zero , 41


  end

  always@(memread, address, mem_array[address])
  begin

			if(memread)begin
      readdata=mem_array[address];
			end
  end

endmodule

module testbench;
  //reg memread;              /* rw=RegWrite */
  reg [7:0] adr;  /* adr=address */
  wire [31:0] rd; /* rd=readdata */

   IMemBank u0(memread, adr, rd);

  initial begin
 //   memread=1'b0;
    adr=16'd0;

    #5
  //  memread=1'b1;
    adr=16'd0;
  end

  initial repeat(127)#10 adr=adr+1;

endmodule;

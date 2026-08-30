`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
module testbench_mips32;

    reg clk1, clk2;
    integer k;
    pipe_MIPS32 mips(clk1,clk2);

    initial begin
        clk1=0; clk2=0;
        repeat (50)
            begin
                #5 clk1=1; #5 clk1=0;
                #5 clk2=1; #5 clk2=0;
            end
    end
  
//--------------------TASK 1 ----------------------------------
  
  /*add 3 numbers 10,20 and 30 stored in processor register
initialize R1 with 10
initialize R2 with 20
initialize R3 with 30

add 3 number and store the sum in R4,R5.

  Assembly Language Program           Machine Code (in Binary)

    ADDI    R1, R0, 10         001010 00000 00001 0000000000001010
    ADDI    R2, R0, 20         001010 00000 00010 0000000000010100
    ADDI    R3, R0, 30         001010 00000 00011 0000000000011110
    ADD     R4, R1, R2         000000 00001 00010 0010000000000000
    ADD     R5, R4, R3         000000 00100 00011 0010100000000000
    HLT                        111111 00000 00000 0000000000000000


   */
  
task task1(); 
    begin
      for (k=0; k<31; k=k+1) begin
            mips.Reg[k]=k;          //initializing Regesters
        end
        /* to avoid hazards (because of data dependency) 
        dummy instructions are used */
        
        mips.Mem[0]  = 32'h2801000A;     //  ADDI    R1, R0, 10 
        mips.Mem[1]  = 32'h28020014;     //  ADDI    R2, R0, 20 
        mips.Mem[2]  = 32'h2803001E;     //  ADDI    R3, R0, 30 
        mips.Mem[3]  = 32'h0CE77800;     //  OR      R7, R7, R7 --- Dummy 
        mips.Mem[4]  = 32'h0CE77800;     //  OR      R7, R7, R7 --- Dummy 
        mips.Mem[5]  = 32'h222000;       //  ADD     R4, R1, R2 
        mips.Mem[6]  = 32'h0CE77800;     //  OR      R7, R7, R7 --- Dummy 
        mips.Mem[7]  = 32'h832800;       //  ADD     R5, R4, R3
        mips.Mem[8]  = 32'hFC000000;     //  HLT

        mips.PC      = 0;
        mips.HALTED  = 0;
        mips.TAKEN_BRANCH = 0;

        #280 
      for(k=0;k<6;k=k+1)
        $display("R%d : %d ",k, mips.Reg[k]);
    end
  endtask
  
//------------------------TASK 2---------------------------------
  /* Load a word from memory location 120 , add 45 to it and then store the result in memory location 121.  
  
  Assembly Language Program           Machine Code (in Binary)

   ADDI    R1, R0, 120         001010 00000 00001 0000000001111000
   LW      R2, 0(R1)           001000 00001 00010 0000000000000000
   ADDI    R2, R2, 45          001010 00010 00010 0000000000101101
   SW      R2, 1(R1)           001001 00010 00001 0000000000000001
   HLT                         111111 00000 00000 0000000000000000
*/  
  
  
 /*task task2;
    begin
      for (k=0; k<31; k=k+1) begin
            mips.Reg[k]=k;          //initializing Regesters
        end
       
        mips.Mem[0]  = 32'h28010078;     //  ADDI    R1, R0, 120
        mips.Mem[1]  = 32'h0c631800;     //  OR      R3, R3, R3 --- Dummy 
        mips.Mem[2]  = 32'h20220000;     //  LW      R2, 0(R1)        
        mips.Mem[3]  = 32'h0c631800;     //  OR      R3, R3, R3 --- Dummy 
        mips.Mem[4]  = 32'h2842002d;     //  ADDI    R2, R2, 45
        mips.Mem[5]  = 32'h0c631800;     //  OR      R3, R3, R3 --- Dummy 
        mips.Mem[6]  = 32'h24220001;     //  SW      R2, 1(R1)  
        mips.Mem[7]  = 32'hfc000000;     //  HLT

        mips.Mem[120]= 85;
        mips.PC      = 0;
        mips.HALTED  = 0;
        mips.TAKEN_BRANCH = 0;

        #500 $display("Mem[120]: %4d \nMem[121]: %4d", mips.Mem[120], mips.Mem[121]);
      
      
    end
  endtask
*/
  //-----------------------TASK 3--------------------------------------
  
  /*  Compute the factorial of a number stored in memory location 200.the result will be stored in memory location 198.

  Assembly Language Program           Machine Code (in Binary)

   ADDI    R10, R0, 200         001010 00000 01010 0000000011001000
   ADDI    R2, R0, 1            001010 00000 00010 0000000001111000
   LW      R3, 0(R10)           001000 01010 00011 0000000000001010
   LOOP : MUL    R2, R2, R3     000101 00010 00011 00010 00000000000
   SUBI    R3, R3, 1            001011 00011 00011 0000000000000001
   BNEQZ   R3,LOOP              001101 00011 00000 1111111111111101
   SW      R2,-2(R10)           001001 00010 01010 1111111111111110
   HLT                          111111 00000 00000 0000000000000000
*/
    initial 
      begin
        task1;
       
        //task2;
       
        //task3;
      end

    initial begin
        $dumpfile ("mips.vcd");
        $dumpvars (0, testbench_mips32);
        #2000 $finish;
    end

endmodule

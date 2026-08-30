	//--------------------MEMORY (MEM) CYCLE ---------------------------------------

	always @ (posedge clk2)
		if (HALTED==0)
		begin
			MEM_WB_type	<= #2 EX_MEM_type;
			MEM_WB_IR	<= #2 EX_MEM_IR;
			
			case (EX_MEM_type)

				RR_ALU, RM_ALU:	MEM_WB_ALUOut	<= #2 EX_MEM_ALUOut;

				LOAD:			MEM_WB_LMD		<= #2 Mem[EX_MEM_ALUOut];

				STORE:	if (TAKEN_BRANCH==0)	//disable write
								Mem[EX_MEM_ALUOut]	<= #2 EX_MEM_B;
			endcase
		end

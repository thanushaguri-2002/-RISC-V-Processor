  //--------------------INSTRUCTION FETCH (IF) CYCLE ---------------------------------------		
			
			always @(posedge clk1)
		if (HALTED==0)
		begin
			if(((EX_MEM_IR[31:26]==BEQZ) && (EX_MEM_cond==1)) || ((EX_MEM_IR[31:26] == BNEQZ) && (EX_MEM_cond ==0)))	//cond = (A==0)
			begin
				IF_ID_IR	 	<= #2 Mem[EX_MEM_ALUOut];
				TAKEN_BRANCH	<= #2 1'b1;
				IF_ID_NPC	 	<= #2 EX_MEM_ALUOut +1;
				PC		 		<= #2 EX_MEM_ALUOut +1;
			end
			else begin
				IF_ID_IR	 <= #2 Mem[PC];
				IF_ID_NPC	 <= #2 PC +1;
				PC		 	 <= #2 PC +1;
		       	end	       
		end

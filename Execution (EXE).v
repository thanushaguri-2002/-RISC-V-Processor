	//--------------------EXECUTION (EX) CYCLE ---------------------------------------

	always @ (posedge clk1)
		if (HALTED==0)
		begin
			EX_MEM_type		<= #2 ID_EX_type;
			EX_MEM_IR		<= #2 ID_EX_IR;
			TAKEN_BRANCH	<= #2 0;

			case (ID_EX_type)
				RR_ALU:	begin
					case (ID_EX_IR[31:26])	//opcode
							ADD: EX_MEM_ALUOut 		<= #2 ID_EX_A + ID_EX_B;
							SUB: EX_MEM_ALUOut 		<= #2 ID_EX_A - ID_EX_B;
							AND: EX_MEM_ALUOut 		<= #2 ID_EX_A & ID_EX_B;
							OR:  EX_MEM_ALUOut 		<= #2 ID_EX_A | ID_EX_B;
							SLT: EX_MEM_ALUOut 		<= #2 ID_EX_A < ID_EX_B;
							MUL: EX_MEM_ALUOut 		<= #2 ID_EX_A * ID_EX_B;
							default: EX_MEM_ALUOut 	<= #2 32'hxxxxxxxx;
					endcase
					end

				RM_ALU: begin
					case (ID_EX_IR[31:26])	//opcode
							ADDI: EX_MEM_ALUOut 	<= #2 ID_EX_A + ID_EX_Imm;
							SUBI: EX_MEM_ALUOut 	<= #2 ID_EX_A - ID_EX_Imm;
							SLTI: EX_MEM_ALUOut 	<= #2 ID_EX_A < ID_EX_Imm;
					        default: EX_MEM_ALUOut 	<= #2 32'hxxxxxxxx;
				    endcase
			       	end 


				LOAD, STORE: begin
						EX_MEM_ALUOut	<= #2 ID_EX_A + ID_EX_Imm;
						EX_MEM_B		<= #2 ID_EX_B;
					end

				BRANCH:	begin
					EX_MEM_ALUOut	<= #2 ID_EX_NPC + ID_EX_Imm;
					EX_MEM_cond		<= #2 (ID_EX_A == 0);
				end
			endcase
		end

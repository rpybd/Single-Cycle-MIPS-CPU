`include "ctrl_encode_def.v"
`include "instruction_def.v"
module singleCtrl (clk, rst, Zero, Op, Funct, 
                    RFWr, DMWr, PCWr, 
                    EXTOp, ALUOp, NPCOp, SpeRegAddr, 
                    RegDst, ALUSrcA, ALUSrcB, MemtoReg);
   input  		        clk, rst, Zero;       
   input [5:0]      Op;
   input [5:0]      Funct;
   output reg       RFWr;
   output reg       DMWr;
   output reg       PCWr;
   output reg [1:0] EXTOp;
   output reg [1:0] NPCOp;
   output reg [4:0] ALUOp;
   output reg [4:0] SpeRegAddr;
   output reg [1:0] RegDst;
   output reg [1:0] ALUSrcA, ALUSrcB;
   output reg       MemtoReg; 
   
   always @(*) begin//posedge clk, get ins from im, pc unwritten
     if( Op == 6'b000000 ) begin //R type, ADDU\SUBU\SLL\SRL\SRA
        if( Funct == `INSTR_ADDU_FUNCT || Funct == `INSTR_SUBU_FUNCT) begin//ADDU\SUBU
          RFWr = 1;
          DMWr = 0;
          PCWr = 1;
          EXTOp = 0;
          NPCOp = 0;
          RegDst = 1;
          ALUSrcA = 0;         
          ALUSrcB = 0;
          MemtoReg = 0;     
          case( Funct )
            `INSTR_ADDU_FUNCT: ALUOp = `ALUOp_ADDU;            
            `INSTR_SUBU_FUNCT: ALUOp = `ALUOp_SUBU;
            default: ;
          endcase
        end
        if( Funct == `INSTR_SLL_FUNCT || Funct == `INSTR_SRL_FUNCT || Funct == `INSTR_SRA_FUNCT) begin//SLL\SRL\SRA
          RFWr = 1;
          DMWr = 0;
          PCWr = 1;
          EXTOp = 0;
          NPCOp = 0;
          RegDst = 1;
          ALUSrcA = 1;         
          ALUSrcB = 1;
          MemtoReg = 0;     
          case( Funct )
            `INSTR_SLL_FUNCT:  ALUOp = `ALUOp_SLL;
            `INSTR_SRL_FUNCT:  ALUOp = `ALUOp_SRL;
            `INSTR_SRA_FUNCT:  ALUOp = `ALUOp_SRA;
            default: ;
          endcase
        end
     end
     if( Op == 6'b001101 ) begin//ORI type 
        RFWr = 1;
        DMWr = 0;
        PCWr = 1;
        EXTOp = `EXT_UNSIGNED;
        NPCOp = 0;
        RegDst = 0;         
        ALUSrcA = 0;
        ALUSrcB = 1;
        MemtoReg = 0; 
        ALUOp = `ALUOp_OR;
     end
     if( Op == 6'b001111 ) begin//LUI type
        RFWr = 1;
        DMWr = 0;
        PCWr = 1;
        EXTOp = `EXT_HIGHPOS;
        NPCOp = 0;
        RegDst = 0;         
        ALUSrcA = 0;
        ALUSrcB = 1;
        MemtoReg = 0; 
        ALUOp = `ALUOp_NOP;
     end
     if( Op == 6'b100011 ) begin//LW type 
        RFWr = 1;
        DMWr = 0;
        PCWr = 1;
        EXTOp = 0;
        NPCOp = 0;
        RegDst = 0;         
        ALUSrcA = 0;
        ALUSrcB = 1;
        MemtoReg = 1; 
        ALUOp = `ALUOp_ADD;
     end
     if( Op == 6'b101011 ) begin//SW type 
        RFWr = 0;
        DMWr = 1;
        PCWr = 1;
        EXTOp = 0;
        NPCOp = 0;
        RegDst = 0;         
        ALUSrcA = 0;
        ALUSrcB = 1;
        MemtoReg = 0; 
        ALUOp = `ALUOp_ADD;
     end
     if( Op == 6'b000100 ) begin//BEQ type 
        RFWr = 0;
        DMWr = 0;
        PCWr = 1;
        EXTOp = 0;
        NPCOp = `NPC_BRANCH;
        RegDst = 0;         
        ALUSrcA = 0;
        ALUSrcB = 0;
        MemtoReg = 0; 
        ALUOp = `ALUOp_EQL;
     end
     if( Op == 6'b000010 ) begin//J type 
        RFWr = 0;
        DMWr = 0;
        PCWr = 1;
        EXTOp = 0;
        NPCOp = `NPC_JUMP;
        RegDst = 0;         
        ALUSrcA = 0;
        ALUSrcB = 0;
        MemtoReg = 0; 
        ALUOp = `ALUOp_NOP;
     end
     if( Op == 6'b000011 ) begin//JAL type 
        RFWr = 1;
        DMWr = 0;
        PCWr = 1;
        EXTOp = 0;
        NPCOp = `NPC_JUMP;
        RegDst = 2'b10;         
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b10;
        MemtoReg = 0; 
        ALUOp = `ALUOp_ADDU;
        SpeRegAddr = 31;
     end
     if( Op == 6'b000000 && Funct == `INSTR_JR_FUNCT ) begin//JR type 
        RFWr = 0;
        DMWr = 0;
        PCWr = 1;
        EXTOp = 0;
        NPCOp = `NPC_JR;
        RegDst = 0;         
        ALUSrcA = 0;
        ALUSrcB = 0;
        MemtoReg = 0; 
        ALUOp = `ALUOp_NOP;
     end
   end//end always
   
   
endmodule
     
        
      
      
      
      
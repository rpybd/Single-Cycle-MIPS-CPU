module singleMips( clk, rst );
   input   clk;
   input   rst;
   
   wire 		     RFWr;
   wire 		     DMWr;
   wire 		     PCWr;             //write enable
   wire [1:0]  EXTOp;
   wire [4:0]  ALUOp;
   wire [1:0]  NPCOp;             //models op
   wire [4:0]  SpeRegAddr;
   wire [1:0]  RegDst;
   wire [1:0]  ALUSrcA;   
   wire [1:0]  ALUSrcB;
   wire        MemtoReg;            //select signal
   wire 		     Zero;
   wire [29:0] PC, NPC;
   wire [31:0] dm_dout;
   wire [31:0] DR_out;
   wire [31:0] instr;
   wire [5:0]  Op;
   wire [5:0]  Funct;
   wire [4:0]  rs;
   wire [4:0]  rt;
   wire [4:0]  rd;
   wire [15:0] Imm16; 
   wire [31:0] Imm32;
   wire [25:0] IMM;
   wire [4:0]  A3;
   wire [31:0] WD;
   wire [31:0] RD1, RD2;
   wire [31:0] A, B, C;
   
   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign Imm16 = instr[15:0];
   assign IMM = instr[25:0];
   
   
   PC U_PC (
      .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC)
   ); 
   
   im_4k U_IM ( 
      .addr(PC[9:0]) , .dout(instr)
   );
   
   NPC U_NPC (
      .Zero(Zero), .PC(PC), .NPCOp(NPCOp), .IMM(IMM), .RA(RD1), .NPC(NPC)
   );//N
   
   RF U_RF (
      .A1(rs), .A2(rt), .A3(A3), .WD(WD), .clk(clk), 
      .RFWr(RFWr), .RD1(RD1), .RD2(RD2)
   );
   
   EXT U_EXT ( 
      .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 
   );
   
   alu U_ALU ( 
      .A(A), .B(B), .ALUOp(ALUOp), .C(C), .Compare(Zero)
   );
   
   dm_4k U_DM ( 
      .addr(C[11:2]), .din(RD2), .DMWr(DMWr), .clk(clk), .dout(dm_dout)
   );
   
   singleCtrl U_CTRL (
      .clk(clk),	.rst(rst), .Zero(Zero), .Op(Op), .Funct(Funct),
            .RFWr(RFWr), .DMWr(DMWr), .PCWr(PCWr),
            .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), .SpeRegAddr(SpeRegAddr),
            .RegDst(RegDst), .MemtoReg(MemtoReg), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB)
   );
   
   mux4 #(.WIDTH(5)) RegDst_MUX2(
      .d0(rt), .d1(rd), .d2(SpeRegAddr), .s(RegDst), .y(A3)
   );//ctr signal left...
   
   mux4 #(.WIDTH(32)) ALUSrcA_MUX2(
      .d0(RD1), .d1(RD2), .d2({PC, 2'b00}), .s(ALUSrcA), .y(A)
   );//ctr signal left...
   
   mux4 #(.WIDTH(32)) ALUSrcB_MUX2(
      .d0(RD2), .d1(Imm32), .d2(4), .s(ALUSrcB), .y(B)
   );//ctr signal left...
   
   mux2 #(.WIDTH(32)) MemtoReg_MUX2(
      .d0(C), .d1(dm_dout), .s(MemtoReg), .y(WD)
   );//ctr signal left...
   
endmodule

`include "ctrl_encode_def.v"
module NPC(  Zero, PC, NPCOp, IMM, RA, NPC );
//receive addr and ctr signals, deal with them then decide follow steps
   input  Zero;
   input  [31:2] PC;        //addr data from PC, use 30 to match PC format
   input  [1:0]  NPCOp;     //ctr signals
   input  [25:0] IMM;       //high bits of instructions: 25-0
   input  [31:0] RA;
   output [31:2] NPC;       //addr data back to PC
   
   reg [31:2] NPC;
   
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4: NPC = PC + 1;                           //normally works
          `NPC_BRANCH: begin
            if( Zero )
              NPC = PC + 1 + {{14{IMM[15]}}, IMM[15:0]};          //branch ins, ext IMM[15:0] to 30 bit. (16->32, sll 2)
            else
              NPC = PC + 1;
           end
          `NPC_JUMP: NPC = {PC[31:28], IMM[25:0]};            //jump ins, PC's high 4 adds IMM's 26
          `NPC_JR: NPC = RA[31:2];
          default: ;
      endcase
   end // end always
   
endmodule

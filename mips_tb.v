 module mips_tb();
    
   reg clk, rst;
    
   singleMips U_MIPS(
      .clk(clk), .rst(rst)
   );
    
   initial begin
      $readmemb( "codeb.txt" , U_MIPS.U_IM.imem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", U_MIPS.U_PC.PC, U_MIPS.instr );       clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;
   
endmodule

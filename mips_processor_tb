//TESTBENCH FOR ALU
//module   alu_tb;  
//reg   [31:0]   A,   B;  
//reg   [2:0]   F;  
//wire   Zero;  
//wire   [31:0]   Y;  
//alu   dut   (A,   B,   F,   Y,   Zero);  
//initial  
//begin  
//A   =   32'd1;  
//B   =   32'd2;  
//F   =   3'b000;  
//#8 F =3'b001;
//#8 F =3'b010;

//end  
 
//endmodule

//TESTBENCH FOR SL2 module(LEFT SHIFT BY 2)
//module   s12_tb;  
//reg[31:0]   a;  
//wire[31:0]   y;  
//initial   begin  
//a   =   32'hffffffff; //answer must be 32'hfffffffc
//#3   a   =   32'd1;  //answer must be 32'd4
//#3  $finish;  
//end  
//sl2   dut(a,y);  
//endmodule

//sign extension

//module   signext_tb;  
//reg[15:0]   a;  
//wire[31:0]   y;  
//initial   begin  
//a   =   16'hff34;  // answer y is 32'h0000fff3
//#3   a   =   16'h032f;  // answer y is 32'h0000004f
//#3   $finish; 
//end 
//signext dut(a,y);
//endmodule

//memory testbench
//module   mem_tb;  
//reg   clk,   we;  
//reg   [31:0]   a,   wd;  
//wire   [31:0]   rd;  
//memory   uut(clk,   we,   wd,   a,   rd);  
//always   begin   clk   <=   1;   #5;   clk   <=   0;   #5;   end  
//initial   begin  
//we   <=   0;  
//wd   <=   0;  
//end  
//initial   begin  
//a   <=   10;     
//#10   a   <=   25;     
//#10   a   <=   25;  
//we   <=   1;  
//wd   <=   32'habcd1234; 
//#10   we   <=   0;  
//a   <=   5;   //32'h00a42820 
//#10   a   <=   25;   //read   memory   from   address   25  
//#10   $stop;  
//end  
//endmodule 

//control unit
//module   controller_tb;  
//reg   clk,   reset,   zero;  
//reg   [5:0]   op,   funct;  
//wire       
//iord,   memwrite,   irwrite,   regdst,   memtoreg,   regwrite,   alusrca,   pcen;  
//wire   [1:0]   alusrcb,   pcsrc;  
//wire   [2:0]   alucontrol;  
//reg   [31:0]   instr;  
//always   @   (   *   )  
//begin  
//op   <=   instr   [31:26];  
//funct   <=   instr   [5:0];  
//end  
//controller   uut(clk,   reset,   op,   funct,   zero,   pcen,   memwrite,   irwrite,   regwrite,   alusrca,   iord,   
//memtoreg,   regdst,   alusrcb,   pcsrc,   alucontrol);  
//always   #1   clk   =   ~clk;  
//initial   begin  
//clk   =   0;  
//reset   =   1;  
//zero   =   0;  
//#2    reset   =   1;   instr   =   0;  
//#2    reset   =   0;   instr   =   32'h20020005;   //addi  
//#2    reset   =   0;   instr   =   32'h20020005;   //addi  
//#2    reset   =   0;   instr   =   32'h20020005;   //addi  
//#2   reset   =   0;   instr   =   32'h20020005;   //addi  
//#2   reset   =   0;   instr   =   32'h2003000c;   //addi  
//#2   reset   =   0;   instr   =   32'h2003000c;   //addi  
//#2   reset   =   0;   instr   =   32'h2003000c;   //addi  
//#2   reset   =   0;   instr   =   32'h00e22025;   //or  
//#2   reset   =   0;   instr   =   32'h00e22025;   //or  
//#2   reset   =   0;   instr   =   32'h00e22025;   //or  
//#2   reset   =   0;   instr   =   32'h00e22025;   //or  
//#2   reset   =   0;   instr   =   32'h00642824;   //and  
//#2   reset   =   0;   instr   =   32'h00642824;   //and  
//#2   reset   =   0;   instr   =   32'h00642824;   //and  
//#2   reset   =   0;   instr   =   32'h00642824;   //and  
//#2   reset   =   0;   instr   =   32'h00a42820;   //add  
//#2   reset   =   0;   instr   =   32'h00a42820;   //add  
//#2   reset   =   0;   instr   =   32'h00a42820;   //add  
//#2   reset   =   0;   instr   =   32'h00a42820;   //add  
//#2   reset   =   0;   instr   =   32'h00853820;   //add  
//#2   reset   =   0;   instr   =   32'h00853820;   //add  
//#2   reset   =   0;   instr   =   32'h00853820;   //add  
//#2   reset   =   0;   instr   =   32'h00853820;   //add  
//#2   reset   =   0;   instr   =   32'h00e23822;   //sub  
//#2   reset   =   0;   instr   =   32'h00e23822;   //sub  
//#2   reset   =   0;   instr   =   32'h00e23822;   //sub  
//#2   reset   =   0;   instr   =   32'h00e23822;   //sub  
//#2   reset   =   0;   instr   =   32'hac670044;   //sw  
//#2   reset   =   0;   instr   =   32'hac670044;   //sw  
//#2   reset   =   0;   instr   =   32'hac670044;   //sw  
//#2   reset   =   0;   instr   =   32'hac670044;   //sw  
//#2   reset   =   0;   instr   =   32'h8c020050;   //lw  
//#2   reset   =   0;   instr   =   32'h8c020050;   //lw  
//#2   reset   =   0;   instr   =   32'h8c020050;   //lw  
//#2   reset   =   0;   instr   =   32'h8c020050;   //lw  
//#2   reset   =   0;   instr   =   32'h8c020050;   //lw  
//#2   $stop;  
//end  
//endmodule 

module   register_file_tb();  
reg   clk,   we3;  
reg   [4:0]   a1,   a2,a3;  
reg   [31:0]   wd3;  
wire   [31:0]   rd1,   rd2;  
regfile   dut   (clk,   we3,a1,a2,   a3,wd3,   rd1,   rd2);  
initial   begin  
wd3   =32'b0;  
a1   =   5'b0;  
a2   =   5'b0;  
a3   =   5'b0;  
we3   =   1'b0;  
clk   =   1'b0;  
#100  
we3=1'b1;  
#20  
wd3=32'habcd_efab;  
a1=5'h0;  
a2=5'h0;  
a3=5'h1;  
#20  
wd3=32'h0123_4567;  
a1=5'h1;  
a2=5'h0;  
a3=5'h2;  
#20  
wd3=32'hcccc_cccc;  
a1=5'h2;  
a2=5'h1;  
a3=5'h3;  
#20  
wd3=32'h3333_4567;  
a1=5'h2;  
a2=5'h3;  
a3=5'h1;  
end  
 
always   begin  
#10;  
clk   =~clk;  
end  
endmodule 



`timescale 1ns / 1ps

module alu( input [31:0] A,B,input [2:0] F, output reg [31:0] Y, output zero

    );
    always@(*)
    begin
    case(F)
        3'b000: Y <= A&B;
        3'b001: Y <= A|B;
        3'b010: Y <= A+B;
        3'b011: Y <= ~(B)+1;
        3'b110: Y <= A+ (~(B)+1);
        3'b111: Y <= A < B ? 1:0;
        default: Y <= 0;
        
    endcase
    end
    assign zero = (Y == 32'b0);
endmodule

module flopenr #(parameter WIDTH = 32)(input clk,reset,en,input [WIDTH-1:0] d,output reg [WIDTH-1:0] q);
always@(posedge clk,posedge reset)
begin
    if(reset)  q<=0;
    else if (en) q<=d;
   // else q <= q;
end
endmodule

module flopr #(parameter WIDTH =32)(input clk,reset,input [WIDTH-1:0] d,output reg [WIDTH-1:0] q);
always@(posedge clk,posedge reset)
begin
    if(reset) q <= 0;
    else q <= d;
end
endmodule

module signext #(parameter BITS=16) (input[BITS-1:0] a,output [31:0] y);
    assign y = {{(32-(BITS)){a[BITS-1]}},a};
endmodule

module mux2 #(parameter WIDTH = 32) (input [WIDTH-1:0]d0,d1,input s,output [WIDTH-1:0] y);
assign y = s ? d1:d0;
endmodule

module mux3 #(parameter WIDTH = 32) (input [WIDTH-1:0]d0,d1,d2,input [1:0] s,output [WIDTH-1:0] y);
assign y = s[1] ? d2:(s[0]?d1:d0);
endmodule

module mux4 #(parameter WIDTH = 32) (input [WIDTH-1:0]d0,d1,d2,d3,input [1:0] s,output reg [WIDTH-1:0] y);
always@(*)
begin
    case(s)
    2'b00: y<= d0;
    2'b01: y<= d1;
    2'b10: y<= d2;
    2'b11: y<= d3;
    
    endcase
end
endmodule

module memory(input clk,we,input [31:0]wd,a,output [31:0]rd);
reg [31:0] RAM [63:0];

initial
begin
RAM[0]  <= 32'h20020005;
RAM[1]  <= 32'h2003000c;
RAM[2]  <= 32'h2067fff7;
RAM[3]  <= 32'h00e22025;
RAM[4]  <= 32'h00642824;
RAM[5]  <= 32'h00a42820;
RAM[6]  <= 32'h10a7000a;
RAM[7]  <= 32'h0064202a;
RAM[8]  <= 32'h10800001;
RAM[9]  <= 32'h20050000;
RAM[10] <= 32'h00e2202a;
RAM[11] <= 32'h00853820;
RAM[12] <= 32'h00e23822;
RAM[13] <= 32'hac670044;
RAM[14] <= 32'h8c020050;
RAM[15] <= 32'h08000011;
RAM[16] <= 32'h20020001;
RAM[17] <= 32'hac020054;
 end 

assign rd = RAM[a[31:2]];

always@(posedge clk)
begin
    if(we)
    RAM[a[31:2]]<=wd;
end
endmodule

module regfile (input clk,we3,input [4:0] ra1,ra2,wa3,input[31:0] wd3,output [31:0] rd1,rd2);
    reg [31:0] rf [31:0];
    
    always@(posedge clk)
    begin
    if(we3) rf[wa3] <= wd3;
    end
    
    assign rd1 = (ra1!=0) ? rf[ra1] :0;
    assign rd2 = (ra2!=0) ? rf[ra2] :0;
endmodule

module sl2(input [31:0] a,output [31:0] y);
    assign y = {a[29:0],2'b00};
endmodule

module datapath(op,funct,clk,regdst,reset,pcen,iord,adr,irwrite,readdata,memtoreg,writedata,alusrca,alusrcb,alucontrol,zero);
input clk,reset;
input pcen,iord,irwrite,regdst,alusrca;
input [1:0] alusrcb;
input memtoreg;
input [2:0]alucontrol; 
input [31:0] readdata;

wire [31:0] pcnext,pc;
wire [31:0] instr,data;
wire [31:0] aluout;
wire [4:0] writereg;
wire [31:0] wd3,rd1,rd2,signimm;
wire [31:0] srca,srcb;
wire [31:0] aluresult;
output [5:0] op,funct;
output zero;
output [31:0] adr,writedata;
assign op = instr[31:26];
assign funct = instr[5:0];

flopenr #(32) pcreg(clk,reset,pcen,pcnext,pc);
mux2 #(32) adrmux(pc,aluout,iord,adr);
flopenr #(32) instrreg(clk,reset,irwrite,readdata,instr);
flopr #(32) datareg(clk,reset,readdata,data);

mux2 #(5) regdstmux(instr[20:16],instr[15:11],regdst,writereg);
mux2 #(32) wdmux(aluout,data,memtoreg,wd3);

regfile rf(clk,regwrite,instr [25:21],instr [20:16],writereg,wd3,rd1,rd2);
signext se(instr [15:0],signimm);
sl2 immsh(signimm,signimmsh);
flopr #(32) areg(clk,reset,rd1,a);
flopr #(32) breg(clk,reset,rd2,writedata);
mux2 #(32) srcamux(pc,a,alusrca,srca);
mux4 #(32) srcbmux(writedata,32'd4,signimm,signimmsh,alusrcb,srcb);
alu alu( srca,srcb,alucontrol,aluresult,zero);
flopr #(32) alureg(clk,reset,aluresult,aluout);
//mux2 #(32) pcmux(aluresult,aluout,pcsrc,pcnext);//doubt
mux3 #(32) pcmux(aluresult,aluout,{pc[31:28],instr[25:0], 2'b00},pcsrc,pcnext); 
endmodule

module controller(clk,reset,op,funct,zero,pcen,memwrite,irwrite,regwrite,alusrca,iord,memtoreg,regdst,alusrcb,pcsrc,alucontrol); 
input clk,reset,zero;
input [5:0] op,funct;
wire [1:0] aluop;
wire branch,pcwrite;
output pcen;
output memwrite,irwrite,regwrite,alusrca,iord,memtoreg,regdst; 
output [2:0] alucontrol;
output [1:0] alusrcb,pcsrc;
maindec md(clk,reset,op,pcwrite,memwrite,irwrite,regwrite,alusrca,branch,iord,memtoreg,regdst,alusrcb,pcsrc,aluop);
aludec ad(funct,aluop,alucontrol);

assign pcen = pcwrite | (branch & zero);
endmodule

module maindec(clk,reset,op,pcwrite,memwrite,irwrite,regwrite,alusrca,branch,iord,memtoreg,regdst,alusrcb,pcsrc,aluop);
input clk,reset;
input [5:0] op;
output pcwrite,memwrite,irwrite,regwrite,alusrca,branch,iord,memtoreg,regdst;
output [1:0]alusrcb,pcsrc,aluop;
reg [4:0] state,nextstate;
reg [14:0] controls; 


parameter FETCH = 5'b00000;
parameter DECODE =5'b00001;
parameter MEMADR =5'b00010;
parameter MEMRD = 5'b00011;
parameter MEMWB =5'b00100;
parameter MEMWR = 5'b00101;
parameter EXECUTE= 5'b00110;
parameter ALUWRITEBACK =5'b00111;
parameter BRANCH = 5'b01000;
parameter ADDIEXECUTE =5'b01001;
parameter ADDIWRITEBACK =5'b01010;
parameter JUMP = 5'b01011;

parameter LW= 6'b100011, SW=6'b101011, RTYPE=6'b000000,BEQ=6'b000100,ADDI=6'b001000,J=6'b000010;

always@(posedge clk or posedge reset)
begin
if(reset) state<=FETCH;
else state<=nextstate;
end


always@(*)
begin
case(state)
    FETCH : nextstate <=DECODE;
    DECODE: case(op)
            LW: nextstate <= MEMADR;
            SW: nextstate <= MEMADR;
            RTYPE: nextstate<= EXECUTE;
            BEQ: nextstate<=BRANCH;
            ADDI: nextstate<=ADDIEXECUTE;
            J: nextstate<= JUMP;
            default: nextstate<=FETCH;
            endcase
    MEMADR: case(op)
            LW: nextstate <=MEMRD;
            SW: nextstate <= MEMWR;
            default: nextstate<=FETCH;
            endcase
    MEMRD:   nextstate<=MEMWB;
    MEMWB:   nextstate<=FETCH;
    MEMWR:   nextstate<=FETCH;
    EXECUTE: nextstate<=ALUWRITEBACK;
    ALUWRITEBACK: nextstate<=FETCH;
    BRANCH: nextstate<=FETCH;
    ADDIEXECUTE: nextstate<=ADDIWRITEBACK;
    ADDIWRITEBACK: nextstate<=FETCH;
    JUMP: nextstate<=FETCH;
    default: nextstate<=FETCH;
            
endcase
end 

assign {pcwrite,memwrite,irwrite,regwrite,alusrca,branch,iord,memtoreg,regdst,alusrcb,pcsrc,aluop}= controls; 

always@(*)  
case(state)  
    FETCH:    controls   <=   15'b1010_00000_0100_00;  
    DECODE:   controls   <=   15'b0000_00000_1100_00;  
    MEMADR:   controls   <=   15'b0000_10000_1000_00;  
    MEMRD:    controls   <=   15'b0000_00100_0000_00;  
    MEMWB:    controls   <=   15'b0001_00010_0000_00;  
    MEMWR:    controls   <=   15'b0100_00100_0000_00;  
    EXECUTE:  controls   <=   15'b0000_10000_0000_10;  
    ALUWRITEBACK: controls <= 15'b0001_00001_0000_00;  
    BRANCH:   controls   <=   15'b0000_11000_0001_01;  
    ADDIEXECUTE:   controls   <=   15'b0000_10000_1000_00;  
    ADDIWRITEBACK: controls   <=   15'b0001_00000_0000_00;  
    JUMP:          controls   <=   15'b1000_00000_0010_00;   
    default:   controls   <=   15'b0000_xxxxx_xxxx_xx;   //   should   never   happen  
endcase  
endmodule 

module aludec(input [5:0]funct,input[1:0]aluop,output reg [2:0]alucontrol);

always@(*)
begin
    case(aluop)
        3'b000: alucontrol <= 3'b010;
        3'b001: alucontrol <= 3'b110;
        3'b010: case(funct)
                6'b100000: alucontrol <= 3'b010;
                6'b100010: alucontrol <= 3'b110;     
                6'b100100: alucontrol <= 3'b000;   
                6'b100101: alucontrol <= 3'b001;    
                6'b101010: alucontrol <= 3'b111;  
                default:   alucontrol <= 3'bxxx;   
                endcase
        default: alucontrol <= 3'bxxx;
    endcase
end
endmodule

//interfacing the components-top level module
module mips(clk,reset,readdata,adr,writedata,memwrite);
input clk,reset;
input [31:0] readdata;
output [31:0] adr,writedata;
output memwrite;
wire [5:0] op,funct;
wire zero,pcen,memwrite,irwrite,regwrite,alusrca,iord,memtoreg,regdst;
wire [1:0] alusrcb,pcsrc;
wire [2:0] alucontrol;
controller c(clk,reset,op,funct,zero,pcen,memwrite,irwrite,regwrite,alusrca,iord,memtoreg,regdst,alusrcb,pcsrc,alucontrol); 
datapath dp(op,funct,clk,regdst,reset,pcen,iord,adr,irwrite,readdata,memtoreg,writedata,alusrca,alusrcb,alucontrol,zero);
endmodule

//interfacing memory and processor
module topmulti(clk,reset,writedata,adr,memwrite);
input clk,reset;
output [31:0] writedata,adr;
output memwrite;

mips mips(clk,reset,readdata,adr,writedata,memwrite);
memory mem(clk,memwrite,writedata,adr,readdata);
endmodule

module LSEN_CTRL ( 
   input   RESET_N , 
   input   CLK_50 ,
	output  LIGHT_I2C_SCL,   // output CAP_SENSE_I2C_SCL,
	inout   LIGHT_I2C_SDA,   // inout  CAP_SENSE_I2C_SDA
	inout   LIGHT_INT,
//----SET     N --- 	
   //input  [15:0]SW_PROX_EN,

//----Test or ST-BUS --- 
	output reg [7:0]PART_ID,  
	output reg [7:0]REV_ID,        
	output reg [7:0]SEQ_ID,   
	output reg [7:0]PS1_DATA0,
	output reg [7:0]PS1_DATA1,
	output reg [7:0]PS2_DATA0,
   output reg [7:0]PS2_DATA1,
   output reg [7:0]PS3_DATA0,
   output reg [7:0]PS3_DATA1,	
   output reg [7:0]RESPONSE,
	output reg [7:0]CHIP_STAT ,
	output reg [7:0]rCOMMAND ,
	output reg [7:0]IRQ_STATUS,
	output reg [7:0]PARAM_RD,
	output reg [15:0]PS1_DATA,
	output reg [15:0]PS2_DATA,
	output reg [15:0]PS3_DATA,
	//test
	output reg  CLK_400K ,
   output reg  I2C_LO0P,
   output reg [7:0] ST ,
   output reg [7:0] CNT,
	output reg [7:0] WCNT,
   output reg [7:0] W_WORD_DATA,
   output reg [7:0] W_POINTER_REG,
	
	output           W_WORD_END ,
   output reg       W_WORD_GO ,
	
	output [7:0] WORD_ST,
	output [7:0] WORD_CNT,
	output [7:0] WORD_BYTE	,
   output [7:0]R_DATA,
	output SDAI_W ,
	output reg REP_RQ ,
	output TR 
	
	);
	
//-- I2C clock 400k generater 
//reg  CLK_400K; 
reg  [31:0]C_DELAY ;
always @(posedge CLK_50 ) begin 
  if ( C_DELAY > 125/2 ) begin  
    CLK_400K<=~CLK_400K ; C_DELAY <= 0 ; 
  end 
  else C_DELAY <=C_DELAY +1 ; 
end
  
//======== Main-ST =======
//==Pointer NUM==
parameter    SLAVE_ADDR          =8'hb4;   
//-WRITE-
parameter    P_COMMAND     =8'h18;
parameter    P_PS_LED21    =8'h0F;
parameter    P_PS_LED3     =8'h10;
parameter    P_MEAS_RATE   =8'h08; 
parameter    P_INT_CFG     =8'h03; 
parameter    P_IRQ_ENABLE  =8'h04 ;
parameter    P_PS1_TH0     =8'h11;
parameter    P_PS1_TH1     =8'h12;
parameter    P_PS2_TH0    	=8'h13;
parameter    P_PS2_TH1 		=8'h14;
parameter    P_PS3_TH0 		=8'h15;
parameter    P_PS3_TH1 		=8'h16;
parameter    P_HW_KEY  		=8'h07;


parameter    P_IRQ_MODE1 = 8'h05;
parameter    P_IRQ_MODE2 = 8'h06;
parameter    P_PARAM_WR  = 8'h17;
parameter    P_IRQ_STATUS  = 8'h21;
//--PRAMA
parameter    P_PS_ENCODING  =8'h05 ;
parameter    P_PS_ADC_MISC  =8'h0C ;
parameter    P_CHLIST       =8'h01 ;

//-READ-
parameter    P_PART_ID     =8'h00;
parameter    P_REV_ID      =8'h01;
parameter    P_SEQ_ID      =8'h02;
parameter    P_PS1_DATA0   =8'h26; 
parameter    P_PS1_DATA1   =8'h27;
parameter    P_PS2_DATA0   =8'h28; 
parameter    P_PS2_DATA1   =8'h29;
parameter    P_PS3_DATA0   =8'h2a; 
parameter    P_PS3_DATA1   =8'h2b;
parameter    P_RESPONSE    =8'h20;
parameter    P_CHIP_STAT   =8'h30;
parameter    P_PARAM_RD    =8'h2E;

//----
reg [31:0] DELY ;

always @(negedge RESET_N or posedge CLK_400K )begin 
if (!RESET_N  ) ST <=0;
else 
case (ST)
0: begin 
   ST<=30; //Config Reg
	W_POINTER_GO <=1;
   R_GO  <=1 ;		 
	W_WORD_GO <=1;
	REP_RQ <= 0;
	WCNT <=0;  CNT <=0;
	DELY <=0 ; 
   end
//<----------------READ -------	
1: begin 
   ST<=2; 
	end	
2: begin 
   if (REP_RQ ==1) begin  W_POINTER_REG <=  P_RESPONSE;   end
	else begin 
	     if ( CNT==0)  W_POINTER_REG <= P_PART_ID  ;
	else if ( CNT==1)  W_POINTER_REG <=  P_PS1_DATA0;
	else if ( CNT==2)  W_POINTER_REG <=  P_PS1_DATA1;
   else if ( CNT==3)  W_POINTER_REG <=  P_PS2_DATA0;
   else if ( CNT==4)  W_POINTER_REG <=  P_PS2_DATA1;
   else if ( CNT==5)  W_POINTER_REG <=  P_PS3_DATA0;
   else if ( CNT==6)  W_POINTER_REG <=  P_PS3_DATA1;
	else if ( CNT==7)  W_POINTER_REG <=  P_RESPONSE;
	else if ( CNT==8) W_POINTER_REG <=  P_CHIP_STAT ;
	else if ( CNT==9) W_POINTER_REG <=  P_IRQ_STATUS;
	else if ( CNT==10)  W_POINTER_REG <=  P_PARAM_RD;
	end
	
	if ( W_POINTER_END ) begin  W_POINTER_GO  <=0; ST<=3 ; DELY<=0;  end
	end                // Write pointer
3: begin 
    DELY  <=DELY +1;
    if ( DELY ==2 ) begin 
     W_POINTER_GO  <=1;
     ST<=4 ; 
	 end

	end       
4: begin 
   if  ( W_POINTER_END ) ST<=5 ; 	
	end              
5: begin ST<=6 ; end //delay
	
//read DATA 		 
6: begin 
	if ( R_END ) begin  R_GO  <=0; ST<=7 ; DELY<=0; end
	end                
7: begin 
    DELY  <=DELY +1;
    if ( DELY ==2 ) begin 	 
    R_GO  <=1;
    ST<=8 ; 
	 end
	 
	end       
8: begin 
   ST<=9 ; 
	end       
	
9: begin 
   if  ( R_END ) begin 
	   if (REP_RQ ==1) begin RESPONSE<=R_DATA ;    end
	  else begin 
	       if ( CNT==0) PART_ID  <=R_DATA ; 
	  else if ( CNT==1) PS1_DATA0<=R_DATA ;      
	  else if ( CNT==2) PS1_DATA1<=R_DATA ;      
	  else if ( CNT==3) PS2_DATA0<=R_DATA ; 
     else if ( CNT==4) PS2_DATA1<=R_DATA ; 
     else if ( CNT==5) PS3_DATA0<=R_DATA ; 
     else if ( CNT==6)  PS3_DATA1<=R_DATA ; 
     else if ( CNT==7)  RESPONSE<=R_DATA ; 	  
	  else if ( CNT==8) CHIP_STAT<=R_DATA ;
	  else if ( CNT==9) IRQ_STATUS<=R_DATA ;
	  else if ( CNT==10) PARAM_RD<=R_DATA ;
	  CNT<=CNT+1 ;
	  end
	  
	  ST<=10 ; 	
	  
	 end
	end              
10: begin   
     if (REP_RQ ==1) begin 
	              if ((W_WORD_DATA ==8'h00 ) && ( RESPONSE == 8'h00) )  begin REP_RQ <= 0 ;ST <=35; end    
				else if ((W_WORD_DATA !=8'h00 ) && ( RESPONSE != 8'h00) )  begin REP_RQ <= 0 ;ST <=35; end      
				else begin ST <=1;  end
			  	
	  end 
	  else begin 
     if (CNT ==11) begin 
	    CNT <= 0 ;  
	    ST<=29;
		 PS1_DATA <= { PS1_DATA1[7:0] , PS1_DATA0[7:0] } ; 
		 PS2_DATA <= { PS2_DATA1[7:0] , PS2_DATA0[7:0] } ; 
		 PS3_DATA <= { PS3_DATA1[7:0] , PS3_DATA0[7:0] } ; 
		 DELY <=0;
	  end
	  else 
	    ST<=1; 
	  
	  end	  
	  W_POINTER_GO <=1;
     R_GO         <=1 ;		 
	  W_WORD_GO    <=1; 
	 end //delay
//<----------------------------------READ-----------------------	  
//<----------------------------------WRITE WORD-----------------
29: begin 
    if (DELY < 10 ) DELY <=DELY+1; 
	 else  ST<=30; 
    end	

30: begin 
    ST<=31; 
	 WCNT<=0 ; 
    end	
31: begin 
             //printf("Send_Hardware_Key %x\n",Send_Hardware_Key(0x17));
				 if ( WCNT==0) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_HW_KEY,8'h17};REP_RQ <= 0 ;   end	
			
		//printf("Init_LED_Current %x\n",Init_LED_Current(0xfff));	 
		 else if ( WCNT==1) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_PS_LED21,8'hff };REP_RQ <= 0; end
		 else if ( WCNT==2) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_PS_LED3,8'h0f };REP_RQ <= 0; end		 		 		 		 
		 
		 //SetParam(PARAM_CH_LIST,0x37);
		 else if ( WCNT==3) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_COMMAND[7:0],8'h00 };REP_RQ <= 1 ; end    		 
		 else if ( WCNT==4) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_PARAM_WR ,8'h37 } ;REP_RQ <= 0 ; end 
		 else if ( WCNT==5) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_COMMAND  ,8'ha0 | P_CHLIST};	REP_RQ <= 1 ; end 	 

       //read parm CHLIST
		 else if ( WCNT==6) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_COMMAND[7:0],8'h00 };REP_RQ <= 1 ; end    		 
		 else if ( WCNT==7) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]}<= { P_COMMAND  ,8'h80 | P_CHLIST};	REP_RQ <= 1 ; end 			
		 
		 //PsAlsForce(0x07);
		 else if ( WCNT==8) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]} <= { P_COMMAND[7:0],8'h00 };REP_RQ <= 1 ; end    
		 else if ( WCNT==9) begin {W_POINTER_REG[7:0] ,W_WORD_DATA[7:0]}<= { P_COMMAND  ,8'h07};	REP_RQ <= 1 ; end 				 
		
	if (  W_WORD_END ) begin  W_WORD_GO  <=0; ST<=32 ;  DELY<=0;  end
	end                // Write ID pointer 
32: begin 
    DELY  <=DELY +1;
    if ( DELY ==3 ) begin 
    W_WORD_GO  <=1;
    ST<=33 ; 
	 end
	 
	end       
33: begin 
    ST<=34 ; 
	end       	
34: begin 
     if  ( W_WORD_END )  begin 	
			 WCNT<=WCNT+1 ;			 
			 if (REP_RQ==0)  ST<=35 ; 
			 else  ST<=1 ;  //read
	  end
	end              
35: begin 
    if (WCNT ==10)  begin ST<=1 ;  WCNT <=0;  CNT <=0;I2C_LO0P <= ~I2C_LO0P ; end 
	 else  ST<=31 ; 	 
	 end 
endcase 
end
//<-----------------------------MAIN-ST END ------------------------------------------
//I2C-BUS
wire   SDAO ;      
assign LIGHT_I2C_SCL = W_POINTER_SCL  & R_SCL   & W_WORD_SCL;
assign SDAO          = W_POINTER_SDAO & R_SDAO  & W_WORD_SDAO;
assign LIGHT_I2C_SDA = (SDAO)?1'bz :1'b0 ; 


//==== I2C WRITE WORD ===

wire   W_WORD_SCL ; 
wire   W_WORD_SDAO ;  

I2C_WRITE_BYTE  wrd(
   .RESET_N      (RESET_N),
	.PT_CK        (CLK_400K),
	.GO           (W_WORD_GO),
	.LIGHT_INT    (LIGHT_INT),
	.POINTER      (W_POINTER_REG),
   .WDATA8	     (W_WORD_DATA),
	.SLAVE_ADDRESS(SLAVE_ADDR ),
	.SDAI  (LIGHT_I2C_SDA),
	.SDAO  (W_WORD_SDAO),
	.SCLO  (W_WORD_SCL ),
	.END_OK(W_WORD_END),
	//--for test 
	.ST  (WORD_ST ),
	.CNT (WORD_CNT),
	.BYTE(WORD_BYTE),
	.ACK_OK(),
	.SDAI_W (SDAI_W )
	
);

//==== I2C WRITE POINTER ===
wire   W_POINTER_SCL ; 
wire   W_POINTER_END ; 
reg    W_POINTER_GO ; 
wire   W_POINTER_SDAO ;  

I2C_WRITE_POINTER  wpt(
   .RESET_N (RESET_N),
	.PT_CK        (CLK_400K),
	.GO           (W_POINTER_GO),
	.POINTER      (W_POINTER_REG),
	.SLAVE_ADDRESS(SLAVE_ADDR ),//37
	.SDAI  (LIGHT_I2C_SDA),
	.SDAO  (W_POINTER_SDAO),
	.SCLO  (W_POINTER_SCL ),
	.END_OK(W_POINTER_END),
	//--for test 
	.ST (),
	.ACK_OK(),
	.CNT (),
	.BYTE()  	
);


//==== I2C READ ===

wire R_SCL; 
wire R_END; 
reg  R_GO; 
wire R_SDAO;  


I2C_READ_BYTE rd( //
   .RESET_N (RESET_N),
	.PT_CK        (CLK_400K),
	.GO           (R_GO),
	.SLAVE_ADDRESS(SLAVE_ADDR ),
	.SDAI  (LIGHT_I2C_SDA),
	.SDAO  (R_SDAO),
	.SCLO  (R_SCL),
	.END_OK(R_END),
	.DATA8(R_DATA),
	//--for test 
	.ST    (),
	.ACK_OK(),
	.CNT   (),
	.BYTE  ()  	
);
	
endmodule
	
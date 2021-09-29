module  SPI_CTL (
 input         RESET_N , 
 input         CLK_50 , 
 output reg [15:0] OUT_X ,//two’s complement left-justified.\
 output reg [15:0] OUT_Y ,//two’s complement left-justified.\
 output reg [15:0] OUT_Z ,//two’s complement left-justified.\
 output reg [7:0] WHO_AM_I ,
 output reg [7:0] OUT_X_L  ,
 output reg [7:0] OUT_X_H  ,
 output reg [7:0] OUT_Y_L  ,
 output reg [7:0] OUT_Y_H  ,
 output reg [7:0] OUT_Z_L  ,
 output reg [7:0] OUT_Z_H  ,
 
 output reg CS ,
 output reg SCLK,
 output reg DIN ,
 input      DO ,
 output reg DATA_RDY ,
 
 //--test--
 output reg SYS_CLK  ,  
 output reg [7:0]ST  ,
 output reg [7:0]BIT_CNT ,
 output reg [7:0]WORD_CNT ,
 output reg  [15:0] RDATA ,
 output reg  [15:0] CREG  , 
 output DIN_  
 );

 //--1MHZ  clock generator--
 reg [7:0] CC; 
  always @( posedge CLK_50 ) begin 
	if  ( CC > 25  ) begin 
	   SYS_CLK <=~SYS_CLK ;   
		CC <=0; 
	 end
	else  
	 CC <=CC+1 ;
 end	
 
 //--BYPASS
 assign  DIN_ = DIN ;  
 
 //--FSM--
 // --WRITE SETTING --   
 parameter CTRL_REG6   = 16'h253F;
 parameter CTRL_REG1   = 16'h2097;
 parameter INT1_CFG    = 16'h30ff;
 parameter INT2_CFG    = 16'h34ff;
 parameter INT1_SRC    = 16'h31ff;
 parameter INT2_SRC    = 16'h35ff;
 parameter CTRL_REG3   = 16'h22c0;
 parameter CTRL_REG2   = 16'h21c0 ;


// --READ POINTER --   
 parameter R_WHO_AM_I = 16'h0F00 ; 
 parameter R_OUT_X_L  = 16'h2800; 
 parameter R_OUT_X_H  = 16'h2900;
 parameter R_OUT_Y_L  = 16'h2A00; 
 parameter R_OUT_Y_H  = 16'h2B00;
 parameter R_OUT_Z_L  = 16'h2C00; 
 parameter R_OUT_Z_H  = 16'h2D00;

 
 always @( negedge RESET_N or posedge SYS_CLK ) begin 
 if ( !RESET_N) begin 
   ST    <=0;
	CS    <=1; 
	SCLK  <=1;  
	DIN   <=0 ;  	 
	BIT_CNT   <=0; 
   DATA_RDY  <=0; 
	WORD_CNT  <=7; 
  end
 else begin 
  case (ST)
  // --- WRITE ---- 
  0: begin 
           if ( WORD_CNT ==0 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  CTRL_REG1   } ;
		else if ( WORD_CNT ==1 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  CTRL_REG6   } ; 
		else if ( WORD_CNT ==2 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  INT1_CFG  } ; 
		else if ( WORD_CNT ==3 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  INT2_CFG  } ; 		
		else if ( WORD_CNT ==4 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  INT1_SRC  } ; 		
		else if ( WORD_CNT ==5 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  INT2_SRC  } ; 	
		else if ( WORD_CNT ==6 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  CTRL_REG3 } ; 
		else if ( WORD_CNT ==7 ) { DIN , RDATA[15:0] }   <=   {   1'b0  ,  CTRL_REG2 } ;
		
		
	  	BIT_CNT   <=0; 
      ST<=1 ;  
  end
  1: begin 
     { DIN , RDATA[15:0] }   <= { RDATA[15:0] ,1'b0 } ;	  
	  CS  <=0; 
	  ST<= 2; 
  end
  2: begin 
     SCLK  <=0;	  
	  BIT_CNT   <=BIT_CNT+1; 
	  ST<= 3; 
   end
  3: begin 
     SCLK  <=1;	  
	  if  ( BIT_CNT==16) begin 
	       ST<=4  ;  
		 end 
	  else  ST<=1 ;  
  end
  4: begin 
     ST  <=5 ;  	
	  CS  <=1; 
	  DIN <=0 ;
  end  
  5: begin 
     if (  WORD_CNT !=0   ) begin  
	      WORD_CNT <=  WORD_CNT -1  ; 
			ST       <= 0 ;
     end
     else begin 	  			
        ST <=10 ; 
	     WORD_CNT <= 0  ; 
	  end
  end  
  
   // ----- READ ------
	
10:begin 
       ST  <=11;
		 CS  <= 1; 
		 SCLK  <=1;
		 BIT_CNT   <=16;  
		 
        if ( WORD_CNT == 0 ) begin  CREG   <=  R_WHO_AM_I ;  end	 
  else  if ( WORD_CNT == 1 ) begin  CREG   <=  R_OUT_X_L  ;  end 
  else  if ( WORD_CNT == 2 ) begin  CREG   <=  R_OUT_X_H  ;  end   
  else  if ( WORD_CNT == 3 ) begin  CREG   <=  R_OUT_Y_L ;   end 
  else  if ( WORD_CNT == 4 ) begin  CREG   <=  R_OUT_Y_H ;   end 
  else  if ( WORD_CNT == 5 ) begin  CREG   <=  R_OUT_Z_L ;   end 
  else  if ( WORD_CNT == 6 ) begin  CREG   <=  R_OUT_Z_H ;   end 
   
  end 
11:begin 
       CREG   <=  16'h8000 | CREG  ;
       CS     <=0; 
       ST     <=12;
  end 
12:begin 
       SCLK  <=0;
       { DIN ,CREG[15:0]} <= {CREG[15:0], 1'b0} ;
       ST<=13;
  end 
13:begin 
      SCLK  <=1;
      BIT_CNT   <=BIT_CNT-1;
      ST    <=14;
  end 
14:begin 
      RDATA[15:0] <= {RDATA[14:0], DO} ;       
      if ( BIT_CNT!=0) ST<=12 ; 
      else begin 
		   ST<=15 ; CS  <=1; 
		end	
  end 
15:begin 
        ST<=16 ; 
	     if  ( WORD_CNT == 7 )    WORD_CNT  <= 0;
	     else  WORD_CNT  <=WORD_CNT + 1 ;	
            if ( WORD_CNT ==0 ) WHO_AM_I <= RDATA[7:0] ;       
		 else  if ( WORD_CNT ==1 ) OUT_X_L  <= RDATA[7:0] ;       
		 else  if ( WORD_CNT ==2 ) OUT_X_H  <= RDATA[7:0] ;       
		 else  if ( WORD_CNT ==3 ) OUT_Y_L  <= RDATA[7:0] ;       
		 else  if ( WORD_CNT ==4 ) OUT_Y_H  <= RDATA[7:0] ;    
		 else  if ( WORD_CNT ==5 ) OUT_Z_L  <= RDATA[7:0] ;       
		 else  if ( WORD_CNT ==6 ) OUT_Z_H  <= RDATA[7:0] ;    		
  end 
16:begin 
        ST<=17 ; 
	     if ( WORD_CNT == 0 )   begin 
		     OUT_X <= { OUT_X_H[7:0] ,OUT_X_L[7:0] } ;
			  OUT_Y <= { OUT_Y_H[7:0] ,OUT_Y_L[7:0] } ;
			  OUT_Z <= { OUT_Z_H[7:0] ,OUT_Z_L[7:0] } ;
			 end  
	 end
17:begin 
        ST<=18 ; 
	     DATA_RDY <=1 ; 
	 end
18:begin 
        ST<=19 ; 
	 end
19:begin 
        ST<=10; 
	     DATA_RDY <=0 ; 
	end
  endcase 
  end
 end

 endmodule
 
  
 
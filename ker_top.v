// ============================================================================
// Designer : Yi_Yuan Chen
// Create   : 2022.11.16
// Ver      : 1.0
// Func     : kernel top module
// ============================================================================
//      Instance Name:              KER_SRAM
//      Words:                      1024
//      Bits:                       64
//      Mux:                        8
//      Drive:                      6
//      Write Mask:                 Off
//      Extra Margin Adjustment:    On
//      Accelerated Retention Test: Off
//      Redundant Rows:             0
//      Redundant Columns:          0
//      Test Muxes                  Off
//-----------------------------------------------------------------------------
// `define FPGA_SRAM_SETTING



module ker_top 
#(
	parameter KER_ADDR_CNT_BITS = 10 
	,	BUF_TAG_BITS	= 8
	,	STARTER_BITS	= 8
	,	PADLEN_BITS		= 8
)(
		clk
	,	reset		

	,	ker_write_data_din				
	,	ker_write_empty_n_din			
	,	ker_write_read_dout			

	,	ker_write_done 				
	,	ker_write_busy 				
	,	ker_write_en 				
	,	start_ker_write				

	,	ker_read_done 					
	,	ker_read_busy 					
	,	start_ker_read					

	,	output_of_cnt_ker 				
	,	output_of_enable_ker_cnt 		
	//----generated by ker_top_mod.py------ 
	//----top port list with rw SRAM reference------ 
	,	dout_kersr_0 ,	dout_kersr_1 ,	dout_kersr_2 ,	dout_kersr_3 ,	dout_kersr_4 ,	dout_kersr_5 ,	dout_kersr_6 ,	dout_kersr_7 	
	,	ksr_valid_0  ,	ksr_valid_1  ,	ksr_valid_2  ,	ksr_valid_3  ,	ksr_valid_4  ,	ksr_valid_5  ,	ksr_valid_6  ,	ksr_valid_7 			
	,	ksr_final_0  ,	ksr_final_1  ,	ksr_final_2  ,	ksr_final_3  ,	ksr_final_4  ,	ksr_final_5  ,	ksr_final_6  ,	ksr_final_7 			
	//----top port list with rw SRAM reference------  

	,	cfg_kernum_sub1		
	,	cfg_colout_sub1		
	,	cfg_normal_length		
	,	cfgin_top_starter		
	,	cfgin_toppad_length	
	,	cfgin_botpad_length	
	,	cfg_kerw_buflength
	,	cfg_atlchin
	
	,	if_r_state		
	
);

// localparam KER_ADDR_CNT_BITS = 10;
// localparam BUF_TAG_BITS = 8;
// localparam STARTER_BITS	=	8 ;
// localparam PADLEN_BITS	=	8 ;


	input wire clk ;
	input wire reset ;


	input wire [ 63 : 0 ] ker_write_data_din	;
	input wire			  ker_write_empty_n_din	;
	output wire			  ker_write_read_dout	;

	output wire 		ker_write_done 		;
	output wire 		ker_write_busy 		;
	output wire 		ker_write_en 		;
	input wire 		    start_ker_write		;

	output wire 		ker_read_done 		;
	output wire 		ker_read_busy 		;
	input wire 		    start_ker_read		;

	output wire [ 64 -1 : 0 ] dout_kersr_0 ,dout_kersr_1 ,dout_kersr_2 ,dout_kersr_3 ,dout_kersr_4 ,dout_kersr_5 ,dout_kersr_6 ,dout_kersr_7 ; 
	output wire 			  ksr_valid_0  ,ksr_valid_1  ,ksr_valid_2  ,ksr_valid_3  ,ksr_valid_4  ,ksr_valid_5  ,ksr_valid_6  ,ksr_valid_7  ; 
	output wire 		      ksr_final_0  ,ksr_final_1  ,ksr_final_2  ,ksr_final_3  ,ksr_final_4  ,ksr_final_5  ,ksr_final_6  ,ksr_final_7  ; 

//----ker w test input declare start------ 
    // input wire tst_sram_rw ;	// will cause failure at read/write change
// ---- declare signal for bias read module ----
	output wire [BUF_TAG_BITS-1:0] 	output_of_cnt_ker 			;
	output wire 		output_of_enable_ker_cnt 	;

	//----    kernel read cfg    -----
	input wire	[BUF_TAG_BITS-1:0]  	cfg_kernum_sub1		;
	input wire	[KER_ADDR_CNT_BITS-1:0]		cfg_colout_sub1		;
	input wire	[KER_ADDR_CNT_BITS-1:0]		cfg_normal_length	;

	input wire	[STARTER_BITS*5	-1:0]	cfgin_top_starter		;
	input wire	[PADLEN_BITS*5	-1:0]	cfgin_toppad_length		;
	input wire	[PADLEN_BITS*5	-1:0]	cfgin_botpad_length		;
	input wire	[5-1:0]					cfg_atlchin				;

	//----    kernel write cfg    -----
	input wire	[KER_ADDR_CNT_BITS-1:0 ]	cfg_kerw_buflength ;	// config for every kernel write buffer data length. If ker=64, ch_in=32 ,the 64ker*32ch_in*(3x3)/8buf /8 -1= 288-1= 287

	//----    ifmap read FSM state    -----
	input wire [3-1:0]	if_r_state	;

//==============================================================================
//========    config declare    ========
//==============================================================================

//----    kernel read cfg    -----
reg		[BUF_TAG_BITS-1:0]  	rcfg_kernum_sub1		;
reg		[KER_ADDR_CNT_BITS-1:0]		rcfg_colout_sub1		;
reg 	[KER_ADDR_CNT_BITS-1:0]		rcfg_normal_length		;

reg		[STARTER_BITS*5	-1:0]	rcfgin_top_starter			;
reg		[PADLEN_BITS*5	-1:0]	rcfgin_toppad_length		;
reg		[PADLEN_BITS*5	-1:0]	rcfgin_botpad_length		;
reg		[5-1:0]					rcfg_atlchin				;

//----    kernel write cfg    -----
reg		[KER_ADDR_CNT_BITS-1:0 ]	rcfg_kerw_buflength ;	// config for every kernel write buffer data length. If ker=64, ch_in=32 ,the 64ker*32ch_in*(3x3)/8buf /8 -1= 288-1= 287


//-----------------------------------------------------------------------------




//----generated by ker_top_mod.py------ 
//---- kersram top declare KER_SRAM start------ 
wire cen_kersr_0 ,cen_kersr_1 ,cen_kersr_2 ,cen_kersr_3 ,cen_kersr_4 ,cen_kersr_5 ,cen_kersr_6 ,cen_kersr_7 ; 
wire wen_kersr_0 ,wen_kersr_1 ,wen_kersr_2 ,wen_kersr_3 ,wen_kersr_4 ,wen_kersr_5 ,wen_kersr_6 ,wen_kersr_7 ; 
wire [ KER_ADDR_CNT_BITS -1 : 0 ] addr_kersr_0 ,addr_kersr_1 ,addr_kersr_2 ,addr_kersr_3 ,addr_kersr_4 ,addr_kersr_5 ,addr_kersr_6 ,addr_kersr_7 ; 
wire [ 64 -1 : 0 ] din_kersr_0 ,din_kersr_1 ,din_kersr_2 ,din_kersr_3 ,din_kersr_4 ,din_kersr_5 ,din_kersr_6 ,din_kersr_7 ; 
//---- kersram top declare KER_SRAM end------ 

//----declare ker_top sram read signal start------ 
wire ksr_cen_kersr_0 ,ksr_cen_kersr_1 ,ksr_cen_kersr_2 ,ksr_cen_kersr_3 ,ksr_cen_kersr_4 ,ksr_cen_kersr_5 ,ksr_cen_kersr_6 ,ksr_cen_kersr_7 ; 
wire ksr_wen_kersr_0 ,ksr_wen_kersr_1 ,ksr_wen_kersr_2 ,ksr_wen_kersr_3 ,ksr_wen_kersr_4 ,ksr_wen_kersr_5 ,ksr_wen_kersr_6 ,ksr_wen_kersr_7 ; 
wire [ KER_ADDR_CNT_BITS -1 : 0 ] ksr_addr_kersr_0 ,ksr_addr_kersr_1 ,ksr_addr_kersr_2 ,ksr_addr_kersr_3 ,ksr_addr_kersr_4 ,ksr_addr_kersr_5 ,ksr_addr_kersr_6 ,ksr_addr_kersr_7 ; 
//----declare ker_top sram read signal  end------ 

//----declare ker_top sram write signal start------ 
wire ksw_cen_kersr_0 ,ksw_cen_kersr_1 ,ksw_cen_kersr_2 ,ksw_cen_kersr_3 ,ksw_cen_kersr_4 ,ksw_cen_kersr_5 ,ksw_cen_kersr_6 ,ksw_cen_kersr_7 ; 
wire ksw_wen_kersr_0 ,ksw_wen_kersr_1 ,ksw_wen_kersr_2 ,ksw_wen_kersr_3 ,ksw_wen_kersr_4 ,ksw_wen_kersr_5 ,ksw_wen_kersr_6 ,ksw_wen_kersr_7 ; 
wire [ KER_ADDR_CNT_BITS -1 : 0 ] ksw_addr_kersr_0 ,ksw_addr_kersr_1 ,ksw_addr_kersr_2 ,ksw_addr_kersr_3 ,ksw_addr_kersr_4 ,ksw_addr_kersr_5 ,ksw_addr_kersr_6 ,ksw_addr_kersr_7 ; 
wire [ 64 -1 : 0 ] ksw_din_kersr_0 ,ksw_din_kersr_1 ,ksw_din_kersr_2 ,ksw_din_kersr_3 ,ksw_din_kersr_4 ,ksw_din_kersr_5 ,ksw_din_kersr_6 ,ksw_din_kersr_7 ; 
//----declare ker_top sram write signal  end------ 

//----    actually cen wen signal declare    -----
// for actually connection between FPGA and CBDK
wire atl_cen_kersr_0 , atl_cen_kersr_1 , atl_cen_kersr_2 , atl_cen_kersr_3 , atl_cen_kersr_4 , atl_cen_kersr_5 , atl_cen_kersr_6 , atl_cen_kersr_7	;
wire atl_wen_kersr_0 , atl_wen_kersr_1 , atl_wen_kersr_2 , atl_wen_kersr_3 , atl_wen_kersr_4 , atl_wen_kersr_5 , atl_wen_kersr_6 , atl_wen_kersr_7	;

//----generated by ker_top_mod.py------ 
//----ker_top assign start------ 
//----ker_top assign cen ------ 
    assign cen_kersr_0 = ( ker_write_busy )? ksw_cen_kersr_0 : ksr_cen_kersr_0 ;
    assign cen_kersr_1 = ( ker_write_busy )? ksw_cen_kersr_1 : ksr_cen_kersr_1 ;
    assign cen_kersr_2 = ( ker_write_busy )? ksw_cen_kersr_2 : ksr_cen_kersr_2 ;
    assign cen_kersr_3 = ( ker_write_busy )? ksw_cen_kersr_3 : ksr_cen_kersr_3 ;
    assign cen_kersr_4 = ( ker_write_busy )? ksw_cen_kersr_4 : ksr_cen_kersr_4 ;
    assign cen_kersr_5 = ( ker_write_busy )? ksw_cen_kersr_5 : ksr_cen_kersr_5 ;
    assign cen_kersr_6 = ( ker_write_busy )? ksw_cen_kersr_6 : ksr_cen_kersr_6 ;
    assign cen_kersr_7 = ( ker_write_busy )? ksw_cen_kersr_7 : ksr_cen_kersr_7 ;
//----ker_top assign wen ------ 
    assign wen_kersr_0 = ( ker_write_busy )? ksw_wen_kersr_0 : 1'd1 ;
    assign wen_kersr_1 = ( ker_write_busy )? ksw_wen_kersr_1 : 1'd1 ;
    assign wen_kersr_2 = ( ker_write_busy )? ksw_wen_kersr_2 : 1'd1 ;
    assign wen_kersr_3 = ( ker_write_busy )? ksw_wen_kersr_3 : 1'd1 ;
    assign wen_kersr_4 = ( ker_write_busy )? ksw_wen_kersr_4 : 1'd1 ;
    assign wen_kersr_5 = ( ker_write_busy )? ksw_wen_kersr_5 : 1'd1 ;
    assign wen_kersr_6 = ( ker_write_busy )? ksw_wen_kersr_6 : 1'd1 ;
    assign wen_kersr_7 = ( ker_write_busy )? ksw_wen_kersr_7 : 1'd1 ;
//----ker_top assign addr ------ 
    assign addr_kersr_0 =  ( ker_write_busy )? ksw_addr_kersr_0 : ksr_addr_kersr_0 ;
    assign addr_kersr_1 =  ( ker_write_busy )? ksw_addr_kersr_1 : ksr_addr_kersr_1 ;
    assign addr_kersr_2 =  ( ker_write_busy )? ksw_addr_kersr_2 : ksr_addr_kersr_2 ;
    assign addr_kersr_3 =  ( ker_write_busy )? ksw_addr_kersr_3 : ksr_addr_kersr_3 ;
    assign addr_kersr_4 =  ( ker_write_busy )? ksw_addr_kersr_4 : ksr_addr_kersr_4 ;
    assign addr_kersr_5 =  ( ker_write_busy )? ksw_addr_kersr_5 : ksr_addr_kersr_5 ;
    assign addr_kersr_6 =  ( ker_write_busy )? ksw_addr_kersr_6 : ksr_addr_kersr_6 ;
    assign addr_kersr_7 =  ( ker_write_busy )? ksw_addr_kersr_7 : ksr_addr_kersr_7 ;
//----ker_top assign din ------ 
    assign din_kersr_0 =  ( ker_write_busy )? ksw_din_kersr_0 : 64'd0 ;
    assign din_kersr_1 =  ( ker_write_busy )? ksw_din_kersr_1 : 64'd0 ;
    assign din_kersr_2 =  ( ker_write_busy )? ksw_din_kersr_2 : 64'd0 ;
    assign din_kersr_3 =  ( ker_write_busy )? ksw_din_kersr_3 : 64'd0 ;
    assign din_kersr_4 =  ( ker_write_busy )? ksw_din_kersr_4 : 64'd0 ;
    assign din_kersr_5 =  ( ker_write_busy )? ksw_din_kersr_5 : 64'd0 ;
    assign din_kersr_6 =  ( ker_write_busy )? ksw_din_kersr_6 : 64'd0 ;
    assign din_kersr_7 =  ( ker_write_busy )? ksw_din_kersr_7 : 64'd0 ;
//----ker_top assign end------ 



//==============================================================================
//========    SRAM instance and assignment    ========
//==============================================================================

`ifdef FPGA_SRAM_SETTING
	assign atl_cen_kersr_0 = ~cen_kersr_0	;
	assign atl_cen_kersr_1 = ~cen_kersr_1	;
	assign atl_cen_kersr_2 = ~cen_kersr_2	;
	assign atl_cen_kersr_3 = ~cen_kersr_3	;
	assign atl_cen_kersr_4 = ~cen_kersr_4	;
	assign atl_cen_kersr_5 = ~cen_kersr_5	;
	assign atl_cen_kersr_6 = ~cen_kersr_6	;
	assign atl_cen_kersr_7 = ~cen_kersr_7	;

	assign atl_wen_kersr_0 = ~wen_kersr_0	;
	assign atl_wen_kersr_1 = ~wen_kersr_1	;
	assign atl_wen_kersr_2 = ~wen_kersr_2	;
	assign atl_wen_kersr_3 = ~wen_kersr_3	;
	assign atl_wen_kersr_4 = ~wen_kersr_4	;
	assign atl_wen_kersr_5 = ~wen_kersr_5	;
	assign atl_wen_kersr_6 = ~wen_kersr_6	;
	assign atl_wen_kersr_7 = ~wen_kersr_7	;
`else 
	assign atl_cen_kersr_0 = cen_kersr_0	;
	assign atl_cen_kersr_1 = cen_kersr_1	;
	assign atl_cen_kersr_2 = cen_kersr_2	;
	assign atl_cen_kersr_3 = cen_kersr_3	;
	assign atl_cen_kersr_4 = cen_kersr_4	;
	assign atl_cen_kersr_5 = cen_kersr_5	;
	assign atl_cen_kersr_6 = cen_kersr_6	;
	assign atl_cen_kersr_7 = cen_kersr_7	;

	assign atl_wen_kersr_0 = wen_kersr_0	;
	assign atl_wen_kersr_1 = wen_kersr_1	;
	assign atl_wen_kersr_2 = wen_kersr_2	;
	assign atl_wen_kersr_3 = wen_kersr_3	;
	assign atl_wen_kersr_4 = wen_kersr_4	;
	assign atl_wen_kersr_5 = wen_kersr_5	;
	assign atl_wen_kersr_6 = wen_kersr_6	;
	assign atl_wen_kersr_7 = wen_kersr_7	;

`endif 


`ifdef FPGA_SRAM_SETTING
	BRAM_KER ker_0 ( .clka( clk ) ,.ena( atl_cen_kersr_0 )	,.wea( atl_wen_kersr_0 )	,.addra( addr_kersr_0 ),.dina( din_kersr_0 )	,.douta( dout_kersr_0 ) );
	BRAM_KER ker_1 ( .clka( clk ) ,.ena( atl_cen_kersr_1 )	,.wea( atl_wen_kersr_1 )	,.addra( addr_kersr_1 ),.dina( din_kersr_1 )	,.douta( dout_kersr_1 ) );
	BRAM_KER ker_2 ( .clka( clk ) ,.ena( atl_cen_kersr_2 )	,.wea( atl_wen_kersr_2 )	,.addra( addr_kersr_2 ),.dina( din_kersr_2 )	,.douta( dout_kersr_2 ) );
	BRAM_KER ker_3 ( .clka( clk ) ,.ena( atl_cen_kersr_3 )	,.wea( atl_wen_kersr_3 )	,.addra( addr_kersr_3 ),.dina( din_kersr_3 )	,.douta( dout_kersr_3 ) );
	BRAM_KER ker_4 ( .clka( clk ) ,.ena( atl_cen_kersr_4 )	,.wea( atl_wen_kersr_4 )	,.addra( addr_kersr_4 ),.dina( din_kersr_4 )	,.douta( dout_kersr_4 ) );
	BRAM_KER ker_5 ( .clka( clk ) ,.ena( atl_cen_kersr_5 )	,.wea( atl_wen_kersr_5 )	,.addra( addr_kersr_5 ),.dina( din_kersr_5 )	,.douta( dout_kersr_5 ) );
	BRAM_KER ker_6 ( .clka( clk ) ,.ena( atl_cen_kersr_6 )	,.wea( atl_wen_kersr_6 )	,.addra( addr_kersr_6 ),.dina( din_kersr_6 )	,.douta( dout_kersr_6 ) );
	BRAM_KER ker_7 ( .clka( clk ) ,.ena( atl_cen_kersr_7 )	,.wea( atl_wen_kersr_7 )	,.addra( addr_kersr_7 ),.dina( din_kersr_7 )	,.douta( dout_kersr_7 ) );
`else 
	//----generated by ker_top_mod.py------ 
	//----instance KER_SRAM start------ 
	KER_SRAM ker_0(.Q(	dout_kersr_0 ),	.CLK( clk ),.CEN( cen_kersr_0 ),.WEN( wen_kersr_0 ),.A( addr_kersr_0 ),.D( din_kersr_0 ),.EMA( 3'b0 ));//----instance KER SRAM_0---------
	KER_SRAM ker_1(.Q(	dout_kersr_1 ),	.CLK( clk ),.CEN( cen_kersr_1 ),.WEN( wen_kersr_1 ),.A( addr_kersr_1 ),.D( din_kersr_1 ),.EMA( 3'b0 ));//----instance KER SRAM_1---------
	KER_SRAM ker_2(.Q(	dout_kersr_2 ),	.CLK( clk ),.CEN( cen_kersr_2 ),.WEN( wen_kersr_2 ),.A( addr_kersr_2 ),.D( din_kersr_2 ),.EMA( 3'b0 ));//----instance KER SRAM_2---------
	KER_SRAM ker_3(.Q(	dout_kersr_3 ),	.CLK( clk ),.CEN( cen_kersr_3 ),.WEN( wen_kersr_3 ),.A( addr_kersr_3 ),.D( din_kersr_3 ),.EMA( 3'b0 ));//----instance KER SRAM_3---------
	KER_SRAM ker_4(.Q(	dout_kersr_4 ),	.CLK( clk ),.CEN( cen_kersr_4 ),.WEN( wen_kersr_4 ),.A( addr_kersr_4 ),.D( din_kersr_4 ),.EMA( 3'b0 ));//----instance KER SRAM_4---------
	KER_SRAM ker_5(.Q(	dout_kersr_5 ),	.CLK( clk ),.CEN( cen_kersr_5 ),.WEN( wen_kersr_5 ),.A( addr_kersr_5 ),.D( din_kersr_5 ),.EMA( 3'b0 ));//----instance KER SRAM_5---------
	KER_SRAM ker_6(.Q(	dout_kersr_6 ),	.CLK( clk ),.CEN( cen_kersr_6 ),.WEN( wen_kersr_6 ),.A( addr_kersr_6 ),.D( din_kersr_6 ),.EMA( 3'b0 ));//----instance KER SRAM_6---------
	KER_SRAM ker_7(.Q(	dout_kersr_7 ),	.CLK( clk ),.CEN( cen_kersr_7 ),.WEN( wen_kersr_7 ),.A( addr_kersr_7 ),.D( din_kersr_7 ),.EMA( 3'b0 ));//----instance KER SRAM_7---------
	//----instance KER_SRAM end------ 
`endif 
//-----------------------------------------------------------------------------

//-------------------------------------------------------------------
//----------------		kernel sram write module		-------------
//-------------------------------------------------------------------
kersram_w	#(    .ADDR_CNT_BITS(	KER_ADDR_CNT_BITS 	)     

    )ker_write (
	.clk	(	clk		)
	,	.reset	(	reset	)


	//----generate by ker_w_io.py 
	//----ker_top sram write instance port start------ 
	,.cen_kersr_0 ( ksw_cen_kersr_0 ),.wen_kersr_0 ( ksw_wen_kersr_0 ),.addr_kersr_0 ( ksw_addr_kersr_0 ),.din_kersr_0 ( ksw_din_kersr_0 )	//----declare ker_top SRAM_0---------
	,.cen_kersr_1 ( ksw_cen_kersr_1 ),.wen_kersr_1 ( ksw_wen_kersr_1 ),.addr_kersr_1 ( ksw_addr_kersr_1 ),.din_kersr_1 ( ksw_din_kersr_1 )	//----declare ker_top SRAM_1---------
	,.cen_kersr_2 ( ksw_cen_kersr_2 ),.wen_kersr_2 ( ksw_wen_kersr_2 ),.addr_kersr_2 ( ksw_addr_kersr_2 ),.din_kersr_2 ( ksw_din_kersr_2 )	//----declare ker_top SRAM_2---------
	,.cen_kersr_3 ( ksw_cen_kersr_3 ),.wen_kersr_3 ( ksw_wen_kersr_3 ),.addr_kersr_3 ( ksw_addr_kersr_3 ),.din_kersr_3 ( ksw_din_kersr_3 )	//----declare ker_top SRAM_3---------
	,.cen_kersr_4 ( ksw_cen_kersr_4 ),.wen_kersr_4 ( ksw_wen_kersr_4 ),.addr_kersr_4 ( ksw_addr_kersr_4 ),.din_kersr_4 ( ksw_din_kersr_4 )	//----declare ker_top SRAM_4---------
	,.cen_kersr_5 ( ksw_cen_kersr_5 ),.wen_kersr_5 ( ksw_wen_kersr_5 ),.addr_kersr_5 ( ksw_addr_kersr_5 ),.din_kersr_5 ( ksw_din_kersr_5 )	//----declare ker_top SRAM_5---------
	,.cen_kersr_6 ( ksw_cen_kersr_6 ),.wen_kersr_6 ( ksw_wen_kersr_6 ),.addr_kersr_6 ( ksw_addr_kersr_6 ),.din_kersr_6 ( ksw_din_kersr_6 )	//----declare ker_top SRAM_6---------
	,.cen_kersr_7 ( ksw_cen_kersr_7 ),.wen_kersr_7 ( ksw_wen_kersr_7 ),.addr_kersr_7 ( ksw_addr_kersr_7 ),.din_kersr_7 ( ksw_din_kersr_7 )	//----declare ker_top SRAM_7---------
	//----ker_top sram write instance port  end------ 

	,.ker_write_data_din		(	ker_write_data_din	)		
	,.ker_write_empty_n_din	(	ker_write_empty_n_din	)	
	,.ker_write_read_dout	(	ker_write_read_dout	)		

	,.ker_write_done 		(	ker_write_done	)
	,.ker_write_busy 		(	ker_write_busy	)
	,.ker_write_en 			(	ker_write_en	)
	,.start_ker_write		(	start_ker_write	)
	,.cfg_kerw_buflength	(	rcfg_kerw_buflength	)

);

//-------------------------------------------------------------------
//----------------		kernel sram read module		-------------
//-------------------------------------------------------------------
kersram_r  #(    .ADDR_CNT_BITS(	KER_ADDR_CNT_BITS 	)     
	,	.BUF_TAG_BITS	(	BUF_TAG_BITS	)
	,	.STARTER_BITS	(	STARTER_BITS	)
	,	.PADLEN_BITS	(	PADLEN_BITS	)
    )ker_read0(
	.clk	(	clk		)
	,.reset	(	reset	)

	//----generate by ker_r_io.py 
	//----ker_top sram read instance port start------ 
	,.cen_kersr_0 ( ksr_cen_kersr_0 ),.addr_kersr_0 ( ksr_addr_kersr_0 ),.valid_0 ( ksr_valid_0 ),.final_0 ( ksr_final_0 )	//----declare ker_top SRAM_0---------
	,.cen_kersr_1 ( ksr_cen_kersr_1 ),.addr_kersr_1 ( ksr_addr_kersr_1 ),.valid_1 ( ksr_valid_1 ),.final_1 ( ksr_final_1 )	//----declare ker_top SRAM_1---------
	,.cen_kersr_2 ( ksr_cen_kersr_2 ),.addr_kersr_2 ( ksr_addr_kersr_2 ),.valid_2 ( ksr_valid_2 ),.final_2 ( ksr_final_2 )	//----declare ker_top SRAM_2---------
	,.cen_kersr_3 ( ksr_cen_kersr_3 ),.addr_kersr_3 ( ksr_addr_kersr_3 ),.valid_3 ( ksr_valid_3 ),.final_3 ( ksr_final_3 )	//----declare ker_top SRAM_3---------
	,.cen_kersr_4 ( ksr_cen_kersr_4 ),.addr_kersr_4 ( ksr_addr_kersr_4 ),.valid_4 ( ksr_valid_4 ),.final_4 ( ksr_final_4 )	//----declare ker_top SRAM_4---------
	,.cen_kersr_5 ( ksr_cen_kersr_5 ),.addr_kersr_5 ( ksr_addr_kersr_5 ),.valid_5 ( ksr_valid_5 ),.final_5 ( ksr_final_5 )	//----declare ker_top SRAM_5---------
	,.cen_kersr_6 ( ksr_cen_kersr_6 ),.addr_kersr_6 ( ksr_addr_kersr_6 ),.valid_6 ( ksr_valid_6 ),.final_6 ( ksr_final_6 )	//----declare ker_top SRAM_6---------
	,.cen_kersr_7 ( ksr_cen_kersr_7 ),.addr_kersr_7 ( ksr_addr_kersr_7 ),.valid_7 ( ksr_valid_7 ),.final_7 ( ksr_final_7 )	//----declare ker_top SRAM_7---------
	//----ker_top sram read instance port  end------ 


	,.output_of_cnt_ker 			(	output_of_cnt_ker 			)
	,.output_of_enable_ker_cnt 	(	output_of_enable_ker_cnt 		)

	,.ker_read_done 		(	ker_read_done	)
	,.ker_read_busy 		(	ker_read_busy	)
	,.start_ker_read		(	start_ker_read	)


	,	.cfg_kernum_sub1		(	rcfg_kernum_sub1		)
	,	.cfg_colout_sub1		(	rcfg_colout_sub1		)
	,	.cfg_normal_length		(	rcfg_normal_length		)
	,	.cfgin_top_starter		(	rcfgin_top_starter		)
	,	.cfgin_toppad_length	(	rcfgin_toppad_length	)	
	,	.cfgin_botpad_length	(	rcfgin_botpad_length	)
	,	.cfg_atlchin				(	rcfg_atlchin				)

	,	.if_r_state	(	if_r_state	)	
);


//----    kernel read cfg    -----


always @(posedge clk ) begin
	if ( reset	)begin
		rcfg_kernum_sub1		<= 7	;	// 8-1	 8 kernels data each ker sram 
		rcfg_colout_sub1		<= 63	;	//64-1	conv columns each row blk
		rcfg_normal_length		<= 10'd36	;	// 3x3 once ker address , 5x5 = 5*5*32ch/8

	end
	else begin
		rcfg_kernum_sub1	<=		cfg_kernum_sub1		;
		rcfg_colout_sub1	<=		cfg_colout_sub1		;
		rcfg_normal_length	<=		cfg_normal_length	;	// 3x3 once ker address

	end
end

always @( posedge clk ) begin
	if( reset )begin
		rcfgin_top_starter		<= 	{8'd12 , 8'd30 , 8'd30 , 8'd30 , 8'd30 };
		rcfgin_toppad_length	<= 	{8'd24 , 8'd30 , 8'd30 , 8'd30 , 8'd30 };
		rcfgin_botpad_length	<= 	{8'd24 , 8'd30 , 8'd30 , 8'd30 , 8'd30 };
		rcfg_atlchin			<= 5'd0	;	
	end
	else begin
		//3x3 setting
		// rcfgin_top_starter		<= 	{8'd12 , 32'd0	};
		// rcfgin_toppad_length		<= 	{8'd24 , 32'd0	};
		// rcfgin_botpad_length		<= 	{8'd24 , 32'd0	};
		
		//5x5 setting
		// rcfgin_top_starter	<= 	{8'd40 , 8'd20 , 8'd0 , 8'd0 , 8'd0 };
		// rcfgin_toppad_length	<= 	{8'd60 , 8'd80 , 8'd0 , 8'd0 , 8'd0 };
		// rcfgin_botpad_length	<= 	{8'd40 , 8'd80 , 8'd0 , 8'd0 , 8'd0 };

		rcfgin_top_starter		<= 	cfgin_top_starter	;
		rcfgin_toppad_length	<= 	cfgin_toppad_length	;
		rcfgin_botpad_length	<= 	cfgin_botpad_length	;
		rcfg_atlchin			<= 	cfg_atlchin			;
	end
end

//----    kernel write cfg    -----

always @(posedge clk ) begin
	if ( reset	)begin
		rcfg_kerw_buflength		<= 10'd287	;	//config for every kernel write buffer data length. If ker=64, ch_in=32 ,the 64ker*32ch_in*(3x3)/8buf /8 -1= 288-1= 287
	end
	else begin
		rcfg_kerw_buflength		<= cfg_kerw_buflength	;
	end
end
 

endmodule



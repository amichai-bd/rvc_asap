module top(
        input  logic        CLK_50,
        input  logic [9:0]  SW,
        input  logic [1:0]  BUTTON,

        output logic [7:0]  HEX0,
        output logic [7:0]  HEX1,
        output logic [7:0]  HEX2,
        output logic [7:0]  HEX3,
        output logic [7:0]  HEX4,
        output logic [7:0]  HEX5,
        output logic [9:0]  LED,

        output logic [3:0]  RED,
        output logic [3:0]  GREEN,
        output logic [3:0]  BLUE,
        output logic        h_sync,
        output logic        v_sync
    );
	 

	 logic og_h_sync;
	 logic og_v_sync;
	 logic ref_h_sync;
	 logic ref_v_sync;
	 logic Rst;
	 assign Rst = ~BUTTON[0];
// Instantiating the rvc_top_5pl module
rvc_top_5pl rvc_top_5pl (
    .Clock    (CLK_50),
    .Rst      (Rst),
    .Button_0 (BUTTON[0]), // CR_MEM
    .Button_1 (BUTTON[1]), // CR_MEM
    .Switch   (SW),   // CR_MEM
    .SEG7_0   (),//HEX0),   // CR_MEM
    .SEG7_1   (HEX1),   // CR_MEM
    .SEG7_2   (HEX2),   // CR_MEM
    .SEG7_3   (HEX3),   // CR_MEM
    .SEG7_4   (HEX4),   // CR_MEM
    .SEG7_5   (HEX5),   // CR_MEM
    .LED      (LED),      // CR_MEM
    .RED      (),//RED),
    .GREEN    (),//GREEN),
    .BLUE     (),//BLUE),
    .h_sync   (og_h_sync),
    .v_sync   (og_v_sync)
);

assign HEX0 = 8'b01010101;
assign h_sync = og_h_sync;//SW[0] ? ref_h_sync : og_h_sync;
assign v_sync = og_v_sync//SW[0] ? ref_v_sync : og_v_sync;

logic CLK_25;
pll_2 pll_2 (
    .inclk0 (CLK_50),    // input
    .c0     (CLK_25)     // output
); 
sync_gen sync_gen(
.CLK_25(CLK_25),
.Reset(~BUTTON[0]),
.vga_h_sync(ref_h_sync),
.vga_v_sync(ref_v_sync),
.inDisplayArea(),
.CounterX(),
.CounterY()
);




assign RED   = SW[0] ? 4'b0 : 4'b1111;
assign GREEN = SW[1] ? 4'b0 : 4'b1111;
assign BLUE  = SW[2] ? 4'b0 : 4'b1111;

endmodule

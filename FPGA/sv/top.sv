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
	 
logic [3:0] NextRed;
logic [3:0] NextGreen;
logic [3:0] NextBlue;
logic Rst;
logic Button_0;
logic Button_1;
assign Rst = (~BUTTON[0] && SW[9]);
assign Button_0 = ~BUTTON[0];
assign Button_1 = ~BUTTON[1];
// Instantiating the rvc_top_5pl module
rvc_top_5pl rvc_top_5pl (
    .Clock    (CLK_50),
    .Rst      (Rst),
    .Button_0 (Button_0), // CR_MEM
    .Button_1 (Button_1), // CR_MEM
    .Switch   (SW),        // CR_MEM
    .SEG7_0   (HEX0),      // CR_MEM
    .SEG7_1   (HEX1),      // CR_MEM
    .SEG7_2   (HEX2),      // CR_MEM
    .SEG7_3   (HEX3),      // CR_MEM
    .SEG7_4   (HEX4),      // CR_MEM
    .SEG7_5   (HEX5),      // CR_MEM
    .LED      (LED),       // CR_MEM
    .RED      (RED),
    .GREEN    (GREEN),
    .BLUE     (BLUE),
    .h_sync   (h_sync),
    .v_sync   (v_sync)
);

endmodule

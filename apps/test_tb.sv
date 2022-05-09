module test_tb ();
logic in_0;
logic in_1;
logic  out;
initial begin : assign_input
    in_0 = 1'b0;
    in_1 = 1'b0; // 0&0
 #4 $display("out = in_0 & in_1:\n    > %b = %b & %b",out ,in_0, in_1);
 #4 in_1 = 1'b1; // 0&1
    $display("out = in_0 & in_1:\n    > %b = %b & %b",out ,in_0, in_1);
 #4 in_0 = 1'b1; // 1&1
    $display("out = in_0 & in_1:\n    > %b = %b & %b",out ,in_0, in_1);
 #1000 $finish;
end// initial
test test_and (
    .in_0(in_0),
    .in_1(in_1),
    .out(out)
);
endmodule // test_tb
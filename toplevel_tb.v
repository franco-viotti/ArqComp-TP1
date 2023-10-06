`timescale 1ns/100ps
`define NB_OP       6
`define NB_BTN      3
`define NB_AB       4


module toplevel_tb();

parameter NB_OP     = `NB_OP;
parameter NB_BTN    = `NB_BTN;
parameter NB_AB     = `NB_AB;

reg                     clock;
reg                     reset;

always #5 clock = ~clock;

reg  [NB_OP-1:0]        i_sw;
reg  [NB_BTN-1:0]       i_btn;

wire [NB_AB - 1: 0]     o_led;

initial
begin
    clock           = 1'b0;
    i_sw            <=  {NB_OP{1'b0}};
    i_btn           <=  {NB_BTN{1'b0}};
    #10 @(posedge clock) reset    = 1'b1;
    #15 reset       =   1'b0;
    #100 i_sw       =   6'b000001;
    #100 i_btn      =   3'b001;
    #100 i_btn      =   3'b000;
    #100 i_sw       =   6'b000001;
    #100 i_btn      =   3'b010;
    #100 i_btn      =   3'b000;
    #100 i_sw       =   6'b100000;
    #100 i_btn      =   3'b100;
    #100 i_btn      =   3'b000;
    #10000 $finish;
end

toplevel
#(
    .NB_BTN(3),
    .NB_OP(6),
    .NP_AB(4)
)
    u_toplevel
    (
        .i_sw   (i_sw),
        .i_btn  (i_btn),
        .clock  (clock),
        .o_led  (o_led),
        .i_reset (reset)
    );

endmodule

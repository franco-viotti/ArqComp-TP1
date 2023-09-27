`timescale 1ns / 1ps
`define NB_OP      6
`define NB_BTN     3
`define NB_AB      4


module random_tb();

parameter NB_OP     =   `NB_OP;
parameter NB_BTN    =   `NB_BTN;
parameter NB_AB    =   `NB_AB;


reg                         clock;
reg                         reset;
reg  [NB_OP -  1 : 0]       i_sw;
reg  [NB_BTN - 1 : 0]       i_btn;
reg  [NB_AB -  1 : 0]       A_tmp;
reg  [NB_AB -  1 : 0]       B_tmp;


wire [NB_AB - 1: 0]    o_led;


always #5 clock = ~clock;


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
    

task automatic load_random();
begin
    i_sw    =   $random % (2 ** NB_AB);
    i_btn   =   3'b001;
    A_tmp   =   i_sw;
    #10;
    i_btn   =   3'b000;
    #10;
    i_sw    =   $random % (2 ** NB_AB);
    i_btn   =   3'b010;
    B_tmp   =   i_sw;
    #10
    i_btn   =   3'b000;
    #10;
end
endtask

initial
begin
    clock                       =   1'b0;
    reset                       =   1'b0;
    i_btn                       =   3'b000;
    #10 @(posedge clock) reset  =   1'b1;
    #10 @(posedge clock) reset  =   1'b0;
    #10;
    repeat (20) begin
        load_random();
        $display("Operandos A: %b, B: %b", A_tmp, B_tmp);
        // SUMA
        i_sw    =   6'b100000;
        #1;
        i_btn   =   3'b100;
        if ((A_tmp + B_tmp) == o_led) begin
            $display("Suma correcta, resultado: %b", o_led);
        end else begin
            $display("Suma incorrecta, resultado: esperado %b, resultado obtenido", (A_tmp+B_tmp), o_led);
        end
        #10;
        i_btn   =   3'b000;
    end
    #10; 
    $finish; 
end


endmodule

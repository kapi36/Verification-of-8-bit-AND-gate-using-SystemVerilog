// Design code :
module top (
  input [7:0] a ,
  input [7:0] b, 
  input [7:0] y
); 
  
  assign y = a&b ;  
endmodule 


//Testbench code : 

class transaction;
  randc bit [7:0] a;
  randc bit [7:0] b;
  bit [7:0] y;
 
endclass

class generator ;
 transaction t ; 
 mailbox mbx; 
 event done ; 
 integer i; 
 
  function new(mailbox mbx) ; 
    this.mbx = mbx;
  endfunction 
  
  task run(); 
    t= new(); 
    for(i= 0 ; i<25; i++)begin 
      t.randomize(); 
      mbx.put(t);
      $display("[GEN]: DATA is send to driver"); 
      @(done); // sensing the event 
      #10; 
    end
  endtask 
endclass

class driver ; 
  transaction t ; 
  mailbox mbx; 
  event done ; 
  virtual top_intf vif; 
 
  function new(mailbox mbx) ; 
    this.mbx = mbx; 
  endfunction 
  
  task run () ;
    t = new() ; 
    forever begin 
      vif.a = t.a; 
      vif.b = t.b ; 
      mbx.get(t) ; 
      ->done  ;
      $display("[DRV}: DATA is Triggered") ;
      #10; 
    end
  endtask 
endclass 
               
interface top_intf();
  logic [7:0] a;
  logic [7:0] b;
  logic [7:0] y;
endinterface
 
class monitor;
  transaction t;
  mailbox mbx; 
  
  virtual top_intf vif;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin 
    t.a = vif.a;
    t.b = vif.b;
    t.y = vif.y;
    mbx.put(t);
      $display("[MON] : data send to Scoreboard"); 
    #10;
    end
  endtask
endclass
 
 
class scoreboard;
  transaction t;
  mailbox mbx;
  bit [7:0] temp;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      mbx.get(t);
      temp = t.a & t.b;
      if(t.y == temp)
        begin
          $display("[SCO] : Test Passed");
          $display("[SCO] : a : %b and b : %b gives temp : %b and y : %b ",t.a, t.b, temp, t.y);
        end
      else
        begin
          $display("[SCO] : Test Failed");
        end
      #10;
    end
  endtask
  
endclass

class environment ; 
  generator g; 
  driver d ;
  monitor m ; 
  scoreboard s; 
  event gddone ; 
  event msdone ; 
  
  mailbox gdmbx; 
  mailbox msmbx; 
  virtual top_intf vif;
  
  function new( mailbox gdmbx, mailbox msmbx);  
    this.gdmbx = gdmbx ; 
    this.msmbx  = msmbx; 
    g = new(gdmbx) ; 
    d = new(gdmbx) ;
    m = new(msmbx) ; 
    s = new(msmbx) ; 
  endfunction 
  
  task run () ; 
    g.done = gddone ; 
    d.done = gddone ; 
    
    d.vif = vif; 
    m.vif = vif;
    
    fork 
      g.run(); 
      d.run() ; 
      m.run () ; 
      s.run() ;
    join_any 
  endtask 
endclass
               
module tb(); 
  environment e; 
  mailbox gdmbx; 
  mailbox msmbx; 
  
  top_intf vif(); 
  top dut (vif.a ,vif.b ,vif.y) ; 
  
  initial begin 
    gdmbx = new() ; 
    msmbx = new() ; 
    e = new(gdmbx, msmbx) ; 
    e.vif = vif; 
    e.run() ; 
    
    #200; 
    $finish(); 
  end
 
  initial begin
    $dumpvars; 
    $dumpfile ("dump.vcd"); 
  end
  
endmodule 

  

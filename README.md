# Verification-of-8-bit-AND-gate-using-SystemVerilog
In this project i am doing verification of 8 bit and gate using systemverilog. The project is very basic and at this moment i am learning System verilog so this project is my first project in System verilog. i added 1 file of the code where i have writtern design and testbench code . Everyone knows the design code of and gate main is the testbench code which i have written in verilog. so there are different different classes i have used there working are here : 

A. Transaction class :  
            1. Decalre all input and output with equivalent sizes . 
			      2. Add modifier like rand and randc to all inputs 
			      3. Do not add modifier to output ports . 
B. Generator Class :
				1)  Generate random stimuli . 
				2) Send data to driver with mailbox 
				3) Signify to driver about completion of stimuli generation using event .
C. Interface :  
				1) Declare all the input and output using logic data type. 
D. Driver : 
				1) Recieve data from mailbox. 
				2) Send the data to interface. 
E. Class monitor : 
				1) Receive data from interface. 
				2) Send data to scoreboard using mailbox. 
F. Class Scoreboard: 
				1) Recieve data form monitor . 
				2) Compare with golden refernace data. 
G.  Class Environment :
				1)  Initialize all the class. 
				2) Connect respective mailbox. 
				3) Connect respective event . 
				4) Connect respective interface. 
				5) Schedule execution of different process. 
H. Testbench top : 
				1) Instance of environment 
				2) New method to mailbox. 
				3) Connect interface . 
				4) Perform connection between interface and dut. 
    
 Basicaly this is the summary of any testbench we are writting in system verilog means 

![image](https://github.com/kapi36/Verification-of-8-bit-AND-gate-using-SystemVerilog/assets/110424577/0c95fbc7-5041-485c-b4d8-015598303ec5)

   


Results: 
![image](https://github.com/kapi36/Verification-of-8-bit-AND-gate-using-SystemVerilog/assets/110424577/1efe968e-f9c9-41e3-bcae-6ffca039a602)


Waveform Result : 
![image](https://github.com/kapi36/Verification-of-8-bit-AND-gate-using-SystemVerilog/assets/110424577/c9db312b-fc1b-40a0-b505-48f557f909ea)




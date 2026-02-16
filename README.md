# Accelerator
Accelerate using approximate hardware
Our main objective is to perform image processing fastly using strided convolution as part of the algorithm. The architecture is divided into RTL modules, each with a specific function. The main module coordinates communication among the modules and also performs key tasks such as slicing incoming data and parallelizing operations.
Change Parameters str_Y & str_X in main and data access file accordingly along with certain modifications.
  Stride                 Memory
Directions (x,y)   Bits (Width)  Locations (Depth) 
1,1                8                    1
2,1                16                   1
1,2                8                    32 = 4096/128 
2,2                16                   32

                                    Main Module
        ________________________________|________________________________
        |                   |                                  |         |
 Input Data Storage     Convolution(Data Access + MAC)      Magnitude    Threshold Comparison

 
<img width="750" height="614" alt="Main_Module" src="https://github.com/user-attachments/assets/5fc82d76-003a-4543-8a5c-37423e6c096b" />

For Input Data: BRAM is initialized with image .coe file. Its size is 4096x512 bits with 128 as the read width. For initialization, certain steps are taken to convert image into coe file based on the desired configuration.

Data Access module: Then how to access and provide data is governed by Data Access module which efficiently reads memory even before the data to be required for processing by further modules. So as to provide data the same clk cycle when its required by the very next module in the sequence. 

MAC: The convolution operation is performed in this module. Two Clock cycles are needed to perform convolution. Signed operations are performed since not using registers  everytime or when working on the bit slices of an array. 

Magnitude: Because of the x and y directions, approximate magnitude is computed instead of exact by adding the magnitudes of each omitting -ve sign if any.

Threshold Comparison: Then the magnitude is compared with the threshold as set by trials before final implementation. 

 

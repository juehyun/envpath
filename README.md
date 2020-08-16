# envpath.bat

a .bat script to manipulate %PATH% environment variable on command-line terminal (for windows system)

## Screen Shot

![envpath_snapshot](https://user-images.githubusercontent.com/5809623/90326274-6a1a1d80-dfc1-11ea-89fc-95f15faa4a7d.png)

## Screen Shot

Initialize internal variables

Retrieve PATH environment variable ...
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::             
:::::::::: Search Path ( user PATH environment variable ) ::::::::::             
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::             
[Org] [0] [SYS] C:\Program Files (x86)\Common Files\Oracle\Java\javapath         
[Org] [1] [SYS] C:\WINDOWS\system32                                              
[Org] [2] [SYS] C:\WINDOWS                                                       
[Org] [3] [SYS] C:\WINDOWS\System32\Wbem                                         
[Org] [4] [SYS] C:\WINDOWS\System32\WindowsPowerShell\v1.0\                      
[Org] [5] [SYS] C:\WINDOWS\System32\OpenSSH\                                     
[Org] [6] [SYS] C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common           
[Org] [7] [SYS] C:\Program Files\ImageMagick-7.0.9-Q16                           
[Org] [8] [SYS] C:\Program Files\nodejs\                                         
[Org] [9] [SYS] C:\Users\juehy\AppData\Roaming\npm                               
[Org] [10] [SYS] C:\MinGW\msys\1.0\bin                                           
[Org] [11] [SYS] C:\MinGW\bin                                                    
[Del] [12] [SYS] C:\LLVM\bin                                                     
[Add] [13] [SYS] c:\Users                                                        
[Org] [14] [SYS] C:\ProgramData\chocolatey\bin                                   
[Org] [15] [SYS] C:\Python38\                                                    
[Org] [16] [SYS] C:\Python38\Scripts\                                            
[Org] [17] [SYS] C:\Program Files\JetBrains\PyCharm 2019.3.3\bin                 
[Org] [18] [SYS] C:\Users\juehy\AppData\Local\hyper\app-3.0.2\resources\bin      
[Org] [19] [SYS] C:\VSCode\bin                                                   
[Org] [20] [usr] c:\Pgm\Git\cmd                                                  
[Org] [21] [usr] C:\Pgm                                                          
[Org] [22] [usr] C:\Pgm\Vim                                                      
[Org] [23] [usr] C:\Pgm\Lib.bat                                                  
total 24 items
:::::::::: Enter Command ::::::::::
:: (a)dd number path : insert path at specified pos
:: (d)el number      : remove the path from specified pos
:: (s)ave            : update the user-level "PATH" environment variable
:: enter             : quit
>

## Usage

    (a)dd  13 C:\Users  [ENTER] : check the path "C:\Users" is valid, insert the path at [13], previous [13-22] will be moved to [14-23]
    (d)el  12           [ENTER] : remove element at [13]
    (s)ave              [ENTER] : save the change ( actual write to windows system registery )
    [ENTER]                     : quit

    after quit, run "refreshenv" command to update changes to current session right now

## Misc.
    SYS : system PATH environment variable
    usr : user's PATH environment variable

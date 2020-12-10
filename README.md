# envpath.bat

a .bat script to manipulate %PATH% environment variable on command-line terminal (for windows system)

## Screen Shot

![envpath_snapshot](https://user-images.githubusercontent.com/5809623/90326274-6a1a1d80-dfc1-11ea-89fc-95f15faa4a7d.png)

## Glossary
    [SYS] : system PATH environment variable
    [usr] : user's PATH environment variable
    [Org] : originally from current windows registry (already updated to registry and env.variable)
    [Add] : changes you add, it will be added to registry when you "save"
    [Del] : changes you remove, it will be removed when you "save"

## Usage

enter command as like following ...

    (a)dd  13 C:\Users  [ENTER] : check the path "C:\Users" is valid, insert the path at [13], previous [13-22] will be moved to [14-23]
    (d)el  12           [ENTER] : remove element at [13]
    (s)ave              [ENTER] : save the change ( actual write to windows system registry )
    [ENTER]                     : quit

after modification, you shold "save" it ! otherwise the changes are discarded

as you know, changed PATH env.variable on windows register are effective from next session

if you want to apply changes to current cmd.exe session right now, after quit, run "refreshenv" command 

## License

MIT, Joohyun Lee ( juehyun@etri.re.kr )


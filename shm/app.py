import sys
from library.input import Input 
from library.input import InputFileType 

def main():
    File = Input(sys.argv[1])
    
    if(File.Type == InputFileType.TxtType):
        print("txt...")
    elif(File.Type == InputFileType.MorseType):
        print("morse...")
    elif(File.Type == InputFileType.AudioType):
        print("audio...")

main()

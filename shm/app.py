from library import translator 
from library import input 
from library import file 
import sys
import wave
import subprocess

def main():
    FileName = sys.argv[1]
    FileType = input.getFileType(FileName)
    
    if(FileType == input.Type.TEXT):
        Text = file.readTextFile(FileName) 
        Text = Text[0:len(Text)-1]
        MorseCode = translator.text2morse(Text)
        Wav = translator.morse2audio(MorseCode)
        file.writeMorseFile("code.morse", MorseCode)
        file.writeAudioFile("audio.wav", Wav)
    elif(FileType == input.Type.WAV):
        print("error")
        #audio2text()
        #audio2morse()
    elif(FileType == input.Type.MORSE):
        Text = file.readTextFile(FileName) 
        print(Text)
        #morse2text()
        #morse2audio()
    else:
        print("error")

main()

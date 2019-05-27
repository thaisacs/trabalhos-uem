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
        Audio = file.openAudioFile("audio.wav")
        MorseCode = translator.audio2morse(Audio)
        Text = translator.morse2text(MorseCode)
        file.writeMorseFile("code.morse", MorseCode)
        file.writeTextFile("text.txt", Text)
    elif(FileType == input.Type.MORSE):
        MorseCode = file.readTextFile(FileName) 
        Text = translator.morse2text(MorseCode)
        Wav = translator.morse2audio(MorseCode)
        file.writeAudioFile("audio.wav", Wav)
        file.writeTextFile("text.txt", Text)
    else:
        print("error")

main()

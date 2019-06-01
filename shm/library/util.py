from library import input 
import sys

def default_name(file_type):
    if(file_type == input.Type.TEXT):
        return "text.txt"
    elif(file_type == input.Type.WAV):
        return "audio.wav"
    elif(file_type == input.Type.MORSE):
        return "code.morse"

def usage():
    print("python3 app.py <file name>")
    print("")
    print("ARGUMENTS:")
    print("  <file name>: *.txt, *.morse or *.wav")
    sys.exit(0)

from library import translator 
from library import input 
from library import file 
from library import util 
from library import config 
import sys
import wave
import subprocess

def main():
    
    if(len(sys.argv) >= 2):
        file_name = sys.argv[1]
    else:
        util.usage()

    file_type = input.get_file_type(file_name)
    
    if(file_type == input.Type.TEXT):
        input_text = file.read_input_file(file_name) 
        morse_code = translator.text2morse(input_text)
        wave = translator.morse2audio(morse_code)
        file.write_output_file(util.default_name(input.Type.MORSE), morse_code)
        file.write_audio_file(util.default_name(input.Type.WAV), wave)
    elif(file_type == input.Type.WAV):
        wave = file.read_audio_file(file_name)
        morse_code = translator.audio2morse(wave)
        text = translator.morse2text(morse_code)
        file.write_output_file(util.default_name(input.Type.MORSE), morse_code)
        file.write_output_file(util.default_name(input.Type.TEXT), text)
    elif(file_type == input.Type.MORSE):
        morse_code = file.read_input_file(file_name) 
        text = translator.morse2text(morse_code)
        wave = translator.morse2audio(morse_code)
        file.write_audio_file(util.default_name(input.Type.WAV), wave)
        file.write_output_file(util.default_name(input.Type.TEXT), text)
    else:
        util.usage()

if __name__ == "__main__":
    main()

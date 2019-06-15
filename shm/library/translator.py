from library import audio
from library import config 
import sys
import matplotlib.pyplot as plt

morse_dict = {'A': '10111', 'B': '111010101', 'C': '11101011101', 
             'D': '1110101', 'E': '1', 'F': '101011101', 'G': '111011101', 
             'H': '1010101', 'I': '101', 'J': '1011101110111', 
             'K': '111010111', 'L': '101110101', 'M': '1110111', 
             'N': '11101', 'O': '11101110111', 'P': '10111011101', 
             'Q': '1110111010111', 'R': '1011101', 'S': '10101', 'T': '111', 
             'U': '1010111', 'V': '101010111', 'W': '101110111', 
             'X': '11101010111', 'Y': '1110101110111', 'Z': '11101110101', 
             '1': '10111011101110111', '2': '101011101110111', 
             '3': '1010101110111', '4': '10101010111', '5': '101010101', 
             '6': '11101010101', '7': '1110111010101', '8': '111011101110101', 
             '9': '11101110111011101', '0': '1110111011101110111', ' ': '0000000'}

def text2morse(text):
    morse_code = ""
    
    for i in range(0, len(text)):
        if(text[i] != '\n'):
            morse_code += morse_dict[text[i].upper()]
            if(text[i] != ' ' and i < len(text) - 2):
                if(text[i+1] != ' '):
                    morse_code += "000"
    
    return morse_code

def morse2text(morse_code):
    morse_code = morse_code.split("0000000")

    for i in range(0, len(morse_code)):
        morse_code[i] = morse_code[i].split("000")

    text = ""

    for w in morse_code:
        for l in w:
            text += list(morse_dict.keys())[list(morse_dict.values()).index(l)]
        text += " "
    
    return text[0:len(text)-1]

def morse2audio(morse_code):
    wave = []
   
    morse_code = morse_code.split("0000000")

    for i in range(0, len(morse_code)):
        morse_code[i] = morse_code[i].split("000")
    
    for i in range(0, len(morse_code)):
        for j in range(0, len(morse_code[i])):
            morse_code[i][j] = morse_code[i][j].split("0")
    
    for i in range(0, len(morse_code)):
        for j in range(0, len(morse_code[i])):
            for k in range(0, len(morse_code[i][j])):
                if(len(morse_code[i][j][k]) == 1):
                    wave += audio.generate_wave(config.frequency, config.dot_dur)
                else:
                    wave += audio.generate_wave(config.frequency, config.dash_dur)
                if(i < len(morse_code)-1):
                    wave += audio.generate_wave(0, config.dot_dur)
                elif(j < len(morse_code[i])-1):
                    wave += audio.generate_wave(0, config.dot_dur)
                else:
                    if(k < len(morse_code[i][j])-1):
                        wave += audio.generate_wave(0, config.dot_dur)
            if(j < len(morse_code[i])-1):
                wave += audio.generate_wave(0, config.dot_dur*2)
        if(i < len(morse_code)-1):
            wave += audio.generate_wave(0, config.dot_dur*6)
    
    return wave 

def audio2morse(wave):
    morse_code = ""
    result = ""
    i = 1
    size = 0
   
    while i < len(wave):
        if(wave[i] != 0):
            result += '1'
            while(i < len(wave) and wave[i] != 0):
                result += '1'
                i += 1
        else:
            result += '0'
        i += 1
   
    for i in range(0, len(result)):
        if(result[i] == '0'):
            size += 1
            if(i < len(result) - 1 and result[i+1] != result[i]):
                if(size == 12000):
                    morse_code += "0"
                elif(size == 36000):
                    morse_code += "000"
                else:
                    morse_code += "0000000"
                size = 0
        else:
            size += 1
            if(i < len(result)-1 and result[i+1] != result[i]):
                if(size == 12000):
                    morse_code += "1"
                else:
                    morse_code += "111"
                size = 0
            elif(i == len(result)-1):
                if(size == 12000):
                    morse_code += "1"
                else:
                    morse_code += "111"
                
    return morse_code

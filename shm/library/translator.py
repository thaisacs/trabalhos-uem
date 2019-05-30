from library import audio
from library import config 

import matplotlib.pyplot as plt

#fator de correção de tempo
correction = 1
 
#duracao do som de ponto
dot_dur = 0.25 * correction
dash_dur = dot_dur * 3

MorseDict = {'A': '10111', 'B': '111010101', 'C': '11101011101', 
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

TextDict = {'10111': 'A', '111010101': 'B', '11101011101': 'C', 
            '1110101': 'D', '1': 'E', '101011101': 'F', '111011101': 'G', 
            '1010101': 'H', '101': 'I', '1011101110111': 'J', 
            '111010111': 'K', '101110101': 'L', '1110111': 'M', 
            '11101': 'N', '11101110111': 'O', '10111011101': 'P', 
            '1110111010111': 'Q', '1011101': 'R', '10101': 'S', '111': 'T', 
            '1010111': 'U', '101010111': 'V', '101110111': 'W', 
            '11101010111': 'X', '1110101110111': 'Y', '11101110101': 'Z', 
            '10111011101110111': '1', '101011101110111': '2', 
            '1010101110111': '3', '10101010111': '4', '101010101': '5', 
            '11101010101': '6', '1110111010101': '7', '111011101110101': '8', 
            '11101110111011101': '9', '1110111011101110111': '0'}

def text2morse(Text):
    MorseCode = ""

    for Index in range(0, len(Text)):
        MorseCode += MorseDict[Text[Index].upper()]
        if(Text[Index] != ' ' and Index < len(Text) - 1):
            if(Text[Index+1] != ' '):
                MorseCode += "000"

    return MorseCode

def morse2text(Code):
    Code = Code.split("0000000")

    for i in range(0, len(Code)):
        Code[i] = Code[i].split("000")

    Text = ""

    for w in Code:
        for l in w:
            Text += TextDict[l]
        Text += " "
    
    return Text

def morse2audio(Code):
    Wave = []
   
    Code = Code.split("0000000")

    for i in range(0, len(Code)):
        Code[i] = Code[i].split("000")
    
    for i in range(0, len(Code)):
        for j in range(0, len(Code[i])):
            Code[i][j] = Code[i][j].split("0")
    
    for i in range(0, len(Code)):
        for j in range(0, len(Code[i])):
            for k in Code[i][j]:
                if(len(k) == 1):
                    Wave += audio.generateWave(config.frequency, dot_dur)
                else:
                    Wave += audio.generateWave(config.frequency, dash_dur)
                Wave += audio.generateWave(0, dot_dur)
            Wave += audio.generateWave(0, dash_dur)
        Wave += audio.generateWave(0, 1.75)
    
    return Wave 

def audio2morse(Audio):
    Resul = ""
    MorseCode = ""
    i = 1
    Size = 0
    plt.plot(Audio)
    plt.show()
    
    while i < len(Audio):
        if(Audio[i] != 0):
            Resul += '1'
            while(Audio[i] != 0):
                i += 1
        else:
            Resul += str(Audio[i])
        i += 1
    
    for i in range(0, len(Resul)):
        if(Resul[i] == '0'):
            Size += 1
            if(i < len(Resul) - 1 and Resul[i+1] != Resul[i]):
                print(Size)
                if(Size == 1200):
                    MorseCode += "00"
                elif(Size == 48000):
                    MorseCode += "00"
                elif(Size == 132000):
                    MorseCode += "000000"
                Size = 0
        else:
            Size += 1
            if(i < len(Resul) - 1 and Resul[i+1] != Resul[i]):
                if(Size == 20):
                    MorseCode += "0"
                    MorseCode += "1"
                else:
                    MorseCode += "0"
                    MorseCode += "111"
                Size = 0
    
    return MorseCode
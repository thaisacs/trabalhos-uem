from library import audio

Code = {' ': '\ ', 'a': '0111 ', 'b': '111000 ', 'c': '11101110 ', 'd': '11100 ', 
        'e': '0 ', 'f': '001110 ', 'g': '1111110 ', 'h': '0000 ', 'i': '00 ', 
        'j': '0111111111 ', 'k': '1110111 ', 'l': '011100 ', 'm': '111111 ',
        'n': '1110 ', 'o': '111111111 ', 'p': '01111110 ', 'q': '1111110111 ', 
        'r': '01110 ', 's': '000 ', 't': '111 ', 'u': '00111 ', 'v': '000111 ', 
        'w': '0111111 ', 'x': '11100111 ', 'y': '1110111111 ', 'z': '11111100 ', 
        '1': '0111111111111 ', '2': '00111111111 ', '3': '000111111 ', '4': '0000111 ', 
        '5': '00000 ', '6': '1110000 ', '7': '111111000 ', '8': '11111111100 ', 
        '9': '1111111111110 ', '0': '111111111111111 '}

def text2morse(Text):
    MorseCode = ""

    for c in Text:
        MorseCode += Code[c.lower()]

    return MorseCode

def morse2text(Code):
    print("morse2text")

def morse2audio(Code):
    Wave = []
   
    CodeSplit = Code.split()
    for i in CodeSplit:
        for j in i:
            if(j == '1'):
                Unit = audio.generateWave(440)
            elif(j == '0'):
                Unit = audio.generateWave(840)
            else:
                Unit = audio.generateWave(1500)
            Wave += Unit
        Unit = audio.generateWave(0)
        Wave += Unit

    return Wave 

def audio2morse(Audio):
    print("audio2morse")

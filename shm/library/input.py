from enum import Enum

class Type(Enum):
    TEXT = 1
    MORSE = 2
    WAV = 3
    OTHER = 4

def get_file_type(file_name):
    if(file_name.find(".txt") != -1):
        return Type.TEXT
    elif(file_name.find(".morse") != -1):
        return Type.MORSE
    elif(file_name.find(".wav") != -1):
        return Type.WAV
    else:
        return Type.OTHER


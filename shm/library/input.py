from enum import Enum

class Type(Enum):
    TEXT = 1
    MORSE = 2
    WAV = 3
    OTHER = 4

def getFileType(FileName):
    if(FileName.find(".txt") != -1):
        return Type.TEXT
    elif(FileName.find(".morse") != -1):
        return Type.MORSE
    elif(FileName.find(".wav") != -1):
        return Type.WAV
    else:
        return Type.OTHER


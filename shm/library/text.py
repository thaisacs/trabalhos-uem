from enum import Enum

class InputFileType(Enum):
    NoneType = 0
    MorseType = 1
    TxtType = 2
    AudioType = 3

class Input:
    def __init__(This, FileName):
        This.Name = FileName
        if(FileName.find(".txt") != -1):
            This.Type = InputFileType.TxtType
        elif(FileName.find(".morse") != -1):
            This.Type = InputFileType.MorseType
        else:
            This.Type = InputFileType.AudioType


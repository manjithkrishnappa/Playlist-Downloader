import re

class Main:
    _propertiesFile='./FolderNames_Links.properties'
    # This dictionary will contain the folder name and the URL to the playlist
    _dicData = {}
    _initialized = False

    def __init__(self):
        print('Main Contructor called')
    
    def Initialize(self):
        if(self._readConfig() is False):
            return False

    def _readConfig(self):
        file1 = open(self._propertiesFile, 'r')
        Lines = file1.readlines()

        # Strips the newline character
        for line in Lines:
            line = line.strip()
            # if there is a blank line in the property file ignore it and go to the next line
            if(not line):
                continue
            _tokens = line.split('=',1)
            if(len(_tokens) != 2):
                print('ERROR: spliting the line entry {} produced incorrect number of tokens: {}'.format(line, len(_tokens)))
                # print (_tokens)
                return False
            # print('Folder Name: {} && URL: {}'.format(_tokens[0], _tokens[1]))
            self._dicData[_tokens[0]] = _tokens[1]
        return True


if __name__ == "__main__":
    main = Main()
    main.Initialize()
from library import translator

def test_text2morse():
    assert translator.text2morse("A") == "10111"

def test_morse2text():
    assert translator.morse2text("10111") == "A"

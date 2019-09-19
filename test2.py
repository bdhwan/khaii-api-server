# -*- coding: utf-8 -*- 

from khaiii import KhaiiiApi
api = KhaiiiApi()


result = []
for word in api.analyze("스벅 아메리카노 한잔 주세요"):
    aWord = dict()

    word_list = []
    for m in word.morphs:
        morph = dict()
        morph['lex'] = m.lex
        morph['tag'] = m.tag
        word_list.append(morph)
    aWord['list'] = word_list
    aWord['word'] = word.lex
    # attrs = vars(word)
    # for item in attrs.items():
    result.append(aWord)

print(result)


  
    

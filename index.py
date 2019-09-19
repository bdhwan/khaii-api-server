import tornado.ioloop
import tornado.web
import json
import time
import sys
import os
import json
import requests
from khaiii import KhaiiiApi
api = KhaiiiApi(rsc_dir='/workspace/khaiii/build/share/khaiii')

class MainHandler(tornado.web.RequestHandler):
        
    def get(self):
        self.write("Hello, world")
    
    def post(self):
        text = self.get_argument('text')
        result = []
        for word in api.analyze(text):
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
        response = dict()
        response['text'] = text
        response['result'] = result
        output = json.dumps(response)
        self.write(output)

def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(8080)
    tornado.ioloop.IOLoop.current().start()
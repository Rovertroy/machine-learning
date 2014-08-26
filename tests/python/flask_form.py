## flask_form.py
#  This file simply echos the post values from 'form.html'

#!/usr/bin/python

from flask import Flask, request
app = Flask(__name__)

# debug options
app.debug = True
app.config['TRAP_HTTP_EXCEPTIONS'] = True

# handles 'get', and 'post'
@app.route('/machine-learning/tests/python/flask_form.py', methods=['GET', 'POST'])
def parse_request():
  temp = request.form['svm_session']
  print temp
  return temp

if __name__ == '__main__':
    app.run()

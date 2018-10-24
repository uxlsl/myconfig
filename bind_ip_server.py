import subprocess
import os
from flask import Flask,request

app = Flask(__name__)


@app.route("/bind_ip")
def hello():
    sign = os.environ.get('sign')
    if sign != request.args.get('sign'):
        return 'fail'
    cmd = 'iptables -I INPUT -p tcp -s {}  --dport 8118 -j ACCEPT'.format(request.environ.get('HTTP_X_REAL_IP'))
    try:
        subprocess.check_call(cmd, shell=True)
        return "success"
    except Exception as e:
        return "fail"


if __name__ == '__main__':
    app.run()

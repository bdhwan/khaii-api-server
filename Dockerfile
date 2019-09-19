FROM pytorch/pytorch:1.0-cuda10.0-cudnn7-runtime 
MAINTAINER bdhwan@gmail.com


RUN apt-get update -y
RUN apt-get install -y language-pack-ko
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

ENV PYTHONIOENCODING=utf-8

RUN pip install tornado
RUN pip install requests

RUN apt-get install sudo 
RUN sudo apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN sudo npm install -g pm2
RUN sudo pm2 install pm2-logrotate
RUN pm2 set pm2-logrotate:max_size 100M






RUN git clone https://github.com/kakao/khaiii.git
WORKDIR /workspace/khaiii

RUN pip install cython
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# RUN rm -rf /workspace/khaiii/rsc/src/preanal.manual
# ADD preanal.manual /workspace/khaiii/rsc/src/preanal.manual

RUN mkdir build
WORKDIR /workspace/khaiii/build

RUN cmake ..
RUN make all
RUN make resource

RUN make package_python
WORKDIR /workspace/khaiii/build/package_python
RUN pip install .


ADD index.py /home/index.py
ADD check.sh /home/check.sh
ADD healthcheck.js /home/healthcheck.js
ADD process.yml /home/process.yml
WORKDIR /home

HEALTHCHECK --interval=30s CMD node healthcheck.js
EXPOSE 8080
ENTRYPOINT ["/bin/sh", "check.sh"]
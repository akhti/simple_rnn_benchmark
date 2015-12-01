FROM b.gcr.io/tensorflow/tensorflow-full-gpu

WORKDIR /tensorflow/
RUN apt-get update && apt-get -y install git
RUN git remote set-url github https://github.com/tensorflow/tensorflow.git \
    && git pull \
    && git checkout 7e1e25b16ba8d01edf6d53d442cac4f93deda2c1

ADD run.sh ./
ADD tmp/data/ /root/

CMD bash run.sh /tensorflow/ /root/ 0

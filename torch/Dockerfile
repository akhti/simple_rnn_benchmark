FROM kaixhin/cuda:7.0
RUN apt-get -y update
RUN apt-get -y install git curl


RUN curl -sk https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash -e

RUN git clone https://github.com/torch/distro.git ~/torch --recursive
RUN cd ~/torch && ./install.sh
RUN echo . /root/torch/install/bin/torch-activate >> ~/.profile

ENV LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.lua;/root/torch/install/share/luajit-2.1.0-alpha/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua' \
  LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so' \
  PATH=/root/torch/install/bin:$PATH \
  LD_LIBRARY_PATH=/root/torch/install/lib:$LD_LIBRARY_PATH \
  DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH



RUN curl -sk https://raw.githubusercontent.com/soumith/fblualib/master/install_all.sh | bash -e

RUN git clone https://github.com/torch/nn && ( cd nn && git checkout getParamsByDevice && luarocks make rocks/nn-scm-1.rockspec )

RUN git clone https://github.com/facebook/fbtorch.git && ( cd fbtorch && luarocks make rocks/fbtorch-scm-1.rockspec )

RUN git clone https://github.com/facebook/fbnn.git && ( cd fbnn && luarocks make rocks/fbnn-scm-1.rockspec )

RUN git clone https://github.com/facebook/fbcunn.git && ( cd fbcunn && luarocks make rocks/fbcunn-scm-1.rockspec )


WORKDIR /root/
ADD run.sh ./
ADD tmp/lstm/ ./lstm


CMD bash run.sh

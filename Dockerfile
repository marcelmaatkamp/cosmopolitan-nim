FROM marcelmaatkamp/cosmopolitan as cosmonim
RUN \
 apt-get update && \
 apt-get -y install \
  nim &&\
 rm -rf /var/lib/apt/lists/*
WORKDIR /

ENV COSMOPOLITAN=/cosmopolitan/
ENV COSMONIM=/cosmonim
RUN \
 git clone https://github.com/Yardanico/cosmonim ${COSMONIM} &&\ 
 cd ${COSMONIM} &&\
 cp \
  ${COSMOPOLITAN}/o/cosmopolitan.h \
  ${COSMOPOLITAN}/o/libc/crt/crt.o \
  ${COSMOPOLITAN}/o/ape/ape.o \
  ${COSMOPOLITAN}/o/ape/ape.lds \
  ${COSMOPOLITAN}/o/cosmopolitan.a \
  ${COSMONIM}/cosmopolitan/

WORKDIR ${COSMONIM}
RUN \  
 nim c -d:danger --opt:size -o:hello.elf hello.nim &&\
 objcopy -SO binary hello.elf ${COSMONIM}/hello.com &&\
 chmod +x hello.com
 
FROM scratch
COPY \
 --from=cosmonim \
 /cosmonim/hello.com \
 /hello.com
ENTRYPOINT ["/hello.com"]

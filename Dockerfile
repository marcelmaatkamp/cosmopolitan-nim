FROM marcelmaatkamp/cosmopolitan:1.0 as cosmonim
WORKDIR /

ENV COSMOPOLITAN=/cosmopolitan/
ENV COSMONIM=/cosmonim
RUN \
 git clone https://github.com/Yardanico/cosmonim &&\ 
 cd lua &&\
 cp \
  ${COSMOPOLITAN}/o/cosmopolitan.h \
  ${COSMOPOLITAN}/o/libc/crt/crt.o \
  ${COSMOPOLITAN}/o/ape/ape.o \
  ${COSMOPOLITAN}/o/ape/ape.lds \
  ${COSMOPOLITAN}/o/cosmopolitan.a \
  ${COSMONIM}/cosmopolitan/

RUN \  
 nim c -d:danger --opt:size -o:hello.elf hello.nim &&\
 objcopy -SO binary hello.elf hello.com &&\
 chmod +x hello.com
 
FROM scratch
COPY \
 --from=osmonim \
 ${COSMONIM}/hello.com \
 /
ENTRYPOINT ["hello.com"]

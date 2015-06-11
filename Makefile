ifneq (,$(findstring /cygdrive/,$(PATH)))
    OS := win
    #PLIBS := utils/bits777.c utils/system777.c utils/cJSON.c utils/NXT777.c utils/files777.c utils/bitcoind_RPC.c utils/bitcoind.c utils/utils777.c nonportable/$(OS)/files.c nonportable/$(OS)/random.c ../libs/libnanomsg.a -lpthread -lanl -lm
else
ifneq (,$(findstring WINDOWS,$(PATH)))
    OS := win
    #PLIBS := utils/bits777.c utils/system777.c utils/cJSON.c utils/NXT777.c utils/files777.c utils/bitcoind_RPC.c utils/bitcoind.c utils/utils777.c nonportable/$(OS)/files.c nonportable/$(OS)/random.c ../libs/libnanomsg.a -lpthread -lanl -lm
else
    OS := $(shell uname -s)
    #PLIBS := ../libs/libjl777.a ../libs/libnanomsg.a -lpthread -lanl -lm
    #PLIBS := utils/bits777.c utils/system777.c utils/cJSON.c utils/files777.c utils/utils777.c nonportable/$(OS)/files.c nonportable/$(OS)/random.c ../libs/libnanomsg.a -lpthread -lanl -lm
endif
endif

PLIBS := ../libs/libjl777.a ../libs/libminiupnpc.a ../nanomsg/.libs/libnanomsg.a -lpthread -lcurl -lanl -lm

LIBS= libs/libjl777.a nanomsg/.libs/libnanomsg.a libs/libminiupnpc.a -lpthread -lcurl -lanl -lm #-lssl -lcrypto

CC=clang
CFLAGS=-Wall -O2  -pedantic -g -fPIC -Iplugins/includes  -Iplugins/utils -Iincludes  -Iplugins/mgw -Iplugins/sophia -Iplugins/ramchain -Iplugins/coins -Inanomsg/src -Inanomsg/src/utils -Iplugins/includes/libtom  -Iplugins/includes/miniupnp -I.. -I../includes -I../../includes -I/usr/include -Wno-unused-function -fPIC -fvisibility=hidden -fstack-protector-all -Wstack-protector -D_FORTIFY_SOURCE=2 #-DADDRINFO_SIZE=256

TARGET	= libjl777.a

PICOC	= picoc.c table.c lex.c parse.c expression.c heap.c type.c variable.c clibrary.c platform.c include.c \
	platform/platform_unix.c platform/library_unix.c  cstdlib/stdio.c cstdlib/math.c cstdlib/string.c cstdlib/stdlib.c \
	cstdlib/time.c cstdlib/errno.c cstdlib/ctype.c cstdlib/stdbool.c cstdlib/unistd.c

GZIP = gzip/adler32.c gzip/crc32.c gzip/gzclose.c gzip/gzread.c gzip/infback.c gzip/inflate.c gzip/trees.c \
    gzip/zutil.c gzip/compress.c  gzip/deflate.c gzip/gzlib.c gzip/gzwrite.c gzip/inffast.c gzip/inftrees.c gzip/uncompr.c

LIBTOM = libtom/yarrow.c libtom/aes.c libtom/cast5.c libtom/khazad.c libtom/rc2.c libtom/safer.c libtom/skipjack.c \
    libtom/aes_tab.c libtom/crypt_argchk.c libtom/kseed.c libtom/rc5.c libtom/saferp.c libtom/twofish.c \
    libtom/anubis.c libtom/des.c libtom/multi2.c libtom/rc6.c libtom/safer_tab.c libtom/twofish_tab.c libgfshare.c \
    libtom/blowfish.c libtom/kasumi.c  libtom/noekeon.c libtom/rmd160.c libtom/sha256.c libtom/hmac_sha512.c libtom/xtea.c

U = plugins/utils
C = plugins/coins
R = plugins/ramchain
S = plugins/sophia
UTILS = $(U)/ramcoder.c $(U)/huffstream.c $(U)/inet.c $(U)/cJSON.c  $(U)/bits777.c $(U)/NXT777.c $(U)/system777.c $(U)/files777.c $(U)/utils777.c
SOPHIA = $(S)/sophia.c $(S)/sophia_main.c $(S)/db777.c $(S)/storage.c
RAMCHAIN = $(R)/ramchain_main.c $(R)/ramchain.c # $(R)/gen1block.c
NONPORTABLE = plugins/nonportable/$(OS)/files.c plugins/nonportable/$(OS)/random.c
COINS = $(C)/bitcoind_RPC.c $(C)/gen1auth.c $(C)/gen1pub.c $(C)/cointx.c $(C)/coins777.c $(C)/coins777_main.c $(C)/gen1.c
CRYPTO = $(U)/sha256.c $(U)/crypt_argchk.c $(U)/hmac_sha512.c $(U)/rmd160.c $(U)/sha384.c $(U)/sha512.c

SRCS = SuperNET.c libjl777.c $(CRYPTO) $(UTILS) $(SOPHIA) $(COINS) $(NONPORTABLE) $(RAMCHAIN) plugins/mgw/MGW_main.c plugins/relays777.c plugins/peers777.c plugins/subscriptions777.c plugins/console777.c # plugins/echodemo.c
 
OBJS	:= $(SRCS:%.c=%.o)

all: $(TARGET)

$(TARGET): $(OBJS)
  	#$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LIBS)
	ar rcu  libs/libjl777.a  $(OBJS)

test:	all
	(cd tests; make test)

clean: doesntexist
	rm libs/libjl777.a SuperNET; rm -f libjl777.a libs/libjl777.so $(OBJS) *~

PINCLUDES := -Iincludes -I../nanomsg/src -I../nanomsg/src/utils -Iincludes/libtom -Iincludes/miniupnp -I. -Iutils -Iramchain -Imgw -I ../includes -I../..

_echodemo := rm lib/echodemo; gcc -o lib/echodemo -O2 $(PINCLUDES) echodemo.c $(PLIBS)

_api := rm cgi/api; gcc -o cgi/api -O2 $(PINCLUDES) api_main.c ccgi.c prefork.c utils/bits777.c utils/utils777.c utils/cJSON.c ../nanomsg/.libs/libnanomsg.a -lpthread -lanl -lm

_msc := rm lib/msc; gcc -o lib/msc -O2 $(PINCLUDES) two/msc.c $(PLIBS)

_nxt := rm lib/msc; gcc -o lib/nxt -O2 $(PINCLUDES) two/nxt.c $(PLIBS)

_eth := rm lib/eth; gcc -o lib/eth -O2 $(PINCLUDES) two/eth.c $(PLIBS)

_two := rm lib/two; gcc -o lib/two -O2 $(PINCLUDES) two/two.c $(PLIBS)

_MGW :=    rm lib/MGW; gcc -o lib/MGW $(PINCLUDES) mgw/main.c mgw/mgw.c mgw/state.c mgw/huff.c  ramchain/ramchain.c ramchain/init.c  ramchain/search.c ramchain/blocks.c ramchain/api.c ramchain/tokens.c utils/bitcoind_RPC.c utils/bitcoind.c  $(PLIBS) -lcurl

_sophia := gcc -c -o ../libs/sophia.o $(PINCLUDES)  -g -O2 -std=c99 -pedantic -Wextra -Wall -Wunused-parameter -Wsign-compare -Wno-unused-function -fPIC -fno-stack-protector -fvisibility=hidden  sophia/sophia.c $(PLIBS)

_stockfish := cd stockfish; rm stockfish; make build ARCH=x86-64-modern; cp stockfish ../lib; cd ..

plugins: lib/echodemo lib/MGW lib/stockfish lib/sophia cgi/api lib/nxt lib/two lib/eth lib/eth; \
	cd plugins; \
    $(_echo); \
    $(_stockfish); \
    $(_sophia); \
    $(_MGW); \
    $(_api); \
    $(_nxt); \
    $(_two); \
    $(_eth); \
    $(_msc); \
    cd ..

echodemo: plugins/lib/echodemo; \
 	cd plugins; $(_echodemo); cd ..

api: plugins/cgi/api; \
 	cd plugins; $(_api); cd ..

eth: plugins/lib/eth; \
       cd plugins; $(_eth); cd ..

msc: plugins/lib/msc; \
        cd plugins; $(_msc); cd ..

nxt: plugins/lib/nxt; \
        cd plugins; $(_nxt); cd ..

two: plugins/lib/two; \
        cd plugins; $(_two); cd ..

install_eth: doesntexist; \
    sudo add-apt-repository -y ppa:ethereum/ethereum-dev; \
    sudo add-apt-repository -y ppa:ethereum/ethereum; \
    sudo apt-get update; \
    sudo apt-get install geth;

start_eth: doesntexist; \
    geth --rpc --rpcport "8545";

stockfish: lib/stockfish; \
 	cd plugins; $(_stockfish); cd ..

sophia: lib/sophia; \
 	cd plugins; $(_sophia); cd ..

MGW: lib/MGW; \
	cd plugins; $(_MGW); cd ..

SuperNET: $(SRCS) SuperNET.c plugins/relays777.c $(TARGET); \
    pkill SuperNET; rm SuperNET; clang -o SuperNET $(CFLAGS) -D STANDALONE SuperNET.c plugins/relays777.c $(LIBS) 

#-lz -ldl -lutil -lpcre -lexpat

special: /usr/lib/libjl777.so; \
    gcc -shared -Wl,-soname,libjl777.so -o libs/libjl777.so $(OBJS) -lstdc++ -lcurl -lm -ldl; \
    sudo cp libs/libjl777.so /usr/lib/libjl777.so

btcd: ../src/BitcoinDarkd; \
    cd ../src; rm BitcoinDarkd; make -f makefile.unix; strip BitcoinDarkd; cp BitcoinDarkd ../libjl777

btcdmac: ../src/BitcoinDarkd; \
    cd ../src; rm BitcoinDarkd; make -f makefile.osx; strip BitcoinDarkd; cp BitcoinDarkd ../libjl777

install: doesntexist; \
    sudo add-apt-repository ppa:fkrull/deadsnakes; sudo apt-get update; sudo aptitude install python-software-properties software-properties-common autotools-dev ; add-apt-repository ppa:bitcoin/bitcoin; echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list ; echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list ; apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 ; aptitude update; aptitude install git build-essential libdb++-dev  libtool  autoconf pkg-config libssl-dev libboost-all-dev libminiupnpc-dev clang libcurl4-gnutls-dev oracle-java8-installer libwebsockets3 libwebsockets-dev cmake qt4-qmake libqt4-dev build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libminiupnpc-dev python3-dev libpcre-ocaml-dev #openjdk-7-jdk openjdk-7-jre-lib

getramchain2:  doesntexist; \
    mkdir /var/www/html/ramchains; mkdir /var/www/html/ramchains/BTCD; \
    rsync -rtv guest@209.126.70.159::ramchains/BTCD.blocks /var/www/html/ramchains/BTCD.blocks; \
    rsync -rtv guest@209.126.70.159::ramchains/BTCD.addr /var/www/html/ramchains/BTCD/BTCD.addr; \
    rsync -rtv guest@209.126.70.159::ramchains/BTCD.txid /var/www/html/ramchains/BTCD/BTCD.txid; \
    rsync -rtv guest@209.126.70.159::ramchains/BTCD.script /var/www/html/ramchains/BTCD/BTCD.script

getramchain1:  doesntexist; \
    mkdir /var/www/html/ramchains/BTCD; rsync -rtv guest@209.126.70.156::ramchains/BTCD.blocks /var/www/html/ramchains/BTCD.blocks; \
    rsync -rtv guest@209.126.70.156::ramchains/BTCD.addr /var/www/html/ramchains/BTCD/BTCD.addr; \
    rsync -rtv guest@209.126.70.156::ramchains/BTCD.txid /var/www/html/ramchains/BTCD/BTCD.txid; \
    rsync -rtv guest@209.126.70.156::ramchains/BTCD.script /var/www/html/ramchains/BTCD/BTCD.script

getramchain0:  doesntexist; \
    mkdir /var/www/html/ramchains/BTCD; rsync -rtv guest@209.126.70.170::ramchains/BTCD.blocks /var/www/html/ramchains/BTCD.blocks; \
    rsync -rtv guest@209.126.70.170::ramchains/BTCD.addr /var/www/html/ramchains/BTCD/BTCD.addr; \
    rsync -rtv guest@209.126.70.170::ramchains/BTCD.txid /var/www/html/ramchains/BTCD/BTCD.txid; \
    rsync -rtv guest@209.126.70.170::ramchains/BTCD.script /var/www/html/ramchains/BTCD/BTCD.script

chessjs:  doesntexist; \
    git clone https://github.com/exoticorn/stockfish-js

nanomsg:  doesntexist; \
    git clone https://github.com/nanomsg/nanomsg; cd nanomsg; ./autogen.sh; ./configure; make -lanl; make check; cp .libs/libnanomsg.a ../libs; cp src/*.h ../includes; cd ..

python: doesntexist; \
    tar -xvf Python-3.4.3.tgz; cd Python-3.4.3; ./configure; make all; cp libpython3.so libpython3.4m.a ../libs; cp pyconfig.h Include; ln ./build/lib.linux-x86_64-3.4/_sysconfigdata.py Lib; cd ..;

patch: doesntexist; \
    #sudo apt-get install csync-owncloud librsync-dev libsmbclient-dev liblog4c-dev flex libsqlite3-dev bison csync2; \
    #git clone http://git.linbit.com/csync2.git; \
    #cd csync2; ./autogen.sh; ./configure  --prefix=/usr --localstatedir=/var --sysconfdir=/etc; make; sudo make install; sudo make cert; cd ..; \
    #echo "add: csync2          30865/tcp       # to /etc/services"; \
    #echo "http://oss.linbit.com/csync2/paper.pdf is useful"; \
    #git clone git://git.csync.org/projects/csync.git; \
    #cd csync; cmake ..; make; \
    #echo "neon can be installed from: http://www.linuxfromscratch.org/blfs/view/svn/basicnet/neon.html"; \
    sudo apt-get install openjdk-7-jdk openjdk-7-jre-lib; \
    sudo apt-get install mercurial; \
    sudo apt-get install libpcre-ocaml-dev; \
    sudo add-apt-repository ppa:fkrull/deadsnakes; \
    sudo apt-get update; \
    sudo apt-get install libpython3.4-dev; \
    cp /usr/lib/python3.4/config-3.4m-x86_64-linux-gnu/libpython3.4m.a libs; \
    cd; git clone https://go.googlesource.com/go; \
    cd go; \
    git checkout go1.4.1; \
    cd src; \
    ./all.bash; \
    export GOPATH=$$HOME/gocode; \
    export GOROOT=$$HOME/go; \
    PATH="$$PATH:$$GOROOT/bin:$$GOPATH/bin"; \
    #echo "export GOPATH=$$HOME/gocode" >> ~/.profile; \
    #echo "export GOROOT=$$HOME/go" >> ~/.profile; \
    #echo "PATH=\"$$PATH:$$GOPATH/bin:$$GOROOT/bin\"" >> ~/.profile; \
    go get golang.org/x/tools/cmd/...; go get golang.org/x/crypto; go get golang.org/x/image; go get golang.org/x/sys; go get golang.org/x/net; go get golang.org/x/text; go get golang.org/x/tools;\
    cd ../../gocode/src; cd ~/gocode/src; mkdir github.com; cd github.com; mkdir syncthing; cd syncthing; git clone https://github.com/syncthing/syncthing; cd syncthing; go run build.go; cp bin/syncthing $HOME; \

patch3: doesntexist; \
    cd miniupnpc; \
    make libminiupnpc.a; \
    cp libminiupnpc.a ../libs; \
    cd ..;\

ramchains: doesntexist; \
    mkdir ramchains; \
    cd ramchains; \
    unzip ../ramchains.zip; \
    cd ..;\

patch1: doesntexist; \
   export LIBDIR="/usr/local/BerkeleyDB.6.1/lib"; \
    unzip db-6.1.19.zip; \
    cd db-6.1.19/build_unix; \
    ../dist/configure; \
    cp ../../env_region.c ../src/env; \
    make; \
    cp *.h ../../includes; \
    cp libdb.a ../../libs;

patch2: doesntexist; \
    unzip lws.zip -d libwebsockets; \
    cd libwebsockets/lib; \
    cmake ..; \
    cp libwebsockets.h lws_config.h ../../includes; \
    cp libwebsockets-test-server.key.pem ../../SuperNET.key.pem; \
    cp libwebsockets-test-server.pem ../../SuperNET.pem; \
    make; \
    cp lib/*  ../../libs; \
    cd ../..;

#git clone https://github.com/joewalnes/websocketd;
#git clone https://github.com/nanomsg/nanomsg; \
    #unzip lws.zip -d libwebsockets; \
    #cd libwebsockets/lib; \
    #cmake ..; \
    #cp libwebsockets.h lws_config.h ../../includes; \
    #cp libwebsockets-test-server.key.pem ../../SuperNET.key.pem; \
    #cp libwebsockets-test-server.pem ../../SuperNET.pem; \
    #make; \
    #cp lib/*  ../../libs; \
    #cd ../..; \
    #unzip db-6.1.19.zip; \
    #cd db-6.1.19/build_unix; \
    #../dist/configure; \
    #cp ../../env_region.c ../src/env; \
    #make; \
    #cp libdb.a ../../libs; \
    #cp *.h ../../includes; \
    #cd ../..; \
    #cd libuv; \
    #sh autogen.sh; \
    #./configure; \
    #make; \
    #cp .libs/libuv.a ../libs; \
    #cp .libs/libuv.so ../libs; \
    #cd ..; \

dependencies: doesntexist; \
    sudo apt-get install make clang-3.4 autoconf  libtool libcurl4-gnutls-dev unzip autogen g++ libssl-dev libdb++-dev  libminiupnpc-dev libboost-all-dev;

onetime: doesntexist; \
    cd nanomsg; ./autogen.sh; ./configure; make; cd ..; \
    cd miniupnpc; make; cp libminiupnpc.a ../libs; cd ..; \
    git clone https://github.com/joewalnes/websocketd; cd websocketd; make; cp websocketd ../libs; cd ..; \
    #git clone https://go.googlesource.com/go; cd go; git checkout go1.4.1; cd src; ./all.bash; cd ..; mkdir gocode; mkdir gocode/src; cd ..; \
    #mkdir go/gocode; mkdir go/gocode/src; export GOPATH=`pwd`/go/gocode;  export GOROOT=`pwd`/go; echo $$GOPATH; echo $$GOROOT; \
    #go get golang.org/x/tools/cmd; go get golang.org/x/crypto; go get golang.org/x/image; go get golang.org/x/sys; go get golang.org/x/net; go get golang.org/x/text; go get golang.org/x/tools;\
    #cd go/gocode/src; mkdir github.com; cd github.com; mkdir joewalnes; cd joewalnes; git clone https://github.com/joewalnes/websocketd; cd websocketd; go build; cp websocketd ../../../../../../libs; cd ../../../../../..;


winpatch: doesntexist; \
   sh make_windows.sh;

winexe: doesntexist; \
    sh quick_win.sh;

winpatch64: doesntexist; \
   sh make_windows64.sh;

winexe64: doesntexist; \
    sh quick_win64.sh;

winbtcd64: doesntexist; \
	sh make_btcd_win64.sh

count:
	@echo "Core:"
	@cat $(SRCS) *.h | grep -v '^[ 	]*/\*' | grep -v '^[ 	]*$$' | wc
	@echo ""
	@echo "Everything:"
	@cat $(SRCS) *.h */*.h | wc

.PHONY: libjl777.c

../src/BitcoinDarkd: libjl777.a
#libs/randombytes.o:
libs/libuv.a:
/usr/lib/libjl777.so: libs/libjl777.so
doesntexist:
picoc.o: picoc.c picoc.h
libgfshare.o: libgfshare.c libgfshare.h
libjl777.o: $(SRCS)
table.o: table.c interpreter.h platform.h
lex.o: lex.c interpreter.h platform.h
parse.o: parse.c picoc.h interpreter.h platform.h
expression.o: expression.c interpreter.h platform.h
heap.o: heap.c interpreter.h platform.h
type.o: type.c interpreter.h platform.h
variable.o: variable.c interpreter.h platform.h
clibrary.o: clibrary.c picoc.h interpreter.h platform.h
platform.o: platform.c picoc.h interpreter.h platform.h
include.o: include.c picoc.h interpreter.h platform.h
platform/platform_unix.o: platform/platform_unix.c picoc.h interpreter.h platform.h
platform/library_unix.o: platform/library_unix.c interpreter.h platform.h
cstdlib/stdio.o: cstdlib/stdio.c interpreter.h platform.h
cstdlib/math.o: cstdlib/math.c interpreter.h platform.h
cstdlib/string.o: cstdlib/string.c interpreter.h platform.h
cstdlib/stdlib.o: cstdlib/stdlib.c interpreter.h platform.h
cstdlib/time.o: cstdlib/time.c interpreter.h platform.h
cstdlib/errno.o: cstdlib/errno.c interpreter.h platform.h
cstdlib/ctype.o: cstdlib/ctype.c interpreter.h platform.h
cstdlib/stdbool.o: cstdlib/stdbool.c interpreter.h platform.h
cstdlib/unistd.o: cstdlib/unistd.c interpreter.h platform.h
plugins/lib/stockfish: plugins/stockfish/stockfish.cpp
plugins/lib/sophia: plugins/sophia/sophia.c plugins/sophia/sophia_main.c
plugins/lib/echodemo: plugins/echodemo.c
#plugins/nonportable/$(OS)/files.o: plugins/nonportable/$(OS)/files.c
#plugins/nonportable/$(OS)/random.o: plugins/nonportable/$(OS)/random.c
plugins/lib/eth: plugins/two/eth.c
plugins/lib/msc: plugins/two/msc.c
plugins/lib/nxt: plugins/two/nxt.c
plugins/lib/two: plugins/two/two.c
plugins/lib/api: plugins/api_main.c plugins/ccgi.c plugins/prefork.c

lib/MGW: plugins/mgw/mgw.c plugins/mgw/state.c plugins/mgw/huff.c plugins/ramchain/touch plugins/ramchain/blocks.c plugins/ramchain/storage.c plugins/ramchain/search.c plugins/ramchain/tokens.c plugins/ramchain/init.c plugins/ramchain/ramchain.c plugins/utils/ramcoder.c plugins/utils/huffstream.c plugins/utils/bitcoind.c

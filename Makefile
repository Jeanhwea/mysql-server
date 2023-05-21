all: build

build:
	cd ./out && make -j4 && make install

install: config
	cd ./out && make -j4 && make install

config:
	-rm -rvf ./out
	mkdir ./out && cd ./out && \
	cmake -DCMAKE_INSTALL_PREFIX=/opt/mysql -DWITH_BOOST=../../boost/boost_1_70_0 -DWITH_DEBUG=1 -DWITH_UNIT_TESTS=0 ..

ctags:
	ctags -e -R --languages=c,c++ --exclude=out/* .

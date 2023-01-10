all: prepare

setup: setup-dev prepare

ctags:
	ctags -e -R --languages=c,c++ .

prepare:
	cd build && make -j8

clean-build:
	rm -rvf ./build && cat /etc/my.cnf

setup-prod: clean-build
	[ -d ./build ] || mkdir build && cd build && \
	cmake -DWITH_BOOST=../../boost/boost_1_59_0 ..

setup-dev: clean-build
	[ -d ./build ] || mkdir build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/opt/mysql -DWITH_BOOST=../../boost/boost_1_59_0 -DWITH_DEBUG=1 -DWITH_UNIT_TESTS=0 ..

# https://dev.mysql.com/doc/refman/5.7/en/making-trace-files.html
debug:
	./build/bin/mysqld --defaults-file=/etc/my.cnf --debug >/dev/null 2>&1 &

trace:
	./build/bin/mysqld --defaults-file=/etc/my.cnf --debug=d,info,error,query,general,where:O,/tmp/mysqld.trace >/dev/null 2>&1 &

# https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization.html
init-data:
	./build/bin/mysqld --defaults-file=/etc/my.cnf --initialize-insecure

# https://dev.mysql.com/doc/refman/5.7/en/starting-server.html
start-server:
	./build/scripts/mysqld_safe --defaults-file=/etc/my.cnf &

start-client:
	./build/bin/mysql

shutdown-server:
	./build/bin/mysqladmin shutdown

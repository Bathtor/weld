CC=clang++
LDFLAGS=-L../../../target/release/
LIBS=-lweld -ledit

.PHONY: all clean

all:
	${CC} ${LDFLAGS} ${LIBS} streaming.cpp -o run

clean:
	rm -rf run


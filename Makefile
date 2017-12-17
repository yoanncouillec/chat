VERSION=1_0_0
BIN=server.out client.out
CFLAGS=-thread

all: $(BIN)

%.out: log.cmo service.cmo server.cmo client.cmo
	ocamlc -thread unix.cma threads.cma $^ -o $@

%.cmo: %.ml %.cmi
	ocamlc -c $(CFLAGS) $<

%.cmi: %.mli
	ocamlc -c $(CFLAGS) $^

%.mli: %.ml
	ocamlc -i $(CFLAGS) $^ > $@

dist: mrproper
	tar czvf chat_$(VERSION).tar.gz ../chat

clean:
	rm -rf $(BIN) *.cmi

mrproper: clean
	rm -rf *~

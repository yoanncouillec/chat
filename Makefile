BIN=chat.out #server.out client.out
CFLAGS=-thread
TARFILE=chat.tar.gz
DIR=chat

all: $(BIN)

%.out: gensym.cmo log.cmo service.cmo %.cmo
	ocamlc -thread unix.cma threads.cma $^ -o $@

%.cmo: %.ml %.cmi
	ocamlc -c $(CFLAGS) $<

%.cmi: %.mli
	ocamlc -c $(CFLAGS) $^

%.mli: %.ml
	ocamlc -i $(CFLAGS) $^ > $@

dist: mrproper
	cd .. && tar czvf $(TARFILE) --exclude .git --exclude *.tar.gz  $(DIR) && mv $(TARFILE) $(DIR)  && cd $(DIR)

clean:
	rm -rf $(BIN) *.cmi

mrproper: clean
	rm -rf *~

.PHONY: run tryout tryout_text_edit

run:
	./espada.sh

tryout:
	./run_with_espada.sh tests/tryout.rb

tryout_text_edit:
	./run_with_espada.sh tests/tryout_text_edit.rb

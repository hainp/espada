.PHONY: run tryout tryout_text_edit

run:
	./espada.sh

tryout:
	cd src/ && ruby ../tests/tryout.rb

tryout_text_edit:
	./run_with_espada.sh tests/tryout_text_edit.rb

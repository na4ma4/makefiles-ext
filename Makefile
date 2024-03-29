_SOURCE := $(shell find . -type f -not -name 'test.zip')

test.zip: $(_SOURCE)
	-@mkdir -p ".tmp/makefiles-ext-main/v1"
	rsync -Pav --exclude .tmp** --exclude 'test.zip' --exclude '.git**' --exclude '.vscode**' ./ .tmp/makefiles-ext-main/v1/
	(cd .tmp; zip -r9 ../test.zip .)

.PHONY: clean
clean:
	$(RM) -r test.zip .tmp
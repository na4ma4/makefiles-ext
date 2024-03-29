.DELETE_ON_ERROR:

#curl -sSfL https://raw.githubusercontent.com/na4ma4/makefiles-ext/main/scripts/install-cfssl.sh | sh -s -- -b "$(@D)"

CFSSL_VERSION ?= latest

CFSSL := artifacts/bin/cfssl
$(CFSSL):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/na4ma4/makefiles-ext/main/scripts/install-cfssl.sh | sh -s -- -b "$(@D)" "$(CFSSL_VERSION)"

CFSSLJSON := artifacts/bin/cfssljson
$(CFSSLJSON):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	curl -sSfL https://raw.githubusercontent.com/na4ma4/makefiles-ext/main/scripts/install-cfssl.sh | sh -s -- -b "$(@D)" "$(CFSSL_VERSION)"

.PHONY: cfssl
cfssl: artifacts/certs/server.pem artifacts/certs/client.pem

artifacts/certs/ca-config.json: SHELL=/bin/bash -o pipefail
artifacts/certs/ca-config.json: testdata/ca-config.json
	-@mkdir -p "$(@D)"
	cp "$(<)" "$(@)"

artifacts/certs/ca.pem: SHELL=/bin/bash -o pipefail
artifacts/certs/ca.pem: $(CFSSL) $(CFSSLJSON) artifacts/certs/ca-config.json testdata/ca-csr.json
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="ca" testdata/ca-csr.json | $(CFSSLJSON) -bare artifacts/certs/ca -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="ca" -csr=artifacts/certs/ca.csr testdata/ca-csr.json | $(CFSSLJSON) -bare artifacts/certs/ca

artifacts/certs/cert.pem: SHELL=/bin/bash -o pipefail
artifacts/certs/cert.pem: testdata/cert.json $(CFSSL) $(CFSSLJSON) artifacts/certs/ca.pem
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="client" "$(<)" | $(CFSSLJSON) -bare artifacts/certs/cert -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="client" artifacts/certs/cert.csr | $(CFSSLJSON) -bare artifacts/certs/cert

artifacts/certs/key.pem: SHELL=/bin/bash -o pipefail
artifacts/certs/key.pem: artifacts/certs/cert.pem
	-@mkdir -p "$(@D)"
	cp artifacts/certs/cert-key.pem "$(@)"

artifacts/certs/server.pem: SHELL=/bin/bash -o pipefail
artifacts/certs/server.pem: testdata/host.json $(CFSSL) $(CFSSLJSON) artifacts/certs/ca.pem
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="server" "$(<)" | $(CFSSLJSON) -bare artifacts/certs/server -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="server" artifacts/certs/server.csr | $(CFSSLJSON) -bare artifacts/certs/server

artifacts/certs/client.pem: SHELL=/bin/bash -o pipefail
artifacts/certs/client.pem: testdata/client.json $(CFSSL) $(CFSSLJSON) artifacts/certs/ca.pem
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="client" "$(<)" | $(CFSSLJSON) -bare artifacts/certs/client -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="client" artifacts/certs/client.csr | $(CFSSLJSON) -bare artifacts/certs/client

tools:: $(CFSSL) $(CFSSLJSON)

CFSSL := artifacts/bin/cfssl
$(CFSSL):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go get $(_MODFILEARG) github.com/cloudflare/cfssl/cmd/cfssl

CFSSLJSON := artifacts/bin/cfssljson
$(CFSSLJSON):
	-@mkdir -p "$(MF_PROJECT_ROOT)/$(@D)"
	GOBIN="$(MF_PROJECT_ROOT)/$(@D)" go get $(_MODFILEARG) github.com/cloudflare/cfssl/cmd/cfssljson

.PHONY: cfssl
cfssl: artifacts/certs/server.pem artifacts/certs/client.pem

artifacts/certs/ca-config.json: test/ca-config.json
	-@mkdir -p "$(@D)"
	cp "$(<)" "$(@)"

artifacts/certs/ca.pem: $(CFSSL) $(CFSSLJSON) artifacts/certs/ca-config.json test/ca-csr.json
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="ca" test/ca-csr.json | $(CFSSLJSON) -bare artifacts/certs/ca -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="ca" -csr=artifacts/certs/ca.csr test/ca-csr.json | $(CFSSLJSON) -bare artifacts/certs/ca

artifacts/certs/cert.pem: test/cert.json $(CFSSL) $(CFSSLJSON) artifacts/certs/ca.pem
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="client" "$(<)" | $(CFSSLJSON) -bare artifacts/certs/cert -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="client" artifacts/certs/cert.csr | $(CFSSLJSON) -bare artifacts/certs/cert

artifacts/certs/key.pem: artifacts/certs/cert.pem
	-@mkdir -p "$(@D)"
	cp artifacts/certs/cert-key.pem "$(@)"

artifacts/certs/server.pem: test/host.json $(CFSSL) $(CFSSLJSON) artifacts/certs/ca.pem
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="server" "$(<)" | $(CFSSLJSON) -bare artifacts/certs/server -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="server" artifacts/certs/server.csr | $(CFSSLJSON) -bare artifacts/certs/server

artifacts/certs/client.pem: test/client.json $(CFSSL) $(CFSSLJSON) artifacts/certs/ca.pem
	-@mkdir -p "$(@D)"
	$(CFSSL) gencert -initca -config="artifacts/certs/ca-config.json" -profile="client" "$(<)" | $(CFSSLJSON) -bare artifacts/certs/client -
	$(CFSSL) sign -ca="artifacts/certs/ca.pem" -ca-key="artifacts/certs/ca-key.pem" -config="artifacts/certs/ca-config.json" -profile="client" artifacts/certs/client.csr | $(CFSSLJSON) -bare artifacts/certs/client

tools:: $(CFSSL) $(CFSSLJSON)

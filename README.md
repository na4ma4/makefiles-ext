# makefiles-ext

makefiles.dev custom extensions.

## Example Usage

```Makefile
-include .makefiles/Makefile
-include .makefiles/pkg/protobuf/v1/Makefile
-include .makefiles/pkg/go/v1/Makefile
-include .makefiles/ext/na4ma4/lib/golangci-lint/v1/Makefile
-include .makefiles/ext/na4ma4/lib/golint/v1/Makefile
-include .makefiles/ext/na4ma4/lib/misspell/v1/Makefile
-include .makefiles/ext/na4ma4/lib/staticcheck/v1/Makefile
-include .makefiles/ext/na4ma4/lib/cfssl/v1/Makefile

.makefiles/ext/na4ma4/%: .makefiles/Makefile
	@curl -sfL https://raw.githubusercontent.com/na4ma4/makefiles-ext/main/v1/install | bash /dev/stdin "$@"

.makefiles/%:
	@curl -sfL https://makefiles.dev/v1 | bash /dev/stdin "$@"
```

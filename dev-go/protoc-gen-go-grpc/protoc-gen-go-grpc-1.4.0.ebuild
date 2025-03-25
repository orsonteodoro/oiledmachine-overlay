# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GEN_EBUILD=0
GRPC_PV="1.65.0" # From version.go
EGO_PN="github.com/grpc/grpc-go/cmd/protoc-gen-go-grpc"
EGO_SUM=(
	"github.com/google/go-cmp v0.5.5"
	"github.com/google/go-cmp v0.5.5/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"google.golang.org/protobuf v1.34.1"
	"google.golang.org/protobuf v1.34.1/go.mod"
	"cel.dev/expr v0.15.0"
	"cel.dev/expr v0.15.0/go.mod"
	"cloud.google.com/go/compute/metadata v0.3.0"
	"cloud.google.com/go/compute/metadata v0.3.0/go.mod"
	"github.com/census-instrumentation/opencensus-proto v0.4.1"
	"github.com/census-instrumentation/opencensus-proto v0.4.1/go.mod"
	"github.com/cespare/xxhash/v2 v2.3.0"
	"github.com/cespare/xxhash/v2 v2.3.0/go.mod"
	"github.com/cncf/xds/go v0.0.0-20240423153145-555b57ec207b"
	"github.com/cncf/xds/go v0.0.0-20240423153145-555b57ec207b/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/envoyproxy/go-control-plane v0.12.0"
	"github.com/envoyproxy/go-control-plane v0.12.0/go.mod"
	"github.com/envoyproxy/protoc-gen-validate v1.0.4"
	"github.com/envoyproxy/protoc-gen-validate v1.0.4/go.mod"
	"github.com/golang/glog v1.2.1"
	"github.com/golang/glog v1.2.1/go.mod"
	"github.com/golang/protobuf v1.5.4"
	"github.com/golang/protobuf v1.5.4/go.mod"
	"github.com/google/go-cmp v0.6.0"
	"github.com/google/go-cmp v0.6.0/go.mod"
	"github.com/google/uuid v1.6.0"
	"github.com/google/uuid v1.6.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/testify v1.8.4"
	"github.com/stretchr/testify v1.8.4/go.mod"
	"golang.org/x/net v0.25.0"
	"golang.org/x/net v0.25.0/go.mod"
	"golang.org/x/oauth2 v0.20.0"
	"golang.org/x/oauth2 v0.20.0/go.mod"
	"golang.org/x/sync v0.7.0"
	"golang.org/x/sync v0.7.0/go.mod"
	"golang.org/x/sys v0.20.0"
	"golang.org/x/sys v0.20.0/go.mod"
	"golang.org/x/text v0.15.0"
	"golang.org/x/text v0.15.0/go.mod"
	"google.golang.org/genproto/googleapis/api v0.0.0-20240528184218-531527333157"
	"google.golang.org/genproto/googleapis/api v0.0.0-20240528184218-531527333157/go.mod"
	"google.golang.org/genproto/googleapis/rpc v0.0.0-20240528184218-531527333157"
	"google.golang.org/genproto/googleapis/rpc v0.0.0-20240528184218-531527333157/go.mod"
	"google.golang.org/protobuf v1.34.1"
	"google.golang.org/protobuf v1.34.1/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
)

inherit go-module edo

go-module_set_globals

KEYWORDS="amd64 x86"
S="${WORKDIR}/grpc-go-cmd-protoc-gen-go-grpc-v${PV}/cmd/protoc-gen-go-grpc"
if [[ "${GEN_EBUILD}" != "1" ]] ; then
	SRC_URI+="
		${EGO_SUM_SRC_URI}
	"
fi
SRC_URI+="
https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="This tool generates Go language bindings of services in protobuf definition files for gRPC"
HOMEPAGE="https://pkg.go.dev/google.golang.org/grpc/cmd/protoc-gen-go-grpc"
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/grpc${GRPC_PV%.*}"
IUSE="test"
RDEPEND="
	>=net-libs/grpc-${GRPC_PV}
	net-libs/grpc:=
"
DEPEND="
	test? (
		dev-libs/protobuf:=
	)
"
RDEPEND=""

src_unpack() {
	unpack "${P}.tar.gz"
	if [[ "${GEN_EBUILD}" == "1" ]] ; then
einfo "Replace EGO_SUM contents with the following:"
		IFS=$'\n'
		for x in $(cat "${WORKDIR}/grpc-go-cmd-${PN}-v${PV}/cmd/protoc-gen-go-grpc/go.sum" "${WORKDIR}/grpc-go-cmd-${PN}-v${PV}/go.sum" | cut -f 1-2 -d " ") ; do
			echo -e "\t\"${x}\""
		done
		IFS=$' \t\n'
		die
	else
		go-module_src_unpack
	fi
}

src_compile() {
	GOBIN="${S}/bin" \
	edo go install ./...
}

src_install() {
	dobin bin/protoc-gen-go-grpc
}

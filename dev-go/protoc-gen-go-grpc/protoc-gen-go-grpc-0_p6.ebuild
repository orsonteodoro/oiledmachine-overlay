# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GEN_EBUILD=0
GRPC_PV="1.30.1" # From version.go
EGO_PN="github.com/grpc/grpc-go/cmd/protoc-gen-go-grpc"
EGO_SUM=(
	"github.com/golang/protobuf v1.4.0-rc.1/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.1.0.20200221234624-67d41d38c208/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.2/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.4.0.20200313231945-b860323f09d0/go.mod"
	"github.com/golang/protobuf v1.4.0/go.mod"
	"github.com/google/go-cmp v0.3.0/go.mod"
	"github.com/google/go-cmp v0.3.1/go.mod"
	"github.com/google/go-cmp v0.4.0/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"google.golang.org/protobuf v0.0.0-20200109180630-ec00e32a8dfd/go.mod"
	"google.golang.org/protobuf v0.0.0-20200221191635-4d8936d0db64/go.mod"
	"google.golang.org/protobuf v0.0.0-20200228230310-ab0ca4ff8a60/go.mod"
	"google.golang.org/protobuf v1.20.1-0.20200309200217-e05f789c0967/go.mod"
	"google.golang.org/protobuf v1.21.0/go.mod"
	"google.golang.org/protobuf v1.23.0"
	"google.golang.org/protobuf v1.23.0/go.mod"
	"cloud.google.com/go v0.26.0"
	"cloud.google.com/go v0.26.0/go.mod"
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod"
	"github.com/client9/misspell v0.3.4"
	"github.com/client9/misspell v0.3.4/go.mod"
	"github.com/cncf/udpa/go v0.0.0-20191209042840-269d4d468f6f"
	"github.com/cncf/udpa/go v0.0.0-20191209042840-269d4d468f6f/go.mod"
	"github.com/envoyproxy/go-control-plane v0.9.0/go.mod"
	"github.com/envoyproxy/go-control-plane v0.9.4"
	"github.com/envoyproxy/go-control-plane v0.9.4/go.mod"
	"github.com/envoyproxy/protoc-gen-validate v0.1.0"
	"github.com/envoyproxy/protoc-gen-validate v0.1.0/go.mod"
	"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b"
	"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
	"github.com/golang/mock v1.1.1"
	"github.com/golang/mock v1.1.1/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.3.2"
	"github.com/golang/protobuf v1.3.2/go.mod"
	"github.com/golang/protobuf v1.3.3"
	"github.com/golang/protobuf v1.3.3/go.mod"
	"github.com/google/go-cmp v0.2.0"
	"github.com/google/go-cmp v0.2.0/go.mod"
	"github.com/google/go-cmp v0.4.0"
	"github.com/google/go-cmp v0.4.0/go.mod"
	"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
	"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
	"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
	"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3"
	"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
	"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
	"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
	"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be"
	"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
	"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
	"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
	"golang.org/x/tools v0.0.0-20190524140312-2c0ae7006135"
	"golang.org/x/tools v0.0.0-20190524140312-2c0ae7006135/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"google.golang.org/appengine v1.1.0/go.mod"
	"google.golang.org/appengine v1.4.0"
	"google.golang.org/appengine v1.4.0/go.mod"
	"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
	"google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55"
	"google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55/go.mod"
	"google.golang.org/grpc v1.19.0/go.mod"
	"google.golang.org/grpc v1.23.0/go.mod"
	"google.golang.org/grpc v1.25.1/go.mod"
	"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
	"honnef.co/go/tools v0.0.0-20190523083050-ea95bdfd59fc"
	"honnef.co/go/tools v0.0.0-20190523083050-ea95bdfd59fc/go.mod"
)

inherit go-module edo

go-module_set_globals

KEYWORDS="amd64 x86"
S="${WORKDIR}/grpc-go-${GRPC_PV}/cmd/protoc-gen-go-grpc"
if [[ "${GEN_EBUILD}" != "1" ]] ; then
	SRC_URI+="
		${EGO_SUM_SRC_URI}
	"
fi
SRC_URI+="
https://github.com/grpc/grpc-go/archive/refs/tags/v${GRPC_PV}.tar.gz
	-> grpc-go-${GRPC_PV}.tar.gz
"

DESCRIPTION="This tool generates Go language bindings of services in protobuf definition files for gRPC"
HOMEPAGE="https://pkg.go.dev/google.golang.org/grpc/cmd/protoc-gen-go-grpc"
LICENSE="Apache-2.0"
RESTRICT="
	mirror
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
	unpack "grpc-go-${GRPC_PV}.tar.gz"
	if [[ "${GEN_EBUILD}" == "1" ]] ; then
einfo "Replace EGO_SUM contents with the following:"
		IFS=$'\n'
		for x in $(cat "${WORKDIR}/grpc-go-${GRPC_PV}/cmd/protoc-gen-go-grpc/go.sum" "${WORKDIR}/grpc-go-${GRPC_PV}/go.sum" | cut -f 1-2 -d " ") ; do
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

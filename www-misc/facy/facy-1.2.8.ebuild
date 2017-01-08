# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

inherit eutils ruby-fakegem

DESCRIPTION="Facy command line Facebook"
HOMEPAGE="https://github.com/huydx/facy"
SRC_URI="https://github.com/huydx/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND="dev-ruby/activesupport
        dev-ruby/addressable
	dev-ruby/eventmachine
	dev-ruby/faraday
	dev-ruby/i18n
	dev-ruby/json
	dev-ruby/koala
	dev-ruby/launchy
	dev-ruby/minitest
	dev-ruby/multi_json
	dev-ruby/multipart-post
	dev-ruby/thread_safe
	dev-ruby/tzinfo
        dev-lang/ruby[ssl,readline]
	dev-ruby/rmagick
	>dev-ruby/bundler-1.8.9
        >=www-client/casperjs-1.1.3
        >=www-client/phantomjs-2.1.1
        >=media-video/mplayer-1.2.1[libcaca]
        >=dev-ruby/json-1.8.2-r1
        >=media-libs/libcaca-0.99_beta19
        >=net-misc/youtube-dl-2016.09.19
        "
RDEPEND="${DEPEND}"
S="${WORKDIR}/all/${P}"

all_ruby_prepare() {
	epatch "${FILESDIR}"/facy-1.2.8-graphapi-fix-with-caca-video.patch
	epatch_user
}

each_ruby_install() {
        each_fakegem_install

	ruby_fakegem_doins config.yml
}

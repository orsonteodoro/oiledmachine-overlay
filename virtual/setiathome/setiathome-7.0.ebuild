EAPI=5

DESCRIPTION="setiathome"
SLOT="7"
KEYWORDS="amd64"
IUSE="ap-cpu ap-gpu sah-cpu sah-gpu"
RDEPEND="sah-cpu? ( sci-misc/setiathome-cpu:7 )
         sah-gpu? ( sci-misc/setiathome-gpu:7 )
         ap-gpu? ( sci-misc/astropulse-gpu:7 )
         ap-gpu? ( sci-misc/astropulse-gpu:7 )
	 sci-misc/setiathome-cfg
        "

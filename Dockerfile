FROM        debian:jessie
MAINTAINER  Carlo Hamalainen <c.hamalainen@uq.edu.au>

# Update and install packages.
ADD sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install python python-dev libpq-dev libssl-dev libsasl2-dev   \
                         libldap2-dev libxslt1.1 libxslt1-dev python-libxslt1  \
                         libexiv2-dev git libgraphviz-dev git ipython screen   \
                         htop imagemagick vim dcmtk supervisor  \
                         pwgen libpq-dev python-dev python-software-properties \
                         software-properties-common python-psycopg2 pyflakes   \
                         tcsh make vim-gtk minc-tools python-pip               \
                         redis-server python-redis python-requests             \
                         inotify-tools daemontools                             \
                         python python-dev cmake mercurial git ipython screen htop vim  \
                         build-essential unzip cmake mercurial                 \
       	       	         uuid-dev libcurl4-openssl-dev liblua5.1-0-dev         \
       	       	         libgoogle-glog-dev libgtest-dev libpng-dev            \
       	       	         libsqlite3-dev libssl-dev zlib1g-dev libdcmtk2-dev    \
                         libboost-all-dev libwrap0-dev libjsoncpp-dev wget     \
                         graphviz graphviz-dev python-pygraphviz pkg-config    \
                         libpugixml-dev stunnel telnet

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql postgresql-contrib

# Python packages.
RUN pip install pydicom
RUN pip install pynetdicom
RUN pip install PyJWT
RUN pip install PyCrypto
RUN pip install pwgen
RUN pip install django-longerusernameandemail
RUN pip install south
RUN pip install django-axes
RUN pip install pytz

# Locale needs to be right for various Haskell packages.
RUN echo 'export LANG=en_AU.UTF-8' >> /root/.bashrc
RUN sed -i 's/# en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/g' /etc/locale.gen
RUN locale-gen

# GHC and friends
RUN apt-get -qqy install ghc ghc-prof ghc-haddock happy alex
RUN wget http://snapshot.debian.org/archive/debian/20140609T162725Z/pool/main/h/haskell-cabal-install/cabal-install_1.20.0.2-1_amd64.deb -O /tmp/cabal-install_1.20.0.2-1_amd64.deb
RUN dpkg -i /tmp/cabal-install_1.20.0.2-1_amd64.deb
WORKDIR /root
ENV HOME /root
RUN cabal update
RUN echo 'export PATH=/root/.cabal/bin:$PATH' >> /root/.bashrc
RUN cabal install Cabal-1.20.0.2
RUN cabal install ghc-mod-4.1.6

# Cabal defaults.
RUN sed -i 's/-- documentation: False/documentation: True/g'         /root/.cabal/config
RUN sed -i 's/-- library-profiling: False/library-profiling: True/g' /root/.cabal/config
RUN sed -i 's/-- jobs:/jobs: $ncpus/g'                               /root/.cabal/config

# Set the timezone.
RUN echo Australia/Brisbane > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

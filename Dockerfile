# 初回の起動の仕方
# git clone git@github.com:Hideyasu/crypto_mf.git                                         <- プロジェクトをgitから持ってくる
# cd crypto_mf                                                                            <- プロジェクトのフォルダに入る
# docker build -t crypto_mf ./                                                            <- Dockerfileを読み込む
# docker run -d --name crypto_mf -v "$PWD":/opt/crypto_mf -it -p 3000:3000 crypto_mf bash <- 読み込んだコンテナ(サーバー)を動かす
# docker exec -it crypto_mf bash                                                          <- コンテナ(サーバー)に入る
# grep ‘temporary password’ /var/log/mysqld.log                                           <- mysqlの初期パスワードを表示する
# database.ymlのpasswordに上の出力の後ろにある初期パスワードを入力する。finish

FROM centos:6.9

# rubyとrailsのバージョンを指定
ENV ruby_ver="2.4.1"
ENV rails_ver="5.1.4"

# 必要なパッケージをインストール
RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install git make autoconf curl wget
RUN yum -y install gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel sqlite-devel bzip2
RUN yum -y install mysql-devel
RUN yum clean all

# rubyとbundleをダウンロード
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

# コマンドでrbenvが使えるように設定
RUN echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init --no-rehash -)"' >> /etc/profile.d/rbenv.sh

# rubyとrailsをインストール
RUN source /etc/profile.d/rbenv.sh; rbenv install ${ruby_ver}; rbenv global ${ruby_ver}
RUN source /etc/profile.d/rbenv.sh; gem update --system; gem install --version ${rails_ver} --no-ri --no-rdoc rails; gem install bundle

# mysqlのインストール
RUN rpm -Uvh http://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm
RUN yum -y install mysql-community-server
RUN service mysqld start

# プロジェクトフォルダに移動
WORKDIR /opt/crypto_mf

# bundle install
RUN /bin/sh -c bundle install

# 起動の仕方
# cd 'cryptoがあるフォルダ'
# docker build -t crypto ./
# docker run -v 'cryptoがあるフォルダの絶対パス':/opt/crypto -it crypto bash

# 残りのしたいこと
# nginx unicornの起動
# ホストからwebで見れるようにする
# git pull でプロジェクトを引っ張ってくる
# 絶対パスの指定をなくす(これ打ってで完結できるようにする)
# 本番環境をdockerに以降する

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

# プロジェクトフォルダに移動
WORKDIR /opt/crypto

# git pull
RUN git clone https://github.com/Hideyasu/crypto_mf.git


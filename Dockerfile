FROM amazonlinux:latest

LABEL maintainer = Jon Larson jon.larson@c9biz.com

ARG USER_NAME="username"
ARG USER_PASSWORD="passw0rd"

ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD
ENV CONTAINER_IMAGE_VER=v1.0.0

RUN echo $USER_NAME
RUN echo $USER_PASSWORD
RUN echo $CONTAINER_IMAGE_VER

# Install the operating system packages
RUN yum update -y && \
  yum install -y aws-cli \
  bash-completion \
  core-utils \
  curl \
  diff \
  file \
  fontconfig \
  git-core \
  gnupg \
  jq \
  ncdu \
  nodejs \
  npm \
  python36 \
  python36-debug \
  python36-devel \
  python36-libs \
  python36-pip \
  python36-setuptools \
  python36-tools \
  python36-virtualenv \
  shadow-utils \
  sudo \
  tar \
  top \
  unzip \
  vim \
  wget \
  which \
  zip \
  zsh \

  # Add the user defined in $USER_NAME
  && adduser --shell /bin/zsh --home /home/$USER_NAME $USER_NAME \

  # Update the password and add user to wheel for sudoers
  && echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && usermod -aG wheel $USER_NAME

  # Add tooling.sh install script
  ADD tooling.sh /home/$USER_NAME/
  RUN chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/tooling.sh \
  && chmod 0755 /home/${USER_NAME}/tooling.sh

  # Set terminal colors with xterm
  USER $USER_NAME
 
  # Set the zsh theme
  ENV TERM xterm
  ENV ZSH_THEME powerlevel9k/powerlevel9k

  # Switch to home directory
  WORKDIR /home/$USER_NAME

  # Install oh-my-zsh
  RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
  
  # Install powerlevel 9k theme
  && git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k \
  
  # Install hack nerd-fonts
  && wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip \
  && unzip Hack-v3.003-ttf.zip \
  && mkdir -p ~/.local/share/fonts/Hack \
  && mv -v ttf/*.ttf ~/.local/share/fonts/Hack \
  && fc-cache -f -v

  # Install tooling
  RUN mkdir ~/bin \
  && mv /home/${USER_NAME}/.zshrc /home/${USER_NAME}/.zshrc-ohmy-original \
  && mv -v /home/$USER_NAME/tooling.sh /home/$USER_NAME/bin/tooling.sh \
  && zsh /home/$USER_NAME/bin/tooling.sh \
  && mv -v /tmp/aws-iam-authenticator ~/bin \
  && mv -v /tmp/eksctl ~/bin \
  && mv -v /tmp/kubectl ~/bin \
  && mv -v /tmp/terraform ~/bin \
  && mv -v /tmp/linux-amd64/helm ~/bin \
  && mv -v /tmp/linux-amd64/tiller ~/bin \
  && chmod 0755 ~/bin/*

  # Add zshrc profile
  ADD zshrc /home/${USER_NAME}/.zshrc
  
  # Clean up install
  RUN rm -rfv ~/Hack-v3.003-ttf.zip ttf \
  && rm -rfv /tmp/terraform.zip /tmp/linux-amd64 \
  && unset ${USER_PASSWORD}

  # Start zsh
  CMD [ "zsh" ]
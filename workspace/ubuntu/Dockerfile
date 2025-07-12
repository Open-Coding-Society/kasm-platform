FROM kasmweb/ubuntu-jammy-desktop:1.14.0-rolling
USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

### Envrionment config
ENV DEBUG=false \
    DEBIAN_FRONTEND=noninteractive \
    SKIP_CLEAN=true \
    KASM_RX_HOME=$STARTUPDIR/kasmrx \
    DONT_PROMPT_WSL_INSTALL="No_Prompt_please" \
    INST_DIR=$STARTUPDIR/install \
    INST_SCRIPTS="/ubuntu/install/tools/install_tools.sh \
                  /ubuntu/install/chrome/install_chrome.sh \
                  /ubuntu/install/chromium/install_chromium.sh \
                  /ubuntu/install/sublime_text/install_sublime_text.sh \
                  /ubuntu/install/slack/install_slack.sh \
                  /ubuntu/install/vs_code/install_vs_code.sh \
                  /ubuntu/install/postman/install_postman.sh \
                  /ubuntu/install/cleanup/cleanup.sh \
                  /ubuntu/install/standard/custom_install.sh"

# Copy install scripts
COPY ./src/ $INST_DIR
# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  rm -f /etc/X11/xinit/Xclients && \
  rm -Rf ${INST_DIR}

# post install scripts
RUN echo "Running VSCode extension install scripts"
RUN code --user-data-dir /root/.vscode --no-sandbox --install-extension github.vscode-github-actions \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-python.python \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-azuretools.vscode-docker \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-vscode-remote.remote-containers \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension VisualStudioExptTeam.vscodeintellicode \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-toolsai.jupyter \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-toolsai.vscode-jupyter-cell-tags \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-toolsai.jupyter-keymap \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-python.vscode-pylance \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-python.debugpy \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension yy0931.vscode-sqlite3-editor


# install docker for ubuntu
RUN sudo apt-get update \
  && sudo apt-get update \
  && sudo apt-get install ca-certificates curl \
  && sudo install -m 0755 -d /etc/apt/keyrings \
  && sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
  && sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update


RUN sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

RUN echo "alias code='code --no-sandbox'" >> ~/.bashrc
RUN . ~/.bashrc

########## End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME


USER 1000
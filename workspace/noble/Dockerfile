FROM kasmweb/ubuntu-noble-desktop:1.17.0-rolling-weekly
USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
ENV INST_SCRIPTS=$STARTUPDIR/install
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
                  /ubuntu/install/docker/install_docker.sh \
                  /ubuntu/install/postman/install_postman.sh \
                  /ubuntu/install/cleanup/cleanup.sh \
                  /ubuntu/install/standard/custom_install.sh"

# Copy install scripts
COPY shared/src/ $INST_DIR
COPY noble/src/ $INST_DIR

# Copy shared scripts to /usr/bin for execution
COPY shared/src/ubuntu/install/common_env/setup_python_envs.sh /usr/bin/
COPY shared/src/ubuntu/install/common_env/setup_ruby_gems.sh /usr/bin/
COPY shared/src/ubuntu/install/common_env/configure_shell.sh /usr/bin/
RUN chmod +x /usr/bin/setup_python_envs.sh /usr/bin/setup_ruby_gems.sh /usr/bin/configure_shell.sh
# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT} || exit 1; \
  done && \
  rm -f /etc/X11/xinit/Xclients && \
  rm -Rf ${INST_DIR}

########## End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
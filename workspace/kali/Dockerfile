FROM kasmweb/kali-rolling-desktop:1.17.0-rolling-weekly
USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND=noninteractive \
    SKIP_CLEAN=true \
    KASM_RX_HOME=$STARTUPDIR/kasmrx \
    DONT_PROMPT_WSL_INSTALL="No_Prompt_please" \
    INST_DIR=$STARTUPDIR/install \
    INST_SCRIPTS="/ubuntu/install/kali/install_kali.sh \
                  /ubuntu/install/tools/install_tools.sh \
                  /ubuntu/install/chrome/install_chrome.sh \
                  /ubuntu/install/chromium/install_chromium.sh \
                  /ubuntu/install/slack/install_slack.sh \
                  /ubuntu/install/vs_code/install_vs_code.sh \
                  /ubuntu/install/docker/install_docker.sh \
                  /ubuntu/install/postman/install_postman.sh \
                  /ubuntu/install/common_env/install_env.sh \
                  /ubuntu/install/cleanup/cleanup.sh"
# Educational Note: 
# - install_env.sh runs AFTER tools are installed (dependency order)
# - cleanup.sh runs LAST to clean up temporary files and caches

# Copy install scripts
COPY shared/src/ $INST_DIR
COPY kali/src/ $INST_DIR

# Copy shared scripts to /usr/bin for execution
# 
# 🎯 KASM OPTIMIZATION: These scripts significantly reduce persistent storage usage
# by pre-installing development environments during image build rather than 
# user-generating them at runtime. This approach:
#
# - Reduces S3 storage costs by ~10K files per user environment
# - Eliminates Ruby Gem and Python Pip package overhead in user storage
# - Faster image downloads and container startup
# - Consistent environments across different base images
# - Centralized maintenance and updates of development toolchains
# - Ready-to-use GitHub Pages (Jekyll) and Python (Flask/Jupyter) environments
#
# Core Development Environment Scripts:
COPY shared/src/ubuntu/install/common_env/install_python_requirements.sh /usr/bin/
COPY shared/src/ubuntu/install/common_env/install_ruby_gems.sh /usr/bin/
COPY shared/src/ubuntu/install/common_env/install_system_bash.sh /usr/bin/
COPY shared/src/ubuntu/install/common_env/configure_user_bash.sh /usr/bin/

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT} || exit 1; \
  done && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  /usr/bin/configure_user_bash.sh && \
  rm -Rf ${INST_DIR}

########## End Customizations ###########

# Userspace Runtime
ENV HOME=/home/kasm-user
WORKDIR $HOME
USER 1000

CMD ["--tail-log"]
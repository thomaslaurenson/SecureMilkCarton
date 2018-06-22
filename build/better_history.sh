# Custom history configuration
# Run script using:
# chmod u+x better_history.shopt
# ./better_history.sh

echo ">>> Starting"
echo ">>> Loading configuration into /etc/bash.bashrc"
echo "HISTTIMEFORMAT='%F %T '" >> /etc/bash.bashrc
echo 'HISTFILESIZE=-1' >> /etc/bash.bashrc
echo 'HISTSIZE=-1' >> /etc/bash.bashrc
echo 'HISTCONTROL=ignoredups' >> /etc/bash.bashrc
echo 'HISTIGNORE=?:??' >> /etc/bash.bashrc
echo 'shopt -s histappend                 # append to history, dont overwrite it' >> /etc/bash.bashrc
echo '# attempt to save all lines of a multiple-line command in the same history entry' >> /etc/bash.bashrc
echo 'shopt -s cmdhist' >> /etc/bash.bashrc
echo '# save multi-line commands to the history with embedded newlines' >> /etc/bash.bashrc
echo 'shopt -s lithist' >> /etc/bash.bashrc
echo '# After each command, append to the history file and reread it' >> /etc/bash.bashrc
echo 'export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"' >> /etc/bash.bashrc

# Reload BASH for settings to take effect
echo ">>> Reloading BASH"
exec "$BASH"

echo ">>> Finished. Exiting"
exit 1
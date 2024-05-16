#! bash oh-my-bash.module
SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${_omb_prompt_bold_brown}✗${_omb_prompt_normal}"
SCM_THEME_PROMPT_CLEAN=" ${_omb_prompt_bold_green}✓${_omb_prompt_normal}"
SCM_GIT_CHAR="${_omb_prompt_bold_green}±${_omb_prompt_normal}"
SCM_SVN_CHAR="${_omb_prompt_bold_teal}⑆${_omb_prompt_normal}"
SCM_HG_CHAR="${_omb_prompt_bold_brown}☿${_omb_prompt_normal}"

#Mysql Prompt
export MYSQL_PS1="(\u@\h) [\d]> "

case $TERM in
        xterm*)
        TITLEBAR="\[\033]0;\w\007\]"
        ;;
        *)
        TITLEBAR=""
        ;;
esac

function generate_emoji_gibberish() {
  emojis=("🐒" "👻" "👽" "🎃" "🤡" "🐙" "🍕" "🚀" "🌛" "💀" "🐛" "💩" "🐀" "🪳" "🤢"
          "🦠" "🧟" "👹" "👺" "🦑" "🦍" "🦧" "🦨" "🦡" "🐧" "🕷 " "🕸 " "🦂" "🦗" "🦟"
          "🐍" "🦎" "🦖" "🦕" "🐊" "🐡" "🐠" "🐙" "🦑" "🦐" "🦀" "🐝" "🦋" "🐌" "🐞"
          "🐜" "🦗" "🪲" "🪳" "🦠" "🌵" "🎍" "🍄" "🌾" "🌿" "🍃" "🍂" "🍁" "🍀" "🎃"
          "🦇" "🌑" "🌒" "🌓" "🌔" "🌕" "🌖" "🌗" "🌘" "🌙" "🌚" "🌝" "🌛" "🌜" "🌡 "
          "💧" "🧃" "🍵" "🧊" "🛢 " "🪓" "🗡 " "🛡 " "⚰️" "🪦" "🏺" "🔮" "🕯 " "🪔" "📜"
          "🪙" "📯" "🎭" "🧩" "🧬" "🧪" "🧫" "🧯" "🔬" "🔭" "📡" "💊" "💉" "🦠" "🧼"
          "🧴" "🚽" "🚰" "🪠" "🛁" "🛀" "🧽" "🧺" "🧻" "🚪" "🪤" "🪒" "🧹" "🧷" "🔩") # Array of emojis
  gibberish=""
  for ((i=0; i<$1; i++)); do
    random_emoji=${emojis[$RANDOM % ${#emojis[@]}]}
    gibberish+=$random_emoji
  done
  echo $gibberish
}

PS3=">> "

function __my_rvm_ruby_version {
    local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
    local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
    local full="$version$gemset"
  [ "$full" != "" ] && echo "[$full]"
}

function is_vim_shell {
        if [ ! -z "$VIMRUNTIME" ]
        then
                echo "[${_omb_prompt_teal}vim shell${_omb_prompt_normal}]"
        fi
}

function modern_scm_prompt {
        CHAR=$(scm_char)
        if [ $CHAR = $SCM_NONE_CHAR ]
        then
                return
        else
                echo "[$(scm_char)][$(scm_prompt_info)]"
        fi
}

# show chroot if exist
function chroot {
    if [ -n "$debian_chroot" ]
    then
        my_ps_chroot="${_omb_prompt_bold_teal}$debian_chroot${_omb_prompt_normal}";
        echo "($my_ps_chroot)";
    fi
    }

# show virtualenvwrapper
function my_ve {
    if [ -n "$VIRTUAL_ENV" ]
    then
        my_ps_ve="${_omb_prompt_bold_purple}$ve${_omb_prompt_normal}";
        echo "($my_ps_ve)";
    fi
    echo "";
    }

function _omb_theme_PROMPT_COMMAND {

    my_ps_host="${_omb_prompt_green}\h${_omb_prompt_normal}";
    # yes, these are the the same for now ...
    my_ps_host_root="${_omb_prompt_green}\h${_omb_prompt_normal}";

    my_ps_user="${_omb_prompt_bold_green}\u${_omb_prompt_normal}"
    my_ps_root="${_omb_prompt_bold_brown}\u${_omb_prompt_normal}";

    if [ -n "$VIRTUAL_ENV" ]
    then
        ve=`basename $VIRTUAL_ENV`;
    fi
    source /home/berkshiregrey.com/jamison.blose/.kube-ps1.sh
# export PS1=$PS1$(kube_ps1)
    # nice prompt
    case "`id -u`" in
        0) PS1="${TITLEBAR}┌─$(my_ve)$(chroot)[$my_ps_root][$my_ps_host_root]$(modern_scm_prompt)$(__my_rvm_ruby_version)[${_omb_prompt_teal}\w${_omb_prompt_normal}]$(is_vim_shell)$(kube_ps1)
└─$(generate_emoji_gibberish 1) "
        ;;
        *) PS1="${TITLEBAR}┌─$(my_ve)$(chroot)[$my_ps_user][$my_ps_host]$(modern_scm_prompt)$(__my_rvm_ruby_version)[${_omb_prompt_teal}\w${_omb_prompt_normal}]$(is_vim_shell)$(kube_ps1)
└─$(generate_emoji_gibberish 1) "
        ;;
    esac
}

PS2="└─$(generate_emoji_gibberish 1) "



_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND

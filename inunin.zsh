#!/usr/bin/env zsh
#
# inunin - Installer/uninstaller for zsh.
#
# <https://github.com/macie/inunin>
# Copyright (c) 2018 Maciej Żok
# MIT License (http://opensource.org/licenses/MIT)


inunin() (
  _help() (
    echo 'Usage: inunin COMMAND [ARGS]'
    echo
    echo 'Commands:'
    echo '  install     Install component'
    echo '  uninstall   Uninstall component'
  )

  _is_exist() (
    local -r FILENAME="$1"
    test -e ${FILENAME}
  )

  install() (
    _init() (
      local -r DEST="$1"
      if ! _is_exist ${DEST} ; then
        mkdir -p ${DEST}
      fi
    )

    _help() (
      echo 'Usage: install COMPONENT DEST'
      echo
      echo 'Components:'
      echo '  antigen   Antigen plugin manager for zsh'
      echo '  fonts     Custom fonts for terminal'
    )

    _notify() (
      local -r COMMAND="$1"
      local -r NAME="${funcstack[2]}"

      echo -n " → Installing ${NAME}... "
      ${COMMAND}
      echo 'done!'
    )

    antigen() (
      local antigen_source="$1/antigen.zsh"

      if ! _is_exist ${antigen_source}; then
        _notify $(
          curl -sS -L git.io/antigen > ${antigen_source}
          chmod +x ${antigen_source}
        )
      fi
    )

    fonts() (
      local font_source="$1/Fura_Mono_Medium_Nerd_Font_Complete.otf"

      if ! _is_exist ${font_source}; then
        _notify $(
          curl -sS -L https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraMono/Medium/complete/Fura%20Mono%20Medium%20Nerd%20Font%20Complete.otf > ${font_source}
          fc-cache
        )
      fi
    )

    if [[ "$#" = 2 ]]; then
      local -r COMMAND="$1"
      local -r DEST="$2"
      _init ${DEST}
      ${COMMAND} ${DEST}
    else
      echo 'Error: invalid usage'
      _help
      exit 64  # command line usage error (via /usr/include/sysexits.h)
    fi
  )

  uninstall() (
    _help() (
      echo 'Usage: uninstall COMPONENT DEST'
      echo
      echo 'Components:'
      echo '  antigen   Antigen plugin manager for zsh'
      echo '  fonts     Custom fonts for terminal'
    )

    _notify() (
      local -r COMMAND="$1"
      local -r NAME="${funcstack[2]}"

      echo -n " → Uninstalling ${NAME}... "
      ${COMMAND}
      echo 'done!'
    )

    antigen() (
      local antigen_source="$1/antigen.zsh"

      _notify $(
        rm ${antigen_source}
      )
    )

    fonts() (
      local font_source="$1/Fura_Mono_Medium_Nerd_Font_Complete.otf"

      _notify $(
        rm ${font_source}
        fc-cache
      )
    )

    if [[ "$#" = 2 ]]; then
      local -r COMMAND="$1"
      local -r DEST="$2"
      ${COMMAND} ${DEST}
    else
      echo 'Error: invalid usage'
      _help
      exit 64  # command line usage error (via /usr/include/sysexits.h)
    fi
  )

  $@
)

# Bash completion for Pi session imports. Source from ~/.bashrc.
_pi_import_project_sessions_complete() {
  local cur device repo_root
  cur=${COMP_WORDS[COMP_CWORD]}
  repo_root="$HOME/pi-sessions"

  case $COMP_CWORD in
    1)
      COMPREPLY=( $(compgen -W "$(find "$repo_root/sessions" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null)" -- "$cur") )
      ;;
    2)
      device=${COMP_WORDS[1]}
      COMPREPLY=( $(compgen -W "$(find "$repo_root/sessions/$device" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null)" -- "$cur") )
      ;;
    3)
      COMPREPLY=( $(compgen -W '--dry-run' -- "$cur") )
      ;;
  esac
}

# Support both the convenient PATH command and the absolute-path form.
complete -F _pi_import_project_sessions_complete import-project-sessions
complete -F _pi_import_project_sessions_complete "$HOME/pi-sessions/bin/import-project-sessions"

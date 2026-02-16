# Bash completions for the dev command
# Sourced by ~/.bashrc

_dev_completions() {
	local cur prev words cword
	_init_completion || return

	# Top-level commands
	local commands="run env backup restore secrets tui help"

	case "$cword" in
		1)
			COMPREPLY=($(compgen -W "$commands" -- "$cur"))
			return
			;;
	esac

	local cmd="${words[1]}"

	case "$cmd" in
		env)
			COMPREPLY=($(compgen -W "deploy capture update diff compare doctor --dry --help" -- "$cur"))
			;;
		backup)
			COMPREPLY=($(compgen -W "--dry --sync --verify --keep --jobs --ssd --help" -- "$cur"))
			;;
		restore)
			COMPREPLY=($(compgen -W "--dry --from --pick --jobs --ssd --help" -- "$cur"))
			;;
		secrets)
			if [[ $cword -eq 2 ]]; then
				COMPREPLY=($(compgen -W "ssh env claude migrate alias --health --diff --list --help" -- "$cur"))
			else
				local subcmd="${words[2]}"
				case "$subcmd" in
					ssh)
						COMPREPLY=($(compgen -W "backup restore list copy-id --bw --dry" -- "$cur"))
						;;
					env)
						COMPREPLY=($(compgen -W "backup restore list --bw --dry" -- "$cur"))
						;;
					claude)
						COMPREPLY=($(compgen -W "backup restore list --bw --dry" -- "$cur"))
						;;
					migrate)
						COMPREPLY=($(compgen -W "all ssh env claude" -- "$cur"))
						;;
					alias)
						COMPREPLY=($(compgen -W "set list remove" -- "$cur"))
						;;
				esac
			fi
			;;
		run)
			# Dynamic: list runs/ scripts + flags
			local _config="${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/config"
			local _dev_env=""
			if [[ -f "$_config" ]]; then
				_dev_env="$(grep '^DEV_ENV_PATH=' "$_config" 2>/dev/null | head -1 | cut -d= -f2-)"
				_dev_env="${_dev_env#\"}"
				_dev_env="${_dev_env%\"}"
			fi
			local run_scripts=""
			if [[ -n "$_dev_env" && -d "$_dev_env/runs" ]]; then
				run_scripts="$(command ls "$_dev_env/runs" 2>/dev/null)"
			fi
			COMPREPLY=($(compgen -W "$run_scripts --dry --env --help" -- "$cur"))
			;;
		tui)
			COMPREPLY=($(compgen -W "--run --list --help" -- "$cur"))
			;;
	esac
}

complete -F _dev_completions dev

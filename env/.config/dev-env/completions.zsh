# Zsh completions for the dev command
# Sourced by ~/.zshrc

_dev_completions() {
	local -a commands subcmds
	local curcontext="$curcontext" state

	# Top-level commands
	commands=(run env backup restore secrets tui help)

	if (( CURRENT == 2 )); then
		compadd -a commands
		return
	fi

	local cmd="${words[2]}"

	case "$cmd" in
		env)
			compadd deploy capture update diff compare doctor --dry --help
			;;
		backup)
			compadd -- --dry --sync --verify --keep --jobs --ssd --help
			;;
		restore)
			compadd -- --dry --from --pick --jobs --ssd --help
			;;
		secrets)
			if (( CURRENT == 3 )); then
				compadd ssh env claude migrate alias --health --diff --list --help
			else
				local subcmd="${words[3]}"
				case "$subcmd" in
					ssh)
						compadd backup restore list copy-id --bw --dry
						;;
					env)
						compadd backup restore list --bw --dry
						;;
					claude)
						compadd backup restore list --bw --dry
						;;
					migrate)
						compadd all ssh env claude
						;;
					alias)
						compadd set list remove
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
			local -a run_scripts
			if [[ -n "$_dev_env" && -d "$_dev_env/runs" ]]; then
				run_scripts=(${(f)"$(command ls "$_dev_env/runs" 2>/dev/null)"})
			fi
			compadd "${run_scripts[@]}" --dry --env --help
			;;
		tui)
			compadd -- --run --list --help
			;;
	esac
}

compdef _dev_completions dev

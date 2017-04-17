#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

default_key_bindings_goto="g"
tmux_option_goto="@sessionist-goto"

default_key_bindings_alternate="S"
tmux_option_alternate="@sessionist-alternate"

default_key_bindings_new="C"
tmux_option_new="@sessionist-new"

default_key_bindings_promote_pane="@"
tmux_option_promote_pane="@sessionist-promote-pane"

default_key_bindings_kill_session="X"
tmux_option_kill_session="@sessionist-kill-session"

source "$CURRENT_DIR/scripts/helpers.sh"

# Multiple bindings can be set. Default binding is "g".
set_goto_session_bindings() {
	local key_bindings=$(get_tmux_option "$tmux_option_goto" "$default_key_bindings_goto")
	local key
	for key in $key_bindings; do
		tmux bind "$key" run "$CURRENT_DIR/scripts/goto_session.sh"
	done
}

set_alternate_session_binding() {
	local key_bindings=$(get_tmux_option "$tmux_option_alternate" "$default_key_bindings_alternate")
	local key
	for key in $key_bindings; do
		# switch to the last/alternate session
		tmux bind "$key" switch-client -l
	done
}

# Prompt for creating a new session. If the session with the same name exists,
# it will switch to existing session.
set_new_session_binding() {
	local key_bindings=$(get_tmux_option "$tmux_option_new" "$default_key_bindings_new")
	local key
	for key in $key_bindings; do
		tmux bind "$key" run "$CURRENT_DIR/scripts/new_session_prompt.sh"
	done
}

# "Promote" the current pane to a new session
set_promote_pane_binding() {
	local key_bindings=$(get_tmux_option "$tmux_option_promote_pane" "$default_key_bindings_promote_pane")
	local key
	for key in $key_bindings; do
		tmux bind "$key" run "$CURRENT_DIR/scripts/promote_pane.sh '#{session_name}' '#{pane_id}' '#{pane_current_path}'"
	done
}

set_kill_session_binding() {
	local key_bindings=$(get_tmux_option "$tmux_option_kill_session" "$default_key_bindings_kill_session")
	local key
	for key in $key_bindings; do
		tmux bind "$key" run "$CURRENT_DIR/scripts/kill_session_prompt.sh '#{session_name}' '#{session_id}'"
	done
}

main() {
	set_goto_session_bindings
	set_alternate_session_binding
	set_new_session_binding
	set_promote_pane_binding
	set_kill_session_binding
}
main

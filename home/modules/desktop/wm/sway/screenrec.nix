{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  screenrec = pkgs.writeShellApplication {
    name = "screenrec";
    runtimeInputs = with pkgs; [
      ffmpeg
      wl-screenrec
      killall
      libnotify
    ];
    text = # bash
      ''
        fifo_path="/tmp/screenrec"

        # not the initial value, it's actually the value to use after the first toggle
        recording=true
        rec_file="$HOME/Videos/recording_tmp.mp4"
        rec_started=""
        rec_pid=""
        rec_args=""
        rec_history="15"

        reset_rec() {
          if [ -n "$rec_pid" ]; then
            # should never happen, but just in case
            kill -INT "$rec_pid"
          fi
          if [ -f "$rec_file" ]; then
            echo "Error: file $rec_file already exists!"
            exit 1
          fi
          wl-screenrec --history "$rec_history" --filename "$rec_file" "''${rec_args[@]}" > /dev/null &
          rec_pid="$!"
        }

        record() {
          if [[ "$recording" = true ]]; then
            kill -USR1 "$rec_pid"
            notify-send "Starting screen recording from the last $rec_history seconds" -t 1000
            rec_started=$(date +"%Y-%m-%dT%H:%M:%S")
            recording=false
          else
            kill -INT "$rec_pid"
            rec_pid=""
            output_file="$HOME/Videos/screenrec_''${rec_started}.mp4"
            mv "$rec_file" "$output_file"
            wl-copy -t text/uri-list <<< "file://$output_file"
            notify-send "Recording saved to $output_file and copied to clipboard." -t 1000
            reset_rec
            recording=true
          fi
        }

        read_args() {
          while [ "$1" != "--" ] && [ "$#" -gt 0 ]; do
            case $1 in
              "--history"|"-h")
                if [[ -n $2 && ! $2 =~ ^-- ]]; then
                    rec_history=$2
                    shift
                else
                    echo "Error: --history requires a value"
                    exit 1
                fi
                ;;
            esac
            shift
          done
          if [ "$1" == "--" ]; then
            shift
            rec_args=( "$@" )
          fi
        }

        cleanup() {
          # shellcheck disable=SC2317
          echo 0 > "$fifo_path" & # it's blocking, so it won't be able to read unless with &
        }

        daemon() {
          read_args "$@"
          if [[ -p $fifo_path ]]; then
            echo "Daemon is already running!"
            exit 1
          fi
          reset_rec
          mkfifo $fifo_path
          trap cleanup INT TERM
          while true; do
            if read -r line < "$fifo_path"; then
              if [[ "$line" == "1" ]]; then
                record
              elif [[ "$line" == "0" ]]; then
                if [ -n "$rec_pid" ]; then
                  kill -INT "$rec_pid"
                fi
                rm -f "$fifo_path"
                rm "$rec_file"
                exit 0
              fi
            fi
            sleep 0.1
          done
        }

        toggle() {
          if [[ -p "$fifo_path" ]]; then
            echo 1 > "$fifo_path"
          else
            echo "Error: daemon is not running!"
            exit 1
          fi
        }

        stop_daemon() {
          if [[ -p "$fifo_path" ]]; then
            cleanup
          else
            echo "Error: daemon is not running!"
            exit 1
          fi
        }

        script_help() {
          printf "%b" "$(cat <<EOF
        Wrapper around wl-screenrec to easily record the last few seconds and copy the video to the clipboard

        \e[1;4mUsage:\e[0m
          \e[1mscreenrec --help, -h\e[0m
            Show this help text
          \e[1mscreenrec --daemon <options> -- <args>\e[0m
            Start the daemon. This should always run in the background while your wayland session is running.
            <args> are passed directly to wl-screenrec.
            Available options are:
            \e[1m--history, -h\e[0m
              How many seconds of history to keep
              Default: 15
          \e[1mscreenrec --stop-daemon\e[0m
            Stop the daemon.
          \e[1mscreenrec --toggle\e[0m
            Start / stop the recording. This will include the last 15 seconds.
        EOF
        )"
        }

        case "''${1:-}" in
          "--daemon")
            daemon "$@"
            exit 0
            ;;
          "--stop-daemon")
            stop_daemon
            exit 0
            ;;
          "--toggle")
            toggle
            exit 0
            ;;
          "-h"|"--help"|*)
            script_help
            exit 0
            ;;
        esac
      '';
  };
in
lib.mkIf config.settings.wm.sway.enable {
  home.packages = [ screenrec ];
  wayland.windowManager.sway.config =
    let
      conf = config.wayland.windowManager.sway.config;
      mod = conf.modifier;
    in
    {
      keybindings = {
        "${mod}+Alt+r" = "exec ${lib.getExe screenrec} --toggle";
      };
      startup = [
        {
          command = "${lib.getExe screenrec} --daemon -h 15 -- --low-power off --output HDMI-A-1 --audio --bitrate \"2 MB\"";
        }
      ];
    };
}

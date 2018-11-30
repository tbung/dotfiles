# fkill - kill process
function fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}
function gi() { curl -L -s https://www.gitignore.io/api/$@; }  # gitignore.io cli
function chrome-app() { google-chrome-stable --app="$1"; }

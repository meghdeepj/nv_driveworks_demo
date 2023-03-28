#!/usr/bin/env bash

cmd=$(which tmux) # tmux path
session=gwdocker # session name

if [ -z $cmd ]; then
    echo "You need to install tmux."
    exit 1
fi

$cmd has -t $session

if [ $? != 0 ]; then
    $cmd new -s $session -d -n git

    $cmd neww -n dwcgf -t $session -d
    $cmd neww -n dwnvsci -t $session -d
    $cmd neww -n dwimage -t $session -d
    $cmd neww -n nvsci -t $session -d
    $cmd neww -n nvmedia -t $session -d
    $cmd neww -n temp -t $session -d

    $cmd splitw -v -p 50 -t $session:git
    $cmd splitw -h -p 50 -t $session:git

    $cmd splitw -v -p 50 -t $session:dwcgf
    $cmd splitw -h -p 50 -t $session:dwcgf
    $cmd splitw -h -p 50 -t $session:dwcgf

    $cmd splitw -v -p 50 -t $session:dwnvsci
    $cmd splitw -h -p 50 -t $session:dwnvsci
    $cmd splitw -h -p 50 -t $session:dwnvsci

    $cmd splitw -v -p 50 -t $session:dwimage
    $cmd splitw -h -p 50 -t $session:dwimage
    $cmd splitw -h -p 50 -t $session:dwimage

    $cmd splitw -v -p 50 -t $session:nvmedia
    $cmd splitw -h -p 50 -t $session:nvmedia
    $cmd splitw -h -p 50 -t $session:nvmedia

    $cmd splitw -v -p 50 -t $session:nvsci
    $cmd splitw -h -p 50 -t $session:nvsci
    $cmd splitw -h -p 50 -t $session:nvsci

    $cmd select-window -t $session:git
    # $cmd select-layout tiled
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t ${_pane} "./docker/build/docker_into.sh" ENTER
        # tmux send-keys -t ${_pane} "source ./tools/zs.bashrc" ENTER
    done

    $cmd select-window -t $session:dwcgf
    $cmd select-layout tiled
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t ${_pane} "./docker/build/docker_into.sh" ENTER
        # tmux send-keys -t ${_pane} "source ./tools/zs.bashrc" ENTER
        # tmux send-keys -t ${_pane} "source ./data/install/setup.bash" ENTER
    done

    $cmd select-window -t $session:dwnvsci
    $cmd select-layout tiled
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t ${_pane} "./docker/build/docker_into.sh" ENTER
        # tmux send-keys -t ${_pane} "source ./tools/zs.bashrc" ENTER
        # tmux send-keys -t ${_pane} "source ./data/install/setup.bash" ENTER
    done

    $cmd select-window -t $session:dwimage
    $cmd select-layout tiled
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t ${_pane} "./docker/build/docker_into.sh" ENTER
        # tmux send-keys -t ${_pane} "source ./tools/zs.bashrc" ENTER
        # tmux send-keys -t ${_pane} "source ./data/install/setup.bash" ENTER
    done

    $cmd select-window -t $session:nvmedia
    $cmd select-layout tiled
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t ${_pane} "./docker/build/docker_into.sh" ENTER
        # tmux send-keys -t ${_pane} "source ./tools/zs.bashrc" ENTER
        # tmux send-keys -t ${_pane} "source ./data/install/setup.bash" ENTER
    done

    $cmd select-window -t $session:nvsci
    $cmd select-layout tiled
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t ${_pane} "./docker/build/docker_into.sh" ENTER
        # tmux send-keys -t ${_pane} "source ./tools/zs.bashrc" ENTER
        # tmux send-keys -t ${_pane} "source ./data/install/setup.bash" ENTER
    done

    $cmd select-window -t $session:git

else

echo "Tmux session:$session exist, attach to."
$cmd att -t $session

fi

$cmd att -t $session

exit 0

#kill
#tmux kill-session -t zswork

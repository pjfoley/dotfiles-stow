#!/usr/bin/env bash
#
# Bash completion script for VBoxManage
#
# Copyright (c) 2012, Thomas Malt <thomas@malt.no>
# Copyright (c) 2015, Benjamin Gandon <https://github.com/bgandon>
#

complete -F _vboxmanage 'vboxmanage'
complete -F _vboxmanage VBoxManage

# export VBOXMANAGE_NIC_TYPES

_vboxmanage() {
    local cur prev opts

    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # echo "cur: |$cur|"
    # echo "prev: |$prev|"

    case $prev in
        # DEVELOPERS: here the commands are listed in alphabetical order
        #             so that it can stay consistent
        -v|--version)
            return 0
            ;;
        controlvm)
            opts=$(__vboxmanage_list-running-vms)
            COMPREPLY=($(compgen -W "$opts" -- $cur))
            return 0
            ;;
        getextradata|setextradata|showvminfo)
            opts=$(__vboxmanage_list-all-vms)
            if [[ $prev =~ [gs]etextradata ]]; then
                opts="$opts global"
            fi
            COMPREPLY=($(compgen -W "$opts" -- $cur))
            return 0
            ;;
        modifyvm|startvm|unregistervm)
            opts=$(__vboxmanage_list-stopped-vms)
            COMPREPLY=($(compgen -W "$opts" -- $cur))
            return 0
            ;;
        list)
            opts=$(__vboxmanage_list)
            COMPREPLY=($(compgen -W "$opts" -- $cur))
            return 0
            ;;
        registervm)
            # It's quite hard to manage sapces in filenames and tilde exampansion
            # But the _filedir function in /etc/bash_completion does this for us.
            # On Debian: /usr/share/bash-completion/bash_completion
            # On OSX with Homebrew: /usr/local/etc/bash_completion
            #
            # See: <http://unix.stackexchange.com/a/77048>
            _filedir vbox
            return 0
            ;;
        vboxmanage|VBoxManage)
            opts="$(__vboxmanage_default)"
            COMPREPLY=($(compgen -W "$opts" -- $cur))
            return 0
            ;;
    esac

    local pprev=${COMP_WORDS[COMP_CWORD-2]}
    # echo "previous: $pprev"
    case $pprev in
        getextradata|setextradata)
            local context="$prev"
            opts="$(__vboxmanage_list-keys "$context")"
            if [ $pprev = getextradata ]; then
                opts="$opts enumerate"
            fi
            COMPREPLY=($(compgen -W "$opts" -- $cur))
            return 0
            ;;
        list)
            case $prev in
                -l|--long)
                    opts=$(__vboxmanage_list -l --long)
                    COMPREPLY=($(compgen -W "$opts" -- $cur))
                    return 0
                    ;;
            esac
            ;;
        vboxmanage|VBoxManage)
            case $prev in
                -q|--nologo)
                    opts="$(__vboxmanage_default -q --nologo)"
                    COMPREPLY=($(compgen -W "$opts" -- $cur))
                    return 0
                    ;;
            esac
            ;;
    esac

    if echo " " $(__vboxmanage_list-all-vms) " " | grep -Fq " $prev "; then
        local VM="$prev"
        case $pprev in
            startvm)
                COMPREPLY=($(compgen -W "--type" -- $cur))
                return 0
                ;;
            controlvm)
                opts=$(__vboxmanage_controlvm $VM)
                COMPREPLY=($(compgen -W "$opts" -- $cur))
                return 0;
                ;;
            showvminfo)
                opts="--details --machinereadable --log"
                COMPREPLY=($(compgen -W "$opts" -- $cur))
                return 0;
                ;;
            modifyvm)
                opts=$(__vboxmanage_modifyvm)
                COMPREPLY=($(compgen -W "$opts" -- $cur))
                return 0
                ;;
        esac
    # else
    #     echo "'$prev' not in '$(__vboxmanage_list-all-vms)'"
    fi

    local ppprev=${COMP_WORDS[COMP_CWORD-2]}
    case $ppprev in
        controlvm)
            case $prev in
                nictrace*|setlinkstate*|videocap|vrde)
                    COMPREPLY=($(compgen -W "on off" -- $cur))
                    return 0
                    ;;
            esac
            ;;
        modifyvm)
            case $prev in
                --nic[1-8])
                    opts=$(__vboxmanage_list-nic-types)
                    COMPREPLY=($(compgen -W "$opts" -- $cur))
                    ;;
            esac
            ;;
        showvminfo)
            COMPREPLY=($(compgen -W "--details --log --machinereadable" -- $cur))
            return 0
            ;;
        startvm)
            case $prev in
                --type)
                    COMPREPLY=($(compgen -W "gui headless separate" -- $cur))
                    return 0
                    ;;
            esac
            ;;
        unregistervm)
            COMPREPLY=($(compgen -W "--delete" -- $cur))
            return 0
            ;;
    esac

    # echo "Got to end withoug completion"
}

function __vboxmanage_list-keys {
    local ctx="$1"
    VBoxManage getextradata "$ctx" enumerate | sed -ne 's/^Key: \([^,]*\), Value:.*$/\1/p'
}

__vboxmanage_list-nic-types() {
    VBoxManage \
        | grep -F ' nic<' \
        | sed -e 's/.*nic<1-N> \([a-z\|]*\).*/\1/' \
        | tr '|' ' '
}

function __vboxmanage_extract-vm-names {
    cut -d' ' -f1 | tr -d '"'
}

function __vboxmanage_list-all-vms {
    VBoxManage list vms | __vboxmanage_extract-vm-names
}

function __vboxmanage_list-running-vms {
    VBoxManage list runningvms | __vboxmanage_extract-vm-names
}

function __vboxmanage_exclude {
    local list="$1"
    local filtered word excluded excl_word
    for word in $list; do
        excluded=false
        for excl_word in "$@"; do
            if [ "$word" = "$excl_word" ]; then
                excluded=true
                break
            fi
        done
        if [ $excluded = false ]; then
            filtered="$filtered $word"
        fi
    done
    echo $filtered
}

function __vboxmanage_list-stopped-vms {
    __vboxmanage_exclude "$(__vboxmanage_list-all-vms)" $(__vboxmanage_list-running-vms)
}

__vboxmanage_list() {
    local opts=$(VBoxManage list | tr -s '\n[]|' ' ' | cut -d' ' -f4-)

    __vboxmanage_exclude "$opts" "$@"
}

__vboxmanage_controlvm() {
    local vm="$1"
    local opts=$( \
        VBoxManage controlvm \
            | grep '^                            [a-z]' \
            | sed -e 's/^ *\([a-z<1N>|-]\{1,\}\).*/\1/; s/\|$//' \
            | tr -d ' ' \
            | tr '|' '\n' \
    )
    local nic_or_nat_opts_pattern='^(setlinkstate|(nic|nat)[a-z]*)<1-N>'
    # NOTE: here we quote "$opts" in order to preserve newlines,
    #       which enables us to properly use 'grep' and 'grep -v'
    local nic_opts="setlinkstate $(echo "$opts" | grep -E "$nic_or_nat_opts_pattern" | sed -e 's/<1-N>//')"
    opts=$(echo "$opts" | grep -Ev "$nic_or_nat_opts_pattern")

    # setlinkstate<1-N> nic<1-N> nictrace<1-N> nictracefile<1-N> nicproperty<1-N> nicpromisc<1-N> natpf<1-N> natpf<1-N>
    local num nic_opt nic_cmds
    for num in $(__vboxmanage_list-active-nic-nums "$vm"); do
        for nic_opt in $nic_opts; do
            nic_cmds="$nic_cmds $nic_opt$num"
        done
    done

    echo $opts $nic_cmds | tr ' ' '\n' | sort | uniq
}

__vboxmanage_modifyvm() {
    local opts=$( \
        VBoxManage modifyvm \
            | grep -F '[--' \
            | grep -Fv '[--nic<' \
            | sed 's/ *\[--\([a-z-]*\).*/--\1/' \
            | sort \
    )
    # Exceptions
    for i in {1..8}; do
        opts="$opts --nic${i}"
    done
    echo $opts
}

function __vboxmanage_list-active-nic-nums {
    local vm="$1"
    VBoxManage showvminfo "$vm" --machinereadable \
        | awk '/^nic[1-8]=/ && ! /="none"$/' \
        | cut -d= -f1 \
        | sed -e 's/^nic//'
}

__vboxmanage_default() {
    local help_text=$(VBoxManage)
    # Note: the default sed in OS X only supports \{1,\} and not \+
    #       that's why we fallback to the latter here
    local opts=$(echo "$help_text" | sed -n -e 's/^ \{2\}\[\([a-z|-]\{1,\}\).*$/\1/p' | tr '|' ' ')
    local cmds=$(echo "$help_text" | sed -n -e 's/^ \{2\}\([a-z-]\{1,\}\).*$/\1/p' | uniq)
    __vboxmanage_exclude "$opts $cmds" "$@"
}

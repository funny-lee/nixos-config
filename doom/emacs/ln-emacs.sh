#! /usr/bin/env bash

##################################################################
# ln: make symbolic links
# -s --symbolic            软链接
# -f --force               强制覆盖
# -n --no-dereference
# -T 可以覆盖旧的软链目录，而不会在内部重复套娃
# -v --verbose             冗长显示输出结果
##################################################################

# this_dir=$(cd "$(dirname "$0")";pwd) #current dir
# this_dir=$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" ) #current dir
this_dir=$( dirname -- "$( readlink -f -- "$0"; )"; ) #current dir

# -e exists
if [[ ! -e "$HOME/.config/emacs" ]]; then
    mkdir "$HOME/.config/emacs"
fi

ln -sfTv "$this_dir"/elisp "$HOME"/.config/emacs/elisp
ln -sfv "$this_dir"/init.el "$HOME"/.config/emacs/init.el
ln -sfv "$this_dir"/early-init.el "$HOME"/.config/emacs/early-init.el

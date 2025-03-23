# source ~/.config/zsh/zshrc

for f in ~/.config/zsh/*; do
    if [ ! -d $f ]; then
        c=`echo $f | sed -e "s=.config/zshrc=.config/zsh/custom="`
        [[ -f $c ]] && source $c || source $f
    fi
done

if [ -f ~/.zshrc_custom ]; then
    source ~/.zshrc_custom
fi

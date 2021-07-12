send(){
    scp "$*" cheny36@openlab:~
}
receive(){
    scp "cheny36@openlab:"$1 .
}
Rmd(){
    Rscript -e "rmarkdown::render('"$1"')"
}
pRmd(){
    Rscript -e "rmarkdown::render('"$1"')"; open -a Preview "${1%.*}.pdf"
}
sextend(){
    ssh cheny36@openlab scontrol update jobid="$1" TimeLimit="$2"
}

alias retrieve="receive"
alias sacct="ssh cheny36@openlab sacct"
alias squeue="ssh cheny36@openlab squeue --me -l"
alias rls="clear; ls"
alias ls="ls -G"
alias cdd="cd ~/Desktop/Cummingslab/project/"
alias history="history | cut -c8- > ~/.history; vim ~/.history"
alias preview="open -a Preview "

export PS1="\u:\W "

export PATH=$PATH":/opt/local/bin"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/cheny/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/cheny/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/cheny/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/cheny/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

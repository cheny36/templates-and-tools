sendopenlab(){
    scp $* cheny36@openlab:~
}
send(){
    scp $* cheny36@lab:/fs/cbcb-scratch/cheny36/
}
receive(){
    if (( $# > 1 )); then
        IFS=,; var="$*"
        scp cheny36@lab:\{"$var"\} .
    else
        scp cheny36@lab:"$1" .
    fi
}
receiveOL(){
    if (( $# > 1 )); then
        IFS=,; var="$*"
        scp cheny36@openlab:\{"$var"\} .
    else
        scp cheny36@openlab:"$1" .
    fi
}
Rmd(){
    Rscript -e "rmarkdown::render('"$1"')"
}
pRmd(){
    Rscript -e "rmarkdown::render('"$1"')"; open -a Preview "${1%.*}.pdf"
}
fRmd(){
    Rscript -e "rmarkdown::render('"$1"')"; open -a Firefox "${1%.*}.html"
}
Rinstall(){
    sudo Rscript -e "devtools::install('"$1"')"
}
Rdocument(){
    Rscript -e "devtools::document()"
}
sextend(){
    ssh cheny36@openlab scontrol update jobid="$1" TimeLimit="$2"
}
templateRmd(){
    if [ $# -eq 0 ]; then
        cp ~/Documents/templates/template.Rmd .
    else
        cp ~/Documents/templates/template.Rmd ./"${1%.Rmd}.Rmd"
        mkdir -p ${1%Rmd}
        sed -i '' 's/Title/'${1%.Rmd}'/' ${1%.Rmd}.Rmd
    fi
}

alias retrieve="receive"
alias Finder="open -a Finder "
alias retrieveOL="receiveOL"
alias sacct="ssh cheny36@openlab sacct"
alias squeue="ssh cheny36@cbcb squeue --me -o \\'%8i %.14j %.5t %.10M %.5C %.7m %.6q %.9R\\'"
alias sq="ssh cheny36@cbcb squeue --me -o \\'%8i %.14j %.5t %.10M %.5C %.7m %.6q %.9R\\'"
alias rls="clear; ls"
alias ls="ls -G"
alias cdd="cd ~/Desktop/Cummingslab/"
alias cddd="cd ~/Desktop/RandomProjects/"
alias history="history | cut -c8- > ~/.history; vim ~/.history"
alias rfeRinstall='R -e "remotes::install_gitlab(\"rchou/rfe\", host=\"https://gitlab.umiacs.umd.edu\")"'
alias rfenewRinstall='R -e "remotes::install_gitlab(\"rchou/rfe_new\", host=\"https://gitlab.umiacs.umd.edu\")"'
alias preview="open -a Preview "
alias firefox="open -a Firefox "
alias msword="open -a 'Microsoft Word' "
alias rinstall="R CMD INSTALL "
alias R='R --no-save'
alias show_qos='cat ~/.qos'
alias finder='open -a Finder '
alias sshhosts='grep -e '^Host' ~/.ssh/config'

complete -f -X '*.un~' vim
complete -f -X '*.un~' ls
complete -f -X '!*.Rmd' Rmd
complete -f -X '*.un~' cd


export PS1="\u:\W "

export PATH=$PATH":/opt/local/bin"
export PATH=$PATH":/Users/cheny/Documents/scripts"
export PATH=$PATH":/Users/cheny/Library/Python/3.8/bin/"
export PATH=$PATH":/Applications/CMake.app/Contents/bin/"

export HISTTIMEFORMAT="%F %T "






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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

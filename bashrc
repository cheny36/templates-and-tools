export PS1="\u@\h:\w: "

# Loads
module load pandoc/1.17.0.3
module unload Python2
module unload Python
module load Python3/3.7.0
module load cuda/11.4.4

# R dependencies
module load gcc/8.1.0
module load libhdf5
module load pcre
module load texlive/2018
module load java
module load libblas
module load openblas
module load samtools
module load curl

# Completion

complete -f -X '!*.Rmd' Rmd
complete -f -X '!*.Rmd' Rmd.sh
complete -f -X '*.un~' ls
complete -f -X '*.un~' vim
complete -f -X '*.un~' cd


# Aliases
alias ml="module load"
alias free="free -h"
alias cdd="cd /fs/cbcb-scratch/cheny36/"
alias ls="ls --color -w80"
alias history="history | cut -c 8- > ~/.history; vim ~/.history"
alias squeue="squeue --me"
alias sq="squeue --me -o '%8i %.14j %.5t %.10M %.5C %.7m %.6q %.9R'"
alias rinstall="R CMD INSTALL "
alias seqstructRinstall='R -e "remotes::install_gitlab(\"cheny36/seqstruct\", host=\"https://gitlab.umiacs.umd.edu\")"'
alias rfeRinstall='R -e "remotes::install_gitlab(\"rchou/rfe\", host=\"https://gitlab.umiacs.umd.edu\")"'
alias R='R --no-save'
alias df='df -h ~; df -h /fs/cbcb-scratch/cheny36'
alias cudaenv='module load cuda/11.0.3; module load gcc/9.3.0; module load zlib; module load cmake/3.22.1'
alias copybash='cp ~/.bashrc ~/.bash_profile'
alias sacct='sacct --format=JobID,AveCPU,AvePages,AveRSS,MaxRSS,AveVMSize'
alias sstat='sstat --format=JobID,Pids,AveRSS,MaxRSS,MinCPU,AveCPU'
alias du="du -h"
alias Finder="open -a Finder "

# PATHS and other environment variables
export PATH=$PATH":/cbcbhomes/cheny36/tools"
export PATH=$PATH":/fs/cbcb-scratch/cheny36/tools/mmseqs/bin"
export GITLAB_PAT="gH6ModaC9cC857zX6uzv"
export PATH=$PATH:"/fs/cbcb-scratch/cheny36/.miniconda3/condabin"
export PATH=$PATH:"/cbcbhomes/cheny36/tools/ncbi-blast-2.13.0+/bin"

# R setup
export PATH=$PATH":/fs/cbcb-scratch/cheny36/.R/4.1.2/bin"
export CPATH=$CPATH":/fs/cbcb-scratch/cheny36/.R/4.1.2/include"
export LIBRARY_PATH=$LIBRARY_PATH":/fs/cbcb-scratch/cheny36/.R/4.1.2/lib"
export LD_RUN_PATH=$LD_RUN_PATH":/fs/cbcb-scratch/cheny36/.R/4.1.2/lib"
export R_LIBS="~/R/"


# Various Functions

bashcp(){
    if [ ~/.bashrc -nt ~/.bash_profile ]; then
        echo ".bashrc newer; copying .bashrc to .bash_profile"
        cp ~/.bash_profile ~/.bash_backup
        cp ~/.bashrc ~/.bash_profile
    else
        echo ".bash_profile newer; copying .bash_profile to .bashrc"
        cp ~/.bashrc ~/.bash_backup
        cp ~/.bash_profile ~/.bashrc
    fi
    source ~/.bash_profile
}

packup(){
    if [ ! -d "$1" ]; then
        echo 'directory does not exist'
        return
    fi 
    find $1 -type f -name '.*.un~' -delete #Remove the undo files
    name=${1%/}
    tar -cvzf ${name}.tgz $1 ${name}.Rmd ${name}.html
    realpath ${name}.tgz
}

cleanvim(){
    if [ -z "$1" ]; then
        var='.'
    else
        var="$1"
    fi
    find . -type f -name '.*.un~' -exec bash -c "i=\"{}\"; j=\${i//\/./\/}; if [ ! -f \${j%%.un~} ]; then echo \"removing {}\"; rm {}; fi" \;
}

psaux(){
    ps aux | grep -P "cheny36|%MEM" | grep -v 'R+\|S+\|Ss\|sleep 5' \
        | grep -v 'sshd:' \
        | awk '{gsub("/bin/.*memtracker.sh", "memtracker.sh", $0); print $0}' \
        | awk '{gsub("/fs/.*--file=", "", $0); print $0}'
}
alias psaux2='psaux | awk "\$8 !~ /^R$/{print}"'

sdinfo(){
    s\acct --format="JobId,MaxRSS,ReqMem,SystemCPU,Timelimit,ReqCPUS" -j $1
    sstat --format="AveCPU,AveRSS,AvePages,AveVMSize" -j $1 --allsteps
}

stdat(){
    VAR1=""
    for i in $(sq | tail -n+2 | grep -v 'bash' | awk '{print $1}'); do
        VAR1="${VAR1},${i}.batch"
    done
    sstat ${VAR1#,}
}

function show_qos {
    VAR1=$(sacctmgr show qos format="Name,MaxWall,MaxJobs,MaxTRES,MaxTRESPU,Priority,GrpCPUs")
    status=$?
    if [ $status -eq 0 ]; then
        echo "$VAR1"
    else
        cat ~/.qos
    fi
}

sqat(){
    VAR1=""
    VAR3=$(sq | grep 'bash')
    VAR4=$(sq | grep ' PD ')
    for i in $(sq | tail -n+2 | grep -v 'bash' | grep -v ' PD ' | awk '{print $1}'); do
        VAR1="${VAR1},${i}.batch"
    done
    VAR1=$(ss\tat --format=AveRSS,MaxRSS,MinCPU,AveCPU ${VAR1#,} | grep -v -- '----')
    VAR2=$(sq | grep -v 'bash' | grep -v ' PD ')
    paste <(echo "$VAR2") <(echo "$VAR1")
    [ ! -z "$VAR3" ] && echo "$VAR3"
    [ ! -z "$VAR4" ] && echo "$VAR4"
}

send(){
    scp $* cheny36@moleninja:~
}

sinteractive(){
    srun --pty --qos=throughput $* bash
}

sintgpu(){
    srun --pty --qos=gpu --partition=gpu $* --gres=gpu:gtx1080ti bash
}

Rinstall(){
    Rscript -e "devtools::install('"$1"')"
}
Rdocument(){
    Rscript -e "devtools::document()"
}

Rmd(){
    Rscript -e "rmarkdown::render('"$1"')"
}
templateRmd(){                                                                     
    if [ $# -eq 0 ]; then                                                          
        cp  ~/templates/template.Rmd .                                    
    else                                                                           
        cp  ~/templates/template.Rmd ./"${1%.Rmd}.Rmd"                    
        mkdir -p ${1%Rmd}                                                          
        sed -i 's/Title/'${1%.Rmd}'/' ${1%.Rmd}.Rmd                             
    fi                                                                             
}            


cdd

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/fs/cbcb-scratch/cheny36/.miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/fs/cbcb-scratch/cheny36/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/fs/cbcb-scratch/cheny36/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/fs/cbcb-scratch/cheny36/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Example running command with mem limit
#      systemd-run --scope -p MemoryMax=500M pdftoppm


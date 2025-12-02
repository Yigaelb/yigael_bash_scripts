#export PS1="\[\033[34m\]\w\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
export PS1="\[\033[01;32m\]\w\[\033[1;34m\]\$(parse_git_branch)\[\033[00m\] $ "
# Bash Color Codes - at bottom of screen or google :-)


#region simple alias
alias gits="git status"
alias gitf="git fetch"
alias gitc="git commit -m"
alias gdiff="git difftool --dir-diff --no-symlinks"
alias gdiffAdded="git difftool --dir-diff --no-symlinks --cached"
alias checkout="git checkout"
alias gamend="echo git commit --amend --no-edit && git commit --amend --no-edit"
alias gitamend="gamend"
alias cleanStaged="git restore ."

# Cross-platform clipboard helper
copy_to_clipboard() {
    if command -v clip.exe &> /dev/null; then
        clip.exe
    elif command -v xclip &> /dev/null; then
        xclip -selection clipboard
    elif command -v xsel &> /dev/null; then
        xsel --clipboard --input
    elif command -v pbcopy &> /dev/null; then
        pbcopy
    else
        echo "No clipboard command found. Install xclip or xsel."
        return 1
    fi
}

gitCpBranchName() {
    git branch | grep '^\*' | cut -d' ' -f2 | tr -d '\n' | copy_to_clipboard
}
alias gitcbn=gitCpBranchName

gitCpCommitName() {
    git log --pretty=format:'%s' --no-walk | copy_to_clipboard
}
alias gitccn=gitCpCommitName
alias gitccn=gitCpCommitName
#endregion simple alias

#region log
gitlog1() { #Shows current commit
    echo git log --pretty=format:"%h%x09%an%x09%ad%x09%s" --no-walk
    git log --pretty=format:"%h%x09%an%x09%ad%x09%s" --no-walk
}

gitparent() { #shows parent of commit
  git rev-list --format=%B --max-count=1 $1
  echo ----------
  echo Parent commit
  git rev-list --format=%B --max-count=1 $1^
}
alias gitprt="gitparent"

gitshfl() { #Shows files commit touched
   echo git show --pretty="" --name-only $1
   git show --pretty="" --name-only $1
}

gitshow() { # Shows diff with diff tool
   echo git difftool --dir-diff $1~1 $1
   git difftool --dir-diff $1~1 $1
}

gitlog() { # Shows list of commits (var1 author) (var2 days back)
   if [ $# -ge 2 ]
   then
       echo git log --pretty --abbrev-commit -i --author=$1 --since=$2.days
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1 --since=$2.days
   elif [ $# -ge 1 ]
   then
       echo git log --pretty --abbrev-commit -i --author=$1
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1
   else
       echo git log --pretty --abbrev-commit
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit
   fi
}

#Shows commits in nice format with optional author
gitloga() { # Shows list of commits, not only in your branch (var1 author) (var2 days back)
   if [ $# -ge 2 ]
   then
       echo gitloga git reflog --all --pretty --abbrev-commit -i --author=$1 --since=$2.days
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1 --since=$2.days
   elif [ $# -ge 1 ]
   then
       echo git reflog --all --pretty --abbrev-commit -i --author=$1
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1
   else
       echo git reflog --all --pretty --abbrev-commit
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit
   fi
}

gitlog_dates() { # Shows list of commits between dates - yyyy-mm-dd yy-mm-dd (Author)
  if [ $# -ge 2 ]
  then
    echo git log --pretty --abbrev-commit --after=\"$1 00:00\" --before=\"$2 23:59\" -i --author=$3
    git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit --after=\"$1\" --before=\"$2\" -i --author=$3
  else
    echo Example: gitlog_dates 2024-02-01 2024-02-07
  fi
}

gitloga_dates() {  # Shows list of commits between dates - yyyy-mm-dd yy-mm-dd (Author). Not only in branch
    echo git reflog --all --pretty --abbrev-commit --after=\"$1 00:00\" --before=\"$2 23:59\" -i --author=$3
    git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit --after=\"$1\" --before=\"$2\" -i --author=$3
}

gitlogstring() { # Shows list of commits between containing string, (Var1 Author), Var2 String (Var3 days back)
   if [ $# -ge 3 ]
   then
       echo git log --pretty --abbrev-commit -i --author=$1 -S$2 --since=$3.days
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1 -S$2 --since=$3.days
   elif [ $# -ge 2 ]
   then
       echo git log --pretty --abbrev-commit -i --author=$1 -S$2
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1 -S$2
   else
       echo git log --pretty --abbrev-commit -S$1
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit  -S$1
   fi
}

gitlogastring() { # Shows list of commits between containing string, (Var1 Author), Var2 String (Var3 days back), not only in branch
   if [ $# -ge 3 ]
   then
       echo git reflog --all --pretty --abbrev-commit -i --author=$1 -S$2 --since=$3.days
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1 -S$2 --since=$3.days
   elif [ $# -ge 2 ]
   then
       echo git reflog --all --pretty --abbrev-commit -i --author=$1 -S$2
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$1 -S$2
   else
       echo git reflog --all --pretty --abbrev-commit -S$1
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit  -S$1
   fi
}

gitlogpath() { #Shows commits in nice format which effect a path, with optional date. Var1 Path, (Var2 Author), (Var3 Days back)
   if [ $# -ge 3 ]
   then
       echo git log --pretty --abbrev-commit  -i --author=$2 --since=$3.days $1
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit --author=$2 --since=$3.days $1
   elif [ $# -ge 2 ]
   then
       echo git log --pretty --abbrev-commit --since=$2.days $1
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit --since=$2.days $1
   else
       echo git log --pretty --abbrev-commit  $1
       git log --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit  $1
   fi
}

gitlogapath() { #Shows commits in nice format which effect a path, with optional date. Var1 Path, (Var2 Author), (Var3 Days back). Not only in branch
   if [ $# -ge 3 ]
   then
       echo git reflog --all --pretty --abbrev-commit  -i --author=$2 --since=$3.days $1
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit --author=$2 --since=$3.days $1
   elif [ $# -ge 2 ]
   then
       echo git reflog --all --pretty --abbrev-commit --since=$2.days $1
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit --since=$2.days $1
   else
       echo git reflog --all --pretty --abbrev-commit  $1
       git reflog --all --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit  $1
   fi
}
#endregion git log

#region branch
gitpush() { # Push to own origin or other origin
   if [ $# -ge 1 ]
   then
    echo git push origin $1
    git push origin $1
   else
   	branch_name=`get_branch`;
    echo git push origin $branch_name
    git push origin $branch_name
   fi
}

gitpushf() { # Push with fource to own origin or other origin
   if [ $# -ge 1 ]
   then
    echo git push origin $1 -f
    git push origin $1 -f
   else
    branch_name=`get_branch`;
    echo git push origin $branch_name -f
    git push origin $branch_name -f
   fi
}

gitrebase() { #rebases from own origin or any orinin
   branch_name=`get_branch`;
   echo git rebase origin/$branch_name
   git rebase origin/$branch_name
}
alias gitRebase="gitrebase"
alias gRebase="gitrebase"
alias grebase="gitrebase"

gitSquash() { #Squashes var commits, default 2, can be 1 for rename
   if [ $# -ge 1 ]
   then
    echo git rebase -i HEAD~$1
    git rebase -i HEAD~$1
   else
    echo git rebase -i HEAD~2
    git rebase -i HEAD~2
   fi
}
alias gitsquash="gitSquash"
alias gsquash="gitSquash"

greset() { #Resets to commit or branch, default is origin/main
   if [ $# -ge 1 ]
   then
    echo git reset --hard $1
    git reset --hard $1
   else
    echo git reset --hard origin/main
    git reset --hard origin/main
   fi
}
alias gitreset="greset"

gitAddExcept() { # Adds everything other than varaibles (can be only 1 or two, can be folders)
	echo git add -u
	git add -u
	echo git reset HEAD $1
	git reset HEAD $1
	if [ $# -ge 2 ]
    then
		echo git reset HEAD $2
		git reset HEAD $2
	fi

	if [ $# -ge 3 ]
    then
		echo git reset HEAD $3
		git reset HEAD $3
	fi
}

gitb() { #Shows branches with timestamp (with author)
   if [ $# -ge 1 ]
   then
       for k in `git branch -a | grep $1 | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r
   else
       for k in `git branch -a | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r
   fi
}

gitbl() { #Shows branches with timestamp (with author)
   if [ $# -ge 1 ]
   then
       for k in `git branch | grep $1 | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r
   else
       for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r
   fi
}

gitDeleteBranch() { #Deletes both local and remote branch
   echo git branch -D $1
   git branch -D $1
   echo git push origin --delete $1
   git push origin --delete $1
}
alias gitdelb="gitDeleteBranch"

gitlb() { #Shows local branches with timestamp (with author)
   if [ $# -ge 1 ]
   then
       for k in `git branch | grep $1 | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r
   else
       for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r
   fi
}

#Shows commit diff between two branches, optional author
gitbdiff() {
   if [ $# -ge 3 ]
   then
      echo git log --left-right --graph --pretty --abbrev-commit -i --author=$3 --cherry-pick $1...$2
      git log --left-right --graph --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit -i --author=$3 --cherry-pick $1...$2
   else
      echo git log --left-right --graph --pretty --abbrev-commit --cherry-pick $1...$2
      git log --left-right --graph --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s %Cgreen(%ai) %C(blue)<%an>%Creset' --abbrev-commit --cherry-pick $1...$2
   fi
}

#Shows file diff between two branches
gitbfdiff() {
   if [ $# -ge 3 ]
   then
      echo git diff --name-status $1..$2 | grep $3
      git diff --name-status $1..$2 | grep $3
   elif [ $# -ge 2 ]
   then
      echo git diff --name-status $1..$2
      git diff --name-status $1..$2
   else
      echo git diff --name-status $parse_git_branch..$1
      git diff --name-status $parse_git_branch..$1
   fi
}

#Gets files which are different from another branch
gitbfget() {
   #the 'sed' part removes M and A from start of output of gitbfget
   #echo git diff --name-status $parse_git_branch..$1 | sed -E "s/^([^MA ]*)[MA ]/\\1/" | while read line ; do git checkout $1 $line ; done
   git diff --name-status $parse_git_branch..$1 | sed -E "s/^([^MA ]*)[MA ]/\\1/" | while read line ; do git checkout $1 $line ; done
}
#endregion branch

#region Stash
gsshow() { # Show last stash
   git stash show stash^{/$*} -p
}

gsapply() { # Apply last stash
   git stash apply stash^{/$*}
}
#endregion

#region Functions used by script ###
# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function get_branch() {
      git branch --no-color | grep -E '^\*' | awk '{print $2}' \
        || echo "default_value"
      # or
      # git symbolic-ref --short -q HEAD || echo "default_value";
}

function get_branch() {
      git branch --no-color | grep -E '^\*' | awk '{print $2}' \
        || echo "default_value"
      # or
      # git symbolic-ref --short -q HEAD || echo "default_value";
}
#endregion

# Bash Color Codes
# Black 0;30

# Dark Gray 1;30

# Blue 0;34

# Light Blue 1;34

# Green 0;32

# Light Green 1;32

# Cyan 0;36

# Light Cyan 1;36

# Red 0;31

# Light Red 1;31

# Purple 0;35

# Light Purple 1;35

# Brown 0;33

# Yellow 1;33

# Light Gray 0;37

# White 1;37

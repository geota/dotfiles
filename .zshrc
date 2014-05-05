#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Adjusted /usr/local/bin to proceed PATH b/c python2.7 was not resolving correctly
# Prepended /usr/local/mysql/bin from https://wiki.whalesharkmedia.com/pages/viewpage.action?pageId=6033314
export PATH=/Users/amaceiras/bin/:/usr/local/bin:/usr/local/mysql/bin:$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:$HOME/.rvm/bin:$HOME/scratch/sdk/platform-tools:$HOME/wip/tools/GitUtils

# vertica cli connect alias
alias vsqlprod="/opt/vertica/bin/vsql -h vertica.rmn.com -U rmn_amaceiras"

# make virtual env alias
alias mkve='mkvirtualenv -p /usr/local/bin/python2.7'

# command completion
export PYTHONSTARTUP=$HOME/.pythonrc.py

# set default editor to ST
#export EDITOR='subl -w'
EDITOR='reattach-to-user-namespace subl -w'
alias st='subl'
alias stt='subl .'

# virtualenv wrapper setup
if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
  source /usr/local/bin/virtualenvwrapper.sh
fi

# setup mysql
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/

alias diffmerge="opendiff"

alias sshgcprod="ssh ec2-54-235-65-0.compute-1.amazonaws.com"
alias sshgcstage="ssh ec2-54-235-206-88.compute-1.amazonaws.com"
alias sshgcdev="ssh ec2-184-72-248-140.compute-1.amazonaws.com"

alias ssh-perimeter-prod='ssh eops-east-report.wsmeco.com'
alias ssh-perimeter-stage='ssh eops-east-stage.wsmeco.com'

# Syntax Highlighting over-rides
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
# ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold,bg=green'
# ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold,bg=green'
# ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold,bg=green'
ZSH_HIGHLIGHT_STYLES[path]='bold'
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# ZSH shortcurts
bindkey -e
bindkey '^[[1;9A' beginning-of-line
bindkey '^[[1;9B' end-of-line

bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# online help (man pages)
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

#
export MRJOB=$HOME/mrjob
export MRJOB_CONF=/Users/amaceiras/mrjob/config/mrjob.conf

#export HADOOP_HOME=/usr/local/Cellar/hadoop/1.0.3/
#export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/Users/amaceiras/mrjob/hadoop-lzo/hadoop-lzo-0.4.20-SNAPSHOT.jar:/usr/local/Cellar/hadoop/1.0.3/libexec/lib:/usr/local/Cellar/hadoop/1.0.3/libexec

#export JAVA_CLASSPATH=$JAVA_CLASSPATH:/Users/amaceiras/mrjob/oddjob/test:/Users/amaceiras/mrjob/oddjob/src:/Users/amaceiras/mrjob/oddjob/dev-resources:/Users/amaceiras/mrjob/oddjob/test-resources:/Users/amaceiras/mrjob/oddjob/resources:/Users/amaceiras/mrjob/oddjob/target/classes:/Users/amaceiras/.m2/repository/org/mortbay/jetty/jsp-api-2.1/6.1.14/jsp-api-2.1-6.1.14.jar:/Users/amaceiras/.m2/repository/org/apache/hadoop/hadoop-streaming/1.0.3/hadoop-streaming-1.0.3.jar:/Users/amaceiras/.m2/repository/commons-httpclient/commons-httpclient/3.0.1/commons-httpclient-3.0.1.jar:/Users/amaceiras/.m2/repository/commons-lang/commons-lang/2.4/commons-lang-2.4.jar:/Users/amaceiras/.m2/repository/org/apache/commons/commons-math/2.1/commons-math-2.1.jar:/Users/amaceiras/.m2/repository/org/eclipse/jdt/core/3.1.1/core-3.1.1.jar:/Users/amaceiras/.m2/repository/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar:/Users/amaceiras/.m2/repository/junit/junit/3.8.1/junit-3.8.1.jar:/Users/amaceiras/.m2/repository/oro/oro/2.0.8/oro-2.0.8.jar:/Users/amaceiras/.m2/repository/org/clojure/data.json/0.2.2/data.json-0.2.2.jar:/Users/amaceiras/.m2/repository/tomcat/jasper-runtime/5.5.12/jasper-runtime-5.5.12.jar:/Users/amaceiras/.m2/repository/org/mortbay/jetty/jetty/6.1.26/jetty-6.1.26.jar:/Users/amaceiras/.m2/repository/net/java/dev/jets3t/jets3t/0.7.1/jets3t-0.7.1.jar:/Users/amaceiras/.m2/repository/xmlenc/xmlenc/0.52/xmlenc-0.52.jar:/Users/amaceiras/.m2/repository/commons-el/commons-el/1.0/commons-el-1.0.jar:/Users/amaceiras/.m2/repository/commons-digester/commons-digester/1.8/commons-digester-1.8.jar:/Users/amaceiras/.m2/repository/org/codehaus/jackson/jackson-core-asl/1.0.1/jackson-core-asl-1.0.1.jar:/Users/amaceiras/.m2/repository/commons-logging/commons-logging/1.0.3/commons-logging-1.0.3.jar:/Users/amaceiras/.m2/repository/ant/ant/1.6.5/ant-1.6.5.jar:/Users/amaceiras/.m2/repository/net/sf/kosmosfs/kfs/0.3/kfs-0.3.jar:/Users/amaceiras/.m2/repository/org/clojure/tools.nrepl/0.2.3/tools.nrepl-0.2.3.jar:/Users/amaceiras/.m2/repository/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.jar:/Users/amaceiras/.m2/repository/org/mortbay/jetty/servlet-api/2.5-20081211/servlet-api-2.5-20081211.jar:/Users/amaceiras/.m2/repository/org/mortbay/jetty/jetty-util/6.1.26/jetty-util-6.1.26.jar:/Users/amaceiras/.m2/repository/commons-codec/commons-codec/1.4/commons-codec-1.4.jar:/Users/amaceiras/.m2/repository/org/clojure/clojure/1.5.1/clojure-1.5.1.jar:/Users/amaceiras/.m2/repository/clojure-complete/clojure-complete/0.2.3/clojure-complete-0.2.3.jar:/Users/amaceiras/.m2/repository/org/clojure/data.csv/0.1.2/data.csv-0.1.2.jar:/Users/amaceiras/.m2/repository/org/apache/hadoop/hadoop-core/1.0.3/hadoop-core-1.0.3.jar:/Users/amaceiras/.m2/repository/tomcat/jasper-compiler/5.5.12/jasper-compiler-5.5.12.jar:/Users/amaceiras/.m2/repository/org/codehaus/jackson/jackson-mapper-asl/1.0.1/jackson-mapper-asl-1.0.1.jar:/Users/amaceiras/.m2/repository/commons-cli/commons-cli/1.2/commons-cli-1.2.jar:/Users/amaceiras/.m2/repository/org/mortbay/jetty/jsp-2.1/6.1.14/jsp-2.1-6.1.14.jar:/Users/amaceiras/.m2/repository/hsqldb/hsqldb/1.8.0.10/hsqldb-1.8.0.10.jar:/Users/amaceiras/.m2/repository/commons-net/commons-net/1.4.1/commons-net-1.4.1.jar:/Users/amaceiras/.m2/repository/commons-beanutils/commons-beanutils-core/1.8.0/commons-beanutils-core-1.8.0.jar:/Users/amaceiras/.m2/repository/commons-configuration/commons-configuration/1.6/commons-configuration-1.6.jar:/Users/amaceiras/.m2/repository/org/mortbay/jetty/servlet-api-2.5/6.1.14/servlet-api-2.5-6.1.14.jar
export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
export JAVA_LIBRARY_PATH=$JAVA_LIBRARY_PATH:/Users/amaceiras/mrjob/hadoop-lzo/target/native/Mac_OS_X-x86_64-64/lib

#export LD_LIBRARY_PATH=/usr/local/Cellar/unixodbc/2.3.2/lib:$LD_LIBRARY_PATH
#export LDFLAGS=-L/usr/local/Cellar/unixodbc/2.3.2/lib:$LDFLAGS
#export CPPFLAGS=-I/usr/local/Cellar/unixodbc/2.3.2/include/:$CPPFLAGS
export EDITOR=vim
export VISUAL=vim

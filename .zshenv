if [ -z $ZSH_ENV_LOADED ]; then
  export PATH=$HOME/bin:$PATH
  export PATH=$HOME/.anyenv/bin:$PATH
  export LESSCHARSET=utf-8
  export ZSH_ENV_LOADED=1
else
  echo "skipped loading ~/.zshenv"
fi

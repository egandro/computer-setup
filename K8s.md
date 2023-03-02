# K8s

idea: https://gist.github.com/GusAntoniassi/2f58e716b67f648d13f91c1d780b05bf


```
mkdir -p ~/.oh-my-zsh/custom/plugins/kubectl-autocomplete/
kubectl completion zsh > ~/.oh-my-zsh/custom/plugins/kubectl-autocomplete/kubectl-autocomplete.plugin.zsh

# ~/.zshrc
alias k=kubectl"
plugins=(kubectl-autocomplete)
```

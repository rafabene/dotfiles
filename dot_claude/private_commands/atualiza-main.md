# Atualiza Main

Atualiza a branch main local com a versão mais recente do repositório.

## Instruções

1. Primeiro, verifique se existe um remote `upstream` configurado:
   - Execute `git remote -v` para listar os remotes
   - Se existir `upstream`, use-o como fonte
   - Se não existir, consulte no GitHub se o repositório é um fork usando `gh repo view --json isFork,parent`
   - Se for um fork, adicione o parent como upstream
   - Se não for um fork, use `origin` como fonte

2. Execute os comandos de atualização:
   - Se tiver upstream: `git fetch upstream && git checkout main && git merge upstream/main && git push origin main`
   - Se não tiver upstream: `git fetch origin && git checkout main && git pull origin main`

3. Informe ao usuário o resultado da operação (quantos commits foram atualizados ou se já estava atualizado)

# === Autor: Art Michel === 
# === CONFIGURACIÓN ===
$GIT_NAME = "TU-USERNAME"
$GIT_EMAIL = "TU-CORREO"
$REMOTE = "git"
$BRANCH = "main"

Write-Host "Iniciando deploy con tu UserName..." -ForegroundColor Cyan

$currentBranch = git branch --show-current

git checkout -b temp-git-deploy

git filter-branch -f --env-filter "export GIT_AUTHOR_NAME='$GIT_NAME'; export GIT_AUTHOR_EMAIL='$GIT_EMAIL'; export GIT_COMMITTER_NAME='$GIT_NAME'; export GIT_COMMITTER_EMAIL='$GIT_EMAIL'" HEAD

git push $REMOTE temp-git-deploy:$BRANCH --force

git checkout $currentBranch
git branch -D temp-git-deploy
Remove-Item -Recurse -Force .git/refs/original -ErrorAction SilentlyContinue

Write-Host "El Deploy de tu proyecto fue completado" -ForegroundColor Green
Write-Host "Tus commits en origin siguen con tu usuario anterior" -ForegroundColor Yellow

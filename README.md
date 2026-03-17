# deploy-segundo-github.ps1

Script de PowerShell para hacer deploy a una **segunda cuenta de GitHub** reescribiendo el autor de los commits automáticamente.

## El problema

Si usas **Vercel en su plan gratuito**, no puedes agregar colaboradores. Esto significa que si un cliente tiene su propia cuenta de Vercel conectada a su propio GitHub, **no puedes hacer deploy desde tu usuario** — Vercel simplemente no lo permite.

La solución obvia sería pagar una segunda suscripción de Vercel, pero eso no tiene mucho sentido si solo necesitas subir código.

## La solución

En lugar de pagar dos veces, creé un flujo con **dos cuentas de GitHub y un solo script**:

- **Tu cuenta principal** → donde trabajas normalmente (`git push` de siempre).
- **Una segunda cuenta** → exclusiva para el deploy del cliente, conectada a su Vercel gratuito.

El script se encarga de todo: crea una rama temporal, reescribe el autor de los commits con el usuario de la segunda cuenta, hace `push --force` al remote correspondiente y limpia todo. Tu historial en `origin` no se toca.

## Configuración del script

Edita estas variables en `deploy-segundo-github.ps1`:

```powershell
$GIT_NAME  = "TU-USERNAME"       # Usuario de tu segunda cuenta de GitHub
$GIT_EMAIL = "TU-CORREO"         # Correo asociado a tu segunda cuenta
$REMOTE    = "deploy"             # Nombre del remote (debe coincidir con el paso siguiente)
$BRANCH    = "main"               # Rama destino
```

## Configuración por proyecto (una sola vez)

### 1. Agregar los remotes

```powershell
# origin → tu cuenta principal (tu flujo de trabajo normal)
git remote add origin https://github.com/tu-cuenta-principal/mi-proyecto.git

# deploy → la cuenta del cliente (conectada a su Vercel)
git remote add deploy https://segunda-cuenta:TOKEN@github.com/segunda-cuenta/mi-proyecto.git
```

> Sustituye `TOKEN` por un [Personal Access Token](https://github.com/settings/tokens) de la segunda cuenta con permisos de `repo`.

Para verificar:

```powershell
git remote -v
```

### 2. Copiar el script al proyecto y excluirlo del repo

```powershell
Add-Content .gitignore "deploy-segundo-github.ps1"
git add .gitignore
git commit -m "chore: agregar script de deploy a gitignore"
git push origin main
```

## Uso

```powershell
# Primero sube a tu cuenta principal como siempre
git push origin main

# Después ejecuta el script para la segunda cuenta
.\deploy-segundo-github.ps1
```

## Reutilización

El script es **idéntico en todos los proyectos**. Lo único que cambia es la configuración de remotes, que se hace una sola vez. Copia el mismo archivo sin modificar nada.

## Verificación

En cualquier momento puedes confirmar a dónde apunta cada remote:

```powershell
git remote get-url origin    # → tu cuenta principal
git remote get-url deploy    # → la cuenta del cliente
```

`git push` normal siempre va a `origin`. La única forma de subir a la segunda cuenta es ejecutando el script manualmente.

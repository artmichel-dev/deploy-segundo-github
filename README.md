# deploy-segundo-github.ps1

Script de PowerShell para hacer deploy de un proyecto a una **segunda cuenta de GitHub** sin afectar tu cuenta principal.

## ¿Qué hace?

1. Crea una rama temporal a partir de tu rama actual.
2. Reescribe el autor y committer de **todos los commits** con el usuario y correo de tu segunda cuenta.
3. Hace `push --force` al remote de tu segunda cuenta.
4. Regresa a tu rama original y limpia la rama temporal.

Tus commits en `origin` (tu cuenta principal) **no se modifican**.

## Configuración del script

Abre `deploy-segundo-github.ps1` y edita estas variables:

```powershell
$GIT_NAME  = "TU-USERNAME"       # Usuario de tu segunda cuenta de GitHub
$GIT_EMAIL = "TU-CORREO"         # Correo asociado a tu segunda cuenta
$REMOTE    = "segundo"            # Nombre del remote (debe coincidir con el que configures abajo)
$BRANCH    = "main"               # Rama destino
```

## Configuración por proyecto (una sola vez)

### 1. Agregar los remotes

```powershell
# origin → tu cuenta principal (respaldo / preview)
git remote add origin https://github.com/tu-cuenta-principal/mi-proyecto.git

# segundo → tu segunda cuenta (producción)
git remote add segundo https://tu-segunda-cuenta:TOKEN@github.com/tu-segunda-cuenta/mi-proyecto.git
```

> Sustituye `TOKEN` por un Personal Access Token de tu segunda cuenta con permisos de `repo`.

Para verificar que los remotes estén bien:

```powershell
git remote -v
```

Deberías ver algo así:

```
origin    https://github.com/tu-cuenta-principal/mi-proyecto.git   (fetch/push)
segundo   https://github.com/tu-segunda-cuenta/mi-proyecto.git     (fetch/push)
```

### 2. Copiar el script a la raíz del proyecto

Copia `deploy-segundo-github.ps1` a la carpeta raíz de tu proyecto.

### 3. Agregar el script al `.gitignore`

```powershell
Add-Content .gitignore "deploy-segundo-github.ps1"
git add .gitignore
git commit -m "chore: agregar script de deploy a gitignore"
git push origin main
```

## Uso

Primero asegúrate de que tu código esté al día en `origin`:

```powershell
git push origin main
```

Después ejecuta el script:

```powershell
.\deploy-segundo-github.ps1
```

Eso es todo. El script sube el código a tu segunda cuenta con los commits reescritos.

## Reutilización en múltiples proyectos

El script es **idéntico** en todos los proyectos. Lo único que cambia es la configuración de remotes, que se hace una sola vez por proyecto. Puedes copiar el mismo archivo sin modificar nada.

## Notas

- El nombre del remote en la variable `$REMOTE` debe coincidir exactamente con el remote que configuraste en Git.
- `git push` normal sigue yendo a `origin` (tu cuenta principal). La única forma de subir a la segunda cuenta es ejecutando el script manualmente.
- Si quieres confirmar a dónde apunta un remote en cualquier momento:

```powershell
git remote get-url origin
git remote get-url segundo
```

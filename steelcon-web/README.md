# Steelcon — Gestión de Envíos y Retiros

Aplicación web multiusuario para Steelcon S.A. Diseñada para publicarse gratis en **GitHub Pages** y utilizar **Supabase Free** para autenticación y base de datos compartida. No requiere contratar ni administrar un servidor virtual. No utiliza Netlify ni Vercel.

## Funciones incluidas

- Inicio de sesión por correo y contraseña.
- Panel de movimientos y registro de envíos/retiros.
- Origen, destino, solicitante, sector, responsable, transporte, vehículo, matrícula, conductor, artículos, cantidades, notas y horarios.
- Estados Pendiente, Autorizado, En tránsito, Completado y Cancelado.
- Vehículos y transportistas.
- Historial y archivo de movimientos completados.
- Exportación CSV e impresión de comprobantes con marca STEELCON / LOGÍSTICA.
- Datos compartidos entre usuarios autenticados mediante Supabase.

## Publicación gratuita (sin servidor propio)

### Paso 1 — Crear Supabase

1. Crear una cuenta/proyecto en <https://supabase.com/>.
2. En el proyecto, abrir **SQL Editor → New query**.
3. Copiar y ejecutar todo el archivo `schema.sql`.
4. En **Project Settings → API**, copiar la **Project URL** y la clave pública **anon/publishable**. Nunca usar una `service_role` o clave secreta en la aplicación web.
5. En **Authentication → URL Configuration**, configurar como `Site URL` la URL final de GitHub Pages. Añadir también esa misma URL a `Redirect URLs`.
6. En **Authentication → Providers → Email**, mantener habilitado Email. Desactivar el registro público si solamente administradores deben crear empleados.
7. En **Authentication → Users**, crear una cuenta para cada empleado.

> La base de datos se comparte entre los empleados que inicien sesión. El esquema inicial permite a todos los usuarios autenticados ver y editar los movimientos y vehículos. Si la empresa necesita permisos distintos por cargo, deben definirse antes de usarlo en producción.

### Paso 2 — Subir el proyecto a GitHub

1. Crear una cuenta en <https://github.com/> si todavía no tienen una.
2. Crear un repositorio nuevo, por ejemplo `steelcon-gestion-envios-retiros`. Si los datos son internos, el repositorio puede ser privado; confirmar que la configuración y el plan de GitHub permitan publicar Pages desde ese repositorio.
3. Subir **el contenido de esta carpeta**, no solamente el ZIP, a la raíz del repositorio. Deben quedar en la raíz `package.json`, `index.html`, `src/`, `schema.sql` y `.github/workflows/deploy.yml`.
4. En el repositorio abrir **Settings → Secrets and variables → Actions → New repository secret** y crear:
   - `VITE_SUPABASE_URL` = Project URL de Supabase.
   - `VITE_SUPABASE_ANON_KEY` = clave pública anon/publishable de Supabase.
5. Abrir **Settings → Pages** y seleccionar **GitHub Actions** como método de publicación.
6. En **Actions**, ejecutar el flujo **Build and publish Steelcon app to GitHub Pages** o hacer un `push` a `main`/`master`.
7. Cuando el flujo termine correctamente, GitHub mostrará la URL publicada, normalmente `https://USUARIO.github.io/steelcon-gestion-envios-retiros/`.
8. Volver a Supabase y añadir la URL publicada a `Authentication → URL Configuration → Redirect URLs` y configurar `Site URL`.

### Paso 3 — Probar

- Abrir la URL publicada y entrar con una cuenta creada en Supabase.
- Registrar un envío de prueba y confirmar que aparece después de actualizar la página.
- Entrar con otra cuenta autorizada y verificar que ambos usuarios ven el mismo movimiento.
- Probar edición, cambio de estado, historial, exportación CSV e impresión.

## Actualizaciones

Cada vez que se suban cambios a la rama `main` o `master`, GitHub Actions volverá a compilar y publicar la aplicación.

## Limitaciones y seguridad

- No se ha publicado automáticamente: hacen falta las cuentas de GitHub y Supabase de la empresa y configurar los secretos indicados.
- Los planes gratuitos tienen límites, y sus condiciones pueden cambiar. Revisar los límites vigentes de GitHub Pages y Supabase antes del uso empresarial.
- GitHub Pages sirve la interfaz estática; Supabase gestiona la autenticación y los datos. No se necesita un VPS.
- La clave anon/publishable está destinada al navegador; la protección de los datos depende de las políticas RLS de `schema.sql`. No introducir claves secretas en GitHub ni en el código.
- El emblema de impresión es provisional. Se puede sustituir por el logo oficial de Steelcon cuando se proporcione.

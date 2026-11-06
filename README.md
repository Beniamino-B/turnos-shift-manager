# Turnos2

Aplicación de calendario de turnos laborales con gestión financiera y de nómina, en español y con diseño Glassmorphism.

## Funcionalidades

- **Calendario** vertical con cabeceras mensuales pegajosas, celdas cuadradas, resaltado del día actual y modo pincel para pintar/borrar turnos arrastrando el dedo.
- **Finanzas**: nómina neta/bruta/deducciones, gráfica de ingresos (3 meses), desglose detallado, registro de pagos e historial.
- **Ajustes**: configuración de nómina (salario base, salud, pensión, recargos nocturno/dominical, frecuencia mensual/quincenal), CRUD de tipos de turno y notificaciones.
- **Motor de nómina**: cálculo de horas, recargos, deducciones y transporte. El dinero se maneja en centavos (`int`) para evitar errores de precisión.

## Stack técnico

- Flutter + Dart
- Riverpod (estado)
- Drift + SQLite (`sqlite3_flutter_libs`)
- fl_chart (gráficas)
- flutter_local_notifications
- google_fonts
- flutter_sticky_header

## Compilar

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run flutter_launcher_icons
flutter build apk --debug
```

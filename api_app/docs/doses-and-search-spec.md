# Especificación: Dosis, Unidades y Buscador en Tiempo Real

## Resumen
Documento de diseño para el manejo de dosis (soporte de unidades diversas) y la implementación del buscador en tiempo real con filtrado. No modifica código existente — solo especificaciones y ejemplos.

## Dosis y Unidades — Enfoque
- No asumir `mg` para todos los medicamentos. Algunos son líquidos, gotas, unidades internacionales (IU), comprimidos, sobres, etc.
- Modelado recomendado (persistencia):
  - `dose_value`: number | string (ej. 5, 0.5, "1/2")
  - `dose_unit`: string (ej. "mg", "ml", "tablet", "drops", "IU", "spray")
  - `dose_form`: optional string (ej. "tableta", "jarabe", "inyección")

### Reglas de negocio sugeridas
- Si `dose_unit` es una unidad de volumen (`ml`, `teaspoon`) o gotas, permitir valores decimales.
- Para formas sólidas como `tablet` o `capsule`, permitir también valores enteros o fracciones legibles ("1/2").
- Mostrar la unidad al lado del valor en las vistas (`5 mg`, `10 ml`, `1 tableta`).
- Proveer un campo de ayuda / hint cuando el medicamento tenga una forma que restrinja las unidades: por ejemplo, si `form = "Jarabe"` mostrar: "Ingrese en ml o cucharadita — no usar mg".

### UI de captura (sin tocar código existente)
- Campo dividido: campo numérico/libre para `dose_value` + selector desplegable para `dose_unit`.
- Mostrar ejemplos dinámicos bajo el input según la `dose_unit` seleccionada.
- Validaciones: rango razonable por unidad (ej. mg: 0.1–10000, ml: 0.1–500, drops: 0.1–50) y mensajes claros.

### Visualización en listas y detalle
- Normalizar presentación: `{dose_value} {dose_unit_label}`. Para unidades tipo `tablet` use pluralización: "1 tableta", "2 tabletas".
- Si el espacio es pequeño (cards), truncar con elipsis y mostrar el contenido completo en tooltip o detalle.

### Migración / Backwards Compatibility
- Si ya hay una sola columna `dose` con texto libre, planear una migración donde se parsean valores detectables.
- Alternativa no intrusiva: dejar `dose` como texto libre y añadir los campos estructurados nuevos; usar los estructurados cuando estén presentes.

## Buscador en Tiempo Real (Requerimientos)
- Debe filtrar mientras el usuario escribe (onChange) y ser responsivo para listas grandes (debounce y/o búsqueda en backend si hay muchos items).
- Campos a filtrar por defecto: nombre del medicamento, principio activo, forma farmacéutica, notas.

### UX Consideraciones
- Debounce recomendado: 200–350 ms.
- Mostrar feedback: indicador de búsqueda si hay latencia (>200ms) y texto "Sin resultados" cuando corresponda.
- Permitir filtrado por unidades/formas (ej. un botón o chips para filtrar: "Tabletas", "Jarabe", "Con receta").

### Snippet de ejemplo (pseudocódigo Flutter — solo referencia)
```dart
// Pseudocódigo: usar onChanged con debounce y filtrar la lista en memoria o via provider
void onSearchChanged(String q) {
  debounce(() {
    final term = q.toLowerCase();
    final results = allMedicines.where((m) {
      return m.name.toLowerCase().contains(term) ||
             m.activeIngredient.toLowerCase().contains(term);
    }).toList();
    provider.updateFiltered(results);
  }, 300);
}
```

## Notas finales
- Estas especificaciones están pensadas para guiar una implementación sin tocar la lógica existente inicialmente: primero agregar documentación y pruebas manuales, luego proponer cambios incrementales.

# Visión General: Objetivo y Rationale de la App

## Objetivo
La app gestiona y recuerda tratamientos farmacológicos para usuarios (registro de medicamentos, dosis, horarios y recordatorios). Su meta es ofrecer una interfaz simple y fiable para que pacientes puedan llevar el control de su medicación.

## Público objetivo
- Pacientes con tratamientos crónicos.
- Cuidadores y familiares que gestionan medicación ajena.

## Principios de diseño y decisiones clave
- Simplicidad: interfaces claras y acciones directas para añadir, editar y tomar dosis.
- Seguridad y claridad: mostrar unidades y condiciones de uso (por ejemplo, suspender la suposición de "mg" por defecto).
- Tolerancia: aceptar campos libres al inicio y evolucionar a datos estructurados según uso real.

## Por qué el enfoque de dosis estructurada
- Razonamiento: evitar errores semánticos (ej. mezclar mg con ml) y permitir filtrados y cálculos automáticos (p. ej. sumar dosis diarias).
- Gradual: mantener compatibilidad con datos existentes y migrar cuando haya reglas de parsing fiables.

## Notas sobre UI / UX que no tocan código actual
- Documentar recomendaciones (ver `docs/doses-and-search-spec.md`) y aplicar cambios en UI de forma incremental.
- Validar cada cambio con pruebas de usabilidad para asegurar que los cuidadores/pacientes entienden la nueva representación de dosis.

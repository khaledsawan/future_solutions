# IDE AI Agent Instructions

This document defines strict rules for generating and maintaining the Flutter Clean Architecture Template project.  
All steps must be followed exactly to maintain architectural consistency.

---

## 1. Project Structure

Ensure the following directories exist:

- lib/core/
- lib/features/
- lib/di/
- lib/route/
- lib/l10n/

Ensure these files exist:

- lib/main.dart
- lib/app.dart

> Note: OpenAPI-generated code lives in an **external Dart package** and is imported via `pubspec.yaml`.

---

## 2. Feature Module Rules

For every new feature `FEATURE_NAME`:

Create:
\`\`\`
lib/features/FEATURE_NAME/
├── presentation/
├── domain/
└── data/
\`\`\`

Rules:

- **No cross-feature imports**
- Shared logic must live in `lib/core/`
- Generators may scaffold new files in Domain/Presentation but **must not overwrite existing handwritten code**

---

## 3. Domain Layer Rules

Domain layer must contain:

- Entities (from external OpenAPI DTOs or internally created custom classes)
- Repository interfaces
- Use cases

Entity Sources:

- **External Source (OpenAPI DTOs)**: Entities can be OpenAPI-generated DTO classes imported from the external package
  - DTOs serve as Entity definitions directly
  - No mapping layer needed
  - API schema is the source of truth
  
- **Internal Source (Custom Entities)**: Developers can create custom Entity classes
  - Pure Dart classes following domain-driven design principles
  - Can include domain-specific methods and validations
  - Provides flexibility for domain models not aligned with API structure

Restrictions:

- **Pure Dart only** (no Flutter, no Firebase, no Dio)
- **OpenAPI-generated DTO classes are allowed** when using external source approach
- **Custom Entity classes are allowed** when using internal source approach
- Business logic only
- Generators may create scaffolding or stubs, but never overwrite existing logic

Important: Choose one Entity source approach per Entity. Do not mix OpenAPI DTOs and custom Entities for the same domain concept. The chosen approach should be consistent within a feature module.

---

## 4. Data Layer Rules

Data layer responsibilities:

- Implement domain repositories
- Consume external OpenAPI-generated clients as primary API source
- Return Entities to domain layer (either DTOs directly or custom Entities)
- Can depend on shared Core abstractions
- Perform DTO to Entity mapping when using custom Entities

Rules:

- **External Source Entities**: No mapping required - OpenAPI DTOs are returned directly as Entities
- **Internal Source Entities**: Mapping from OpenAPI DTOs to custom Entities is required
- Must be replaceable via DI
- Mapping logic should be isolated and maintainable
- Choose mapping strategy based on Entity source approach used in Domain layer

---

## 5. Presentation Layer Rules

Presentation layer contains:

- UI widgets
- State management scaffolds
- Navigation stubs

Rules:

- Depends **only on Domain and Core**
- Can be scaffolded by generators, but **must not contain business logic or direct API calls**
- No direct Data layer access

---

## 6. Dependency Injection

- Use `get_it` as the service locator
- Use `injectable` for automatic DI code generation
- Register all dependencies via DI annotations (`@injectable`, `@singleton`)
- No direct instantiation inside widgets or use cases
- Code generator automatically adds `@injectable` annotations to generated classes

**Setup:**
1. Generated code includes `@injectable` or `@singleton` annotations
2. Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate DI registration code
3. Initialize DI in `main.dart`: `configureDependencies()` (from `lib/di/injection.dart`)

**Annotation Strategy:**
- `@singleton`: For services that should have one instance (repositories, data sources, cache manager, network info)
- `@injectable`: For transient instances (use cases typically)

> All services must be swappable by changing DI bindings only

---

## 7. Routing

- Abstracted and type-safe routing supported
- Can scaffold router stubs
- Implementation choice is flexible (e.g., auto_route, go_router)
- No hardcoded navigation logic in Domain or Data

---

## 8. Localization

- Support multiple locales (configurable)
- Use external JSON translation files
- Fallback locale defined
- No hardcoded strings in UI or Domain

---

## 9. Theming

- Light and dark theme support
- Centralized and reusable
- Platform-adaptive (Material / Cupertino optional)
- Implementation is flexible; scaffolds can be generated

---

## 10. Analytics & Crash Reporting

- Access all third-party services through **abstract interfaces**
- Implementation is swappable via DI
- No direct usage of any specific provider in Domain or Presentation
- Examples: Analytics, Crash Reporting, Logging

---

## 11. Testing Requirements

Required test types:

- Unit tests for Domain and Data
- Widget tests for Presentation
- Integration tests for critical flows

Mocks:

- Use `mocktail` or equivalent

---

## 12. Code Generation Rules

- Always use code generation when available
- Generators may scaffold Domain and Presentation **safely**
- Must never overwrite existing handwritten logic
- External OpenAPI package is the primary source of API code

Suggested generators:

- OpenAPI generator (external package)
- build_runner
- freezed / json_serializable (as needed)
- injectable (automatic DI registration)

**Workflow:**
1. Run feature generator: `dart tool/codegenerator/bin/generate_features.dart`
2. Generated code includes `@injectable` annotations
3. Run build_runner: `flutter pub run build_runner build --delete-conflicting-outputs`
4. `injectable_generator` generates `lib/di/injection.config.dart` with all service registrations

---

## 13. Replaceable Services Rule

For any third-party service:

1. Define interface in `core/`
2. Implement concrete class in Data or Core
3. Register via DI
4. Allow swapping by changing DI binding only

---

## FINAL RULE

1. Domain layer is **pure Dart**; no infrastructure code allowed (except OpenAPI DTOs when using external source, or custom Entity classes when using internal source).
2. **Entities are flexible**: Can be OpenAPI DTOs (external source) or custom classes (internal source).
3. **Choose one approach per Entity**: Do not mix OpenAPI DTOs and custom Entities for the same domain concept.
4. Features are isolated; no cross-feature imports.
5. Generators may scaffold but **cannot overwrite existing handwritten logic**.
6. OpenAPI-generated code lives **outside the project**.
7. Data layer handles mapping only when using custom Entities (no mapping needed for DTO Entities).

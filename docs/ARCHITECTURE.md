# e7gz App - Architecture Guide

## Architecture Overview
Feature-First + Clean Architecture.
lib/
└── src/
    ├── core/                       # Shared & cross-cutting components
    │   ├── errors/                 # Exceptions & failures
    │   ├── services/               # Shared services
    │   ├── utils/                  # Helpers & extensions
    │   ├── constants/              # App-wide constants
    │   └── di/                     # Dependency injection
    │
    └── features/                   # Feature-based modules
        └── <feature_name>/
            ├── data/
            │   ├── datasources/    # Remote & local data sources
            │   ├── models/         # Data models & DTOs
            │   └── repositories/   # Repository implementations
            │
            ├── domain/
            │   ├── entities/      # Business entities
            │   ├── repositories/  # Repository contracts
            │   └── usecases/      # Application business logic
            │
            └── presentation/
                ├── cubit/         # Cubits & states
                ├── screens/       # Feature screens
                └── widgets/       # Reusable feature widgets



## Golden Rules
1. **Domain Isolation**: Pure Dart only. No Flutter, no Firebase, no Dio.
2. **Error Flow**: Data layer converts all exceptions into `Failure` using `fpdart` (`Either<Failure, T>`).
3. **State Management**: Bloc/Cubit only. Constructor injected dependencies.
4. **UseCases**: Only created when real business logic / orchestration exists.
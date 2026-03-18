# Architecture

This document defines the architectural foundations of Estatia iOS.

---

## Overview

The system is built using **Clean Architecture + modular SPM packages**, enforcing strict separation of concerns and long-term scalability.

---

## Layered Architecture

Each feature follows this structure:

Presentation (SwiftUI)

↓

Domain (UseCases)

↓

Data (Repositories)

↓

Core (Networking, DB, Utils)


---

## Core Principles

### 1. Dependency Inversion

- High-level modules do not depend on low-level modules
- All dependencies flow inward
- Interfaces (protocols) define contracts

---

### 2. Modular Isolation

- Each feature is an independent package
- No implicit dependencies
- Explicit imports only

---

### 3. Unidirectional Data Flow
User Action → ViewModel → UseCase → Repository → Data Source

↓

State Update

↓

UI Render


---

### 4. State Management

- Immutable state objects
- Explicit state transitions
- No shared mutable state

---

### 5. Concurrency Model

- Swift Concurrency (`async/await`)
- Structured concurrency
- No unmanaged threads
- Cancellation-aware operations

---

## Module Responsibilities

### Core Modules

| Module        | Responsibility |
|--------------|----------------|
| Network      | API communication |
| Data         | Repository implementations |
| Domain       | Business logic |
| Database     | Persistence |
| Analytics    | Event tracking |
| Security     | Auth + validation |
| UI           | Shared UI components |

---

### Feature Modules

Each feature contains:

- View (SwiftUI)
- ViewModel
- UseCases
- State models

---

## Dependency Rules

- Feature → Domain → Data → Core
- Feature modules cannot depend on other feature modules directly
- Shared logic must live in Core or Domain

---

## API Design

Repositories expose:

```swift
protocol PropertyRepository {
    func fetchProperties() async throws -> [Property]
}

//UseCases orchestrate logic:

struct FetchPropertiesUseCase {
    let repository: PropertyRepository
    
    func execute() async throws -> [Property] {
        try await repository.fetchProperties()
    }
}

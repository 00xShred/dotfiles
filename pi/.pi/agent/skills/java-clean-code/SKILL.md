---
name: java-clean-code
description: Java clean-code checklist from ZHAW PROG1/PM1 + PROG2/PM2 (FS2026) handbooks. Use when writing, reviewing, or refactoring Java code, esp. ZHAW assignments/projects, or when asked to check code against clean-code rules.
---

# Java Clean Code (ZHAW PROG1/PROG2 merged)

PROG2 (FS2026) is a superset of PROG1. Graders enforce these across the whole degree. Review code against the list, fix violations, report by rule name.
Sources: `~/Documents/ZHAW/1S/PROG1/info/Clean-Code/` (`16 Clean Code Handbuch.pdf` = PROG1; `PROG2PM2 Clean Code Handbuch1.pdf` / `...2.html` = PROG2/PM2, with full examples). Read the matching section there if a rule is unclear.

## Readability
- Names: Class `UpperCamel` (`Html` not `HTML`), method/var/field `lowerCamel`, constants `UPPER_SNAKE`.
- Descriptive names stating purpose + unit (`toCelsius(degreesKelvin)`, not `calculate(value)`). No Hungarian notation (`MathClass`, `S_x`, `dRadius`).
- No dead/commented-out code (git has history).
- Comments explain *why* (formula, link, rationale), never restate the next line.
- Imports: only what is used, no star imports.
- No copy & paste → extract method.
- No `== true` / `== false` / `!= false`; flip then/else instead of negating.
- No magic numbers → named `static final` constant.
- Consistent formatting via IDE/`.editorconfig`; formatting commits separate from logic commits.
- No deprecated APIs: `java.util.Date`/`Calendar` → `java.time`; `HttpURLConnection` → `java.net.http`.
- Methods ≤ 40 lines; extract helpers.
- Params ≤ 4-5; else argument object or Builder (final fields, private ctor, defaults, validate in `build()`). (L3)
- `String.format` over `+` concatenation for layout. (L2)
- Collections: prefer streams over nested imperative loops (L4); terminate complex streams with `Collectors` (`groupingBy`, `counting`) not `forEach` side effects.
- Foreach over indexed `for` when index is unused. (L2)

## Class design
- Classes have behavior, not just getters/setters (pure data → `record`).
- Minimal surface: `private` by default; no public fields; no IDE-generated getter/setter for everything.
- Interfaces over abstract classes (composition over inheritance); no speculative abstraction (single-impl interface, unused methods).
- Tell, don't ask / Law of Demeter: if a class keeps querying another's state or calling several methods in order, move the logic. (L2)
- Fields only for state that outlives a method call; else local variable.

## Testing
- Essential logic covered by unit tests with real assertions (no `assertTrue(true)`; getters/setters/`toString` exempt).
- Mock/stub external collaborators (DB, etc.). (L3)
- Parameterize repeated asserts (`@ParameterizedTest`). (L3)
- Collaborators passed via constructor, not `new` inside; inject `Clock` instead of `Instant.now()`/static calls. (L2)

## Maintainability
- Enums/classes instead of primitives/Strings (`CardType` enum; `Money` class; `BigDecimal` not `double` for exact values; convert strings with `valueOf` early).
- Reference interfaces (`List`) not concrete types (`ArrayList`); pick specific enough interface (`SortedSet` if order matters). Use concrete only at construction.
- Right collection: `ArrayList` not arrays/`Vector`; `Collections.emptyList()/singletonList()`.
- Javadoc: purpose of every class/interface; contract for interface/abstract/internal-API methods: what (not how), params, return, pre/postconditions, every exception + when.
- Document with valid/invalid examples where non-obvious (regex, formats). (L2)
- Exceptions: throw on exceptional situation with diagnostic message; JDK exceptions where fit (`IllegalArgumentException`); custom ones extend `Exception`/`RuntimeException` with message+cause ctors; never swallow; when wrapping pass cause. (L2)
- Logging (`java.util.logging`, `private static final Logger` named for class) instead of `System.out`/`printStackTrace`; use `{0}` interpolation not concatenation; never log sensitive data. (L3)
- User gets meaningful error message: never blank view, never stacktrace, say what to do. (L3)

## Correctness
- Return empty object (empty list etc.) not `null`; fields never null. 
- `Optional` instead of `null` for "no value"; handle via `orElse`/`isPresent`, avoid bare `get()`. (L2)
- Validate arguments early (`Objects.requireNonNull(x, "msg")`, range checks), document thrown exceptions.
- `equals`/`hashCode`: avoid overriding; if so, immutable value type, override both together, honor Object contract.
- Reuse expensive objects: precompile `Pattern` as `static final` (not `String.matches` in loops), reuse formatters, `clear()` collections instead of recreating. No writable shared collections in static fields. (L2)
- Close resources with try-with-resources (`AutoCloseable`); manual `finally` + null check otherwise. (L3)
- Streams side-effect free (no mutating outside state in `forEach`/`map`). (L3)
- No reference leaks: return `Collections.unmodifiableList(...)`/copies, not internal mutable collections. (L3)

## VCS / structure
- Early, frequent commits; commit messages: imperative, ≤50-char capitalized summary, blank line, body wrapped ~72 (Tim Pope). (L1/L2)
- Feature branches + pull requests. (L2)
- Standard layout: `src/main/java/<pkg>/X.java`, `src/main/resources`, `src/test/java/<same pkg>/XTest.java`, `src/test/resources`; one top-level class per file. (L2)

## Notes
- `(Ln)` = PROG2/PM2 project level where graded; apply all unless user scopes to PROG1 (then skip L2-L4 items except those also in PROG1: naming, tidy code, method length, class behavior/surface/abstraction, unit tests, mocks, enums, interfaces, ctor collaborators, Javadoc, null objects, input validation, Object contract, collections).
- Rules are for Java only; don't apply to other languages.

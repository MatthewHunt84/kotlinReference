# Functions & Closures
#Android/Kotlin/Familiar

### Basic Function Syntax

> [!NOTE]
> Kotlin uses `fun` keyword for all functions. The return type comes after the parameter list with a colon instead of an arrow. 
> Default values are supported similarly.

| Task                       | Swift                                           | Kotlin                                   | Note                       |
|----------------------------|-------------------------------------------------|------------------------------------------|----------------------------|
| Simple function            | `func greet() { }`                              | `fun greet() { }`                        |                            |
| With parameters            | `func greet(name: String) { }`                  | `fun greet(name: String) { }`            |                            |
| With return type           | `func add(a: Int, b: Int) -> Int { }`           | `fun add(a: Int, b: Int): Int { }`       | Colon instead of arrow     |
| Single expression          | `func double(_ x: Int) -> Int { return x * 2 }` | `fun double(x: Int): Int = x * 2`        | Can omit braces and return |
| Single expression inferred | -                                               | `fun double(x: Int) = x * 2`             | Type inferred              |
| No return (Void)           | `func log() { }`                                | `fun log() { }` or `fun log(): Unit { }` | Unit is implicit           |

### Parameter Labels & Names

> [!WARNING]
> **Major difference**: Kotlin doesn't have argument labels. All parameters are named and can be called positionally or with names, but there's no separate external name.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| External & internal names | `func greet(person name: String) { }` | No equivalent | All params just have one name |
| Omit label | `func add(_ a: Int, _ b: Int) { }` | `fun add(a: Int, b: Int) { }` | All Kotlin params work this way |
| Named arguments | `greet(person: "Alice")` | `greet(name = "Alice")` | Use `=` not `:` |

### Default Parameters

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Default value | `func greet(name: String = "World") { }` | | |
| Call with default | `greet()` | | |
| Call without default | `greet(name: "Alice")` | `greet("Alice")` or `greet(name = "Alice")` | |

### Variadic Parameters

> [!NOTE]
> Kotlin uses `vararg` instead of `...`. The vararg parameter can be at any position (not just last), and you use spread operator `*` to pass arrays.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Variadic param | `func sum(_ numbers: Int...) { }` | `fun sum(vararg numbers: Int) { }` | Use `vararg` keyword |
| Access as array | `for n in numbers { }` | | Same - it's an array |
| Pass array | `sum([1, 2, 3])` | `sum(*arrayOf(1, 2, 3))` | Must use spread operator `*` |
| Call normally | `sum(1, 2, 3)` | | |

### Closures / Lambdas

> [!NOTE]
> Kotlin calls them "lambdas" but they work very similarly to Swift closures. The syntax is slightly different: parameters are inside braces with `->` separator.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Basic closure | `{ (x: Int) -> Int in return x * 2 }` | `{ x: Int -> x * 2 }` | No `return` needed |
| Type inference | `{ x in x * 2 }` | `{ x -> x * 2 }` | |
| Single parameter | `{ $0 * 2 }` | `{ it * 2 }` | Use `it` instead of `$0` |
| Multiple parameters | `{ $0 + $1 }` | `{ a, b -> a + b }` | Must name parameters |
| Trailing closure | `array.map { $0 * 2 }` | | Same syntax |
| Explicit return | `{ x in return x * 2 }` | `{ x -> return@map x * 2 }` | Need label for non-local return |

### Function Types

> [!NOTE]
> Kotlin uses `() ->` syntax for function types. Parameters in parens, arrow, then return type.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Function type | `(Int, Int) -> Int` | `(Int, Int) -> Int` | Identical! |
| No parameters | `() -> Int` | | |
| No return | `(Int) -> Void` | `(Int) -> Unit` | Use `Unit` |
| Store in variable | `let fn: (Int) -> Int = { $0 * 2 }` | `val fn: (Int) -> Int = { it * 2 }` | |
| Optional function | `var fn: ((Int) -> Int)?` | `var fn: ((Int) -> Int)?` | |

### Higher-Order Functions

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Function as parameter | `func apply(_ fn: (Int) -> Int) { }` | `fun apply(fn: (Int) -> Int) { }` | |
| Return function | `func makeMultiplier() -> (Int) -> Int { }` | `fun makeMultiplier(): (Int) -> Int { }` | |
| Call function param | `fn(5)` | | |

### Trailing Closure Syntax

> [!TIP]
> Both Swift and Kotlin support trailing closure syntax. In Kotlin, if the last parameter is a function, you can put the lambda outside the parentheses.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Single function param | `doSomething { print("done") }` | | |
| Last param is function | `array.map { $0 * 2 }` | | |
| Multiple params | `UIView.animate(withDuration: 1) { }` | Not quite the same | Kotlin requires all or nothing |

### Capturing Values

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Capture by reference | `{ count += 1 }` | | Both capture by reference by default |
| Capture list | `{ [weak self] in self?.update() }` | Not needed | Kotlin has no ARC/reference cycles |

### Common Functional Operations

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Map | `array.map { $0 * 2 }` | `array.map { it * 2 }` | |
| Filter | `array.filter { $0 > 5 }` | `array.filter { it > 5 }` | |
| Reduce | `array.reduce(0) { $0 + $1 }` | `array.reduce(0) { acc, n -> acc + n }` | Must name params |
| ForEach | `array.forEach { print($0) }` | `array.forEach { print(it) }` | |
| FlatMap | `array.flatMap { $0 }` | `array.flatMap { it }` | |
| CompactMap | `array.compactMap { Int($0) }` | `array.mapNotNull { it.toIntOrNull() }` | |
| First/where | `array.first { $0 > 5 }` | `array.firstOrNull { it > 5 }` | Returns nullable |
| Contains/where | `array.contains { $0 > 5 }` | `array.any { it > 5 }` | Different name |

### Inout Parameters / Reference Parameters

> [!WARNING]
> Kotlin doesn't have direct equivalent to `inout`. Collections are passed by reference anyway, but for primitives you'd need to use a wrapper class or return the new value.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Inout parameter | `func increment(_ value: inout Int) { }` | No direct equivalent | Return new value or use wrapper |
| Call with inout | `increment(&count)` | - | |

### Function Overloading

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Overload by param count | `func print(_ x: Int) { }` <br> `func print(_ x: Int, _ y: Int) { }` | `fun print(x: Int) { }` <br> `fun print(x: Int, y: Int) { }` | |
| Overload by type | `func process(_ x: Int) { }` <br> `func process(_ x: String) { }` | `fun process(x: Int) { }` <br> `fun process(x: String) { }` | |
| Overload by return | Allowed with context | Not allowed | Must differ by parameters |

### Extension Functions

> [!NOTE]
> This is a major Kotlin feature - see Part 2 for details. Swift has similar `extension` syntax but Kotlin's approach is lighter weight.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Add method to type | `extension String { func shout() -> String { } }` | `fun String.shout(): String { }` | See Part 2 |

### Local Functions

> [!NOTE]
> Kotlin allows defining functions inside other functions. These have access to the outer function's variables.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Nested function | `func outer() { func inner() { } }` | `fun outer() { fun inner() { } }` | |
| Access outer scope | `inner()` can access outer's vars | | |

### Operator Functions

> [!NOTE]
> Kotlin allows overloading operators by defining functions with special names and the `operator` keyword. See Part 2 for details.

### Generic Functions

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Generic function | `func identity<T>(_ value: T) -> T { }` | `fun <T> identity(value: T): T { }` | Type params before name |
| Multiple type params | `func pair<T, U>(_ a: T, _ b: U) { }` | `fun <T, U> pair(a: T, b: U) { }` | |
| Generic constraints | `func process<T: Comparable>(_ value: T) { }` | `fun <T: Comparable<T>> process(value: T) { }` | Must specify Comparable's type param |

### Inline Functions

> [!NOTE]
> Kotlin's `inline` is different from Swift's `@inline`. It tells the compiler to copy the function body to call sites, which is particularly useful for lambdas to avoid object allocation.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Inline hint | `@inline(__always) func fast() { }` | `inline fun fast() { }` | Different purposes |

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - Single-expression functions with `=` are more concise
> - `it` for single parameter lambdas is cleaner
> - Local functions for better organization
> - No argument labels simplifies function signatures

> [!WARNING]
> **Watch out for:**
> - No separate external parameter names in Kotlin
> - Named arguments use `=` not `:`
> - Use `it` not `$0` for single parameter lambdas
> - Must name parameters in multi-parameter lambdas (no `$0`, `$1`)
> - No `inout` - return new values or use wrappers
> - `vararg` keyword and spread operator `*` for variadic params
> - Type parameters come before function name: `fun <T> identity()`
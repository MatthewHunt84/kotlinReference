# Advanced Nullability
#Android/Kotlin/Familiar

## Advanced Nullability Patterns

> [!NOTE]
> Basic nullable types were covered in Type System & Basics. This section covers advanced patterns for working with nullability in Kotlin.

### Quick Reference

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Optional type | `String?` | | |
| Nil coalescing | `name ?? "Unknown"` | `name ?: "Unknown"` | Elvis operator |
| Safe call | `user?.name` | | |
| Force unwrap | `name!` | `name!!` | Avoid in both languages |
| Optional chaining | `user?.address?.street` | | |

### Safe Call Operator

> [!NOTE]
> The safe call operator `?.` works identically in both languages, but Kotlin has some additional capabilities.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Safe property access | `user?.name` | | |
| Safe method call | `text?.isEmpty` | `text?.isEmpty()` | Property vs method |
| Safe subscript | `array?[0]` | `array?.get(0)` or `array?.getOrNull(0)` | |
| Chain safe calls | `user?.address?.street?.name` | | |

### Let / Scope Functions

> [!NOTE]
> Swift's `if let` pattern doesn't have a direct Kotlin equivalent, but Kotlin's scope functions (especially `let`) provide similar functionality. See the ‘Unique’ section for details on all scope functions.

```swift
// Swift
if let name = optionalName {
    print("Hello, \(name)")
}

guard let name = optionalName else {
    return
}
```

```kotlin
// Kotlin - using let
optionalName?.let { name ->
    println("Hello, $name")
}

// Early return
val name = optionalName ?: return
```

### Elvis Operator Advanced Usage

> [!TIP]
> The Elvis operator `?:` can be used with `return` or `throw` for early exits. This is more powerful than Swift's `??`.

```kotlin
// Return on null
fun greet(name: String?) {
    val userName = name ?: return
    println("Hello, $userName")
}

// Throw on null
fun process(data: Data?) {
    val validData = data ?: throw IllegalArgumentException("Data required")
    // use validData
}

// Call function on null
val value = getValue() ?: getDefaultValue()

// Multiple chaining
val result = first() ?: second() ?: third() ?: "default"
```

### Not-Null Assertion

> [!WARNING]
> The not-null assertion `!!` should be avoided. It throws `NullPointerException` if the value is null. Use safer alternatives.

```kotlin
// ❌ Avoid - will crash if null
val length = text!!.length

// ✅ Better - safe call
val length = text?.length

// ✅ Better - with default
val length = text?.length ?: 0

// ✅ Better - early return
val length = text?.length ?: return
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Force unwrap | `text!` | `text!!` | Both throw if null |
| When to use | Never (prefer safe alternatives) | Never (prefer safe alternatives) | Only when 100% certain |

### Safe Casting with Nullability

```kotlin
// Safe cast returns null if cast fails
val str: String? = obj as? String

// Use with Elvis for default
val str: String = obj as? String ?: "default"

// Use with let
(obj as? String)?.let { str ->
    println("String value: $str")
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Safe cast | `value as? String` | | |
| Use cast result | `if let str = value as? String { }` | `(value as? String)?.let { str -> }` | |
| Cast with default | `(value as? String) ?? "default"` | `value as? String ?: "default"` | |

### Checking for Null

> [!NOTE]
> After checking for null in an `if` condition, Kotlin smart-casts the variable to non-null in that scope.

```kotlin
fun printLength(text: String?) {
    if (text != null) {
        // text is smart-cast to String (non-null)
        println(text.length)  // No safe call needed
    }
}

// Works with more complex conditions
fun process(a: String?, b: String?) {
    if (a != null && b != null) {
        // Both a and b are non-null here
        val combined = a + b
    }
}

// Also works with return
fun greet(name: String?) {
    if (name == null) return
    // name is non-null here
    println("Hello, $name")
}
```

### Collection of Optionals / Nullables

```swift
// Swift
let names: [String?] = ["Alice", nil, "Bob"]
let validNames = names.compactMap { $0 }  // ["Alice", "Bob"]
```

```kotlin
// Kotlin
val names: List<String?> = listOf("Alice", null, "Bob")
val validNames = names.mapNotNull { it }  // ["Alice", "Bob"]

// Or using filterNotNull
val validNames = names.filterNotNull()
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Filter out nils/nulls | `array.compactMap { $0 }` | `array.filterNotNull()` | More explicit in Kotlin |
| Map and filter nulls | `array.compactMap { transform($0) }` | `array.mapNotNull { transform(it) }` | |

### Platform Types from Java Interop

> [!NOTE]
> When calling Java code, Kotlin represents types that might be nullable as "platform types" denoted with `!` (e.g., `String!`). Treat these as potentially nullable.

```kotlin
// Java method: String getName() { ... }
// In Kotlin, this returns String! (platform type)

val javaObject = getJavaObject()
val name = javaObject.name  // String! - might be null

// Treat as nullable to be safe
val safeName: String? = javaObject.name
```

### Late Initialization

> [!NOTE]
> `lateinit` allows declaring non-null `var` properties that are initialized later. Accessing before initialization throws an exception.

```kotlin
class MyActivity {
    lateinit var binding: ActivityBinding
    
    fun onCreate() {
        binding = ActivityBinding.inflate(layoutInflater)
    }
    
    fun onDestroy() {
        // Check if initialized
        if (::binding.isInitialized) {
            binding.cleanup()
        }
    }
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Late initialization | `var name: String!` | `lateinit var name: String` | Cannot be `val` or primitives |
| Check if initialized | - | `::propertyName.isInitialized` | Returns Boolean |
| Access before init | Crashes | Throws `UninitializedPropertyAccessException` | |

### Nullable Receiver in Extensions

> [!TIP]
> Extension functions can be defined on nullable types, allowing you to call them even when the receiver is null.

```kotlin
// Extension on nullable String
fun String?.isNullOrEmpty(): Boolean {
    return this == null || this.isEmpty()
}

// Usage
val text: String? = null
if (text.isNullOrEmpty()) {  // Works even though text is null
    println("Empty or null")
}
```

This is how Kotlin's standard library implements functions like `.isNullOrEmpty()`, `.isNullOrBlank()`, etc.

### Null Coalescing with Functions

```kotlin
// Call function only if not null
fun process(data: Data?) {
    data?.let { processData(it) }
}

// Or using apply/also - see Part 2
data?.apply {
    validate()
    transform()
}
```

### Safe Calls with Collections

```kotlin
// Safe access to collection elements
val first: String? = list?.firstOrNull()
val element: String? = list?.getOrNull(5)

// Filter with null-safe predicate
val filtered = list?.filter { it.length > 5 }

// Chain operations
val result = users
    ?.filter { it.isActive }
    ?.map { it.name }
    ?.firstOrNull()
```

### Assertions for Non-Null

> [!NOTE]
> Use `requireNotNull()` and `checkNotNull()` to assert non-nullability with better error messages than `!!`.

```kotlin
fun process(data: Data?) {
    // Throws IllegalArgumentException if null
    val validData = requireNotNull(data) { "Data must not be null" }
    
    // Throws IllegalStateException if null
    val state = checkNotNull(currentState) { "State not initialized" }
}
```

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Assert non-null | `guard let value = optional else { fatalError() }` | `requireNotNull(value) { "message" }` | For arguments |
| Assert state | - | `checkNotNull(value) { "message" }` | For state |
| Silent assert | `value!` | `value!!` | Avoid both |

### Optional Mapping

```swift
// Swift
let upper = name?.uppercased()
```

```kotlin
// Kotlin
val upper = name?.uppercase()

// More complex transformations
val length: Int? = name?.let { it.trim().length }
```

### Multiple Optionals / Nullables

```swift
// Swift - unwrap multiple
if let first = firstName, let last = lastName {
    print("\(first) \(last)")
}
```

```kotlin
// Kotlin - various approaches

// Approach 1: Multiple checks
if (firstName != null && lastName != null) {
    println("$firstName $lastName")
}

// Approach 2: Safe calls with Elvis
val fullName = firstName?.let { first ->
    lastName?.let { last ->
        "$first $last"
    }
} ?: "Unknown"

// Approach 3: When expression
when {
    firstName != null && lastName != null -> println("$firstName $lastName")
    else -> println("Missing name")
}
```

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - Elvis operator `?:` can be used with `return`/`throw`
> - Smart casting after null checks
> - `lateinit` for late initialization
> - Nullable receiver extensions
> - `requireNotNull()`/`checkNotNull()` for better error messages
> - `filterNotNull()` more explicit than `compactMap`

> [!WARNING]
> **Watch out for:**
> - Double bang `!!` should be avoided (just like Swift's `!`)
> - `lateinit` only works with `var`, not `val`
> - `lateinit` cannot be used with primitives (Int, Boolean, etc.)
> - Platform types (`String!`) from Java can be null - treat as nullable
> - No direct equivalent to Swift's `if let` - use `?.let { }` or null checks
> - No `guard let` - use Elvis with return: `?: return`
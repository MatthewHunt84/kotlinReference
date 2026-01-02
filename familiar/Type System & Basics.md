# Type System & Basics
#Android/Kotlin/Familiar

### Variable Declaration

> [!NOTE]
> Kotlin uses `lateinit` instead of Swift's implicitly unwrapped optionals or `lazy`. Unlike `lazy`, `lateinit` variables must be assigned before use (not computed on first access), and can only be used with `var`, not `val`.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Immutable variable | `let name = "John"` | `val name = "John"` | |
| Mutable variable | `var age = 25` | | |
| Explicit type | `let name: String = "John"` | | |
| Lazy initialization | `var name: String!` or `lazy var` | `lateinit var name: String` | Must assign before use, vars only |

### Primitive Types

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Integer | `Int` | | |
| Long integer | `Int64` | `Long` | |
| Float | `Float` | | |
| Double | `Double` | | |
| Boolean | `Bool` | `Boolean` | |
| Character | `Character` | `Char` | |
| Byte | `UInt8` | `Byte` | |

### Type Checking & Casting

> [!NOTE]
> **Smart Casts**: After checking a type with `is`, Kotlin automatically casts the variable in that scope. No manual casting needed!

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Type inference | `let x = 5` | `val x = 5` | |
| Type checking | `if value is String` | `if (value is String)` | |
| Safe casting | `value as? String` | | |
| Force casting | `value as! String` | `value as String` | Throws exception if fails |
| Smart casting | - | Automatic after `is` check | Auto-casts in scope after type check |

**Smart Cast Example:**

```kotlin
fun printLength(obj: Any) {
    if (obj is String) {
        // obj is automatically cast to String here
        println(obj.length)  // No need to cast!
    }
}
```

### Optionals / Nullability

> [!NOTE]
> Kotlin's null safety syntax is nearly identical to Swift's optionals! The main differences: `??` becomes `?:` (the "Elvis operator") and force unwrap uses `!!` instead of `!`.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Optional type | `String?` | | |
| Non-null type | `String` | | |
| Nil coalescing | `name ?? "Unknown"` | `name ?: "Unknown"` | Elvis operator |
| Safe property access | `user?.name` | | |
| Force unwrap | `name!` | `name!!` | Double bang - avoid when possible |
| Optional chaining | `user?.address?.street` | | |
| Nil check | `if name != nil` | `if (name != null)` | |

**Optional binding vs scope function:**

```swift
// Swift
if let name = optionalName {
    print(name)  // unwrapped
}
```

```kotlin
// Kotlin - see Part 2 for scope functions
optionalName?.let { name ->
    println(name)  // unwrapped
}
```

### Strings

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| String literal | `"Hello"` | | |
| Multi-line string | `"""..."""` | | |
| String interpolation | `"Hello \(name)"` | `"Hello $name"` | Use `$` instead of `\()` |
| Complex interpolation | `"Result: \(x + y)"` | `"Result: ${x + y}"` | Use `${}` for expressions |
| Character access | `str[str.startIndex]` | `str[0]` | Simpler indexing in Kotlin |
| Length | `str.count` | `str.length` | |
| Concatenation | `str1 + str2` | | |
| String comparison | `str1 == str2` | | Both use `==` for value comparison |

### Characters

> [!NOTE]
> **Important**: Kotlin uses single quotes `'A'` for `Char` literals, while Swift uses double quotes. Double quotes are always strings in Kotlin.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Character literal | `let c: Character = "A"` | `val c: Char = 'A'` | Single quotes required |
| From string | `"A".first!` | `"A"[0]` or `"A".first()` | |
| To string | `String(char)` | `char.toString()` | |
| Check if digit | `char.isNumber` | `char.isDigit()` | Property vs method |
| Check if letter | `char.isLetter` | `char.isLetter()` | Property vs method |

### Boolean

| **Task** | **Swift** | **Kotlin** | **Note** |
|:-:|:-:|:-:|:-:|
| Boolean type | Bool | Boolean | Different name |
| True/False | true, false | true, false | Same |
| Logical AND | && | && | Same |
| Logical OR | ` |  | ` |
| Logical NOT | ! | ! | Same |

### Number Operations

> [!NOTE]
> Unlike Swift's failable initializers that return optionals, Kotlin's `.toInt()` throws an exception. Use `.toIntOrNull()` for safe parsing that returns a nullable type.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Convert to string | `String(number)` | `number.toString()` | |
| Parse from string | `Int("42")` returns `Int?` | `"42".toInt()` | Throws exception on failure |
| Safe parse | `Int("42")` | `"42".toIntOrNull()` | Returns null on failure |
| Min/Max | `min(a, b)` | | |
| Absolute value | `abs(x)` | | |
| Random number | `Int.random(in: 0..<10)` | `(0..<10).random()` | Called on the range |

### Type Conversion

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Int to Double | `Double(intValue)` | `intValue.toDouble()` | |
| Double to Int | `Int(doubleValue)` | `doubleValue.toInt()` | |
| String to Int | `Int(string)` | `string.toInt()` | See safe parse above |
| Any to String | `String(describing: value)` | `value.toString()` | Everything has `toString()` |

### Constants

> [!NOTE]
> Kotlin requires `const val` for compile-time constants. These must be top-level or in objects/companion objects (see Part 2), and can only be primitive types or Strings.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| File-level constant | `let PI = 3.14` | `const val PI = 3.14` | Requires `const` keyword |
| Class constant | `static let MAX = 100` | See Part 2: Companion Objects | Different approach in Kotlin |
| Computed property | `static var computed: Int { return x }` | See Part 2: Companion Objects | |

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - Smart casts eliminate many manual casts
> - Simpler string indexing with `[]`
> - Everything has `.toString()`
> - Explicit null-safety at compile time

> [!WARNING]
> **Watch out for:**
> - `Boolean` vs `Bool` (different spelling)
> - Single quotes `'A'` for `Char`, double quotes `"A"` for `String`
> - `.toInt()` throws exceptions (use `.toIntOrNull()` for safety)
> - `!!` force unwrap is discouraged (use safer alternatives)
> - `const val` required for compile-time constants
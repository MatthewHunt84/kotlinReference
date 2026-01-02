# Control Flow
#Android/Kotlin/Familiar

### If Statements

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Basic if | `if condition { }` | `if (condition) { }` | Parens required in Kotlin |
| If-else | `if condition { } else { }` | | |
| Else-if | `if x > 0 { } else if x < 0 { } else { }` | | |

### If as Expression

> [!NOTE]
> In Kotlin, `if` is an expression that returns a value, similar to Swift's ternary operator. This is often more concise than Swift's `if`/`else` statements.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Ternary operator | `let max = a > b ? a : b` | `val max = if (a > b) a else b` | No ternary operator in Kotlin |
| If expression | - | `val result = if (x > 0) "positive" else "negative"` | Can assign result |
| Multi-line if expression | - | `val result = if (x > 0) {` <br> `  "positive"` <br> `} else {` <br> `  "negative"` <br> `}` | Last expression is returned |

### Switch / When

> [!NOTE]
> Kotlin uses `when` instead of `switch`. It's much more powerful - it can match on types, ranges, expressions, and more. It's also an expression that returns a value.

| Task            | Swift                                       | Kotlin                                  | Note                                |
|-----------------|---------------------------------------------|-----------------------------------------|-------------------------------------|
| Basic switch    | `switch value { case 1: ... default: ... }` | `when (value) { 1 -> ... else -> ... }` | Use `when` and arrows               |
| Multiple values | `case 1, 2, 3:`                             | `1, 2, 3 ->`                            | Comma-separated                     |
| Range           | `case 1...10:`                              | `in 1..10 ->`                           | Use `in` keyword                    |
| No fallthrough  | Break is automatic                          | Break is automatic                      | Both prevent fallthrough by default |
| Fallthrough     | `fallthrough`                               | Not needed/supported                    | Each branch independent             |

**When as expression:**

```kotlin
val description = when (value) {
    1 -> "one"
    2 -> "two"
    else -> "other"
}
```

### Advanced When Patterns

> [!TIP]
> Kotlin's `when` can do things Swift's `switch` can't easily do, like matching on arbitrary expressions or checking types.

```kotlin
// Without argument - like if-else chain
when {
    x > 0 -> println("positive")
    x < 0 -> println("negative")
    else -> println("zero")
}

// Type checking
when (obj) {
    is String -> println("String of length ${obj.length}")
    is Int -> println("Int: $obj")
    else -> println("Unknown")
}

// Smart casts work inside when branches
when (val response = getResponse()) {
    is Success -> println(response.data)  // response is cast to Success
    is Error -> println(response.message)  // response is cast to Error
}
```

### For Loops

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| For-in | `for item in array { }` | `for (item in array) { }` | Parens required |
| Range | `for i in 0..<10 { }` | `for (i in 0..<10) { }` or `for (i in 0 until 10) { }` | |
| Closed range | `for i in 0...10 { }` | `for (i in 0..10) { }` | |
| Reverse range | `for i in (0...10).reversed() { }` | `for (i in 10 downTo 0) { }` | |
| Step | `for i in stride(from: 0, to: 10, by: 2) { }` | `for (i in 0..<10 step 2) { }` | |
| With index | `for (index, item) in array.enumerated() { }` | `for ((index, item) in array.withIndex()) { }` | Extra parens for destructuring |
| Iterate map | `for (key, value) in map { }` | | |

### While Loops

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| While | `while condition { }` | `while (condition) { }` | Parens required |
| Repeat-while | `repeat { } while condition` | `do { } while (condition)` | `do` instead of `repeat` |

### Break and Continue

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Break | `break` | | |
| Continue | `continue` | | |
| Labeled break | `break outerLoop` | `break@outerLoop` | Use `@` for labels |
| Labeled continue | `continue outerLoop` | `continue@outerLoop` | |

### Labels

> [!NOTE]
> Kotlin uses `@` suffix for labels instead of `:` suffix like Swift.

```swift
// Swift
outerLoop: for i in 0..<10 {
    for j in 0..<10 {
        if j == 5 { break outerLoop }
    }
}
```

```kotlin
// Kotlin
outerLoop@ for (i in 0..<10) {
    for (j in 0..<10) {
        if (j == 5) break@outerLoop
    }
}
```

### Guard Statements

> [!WARNING]
> Kotlin doesn't have `guard`. Use early returns with `if` + `return`, or use `require()`/`check()` for preconditions.

```swift
// Swift
guard let name = optionalName else {
    return
}
// use name
```

```kotlin
// Kotlin approach 1: early return
val name = optionalName ?: return
// use name

// Kotlin approach 2: require for preconditions
val name = requireNotNull(optionalName) { "Name must not be null" }
// use name
```

### Return, Break, Continue in Lambdas

> [!NOTE]
> In Kotlin, `return` in a lambda returns from the enclosing function (non-local return). Use `return@` with a label to return from just the lambda.

```swift
// Swift - returns from closure
array.forEach { item in
    if item < 0 { return }  // returns from forEach
    print(item)
}
```

```kotlin
// Kotlin - would return from enclosing function!
array.forEach { item ->
    if (item < 0) return  // returns from enclosing function!
    print(item)
}

// To return from just the lambda:
array.forEach { item ->
    if (item < 0) return@forEach  // returns from forEach only
    print(item)
}
```

### Exception Handling

> [!NOTE]
> Covered in detail in the "Error Handling" section, but here's the control flow syntax.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Try-catch | `do { try ... } catch { }` | `try { ... } catch (e: Exception) { }` | Must specify exception type |
| Finally | `defer { }` | `finally { }` | Different keyword |
| Try as expression | - | `val result = try { ... } catch (e: Exception) { null }` | Can assign result |

### Ranges and Progression

> [!TIP]
> Kotlin has first-class range objects that can be stored, passed, and manipulated.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Ascending range | `0..<10` or `0...10` | `0..<10` or `0..10` or `0 until 10` | |
| Descending range | `(0...10).reversed()` | `10 downTo 0` | |
| Check contains | `(0..<10).contains(5)` | `5 in 0..<10` | More natural in Kotlin |
| Check not contains | `!(0..<10).contains(5)` | `5 !in 0..<10` | |
| Iterate range | `for i in 0..<10 { }` | `for (i in 0..<10) { }` | |

### Elvis Operator

> [!NOTE]
> The Elvis operator `?:` is like Swift's `??` but has an additional use case: it can be used with `return` or `throw` for early exits.

```kotlin
// Standard nil coalescing
val name = optionalName ?: "Unknown"

// Early return
val name = optionalName ?: return

// Throw exception
val name = optionalName ?: throw IllegalArgumentException("Name required")
```

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - `if` and `when` are expressions (can return values)
> - `when` is much more powerful than Swift's `switch`
> - Ranges are first-class objects with `in` operator
> - `in` and `!in` for membership testing

> [!WARNING]
> **Watch out for:**
> - Parentheses required around conditions: `if (x > 0)` not `if x > 0`
> - No ternary operator - use `if` expression instead
> - No `guard` - use early returns or `require()`/`check()`
> - `when` uses `->` not `:` for cases
> - Labels use `@` suffix: `loop@` not `loop:`
> - `return` in lambdas can return from enclosing function - use `return@label`
> - `do-while` not `repeat-while`
# Smart Casts
#android/Kotlin/Unique

> [!NOTE]
> Smart casts are one of Kotlin's most convenient features. After checking a type with `is`, Kotlin automatically casts the variable to that type in the appropriate scope. No manual casting needed!

### Basic Smart Casting

```kotlin
fun process(obj: Any) {
    if (obj is String) {
        // obj is automatically cast to String here
        println(obj.length)  // No cast needed!
        println(obj.uppercase())
    }
}
```

**Comparison with explicit casting:**

```kotlin
// Without smart cast (manual approach)
if (obj is String) {
    val str = obj as String
    println(str.length)
}

// With smart cast (automatic!)
if (obj is String) {
    println(obj.length)  // Already cast
}
```

### When Smart Casts Work

> [!IMPORTANT]
> Smart casts only work when the compiler can guarantee the value hasn't changed between the check and usage. This means:
> - ✅ Local variables (val and var)
> - ✅ Immutable properties (val) without custom getters
> - ❌ Mutable properties (var) that could be changed by other threads
> - ❌ Properties with custom getters

```kotlin
class Example {
    val immutableProp: Any = "Hello"
    var mutableProp: Any = "World"
    
    fun test() {
        // ✅ Works - immutable property
        if (immutableProp is String) {
            println(immutableProp.length)
        }
        
        // ❌ Doesn't work - mutable property
        if (mutableProp is String) {
            // println(mutableProp.length)  // Error!
            println((mutableProp as String).length)  // Need explicit cast
        }
        
        // ✅ Works - local variable
        val local = mutableProp
        if (local is String) {
            println(local.length)  // Smart cast works!
        }
    }
}
```

### Smart Casts in Conditions

**After type check:**

```kotlin
fun describe(obj: Any): String {
    if (obj is String) {
        return "String of length ${obj.length}"
    }
    if (obj is Int) {
        return "Integer: $obj"
    }
    return "Unknown type"
}
```

**With && operator:**

```kotlin
if (obj is String && obj.length > 5) {
    // obj is String in this entire block
    println(obj.uppercase())
}

// Both conditions must be true
if (obj is String && obj.isNotEmpty()) {
    println(obj[0])  // obj is String
}
```

**With || operator:**

```kotlin
// After ||, not smart cast (could be either type)
if (obj !is String || obj.length == 0) {
    return
}
// Here, obj must be String with length > 0
println(obj.uppercase())
```

**Negative checks:**

```kotlin
if (obj !is String) {
    return
}
// After early return, obj must be String
println(obj.length)
```

### Smart Casts with When Expressions

> [!TIP]
> `when` expressions are perfect for smart casts. Each branch automatically casts to the checked type.

```kotlin
fun process(obj: Any) = when (obj) {
    is String -> obj.uppercase()  // obj is String
    is Int -> obj * 2             // obj is Int
    is List<*> -> obj.size        // obj is List
    else -> null
}

// With multiple conditions
when (obj) {
    is String -> {
        println("String: ${obj.length}")
        obj.uppercase()
    }
    is Int -> {
        println("Int: $obj")
        obj * 2
    }
    is Boolean -> {
        if (obj) "yes" else "no"  // obj is Boolean
    }
    else -> "unknown"
}
```

**Capturing value in when:**

```kotlin
when (val result = getResult()) {
    is Success -> println(result.data)  // result is Success
    is Error -> println(result.message)  // result is Error
}
```

### Smart Casts with Nullable Types

```kotlin
fun printLength(str: String?) {
    if (str != null) {
        // str is smart-cast to String (non-null)
        println(str.length)
    }
}

// With Elvis operator
fun process(value: String?) {
    val nonNull = value ?: return
    // nonNull is String (not nullable)
    println(nonNull.length)
}

// In when
fun describe(value: String?) = when {
    value == null -> "null"
    value.isEmpty() -> "empty"  // value is String here
    else -> "length: ${value.length}"
}
```

### Smart Casts Across Scopes

**In if-else:**

```kotlin
if (obj is String) {
    println(obj.length)  // String
} else {
    // obj is NOT String here
}

// After if with return
if (obj !is String) return
println(obj.length)  // String (guaranteed by early return)
```

**In when with else:**

```kotlin
when {
    obj is String -> println(obj.length)
    obj is Int -> println(obj * 2)
    else -> {
        // obj is neither String nor Int here
    }
}
```

### Safe Casts with Smart Casts

```kotlin
// as? returns null if cast fails
val str: String? = obj as? String

// Combine with null check for smart cast
val str = obj as? String
if (str != null) {
    println(str.length)  // str is String (non-null)
}

// Or with Elvis
val length = (obj as? String)?.length ?: 0

// Or with let
(obj as? String)?.let { str ->
    println(str.length)  // str is String
}
```

### Smart Casts with Custom Types

```kotlin
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val message: String) : Result()
}

fun handle(result: Result) {
    when (result) {
        is Result.Success -> {
            // result is automatically Success
            println(result.data)
        }
        is Result.Error -> {
            // result is automatically Error
            println(result.message)
        }
    }
}
```

### Smart Casts in Logical Expressions

**Complex conditions:**

```kotlin
// All of these enable smart cast
if (obj is String && obj.isNotEmpty() && obj.length > 5) {
    println(obj.uppercase())  // obj is String throughout
}

// Order matters
if (obj !is String || obj.isEmpty()) {
    return
}
// obj is guaranteed to be non-empty String here
println(obj[0])
```

**Short-circuiting:**

```kotlin
// Works because of short-circuit evaluation
if (obj is String && obj.length > 5) {
    // obj.length is only checked if obj is String
}

// This would fail without smart cast
// if (obj.length > 5 && obj is String)  // Error! Can't check length before is check
```

### Common Patterns

**Guard pattern:**

```kotlin
fun processUser(user: Any?) {
    if (user !is User) return
    // user is User here
    
    if (user.name.isEmpty()) return
    // user.name is non-empty String here
}
```

**Safe navigation with smart cast:**

```kotlin
fun getName(obj: Any?): String? {
    return (obj as? User)?.name
}

// Or with when
fun getName(obj: Any?) = when (obj) {
    is User -> obj.name
    else -> null
}
```

**Collection filtering with type:**

```kotlin
val items: List<Any> = listOf(1, "two", 3, "four")

// filterIsInstance with smart cast
val strings: List<String> = items.filterIsInstance<String>()
strings.forEach { str ->
    println(str.uppercase())  // str is String
}

// Manual filtering
items.forEach { item ->
    if (item is String) {
        println(item.uppercase())  // item is String
    }
}
```

### When Smart Casts Don't Work

> [!WARNING]
> Smart casts have limitations. Be aware of these cases:

**Mutable properties:**

```kotlin
class Container {
    var value: Any = "Hello"
    
    fun test() {
        if (value is String) {
            // Can't smart cast - value could change
            // println(value.length)  // Error!
        }
    }
}

// Solution: use local variable
fun test() {
    val local = value
    if (local is String) {
        println(local.length)  // Works!
    }
}
```

**Custom getters:**

```kotlin
val value: Any
    get() = getValueFromSomewhere()

fun test() {
    if (value is String) {
        // Can't smart cast - getter could return different value
        // println(value.length)  // Error!
    }
}
```

**Properties accessed from other objects:**

```kotlin
class User(var data: Any)

fun process(user: User) {
    if (user.data is String) {
        // Can't smart cast - data could be changed by another thread
        // println(user.data.length)  // Error!
        
        // Solution: use local variable
        val data = user.data
        if (data is String) {
            println(data.length)  // Works!
        }
    }
}
```

### Sealed Classes and Exhaustive When

> [!TIP]
> Smart casts work especially well with sealed classes, enabling exhaustive when expressions without `else`.

```kotlin
sealed class UiState {
    object Loading : UiState()
    data class Success(val data: String) : UiState()
    data class Error(val message: String) : UiState()
}

fun render(state: UiState) = when (state) {
    is UiState.Loading -> showLoading()
    is UiState.Success -> showData(state.data)  // state is Success
    is UiState.Error -> showError(state.message)  // state is Error
    // No else needed - compiler knows all cases covered
}
```

### Combining with Other Features

**With scope functions:**

```kotlin
// Smart cast + let
obj.takeIf { it is String }?.let { str ->
    // Doesn't smart cast inside let
    println((str as String).length)
}

// Better pattern
if (obj is String) {
    obj.let { str ->
        println(str.length)  // str is String due to outer check
    }
}
```

**With nullable checks:**

```kotlin
fun process(value: Any?) {
    if (value != null && value is String) {
        // value is String (non-null)
        println(value.length)
    }
}

// Order matters
if (value is String && value != null) {
    // This also works, but first check is redundant
    // (is String already implies not null)
}
```

### Performance Considerations

> [!NOTE]
> Smart casts have no runtime overhead - they're a compile-time feature. The compiler inserts the cast where needed.

```kotlin
// These are equivalent at runtime
if (obj is String) {
    println(obj.length)
}

if (obj is String) {
    println((obj as String).length)
}
```

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - Smart casts work after `is` checks in the appropriate scope
> - Only works when the compiler can guarantee the value hasn't changed
> - Use local variables to enable smart casts for mutable properties
> - Works great with `when` expressions
> - Combine with null checks for nullable types
> - No runtime overhead - purely a compile-time feature
> - `when` with sealed classes enables exhaustive checking with smart casts
# Extension Functions
#android/Kotlin/Unique

Extension functions allow you to add new functions to existing classes without modifying their source code or using inheritance. While Swift has extensions, Kotlin's approach is different enough to warrant special attention.

### Swift vs Kotlin: The Key Difference

**Swift Extensions:**

```swift
extension String {
    func addExclamation() -> String {
        return self + "!"
    }
}

"Hello".addExclamation()  // "Hello!"
```

**Kotlin Extension Functions:**

```kotlin
fun String.addExclamation(): String {
    return this + "!"
}

"Hello".addExclamation()  // "Hello!"
```

| Aspect | Swift | Kotlin |
|--------|-------|--------|
| Syntax wrapper | `extension Type { }` | No wrapper needed |
| Multiple functions | Grouped in extension block | Each function separate |
| Access to internals | Can access private members | Only public/internal members |
| This/self | `self` | `this` |

### Basic Syntax

```kotlin
fun ReceiverType.functionName(parameters): ReturnType {
    // this refers to the receiver object
    return result
}
```

- **ReceiverType**: The type you're extending
- **this**: Refers to the instance the function is called on
- The function can be called as if it were a method of ReceiverType

### Common Patterns

#### 1. Adding Utility Functions

```kotlin
// Add a function to check if a string is a valid email
fun String.isValidEmail(): Boolean {
    return this.contains("@") && this.contains(".")
}

// Usage
val email = "user@example.com"
if (email.isValidEmail()) {
    println("Valid email")
}
```

#### 2. Extending Collections

```kotlin
// Get second element safely
fun <T> List<T>.secondOrNull(): T? {
    return if (this.size >= 2) this[1] else null
}

// Usage
val numbers = listOf(1, 2, 3)
val second = numbers.secondOrNull()  // 2
```

#### 3. Domain-Specific Extensions

```kotlin
// Add domain logic to standard types
fun Int.toPixels(): String {
    return "${this}px"
}

fun Int.toPercent(): String {
    return "$this%"
}

// Usage
val width = 100.toPixels()    // "100px"
val opacity = 80.toPercent()  // "80%"
```

#### 4. Chaining Operations

```kotlin
fun String.removeWhitespace(): String {
    return this.replace(" ", "")
}

fun String.capitalize(): String {
    return this.replaceFirstChar { it.uppercase() }
}

// Usage - can chain extension functions
val result = "hello world"
    .removeWhitespace()
    .capitalize()  // "Helloworld"
```

### Extension Properties

You can also extend classes with properties (read-only or read-write with backing fields):

```kotlin
// Extension property (read-only)
val String.firstChar: Char?
    get() = this.firstOrNull()

// Usage
"Hello".firstChar  // 'H'

// Extension property with getter and setter
var StringBuilder.firstChar: Char
    get() = this[0]
    set(value) {
        this.setCharAt(0, value)
    }
```

**Note:** Extension properties cannot have backing fields (no `field` keyword), so they must define custom getters.

### Nullable Receiver Extensions

You can create extensions that work on nullable types:

```kotlin
fun String?.isNullOrEmpty(): Boolean {
    return this == null || this.isEmpty()
}

// Usage
val name: String? = null
if (name.isNullOrEmpty()) {
    println("Name is null or empty")
}
```

This is actually how Kotlin's standard library implements many null-safe utility functions!

### Generic Extension Functions

```kotlin
// Extension function with generic type
fun <T> T.print(): T {
    println(this)
    return this
}

// Usage
"Hello".print()  // Prints: Hello
42.print()       // Prints: 42

// More complex example
fun <T> List<T>.secondHalf(): List<T> {
    val midpoint = this.size / 2
    return this.subList(midpoint, this.size)
}
```

### When to Use Extension Functions

**✅ Good use cases:**
- Adding utility functions to classes you don't control
- Creating domain-specific APIs
- Improving readability by making operations read like methods
- Adding convenience functions to standard library types
- Implementing adapter patterns

**❌ Avoid when:**
- You control the class (just add a regular method)
- The logic is complex and should be in a separate utility class
- You need access to private members of the class

### Important Limitations

1. **Static Resolution**: Extensions are resolved statically, not dynamically

```kotlin
open class Shape
class Circle : Shape()

fun Shape.name() = "Shape"
fun Circle.name() = "Circle"

fun printName(shape: Shape) {
    println(shape.name())  // Always prints "Shape"
}

printName(Circle())  // Prints "Shape", not "Circle"
```

2. **No Override**: Extensions cannot override existing class members

```kotlin
class MyClass {
    fun foo() = "Member"
}

fun MyClass.foo() = "Extension"  // This won't be called

MyClass().foo()  // Returns "Member"
```

3. **Scope**: Extensions are scoped to the file/package unless imported

```kotlin
// File1.kt
fun String.reverse(): String = this.reversed()

// File2.kt
// Need to import if in different package
import com.example.reverse

val reversed = "Hello".reverse()
```

### Comparing to Swift Extensions

| Feature | Swift | Kotlin |
|---------|-------|--------|
| Grouping | Extensions group related functions | Each function standalone |
| Protocol conformance | Can add protocol conformance | Separate interface implementation |
| Stored properties | Can't add stored properties | Can't add stored properties |
| Computed properties | ✅ Yes | ✅ Yes (must define getter) |
| Private access | ✅ Can access private | ❌ Only public/internal |
| Conditional extensions | ✅ Protocol constraints | ✅ Generic constraints |

### Real-World Examples from Android Development

```kotlin
// Common Android extensions for Context
fun Context.toast(message: String, duration: Int = Toast.LENGTH_SHORT) {
    Toast.makeText(this, message, duration).show()
}

// Usage in Activity
toast("Hello!")  // Much cleaner than Toast.makeText(...)

// Extensions for View visibility
fun View.visible() {
    visibility = View.VISIBLE
}

fun View.gone() {
    visibility = View.GONE
}

// Usage
myButton.gone()
myTextView.visible()

// Resource extensions
fun Context.color(@ColorRes id: Int): Int {
    return ContextCompat.getColor(this, id)
}

// Usage
val primaryColor = color(R.color.primary)
```

### Quick Reference

| Task | Syntax |
|------|--------|
| Basic extension | `fun Type.method() { }` |
| With parameters | `fun Type.method(param: T) { }` |
| With return | `fun Type.method(): ReturnType { }` |
| Extension property | `val Type.property: T get() = ...` |
| Nullable receiver | `fun Type?.method() { }` |
| Generic extension | `fun <T> T.method() { }` |
| Access receiver | Use `this` inside extension |

### Key Takeaways

- Extension functions are resolved statically (compile-time), not dynamically (runtime)
- They can't access private members of the class
- They don't actually modify the class (no inheritance involved)
- They're one of Kotlin's most distinctive and useful features
- Android development uses them extensively for cleaner APIs
- Think of them as "utility functions with method call syntax"




# Part 2: Kotlin-Specific Features

## Extension Functions

> [!NOTE]
> Extension functions let you add methods to existing classes without modifying them or using inheritance. While Swift has extensions, Kotlin's approach is lighter weight - no wrapper block needed, just define the function directly.

Extension functions are one of Kotlin's most distinctive features and are used extensively in Android development to create cleaner, more readable APIs.

### Swift vs Kotlin: The Key Difference

**Swift Extensions:**

```swift
extension String {
    func addExclamation() -> String {
        return self + "!"
    }
}

"Hello".addExclamation()  // "Hello!"
```

**Kotlin Extension Functions:**

```kotlin
fun String.addExclamation(): String {
    return this + "!"
}

"Hello".addExclamation()  // "Hello!"
```

| Aspect | Swift | Kotlin |
|--------|-------|--------|
| Syntax wrapper | `extension Type { }` | No wrapper needed |
| Multiple functions | Grouped in extension block | Each function separate |
| Access to internals | Can access private members | Only public/internal members |
| This/self | `self` | `this` |

### Basic Syntax

> [!NOTE]
> **ReceiverType**: The type you're extending (e.g., `String`, `Int`, `List<T>`)
> 
> **this**: Inside an extension function, `this` refers to the instance the function is called on - just like `self` in Swift.

```kotlin
fun ReceiverType.functionName(parameters): ReturnType {
    // this refers to the receiver object
    return result
}
```

The function can then be called as if it were a method of ReceiverType.

### Common Patterns

#### 1. Adding Utility Functions

```kotlin
// Add a function to check if a string is a valid email
fun String.isValidEmail(): Boolean {
    return this.contains("@") && this.contains(".")
}

// Usage
val email = "user@example.com"
if (email.isValidEmail()) {
    println("Valid email")
}
```

#### 2. Extending Collections

> [!NOTE]
> You can use generics in extension functions. Here `<T>` means the function works with any list type.

```kotlin
// Get second element safely
fun <T> List<T>.secondOrNull(): T? {
    return if (this.size >= 2) this[1] else null
}

// Usage
val numbers = listOf(1, 2, 3)
val second = numbers.secondOrNull()  // 2
```

#### 3. Domain-Specific Extensions

```kotlin
// Add domain logic to standard types
fun Int.toPixels(): String {
    return "${this}px"
}

fun Int.toPercent(): String {
    return "$this%"
}

// Usage
val width = 100.toPixels()    // "100px"
val opacity = 80.toPercent()  // "80%"
```

#### 4. Chaining Operations

```kotlin
fun String.removeWhitespace(): String {
    return this.replace(" ", "")
}

fun String.capitalize(): String {
    return this.replaceFirstChar { it.uppercase() }
}

// Usage - can chain extension functions
val result = "hello world"
    .removeWhitespace()
    .capitalize()  // "Helloworld"
```

### Extension Properties

> [!NOTE]
> Extension properties must define custom getters (and setters for `var`). They cannot have backing fields - you can't store new data, only compute values from existing data.

You can extend classes with computed properties:

```kotlin
// Extension property (read-only)
val String.firstChar: Char?
    get() = this.firstOrNull()

// Usage
"Hello".firstChar  // 'H'

// Extension property with getter and setter
var StringBuilder.firstChar: Char
    get() = this[0]
    set(value) {
        this.setCharAt(0, value)
    }
```

### Nullable Receiver Extensions

> [!NOTE]
> The `?` after the type name means the extension can be called on nullable instances. This is how Kotlin's standard library implements functions like `.isNullOrEmpty()`.

You can create extensions that work on nullable types:

```kotlin
fun String?.isNullOrEmpty(): Boolean {
    return this == null || this.isEmpty()
}

// Usage
val name: String? = null
if (name.isNullOrEmpty()) {
    println("Name is null or empty")
}
```

### Generic Extension Functions

```kotlin
// Extension function with generic type
fun <T> T.print(): T {
    println(this)
    return this
}

// Usage
"Hello".print()  // Prints: Hello
42.print()       // Prints: 42

// More complex example
fun <T> List<T>.secondHalf(): List<T> {
    val midpoint = this.size / 2
    return this.subList(midpoint, this.size)
}
```

### When to Use Extension Functions

> [!TIP]
> **✅ Good use cases:**
> - Adding utility functions to classes you don't control
> - Creating domain-specific APIs
> - Improving readability by making operations read like methods
> - Adding convenience functions to standard library types
> - Implementing adapter patterns

> [!WARNING]
> **❌ Avoid when:**
> - You control the class (just add a regular method)
> - The logic is complex and should be in a separate utility class
> - You need access to private members of the class

### Important Limitations

> [!WARNING]
> **Static Resolution**: Extension functions are resolved at compile time based on the declared type, not the runtime type. This is different from method overriding.

#### 1. Static Resolution

```kotlin
open class Shape
class Circle : Shape()

fun Shape.name() = "Shape"
fun Circle.name() = "Circle"

fun printName(shape: Shape) {
    println(shape.name())  // Always prints "Shape"
}

printName(Circle())  // Prints "Shape", not "Circle"
```

The function called depends on the declared type (`Shape`), not the actual type (`Circle`).

#### 2. No Override

> [!WARNING]
> Extensions cannot override existing class members. The member function always wins.

```kotlin
class MyClass {
    fun foo() = "Member"
}

fun MyClass.foo() = "Extension"  // This won't be called

MyClass().foo()  // Returns "Member"
```

#### 3. Scope

> [!NOTE]
> Extensions are scoped to the file/package where they're defined. To use them elsewhere, you need to import them.

```kotlin
// File1.kt
fun String.reverse(): String = this.reversed()

// File2.kt
// Need to import if in different package
import com.example.reverse

val reversed = "Hello".reverse()
```

### Comparing to Swift Extensions

| Feature | Swift | Kotlin |
|---------|-------|--------|
| Grouping | Extensions group related functions | Each function standalone |
| Protocol conformance | Can add protocol conformance | Separate interface implementation |
| Stored properties | Can't add stored properties | Can't add stored properties |
| Computed properties | ✅ Yes | ✅ Yes (must define getter) |
| Private access | ✅ Can access private | ❌ Only public/internal |
| Conditional extensions | ✅ Protocol constraints | ✅ Generic constraints |

### Real-World Examples from Android Development

> [!TIP]
> These examples show how Android developers use extension functions to create cleaner, more expressive APIs. You'll see this pattern everywhere in Android codebases.

```kotlin
// Common Android extensions for Context
fun Context.toast(message: String, duration: Int = Toast.LENGTH_SHORT) {
    Toast.makeText(this, message, duration).show()
}

// Usage in Activity
toast("Hello!")  // Much cleaner than Toast.makeText(...)

// Extensions for View visibility
fun View.visible() {
    visibility = View.VISIBLE
}

fun View.gone() {
    visibility = View.GONE
}

// Usage
myButton.gone()
myTextView.visible()

// Resource extensions
fun Context.color(@ColorRes id: Int): Int {
    return ContextCompat.getColor(this, id)
}

// Usage
val primaryColor = color(R.color.primary)
```

### Quick Reference

| Task | Syntax |
|------|--------|
| Basic extension | `fun Type.method() { }` |
| With parameters | `fun Type.method(param: T) { }` |
| With return | `fun Type.method(): ReturnType { }` |
| Extension property | `val Type.property: T get() = ...` |
| Nullable receiver | `fun Type?.method() { }` |
| Generic extension | `fun <T> T.method() { }` |
| Access receiver | Use `this` inside extension |

### Key Takeaways

> [!IMPORTANT]
> - Extension functions are resolved **statically** (compile-time), not dynamically (runtime)
> - They **can't access private** members of the class
> - They **don't actually modify** the class (no inheritance involved)
> - They're one of Kotlin's most **distinctive and useful** features
> - Android development uses them **extensively** for cleaner APIs
> - Think of them as "utility functions with method call syntax"
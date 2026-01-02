# Scope Functions
#android/Kotlin/Unique

> [!NOTE]
> Scope functions are one of Kotlin's most distinctive features. They execute a block of code within the context of an object. There are five functions: `let`, `run`, `with`, `apply`, and `also`. They differ in how they reference the object (`it` vs `this`) and what they return (the object vs the result).

### Overview

All scope functions are similar but have key differences:

| Function | Object Reference | Returns | Use Case |
|----------|-----------------|---------|----------|
| `let` | `it` | Lambda result | Null-safe calls, transformations |
| `run` | `this` | Lambda result | Object configuration + computation |
| `with` | `this` | Lambda result | Grouping calls on an object |
| `apply` | `this` | Object itself | Object configuration |
| `also` | `it` | Object itself | Side effects, debugging |

> [!NOTE]
> **Reference**: `it` | **Returns**: Lambda result
> 
> `let` is the most commonly used scope function. It has a few important uses.
> 1. Equivalent of `if let` in swift to safely unwrap optionals if they aren’t null
> 2. Avoid assigning the result of an operation to a temporary intermediate variable
> 3. To name and use a returned value for more readable code

**Common patterns:**
```kotlin
// Replace if-let pattern from Swift
optionalValue?.let { value ->
    // use value (non-null here)
	println("Processing: $it") // it is no longer null inside ?.let scope
}

// Avoid temporary variables 
// Instead of:
val data = getData()
val result = process(data)
// Use let:
val result = getData().let {
    process(it)
}

// Use named varibles like in swift
val result = getData().let { data ->
    process(data)
}
```

**Other examples of uses:**
```kotlin
// Transform and use result
val squared = value.let { it * it }

// Chain multiple operations
val result = text
    .let { it.trim() }
    .let { it.uppercase() }
    .let { it.split(" ") }
```
## run

> [!NOTE]
> **Reference**: `this` | **Returns**: Lambda result
> 
> Use `run` when you want to operate on an object and return a computed result. Similar to `let` but uses `this`.

```kotlin
val result = user.run {
    // 'this' refers to user
    println("User: $name")  // no 'this.' needed
    age * 2
}

// Initialize and compute
val hexColor = Color(255, 0, 0).run {
    "#%02x%02x%02x".format(red, green, blue)
}

// Null-safe version
val result = user?.run {
    "$firstName $lastName"
}
```

**When to use over `let`:**

```kotlin
// run - when many properties accessed
user.run {
    println("$firstName $lastName")
    println("Age: $age")
    println("Email: $email")
}

// let - when treating object as single value
user.let { u ->
    println(u)
    validate(u)
}
```

## with

> [!NOTE]
> **Reference**: `this` | **Returns**: Lambda result
> 
> Use `with` for grouping operations on an object. Takes the object as a parameter (not an extension function).

```kotlin
val result = with(user) {
    // 'this' refers to user
    println("Name: $name")
    println("Age: $age")
    email.isNotEmpty()
}

// Useful for calling multiple methods
with(canvas) {
    drawLine(0, 0, 100, 100)
    drawCircle(50, 50, 25)
    drawText("Hello", 10, 10)
}

// Configuration
val list = with(ArrayList<String>()) {
    add("One")
    add("Two")
    add("Three")
    this  // Must explicitly return if needed
}
```

**`with` vs `run`:**

```kotlin
// run - called on object
user.run { /* this = user */ }

// with - object passed as parameter
with(user) { /* this = user */ }

// Functionally similar, stylistic choice
```

## apply

> [!NOTE]
> **Reference**: `this` | **Returns**: Object itself
> 
> Use `apply` for configuring objects. Perfect for builder-style initialization. Returns the object, enabling chaining.

```kotlin
val user = User().apply {
    firstName = "John"
    lastName = "Doe"
    age = 30
    email = "john@example.com"
}

// Android example
val textView = TextView(context).apply {
    text = "Hello"
    textSize = 16f
    setTextColor(Color.BLACK)
}

// Chain with other operations
val result = StringBuilder().apply {
    append("Hello")
    append(" ")
    append("World")
}.toString()
```

**Common patterns:**

```kotlin
// Object initialization
val intent = Intent(this, MainActivity::class.java).apply {
    putExtra("key", "value")
    flags = Intent.FLAG_ACTIVITY_NEW_TASK
}

// Modify and return
fun createUser(name: String) = User().apply {
    this.name = name
    this.createdAt = System.currentTimeMillis()
}

// Configure existing object
existingObject.apply {
    property1 = value1
    property2 = value2
}
```

## also

> [!NOTE]
> **Reference**: `it` | **Returns**: Object itself
> 
> Use `also` for side effects that don't modify the object. Great for logging, validation, or debugging without breaking chains.

```kotlin
val numbers = mutableListOf(1, 2, 3)
    .also { println("Initial: $it") }
    .also { it.add(4) }
    .also { println("After add: $it") }

// Logging in a chain
val result = fetchData()
    .also { println("Fetched: $it") }
    .process()
    .also { println("Processed: $it") }
    .validate()

// Side effects without breaking chain
val user = createUser()
    .also { validateUser(it) }
    .also { logUserCreation(it) }
    .also { sendWelcomeEmail(it) }
```

**`also` vs `apply`:**

```kotlin
// apply - configure the object
user.apply {
    name = "John"  // this.name
    age = 30       // this.age
}

// also - perform side effects
user.also {
    validate(it)
    log(it)
}
```

### Choosing the Right Function

> [!TIP]
> **Quick selection guide:**
> - Null safety + transform → `let`
> - Configure object → `apply`
> - Side effects/logging → `also`
> - Multiple method calls → `with` or `run`
> - Compute from object → `run`

### Comparison Examples

**Null-safe operation:**

```kotlin
// let - most common for null safety
name?.let { println("Name: $it") }

// run - when accessing multiple properties
user?.run { println("$firstName $lastName") }
```

**Object initialization:**

```kotlin
// apply - for configuration
val person = Person().apply {
    name = "Alice"
    age = 25
}

// also - for side effects during creation
val person = Person()
    .also { println("Created: $it") }
    .also { validate(it) }
```

**Computation:**

```kotlin
// run - called on object
val length = text.run { 
    trim().lowercase().length 
}

// let - explicit parameter
val length = text.let { t ->
    t.trim().lowercase().length
}

// with - object as parameter
val length = with(text) {
    trim().lowercase().length
}
```

### Nesting Scope Functions

> [!WARNING]
> Be careful when nesting scope functions - it can become hard to track what `it` or `this` refers to.

```kotlin
// Can be confusing
user.apply {
    address.apply {
        street.let {
            // Which object is 'it'? Which is 'this'?
        }
    }
}

// Better - use explicit names
user.apply {
    address.apply {
        street.let { streetName ->
            // Clear what each refers to
        }
    }
}

// Or avoid deep nesting
val streetName = user.address.street
streetName.let { /* use it */ }
```

### takeIf and takeUnless

> [!NOTE]
> Related functions: `takeIf` returns the object if a condition is true (else null), `takeUnless` is the opposite.

```kotlin
// takeIf - return object if condition true
val evenNumber = number.takeIf { it % 2 == 0 }

// takeUnless - return object if condition false  
val positiveNumber = number.takeUnless { it < 0 }

// Useful in chains
val result = fetchData()
    .takeIf { it.isValid() }
    ?.process()
    ?: getDefaultData()

// Filter single value
val adult = person.takeIf { it.age >= 18 }
```

### Real-World Patterns

**Android View setup:**

```kotlin
// apply for configuration
binding.textView.apply {
    text = "Hello"
    textSize = 16f
    setOnClickListener { /* ... */ }
}
```

**API call with logging:**

```kotlin
val result = api.fetchUser(id)
    .also { println("API response: $it") }
    .takeIf { it.isSuccess }
    ?.data
    .also { println("Extracted data: $it") }
```

**Builder pattern:**

```kotlin
val request = Request.Builder()
    .apply {
        url("https://api.example.com")
        addHeader("Authorization", "Bearer $token")
    }
    .also { println("Request configured: $it") }
    .build()
```

**Null-safe transformation:**

```kotlin
// Swift pattern
if let name = optionalName {
    let upper = name.uppercased()
    print(upper)
}

// Kotlin with let
optionalName?.let { name ->
    val upper = name.uppercase()
    println(upper)
}

// Or chain it
optionalName
    ?.let { it.uppercase() }
    ?.let { println(it) }
```

### Quick Reference Table

| Need | Use | Example |
|------|-----|---------|
| Null-safe operation | `?.let` | `name?.let { print(it) }` |
| Configure object | `.apply` | `User().apply { name = "John" }` |
| Side effect | `.also` | `data.also { log(it) }` |
| Compute result | `.run` or `.let` | `text.run { length }` |
| Multiple calls | `with()` | `with(obj) { method1(); method2() }` |
| Conditional keep | `.takeIf` | `num.takeIf { it > 0 }` |

### Common Mistakes

> [!WARNING]
> **Common pitfalls:**

```kotlin
// ❌ Using apply for computation (returns object, not result)
val length = text.apply {
    trim().length  // Returns text, not length!
}

// ✅ Use run or let instead
val length = text.run { trim().length }

// ❌ Using let when you want the object back
val updated = user.let {
    it.age = 30
    // Returns Unit, not user!
}

// ✅ Use apply
val updated = user.apply {
    age = 30
}

// ❌ Unnecessary nesting
value.let {
    it.let { v ->
        process(v)
    }
}

// ✅ Just use one
value.let { process(it) }
```

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - `let` and `also` use `it` (explicit parameter)
> - `run`, `with`, and `apply` use `this` (implicit receiver)
> - `let`, `run`, and `with` return the lambda result
> - `apply` and `also` return the object itself
> - Use `let` for null safety
> - Use `apply` for configuration
> - Use `also` for side effects
> - Don't overthink it - any scope function is usually better than none
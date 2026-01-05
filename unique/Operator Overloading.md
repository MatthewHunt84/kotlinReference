# Operator Overloading
#android/Kotlin/Unique
> [!NOTE]
> Kotlin allows you to overload operators by defining functions with specific names and the `operator` modifier. This lets you use operators like `+`, `-`, `*`, `[]`, `in`, etc. with your custom types.

### Basic Operator Overloading

```kotlin
data class Point(val x: Int, val y: Int) {
    operator fun plus(other: Point): Point {
        return Point(x + other.x, y + other.y)
    }
}

val p1 = Point(1, 2)
val p2 = Point(3, 4)
val p3 = p1 + p2  // Calls p1.plus(p2)
println(p3)  // Point(x=4, y=6)
```

### Arithmetic Operators

> [!NOTE]
> **Operator functions**: `plus` (+), `minus` (-), `times` (*), `div` (/), `rem` (%)

```kotlin
data class Vec2(val x: Double, val y: Double) {
    operator fun plus(other: Vec2) = Vec2(x + other.x, y + other.y)
    operator fun minus(other: Vec2) = Vec2(x - other.x, y - other.y)
    operator fun times(scalar: Double) = Vec2(x * scalar, y * scalar)
    operator fun div(scalar: Double) = Vec2(x / scalar, y / scalar)
    
    operator fun unaryMinus() = Vec2(-x, -y)
    operator fun unaryPlus() = Vec2(+x, +y)
}

val v1 = Vec2(1.0, 2.0)
val v2 = Vec2(3.0, 4.0)

val sum = v1 + v2        // plus
val diff = v1 - v2       // minus
val scaled = v1 * 2.0    // times
val divided = v1 / 2.0   // div
val negated = -v1        // unaryMinus
```

| Operator | Function | Example |
|----------|----------|---------|
| `+` | `plus` | `a + b` → `a.plus(b)` |
| `-` | `minus` | `a - b` → `a.minus(b)` |
| `*` | `times` | `a * b` → `a.times(b)` |
| `/` | `div` | `a / b` → `a.div(b)` |
| `%` | `rem` | `a % b` → `a.rem(b)` |
| `-a` | `unaryMinus` | `-a` → `a.unaryMinus()` |
| `+a` | `unaryPlus` | `+a` → `a.unaryPlus()` |

### In and Range Operators

> [!NOTE]
> **Range operators**: `rangeTo` (..), `rangeUntil` (..<)
> **Membership**: `contains` (in, !in)

```kotlin
class DateRange(val start: Date, val end: Date) {
    operator fun contains(date: Date): Boolean {
        return date >= start && date <= end
    }
}

val range = DateRange(startDate, endDate)
if (today in range) {  // Calls range.contains(today)
    println("Today is in range")
}

// rangeTo for creating ranges
class MyInt(val value: Int) {
    operator fun rangeTo(other: MyInt) = MyIntRange(this, other)
}

val range = MyInt(1)..MyInt(10)  // Calls MyInt(1).rangeTo(MyInt(10))
```

### Indexed Access Operators

> [!NOTE]
> **Indexing**: `get` ([]), `set` ([]=)

```kotlin
class Grid<T>(private val width: Int, private val height: Int) {
    private val data = Array<Any?>(width * height) { null }
    
    operator fun get(x: Int, y: Int): T? {
        return data[y * width + x] as? T
    }
    
    operator fun set(x: Int, y: Int, value: T) {
        data[y * width + x] = value
    }
}

val grid = Grid<String>(10, 10)
grid[0, 0] = "Hello"     // Calls grid.set(0, 0, "Hello")
val value = grid[0, 0]   // Calls grid.get(0, 0)
```

**Multiple parameters:**

```kotlin
class Matrix {
    operator fun get(row: Int, col: Int): Double {
        // ...
    }
    
    operator fun set(row: Int, col: Int, value: Double) {
        // ...
    }
}

val matrix = Matrix()
matrix[0, 1] = 5.0
val value = matrix[0, 1]
```

### Invoke Operator

> [!NOTE]
> The `invoke` operator lets you call objects like functions: `object(args)`

```kotlin
class Greeter(val greeting: String) {
    operator fun invoke(name: String) {
        println("$greeting, $name!")
    }
}

val greeter = Greeter("Hello")
greeter("Alice")  // Calls greeter.invoke("Alice")
// Prints: Hello, Alice!

// With multiple parameters
class Multiplier {
    operator fun invoke(a: Int, b: Int) = a * b
}

val multiply = Multiplier()
val result = multiply(3, 4)  // 12
```

**Lambda-like behavior:**

```kotlin
class Logger {
    operator fun invoke(message: String) {
        println("[LOG] $message")
    }
}

val log = Logger()
log("Application started")  // Looks like function call
```

### Augmented Assignment Operators

> [!NOTE]
> **Augmented assignment**: `plusAssign` (+=), `minusAssign` (-=), `timesAssign` (*=), `divAssign` (/=), `remAssign` (%=)

```kotlin
class Counter(var count: Int) {
    operator fun plusAssign(value: Int) {
        count += value
    }
    
    operator fun minusAssign(value: Int) {
        count -= value
    }
}

val counter = Counter(0)
counter += 5   // Calls counter.plusAssign(5)
counter -= 2   // Calls counter.minusAssign(2)
println(counter.count)  // 3
```

> [!WARNING]
> If both `plus` and `plusAssign` are defined, `plus` is preferred for `a = a + b` and `plusAssign` for `a += b`. Define only one to avoid ambiguity.

### Comparison Operators

> [!NOTE]
> **Comparison**: `compareTo` (<, >, <=, >=)

```kotlin
class Version(val major: Int, val minor: Int, val patch: Int) : Comparable<Version> {
    override operator fun compareTo(other: Version): Int {
        if (major != other.major) return major - other.major
        if (minor != other.minor) return minor - other.minor
        return patch - other.patch
    }
}

val v1 = Version(1, 2, 3)
val v2 = Version(1, 3, 0)

println(v1 < v2)   // true, calls v1.compareTo(v2) < 0
println(v1 >= v2)  // false
```

### Equality Operators

> [!NOTE]
> **Equality**: `equals` (==, !=)
> Note: Structural equality `==` calls `equals()`, reference equality uses `===`

```kotlin
data class Person(val name: String, val age: Int) {
    // data class already provides equals
    // override fun equals(other: Any?): Boolean {
    //     if (other !is Person) return false
    //     return name == other.name && age == other.age
    // }
}

val p1 = Person("Alice", 25)
val p2 = Person("Alice", 25)

println(p1 == p2)   // true (structural equality, calls equals)
println(p1 === p2)  // false (reference equality, different objects)
```

### Iterator Operators

> [!NOTE]
> Implement `iterator()` to use your class in for loops and with iteration operators.
> This used to exist in swift but was removed in Swift 3 for being a little confusing for newcomers and the ability to add bugs.

> [!TIP] The position of the ++ matters!
> let id = current++ // assign first, then iterate
> let id = ++current // iterate first, then assign

```kotlin
class IntRange(private val start: Int, private val end: Int) {
    operator fun iterator() = object : Iterator<Int> {
        private var current = start
        
        override fun hasNext() = current <= end
        
        override fun next(): Int {
            if (!hasNext()) throw NoSuchElementException()
            return current++
        }
    }
}

val range = IntRange(1, 5)
for (i in range) {  // Uses iterator()
    println(i)
}
```

### Destructuring Declarations

> [!NOTE]
> **Component functions**: `component1`, `component2`, etc. Enable destructuring.

```kotlin
class Result(val success: Boolean, val value: Int, val message: String) {
    operator fun component1() = success
    operator fun component2() = value
    operator fun component3() = message
}

val result = Result(true, 42, "OK")
val (success, value, message) = result  // Destructuring

// Each variable calls corresponding componentN function
// success = result.component1()
// value = result.component2()
// message = result.component3()
```

**Data classes get these automatically:**

```kotlin
data class User(val name: String, val age: Int, val email: String)

val user = User("Alice", 25, "alice@example.com")
val (name, age, email) = user  // Works automatically
```

### Property Delegation Operators

> [!NOTE]
> **Delegation operators**: `getValue` and `setValue` for property delegation (see Delegation section).

```kotlin
class Delegate {
    operator fun getValue(thisRef: Any?, property: KProperty<*>): String {
        return "Delegated value"
    }
    
    operator fun setValue(thisRef: Any?, property: KProperty<*>, value: String) {
        println("Setting to $value")
    }
}

class Example {
    var prop: String by Delegate()
}

val example = Example()
println(example.prop)  // Calls Delegate.getValue
example.prop = "new"   // Calls Delegate.setValue
```

### Extension Operators

```kotlin
// Extend existing types with operators
operator fun String.times(n: Int): String {
    return this.repeat(n)
}

val repeated = "Ha" * 3  // "HaHaHa"

// Extend collections
operator fun <T> List<T>.get(range: IntRange): List<T> {
    return this.subList(range.first, range.last + 1)
}

val numbers = listOf(1, 2, 3, 4, 5)
val slice = numbers[1..3]  // [2, 3, 4]
```

### Real-World Examples

**Money class:**

```kotlin
data class Money(val amount: BigDecimal, val currency: String) {
    operator fun plus(other: Money): Money {
        require(currency == other.currency) { "Currency mismatch" }
        return Money(amount + other.amount, currency)
    }
    
    operator fun minus(other: Money): Money {
        require(currency == other.currency) { "Currency mismatch" }
        return Money(amount - other.amount, currency)
    }
    
    operator fun times(multiplier: Int): Money {
        return Money(amount * multiplier.toBigDecimal(), currency)
    }
    
    operator fun compareTo(other: Money): Int {
        require(currency == other.currency) { "Currency mismatch" }
        return amount.compareTo(other.amount)
    }
}

val price1 = Money(BigDecimal("10.00"), "USD")
val price2 = Money(BigDecimal("5.50"), "USD")

val total = price1 + price2
val double = price1 * 2
val more = price1 > price2
```

**DSL with invoke:**

```kotlin
class Html {
    private val elements = mutableListOf<String>()
    
    operator fun String.invoke(block: Html.() -> Unit) {
        elements.add("<$this>")
        block()
        elements.add("</$this>")
    }
    
    operator fun String.unaryPlus() {
        elements.add(this)
    }
    
    override fun toString() = elements.joinToString("")
}

fun html(block: Html.() -> Unit): String {
    return Html().apply(block).toString()
}

// Usage - DSL-like syntax
val page = html {
    "html" {
        "body" {
            +"Hello, World!"
        }
    }
}
```

**Collection builder:**

```kotlin
class ListBuilder<T> {
    private val list = mutableListOf<T>()
    
    operator fun T.unaryPlus() {
        list.add(this)
    }
    
    fun build(): List<T> = list
}

fun <T> buildList(block: ListBuilder<T>.() -> Unit): List<T> {
    return ListBuilder<T>().apply(block).build()
}

// Usage
val numbers = buildList {
    +1
    +2
    +3
}
```

### Operator Precedence

> [!NOTE]
> Operators have fixed precedence regardless of how you implement them. You cannot change operator precedence.

```kotlin
// Multiplication has higher precedence than addition
val result = 2 + 3 * 4  // 14, not 20

// This applies to custom operators too
class MyInt(val value: Int) {
    operator fun plus(other: MyInt) = MyInt(value + other.value)
    operator fun times(other: MyInt) = MyInt(value * other.value)
}

val a = MyInt(2)
val b = MyInt(3)
val c = MyInt(4)

val result = a + b * c  // Still follows standard precedence
// b * c is evaluated first
```

### Common Mistakes

> [!WARNING]
> **Common pitfalls:**

```kotlin
// ❌ Forgetting operator modifier
class Point(val x: Int, val y: Int) {
    fun plus(other: Point) = Point(x + other.x, y + other.y)
}
// val p3 = p1 + p2  // Error! Need operator modifier

// ✅ Use operator modifier
class Point(val x: Int, val y: Int) {
    operator fun plus(other: Point) = Point(x + other.x, y + other.y)
}

// ❌ Both plus and plusAssign
class Counter(var value: Int) {
    operator fun plus(n: Int) = Counter(value + n)
    operator fun plusAssign(n: Int) { value += n }  // Ambiguous!
}

// ✅ Choose one based on semantics
// Use plus for immutable, plusAssign for mutable

// ❌ Inconsistent operators
class Money(val amount: Double) {
    operator fun plus(other: Money) = Money(amount + other.amount)
    // Missing minus - users expect it if plus exists
}
```

### Guidelines for Operator Overloading

> [!TIP]
> **Best practices:**
> - Only overload operators when the meaning is clear and expected
> - Maintain mathematical/logical conventions
> - If you define `plus`, consider defining `minus`
> - If you define `compareTo`, consider implementing `Comparable`
> - Use for DSLs and mathematical types primarily
> - Don't surprise users with unexpected behavior

### Key Takeaways

> [!IMPORTANT]
> **Remember:**
> - Use `operator` modifier on functions with specific names
> - Operators have fixed precedence you cannot change
> - Common operators: `plus`, `minus`, `times`, `div`, `get`, `set`, `invoke`, `rangeTo`, `contains`
> - Destructuring uses `componentN` functions (automatic in data classes)
> - Can overload operators in extension functions
> - Great for DSLs, mathematical types, and collection-like classes
> - Follow conventions and user expectations
> - Prefer immutable types with `plus` over mutable with `plusAssign`

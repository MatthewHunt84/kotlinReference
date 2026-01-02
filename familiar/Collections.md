# Collections
#Android/Kotlin/Familiar


> [!NOTE]
> Kotlin distinguishes between mutable and immutable collections at the type level. `List`, `Set`, and `Map` are immutable interfaces, while `MutableList`, `MutableSet`, and `MutableMap` are their mutable counterparts. Swift uses the same type for both but distinguishes via `let` vs `var`.

### Arrays & Lists

> [!NOTE]
> **Arrays vs Lists**: In Kotlin, prefer `List` and `MutableList` over `Array`. Arrays are a lower-level construct mainly for Java interop. In Swift, `Array` is the standard collection type.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Immutable array | `let numbers = [1, 2, 3]` | `val numbers = listOf(1, 2, 3)` | Returns `List<Int>` |
| Mutable array | `var numbers = [1, 2, 3]` | `val numbers = mutableListOf(1, 2, 3)` | Returns `MutableList<Int>` |
| Empty array | `let empty: [Int] = []` | `val empty = listOf<Int>()` or `emptyList<Int>()` | |
| Array with capacity | `var array = [Int]()` <br> `array.reserveCapacity(10)` | `val array = ArrayList<Int>(10)` | When capacity matters |
| Array of size with value | `Array(repeating: 0, count: 5)` | `List(5) { 0 }` or `MutableList(5) { 0 }` | |

### Size & Empty Checks

| Task            | Swift            | Kotlin                 | Note                                                         |
|-----------------|------------------|------------------------|--------------------------------------------------------------|
| Get size        | `.count`         | `.size` or `.count()`  | Count is a method, useful for functional programming patterns like `numbers.count { it > 3 }` |
| Check empty     | `.isEmpty`       | `.isEmpty()`           | Property vs method                                           |
| Check not empty | `!array.isEmpty` | `.isNotEmpty()`        | Kotlin has dedicated method                                  |

### Accessing Elements

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Get element | `array[0]` | | |
| First element | `array.first` or `array.first!` | `array.first()` or `array.firstOrNull()` | Kotlin method returns nullable |
| Last element | `array.last` or `array.last!` | `array.last()` or `array.lastOrNull()` | Kotlin method returns nullable |
| Get or nil/null | `array.first` | `array.firstOrNull()` | |
| Safe access | `array.indices.contains(i) ? array[i] : nil` | `array.getOrNull(i)` | Cleaner in Kotlin |

### Adding Elements

> [!WARNING]
> You can only add elements to `MutableList`, not `List`. Immutable collections cannot be modified.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Append | `array.append(4)` | `array.add(4)` | MutableList only |
| Insert at index | `array.insert(0, at: 0)` | `array.add(0, 0)` | Parameters reversed |
| Append array | `array.append(contentsOf: [5, 6])` | `array.addAll(listOf(5, 6))` | |
| Concatenate | `array1 + array2` | | Returns new list |

### Removing Elements

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Remove at index | `array.remove(at: 0)` | `array.removeAt(0)` | MutableList only |
| Remove first | `array.removeFirst()` | `array.removeFirst()` or `array.removeAt(0)` | |
| Remove last | `array.removeLast()` | `array.removeLast()` or `array.removeAt(array.lastIndex)` | |
| Remove all | `array.removeAll()` | `array.clear()` | |
| Remove by value | `array.removeAll { $0 == value }` | `array.remove(value)` | Removes first occurrence |

### Common Operations

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Contains | `array.contains(5)` | | |
| Index of | `array.firstIndex(of: 5)` | `array.indexOf(5)` | Returns -1 if not found (not null) |
| Filter | `array.filter { $0 > 2 }` | | |
| Map | `array.map { $0 * 2 }` | | |
| Reduce | `array.reduce(0, +)` | `array.reduce(0) { acc, n -> acc + n }` | Must specify operation explicitly |
| Sorted | `array.sorted()` | | |
| Reversed | `array.reversed()` | | Returns Iterable, use `.toList()` if needed |
| ForEach | `array.forEach { print($0) }` | | |

### Slicing & Subranges

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Slice | `array[1...3]` | `array.subList(1, 4)` | End index is exclusive in Kotlin |
| Slice to end | `array[2...]` | `array.subList(2, array.size)` | |
| Drop first N | `array.dropFirst(2)` | `array.drop(2)` | |
| Take first N | `array.prefix(3)` | `array.take(3)` | |

### Sets

> [!NOTE]
> Like lists, Kotlin has `Set` (immutable) and `MutableSet` (mutable). Swift uses the same `Set` type with `let` vs `var`.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Create set | `let set: Set = [1, 2, 3]` | `val set = setOf(1, 2, 3)` | Type inference works |
| Mutable set | `var set: Set = [1, 2, 3]` | `val set = mutableSetOf(1, 2, 3)` | |
| Empty set | `let empty = Set<Int>()` | `val empty = setOf<Int>()` or `emptySet<Int>()` | |
| Insert | `set.insert(4)` | `set.add(4)` | MutableSet only |
| Remove | `set.remove(2)` | | |
| Contains | `set.contains(3)` | | |
| Size | `set.count` | `set.size` | |
| Union | `set1.union(set2)` | `set1.union(set2)` or `set1 + set2` | |
| Intersection | `set1.intersection(set2)` | | |
| Subtract | `set1.subtracting(set2)` | `set1.subtract(set2)` or `set1 - set2` | |

### Dictionaries / Maps

> [!NOTE]
> Kotlin calls them "Maps" instead of "Dictionaries". Like other collections, there are immutable `Map` and mutable `MutableMap` types.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Create map | `let map = ["a": 1, "b": 2]` | `val map = mapOf("a" to 1, "b" to 2)` | Use `to` instead of `:` |
| Mutable map | `var map = ["a": 1, "b": 2]` | `val map = mutableMapOf("a" to 1, "b" to 2)` | |
| Empty map | `let empty = [String: Int]()` | `val empty = mapOf<String, Int>()` or `emptyMap<String, Int>()` | |
| Get value | `map["a"]` | | Returns nullable |
| Get with default | `map["a", default: 0]` | `map.getOrDefault("a", 0)` or `map["a"] ?: 0` | |
| Set value | `map["c"] = 3` | | MutableMap only |
| Remove | `map.removeValue(forKey: "a")` | `map.remove("a")` | |
| Contains key | `map.keys.contains("a")` | `map.containsKey("a")` | |
| Keys | `map.keys` | | Returns Set in both |
| Values | `map.values` | | |
| Size | `map.count` | `map.size` | |

### Iteration

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| For-each | `for item in array { }` | | |
| For-each with index | `for (index, item) in array.enumerated() { }` | `for ((index, item) in array.withIndex()) { }` | |
| For range | `for i in 0..<10 { }` | `for (i in 0..<10) { }` or `for (i in 0 until 10) { }` | Parens required |
| For range closed | `for i in 0...10 { }` | `for (i in 0..10) { }` | |
| For range step | `for i in stride(from: 0, to: 10, by: 2) { }` | `for (i in 0..<10 step 2) { }` | |
| Iterate map | `for (key, value) in map { }` | | |

### Useful Collection Extensions

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Zip | `zip(array1, array2)` | `array1.zip(array2)` | |
| FlatMap | `array.flatMap { $0 }` | | |
| Partition | `array.partition(by: { $0 < 5 })` | `array.partition { it < 5 }` | Returns index in Kotlin |
| Distinct/Unique | - | `array.distinct()` | No built-in in Swift |
| GroupBy | `Dictionary(grouping: array, by: { $0 % 2 })` | `array.groupBy { it % 2 }` | Cleaner in Kotlin |
| Sum | `array.reduce(0, +)` | `array.sum()` | For numeric types |
| Min | `array.min()` | `array.minOrNull()` | |
| Max | `array.max()` | `array.maxOrNull()` | |
| All/Every | `array.allSatisfy { $0 > 0 }` | `array.all { it > 0 }` | |
| Any | `array.contains(where: { $0 > 5 })` | `array.any { it > 5 }` | |
| None | - | `array.none { it > 5 }` | No built-in in Swift |

### Ranges

> [!NOTE]
> Kotlin ranges are first-class objects that can be stored in variables and passed around. They're also used extensively in `when` expressions and `for` loops.

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Range (exclusive) | `0..<10` | `0..<10` or `0 until 10` | |
| Range (inclusive) | `0...10` | `0..10` | |
| Contains | `(0..<10).contains(5)` | `5 in 0..<10` | More natural in Kotlin |
| Reverse range | `(0...10).reversed()` | `10 downTo 0` | |
| Range with step | `stride(from: 0, to: 10, by: 2)` | `0..<10 step 2` | |
| Character range | `"a"..."z"` | `'a'..'z'` | Single quotes for Char |

### Converting Between Collection Types

| Task | Swift | Kotlin | Note |
|------|-------|--------|------|
| Array to set | `Set(array)` | `array.toSet()` | |
| Set to array | `Array(set)` | `set.toList()` | |
| Map keys to array | `Array(map.keys)` | `map.keys.toList()` | |
| Mutable to immutable | - | `mutableList.toList()` | Creates copy |
| Immutable to mutable | - | `list.toMutableList()` | Creates copy |

### Key Differences to Remember

> [!TIP]
> **Kotlin advantages:**
> - Immutability at the type level (can't accidentally modify `List`)
> - More explicit collection operations (`distinct()`, `none()`)
> - Ranges are first-class objects
> - `to` for map pairs is more readable

> [!WARNING]
> **Watch out for:**
> - `size` not `count` for collection size
> - `add()` not `append()` for adding to lists
> - Collection operations return `Sequence` or `Iterable` - may need `.toList()`
> - `indexOf()` returns -1 (not null) when not found
> - Sublist end index is **exclusive** unlike Swift's closed range
> - Must use mutable collection types to modify collections
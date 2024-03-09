# mojo-stringbuilder

`mojo-stringbuilder` is a library for the Mojo programming language that provides a `StringBuilder` class for efficient string concatenation. It is designed to be a faster alternative to using the `+` operator for concatenating strings, especially when dealing with large or multiple strings.

## Features

- Efficient string concatenation using a dynamic vector
- Avoids the overhead of creating and destroying intermediate strings
- Approximately 10x faster than using the `+` operator for large concatenations
- Easy-to-use API for appending, accessing, and setting strings

## Installation

To use `mojo-stringbuilder`, clone the repository into your project's vendor directory:

```bash
git clone https://github.com/yourusername/mojo-stringbuilder.git vendor/stringbuilder
```

Then, import the `StringBuilder` class in your Mojo code:

```mojo
from stringbuilder import StringBuilder
```

## Usage

```mojo
from stringbuilder import StringBuilder

fn main():
  var sb = StringBuilder()
  sb.append("Hello, ")
  sb.append("world!")
  print(sb)  # Output: Hello, world!
```

## Performance Comparison

The following example demonstrates the performance difference between using `StringBuilder` and the `+` operator for string concatenation:

```mojo
from stringbuilder import StringBuilder
from time import now

fn main():
  var sb = StringBuilder()
  var startTime = now()
  for i in range(1000):
    sb.append("Some long string to be concatenated. ")
  var endTime = now()
  print("StringBuilder time: ", endTime - startTime, "ns")

  var strConcat = ""
  startTime = now()
  for i in range(1000):
    strConcat = strConcat + "Some long string to be concatenated. "
  endTime = now()
  print("String + operator time: ", endTime - startTime, "ns")
```

## Special Thanks

Special thanks to @Michael Kowalski and @Benny from the Mojo Discord server for their help and support in developing this library.

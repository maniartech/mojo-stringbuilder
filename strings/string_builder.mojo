# Special Thanks to @Michael Kowalski and @Benny for the help
# at the Mojo discord server

from memory.buffer import Buffer, Dim
from memory import memcpy
from time import now
from collections.vector import DynamicVector

struct StringBuilder(Stringable):
  """
  A string builder class that allows for efficient string concatenation. This
  class is useful when you need to build a string by appending multiple strings
  together. It is more efficient than using the `+` operator to concatenate
  strings because it avoids the overhead of creating and destroying many
  intermediate strings.

  The result is a more efficient when building larger string concatenations. It
  is generally not recommended to use this class for small concatenations such as
  a few strings like `a + b + c + d` because the overhead of creating the string
  builder and appending the strings is not worth the performance gain.

  Example:
    ```
    var sb = StringBuilder()
    sb.append("mojo")
    sb.append("jojo")
    print(sb) # mojojojo
    ```
  """
  var _strings: DynamicVector[String]

  fn __init__(inout self:StringBuilder):
    self._strings = DynamicVector[String]()

  fn __str__(self:StringBuilder) -> String:
    """
    Converts the string builder to a string.

    Returns:
      The string representation of the string builder. Returns an empty
      string if the string builder is empty.
    """
    var length = 0
    var vlen = self._strings.__len__()
    for i in range(vlen):
      length += self._strings[i].__len__()

    var ptr = DTypePointer[DType.int8].alloc(length + 1)
    var offset = 0
    for i in range(vlen):
      # Get the string as an lvalue without copying
      let tmp = __get_address_as_lvalue((self._strings.data + i).value)

      # Copy the string into the buffer at the offset
      memcpy(ptr.offset(offset), tmp._as_ptr(), len(tmp))
      offset += len(tmp)

    ptr.store(offset, 0) # Null terminate the string
    return StringRef(ptr, length + 1)

  fn append(inout self:StringBuilder, string: String):
    """
    Appends a string to the buffer.

    Args:
      string: The string to append.
    """
    self._strings.push_back(string)

fn main():
  # Create a string from the buffer
  var sb = StringBuilder()

  for i in range(100):
    sb.append("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

  let t1 = now()
  let s = sb.__str__()
  let t1delta = now() - t1

  # Create a string using the + operator

  var vec = DynamicVector[String]()
  for i in range(100):
    vec.push_back("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

  let t2 = now()
  var s2: String = ""
  for i in range(vec.__len__()):
    s2 = s2 + vec[i]
  let t2delta = now() - t2

  print("StringBuilder: ", "(", t1delta, "ns)")
  print("String +: ", "(", t2delta, "ns)")
  print("Performance difference: ", str(t2delta - t1delta) + "ns", ": StringBuilder is ", str(t2delta // t1delta) + "x faster")

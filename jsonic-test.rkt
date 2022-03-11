#lang jsonic

// line comment
[
  null,
  42,
  true,
  ["array", "of", "strings"],
  {
    "key-1": @$ (zero? (- 5 5)) $@,
    "key-2": @$ (random 10) $@,
    "key-3": @$ (range 5) $@
  }
]
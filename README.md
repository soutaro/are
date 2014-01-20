# Array meets Regular Expression

Maintained by: Soutaro Matsumoto

Regular Expression is one of the most useful elements in programming languages. It helps programmers to define a set of strings, and allows to test membership of a string with the set. You use it for various text tests including:

* If the input string is a number
* If the input string can be used as a unix username
* If the input string starts with `http://` or `https://`
* If the input string is a correct email address

Though we usually use Regular Expressions over strings, the definition of them itself does not depends on string. In fact, it can be used over an array. And this is it.

> Regexps in modern programming languages are quite fast, and suitable for use in production.
> ARE is not very fast and we do not recommend to use it in production.
> The library is designed to help you writing a kind of software testing.

## Installation

````
$ gem install are
````

## Syntax

````
ARE.any                         # /./
ARE(1,2)                        # /12/           Concatenation
ARE(1,2) + ARE(3,4)             # /1234/         Concatenation
ARE(1,2) | ARE(3,4)             # /(12)|(34)/    Alternation
ARE.oneof(1,2,3)                # /[123]/
ARE.except(0,1,2)               # /[^012]/
ARE.start + ARE.any + ARE.last  # /\A.\Z/
ARE(1,2).star                   # /(12)*/        Repeat
ARE(1,2).plus                   # /(12)+/        Repeat
ARE(1,2).optional               # /(12)?/        Optional
ARE(1,2).repeat(min:3, max:4)   # /(12){3,4}/
````

### Examples

#### Array should contain `1`

````
ARE(1) =~ array
````

#### Array should contain subarray of `[1,2]`

````
ARE(1,2) =~ array
````

#### Array should contain subarray of `[1,2]` and `[3,4]`

````
ARE(1,2) =~ array and ARE(3,4) =~ array
````

#### Array should contain subarray of `[1,2]` and `[3,4]`, and `[3,4]` should occur after `[1,2]`

````
(ARE(1,2) + ARE.any.star + ARE(3,4)) =~ array
````

#### Array should contain subarray of `[1,2]` and `[3,4]`, and `[3,4]` should occur after `[1,2]`, and should not have `5` or `6` between them 

````
ARE(1,2) + ARE.except(5,6).star + ARE(3,4)
````

### Testing a element of Array

It uses `each` for enumeration and `===` to test the membership. You can give any object in regexp including classes, procs, and ranges.

````
ARE(Fixnum, Symbol, String) =~ [1, :x, "a"]       # => 0
ARE(:even?.to_proc) =~ [1,3,5]                    # => nil
ARE(1...3) =~ [5,4,3,2,1]                         # => 3
````

Note that if you give more than two possibilities which matches with `===` operator, the result of the test will be nondeterministic.
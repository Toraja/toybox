---
syntax: markdown
---

NOTE: `jq` can receive input as STDIN instead of reading file.

# Select multiple value
This includes the all the parent keys unlike other methods.

```sh
echo '{"fruit": "apple", "animal": "bear", "foo": {"bar": {"baz": "!!!"}, "qux": "@@@"}}' | jq 'pick(.fruit, .foo.bar)'
```

Output:
```json
{
  "fruit": "apple",
  "foo": {
    "bar": {
      "baz": "!!!"
    }
  }
}
```

# Convert json to sting (usable form as json value)
i.e. wrap entire json in double quote and escape each quote inside json.
```sh
jq tostring <file>
```
This command changes
```json
{
    "a": "apple",
    "b": "banana"
}
```
to
```
"{\"a\":\"apple\",\"b\":\"banana\"}"
```

# Convert escaped json to normal json (invert of tostring)
```sh
jq fromjson <file>
```

# Modify values
Add the entry if it does not exist, and replace the value if the key exists.

```sh
echo '{"foo": {"bar": "zzz"}}' | jq '.foo.bar = "qux" | .nums = [2,3,4]'
```

Output:
```json
{
  "foo": {
    "bar": "qux"
  },
  "nums": [
    2,
    3,
    4
  ]
}
```

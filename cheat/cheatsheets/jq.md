---
syntax: markdown
---

NOTE: `jq` can receive input as STDIN instead of reading file.

# Convert json to sting (usable form as json value)
i.e. wrap entire json in double quote and escape each quote inside json.
```
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
```
jq fromjson <file>
```

# Modify values
Add the entry if it does not exist, and replace the value if the key exists.

```sh
echo '{"foo": {"bar": "zzz"}}' | jq '.foo.bar = "qux" | .nums = [2,3,4]'
```

Output:
```
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

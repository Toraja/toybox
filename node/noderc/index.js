/**
 * Escape double quotaion in JSON, so that it can be used in other languages like Java.
 */
function stringifyWithEscape(obj) {
  return '"' + JSON.stringify(obj).replace(/"/g, '\\"') + '"';
}
global.JSON.stringifyWithEscape = module.exports.stringifyWithEscape = stringifyWithEscape;

/**
 * Save the argument to clipboard.
 * If <arg> is not a string, it is converted to JSON using JSON.stringify().
 */
function clip(arg) {
  let cp = child_process.spawn('clip');
  data = (typeof arg === 'string') ? arg : JSON.stringify(arg);
  cp.stdin.write(data);
  cp.stdin.end();
}
global.clip = module.exports.clip = clip;

/**
 * List of fruits
 */
let fruits = [
  'apple', 'banana', 'cherry', 'durian', 'elderberry',
  'fig', 'guava', 'huckleberry', 'ita palm', 'jackfruit',
  'kumquat', 'lychee', 'mango', 'nectarine', 'orange',
  'papaya', 'quince', 'raspberry', 'strawberry', 'tamarind',
  'ugli fruit', 'voavanga', 'water melon', 'ximenia', 'yuzu', 'zapote'
]
global.fruits = module.exports.fruits = fruits;

/**
 * Dictionary of fruits
 * This will be like {a: 'apple', b: 'banana'...}
 */
let fd = {};
for (let fruit of fruits) {
  let firstChar = fruit[0];
  fd[firstChar] = fruit;
}
global.fruitsDict = module.exports.fruitsDict = fd;

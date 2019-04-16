module.exports = handler

function handler(iterator, callback) {
  for (var it of iterator) {
    callback(it)
  }
}

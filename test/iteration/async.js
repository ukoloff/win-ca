module.exports = handler

async function handler(iterator, callback) {
  for await (var it of iterator) {
    callback(it)
  }
}

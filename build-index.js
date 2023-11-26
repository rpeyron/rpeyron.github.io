var stdin = process.stdin,
    stdout = process.stdout,
    buffer = []

var lunr = require('./assets/js/lunr')
require("./assets/js/lunr.stemmer.support.min")(lunr)
require("./assets/js/lunr.fr.min")(lunr)
require("./assets/js/lunr.multi.min")(lunr)

const fs = require("fs")

const fileIn = "./_site/assets/search-cards.json"
const fileOut = "./_site/assets/search-lunr-index.json"

if (fileIn && fs) stdin = fs.createReadStream(fileIn);
if (fileOut && fs) stdout = fs.createWriteStream(fileOut, {flags: "w"});

stdin.resume()
stdin.setEncoding('utf8')

stdin.on('data', function (data) {
  buffer.push(data)
})

stdin.on('end', async function () {
  var documents = JSON.parse(buffer.join(''))

  var idx = lunr(function () {
    this.use(lunr.fr)
    this.use(lunr.multiLanguage('en', 'fr'))

    this.ref('id')
    this.field('title')
    this.field('body')

    documents.forEach(function (doc) {
      this.add(doc)
    }, this)
  })

  console.log("Docs", documents.length, fileOut)
  await stdout.write(JSON.stringify(idx))
})
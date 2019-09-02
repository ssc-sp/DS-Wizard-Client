const fs = require('fs')

const defaultLocalePath = 'src/elm/Common/Provisioning/DefaultLocale.elm'
const fileContent = fs.readFileSync(defaultLocalePath, 'utf8')
const locale = {}
const regex = /\( "(.*)", "(.*)" \)/g

let result
while ((result = regex.exec(fileContent)) !== null) {
    locale[result[1]] = result[2]
}

console.log(JSON.stringify(locale))

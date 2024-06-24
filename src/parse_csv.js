const fs = require('fs')
const moment = require('moment-timezone')
const _ = require('lodash')

function parseCsv(fileName) {
    let file = fs.readFileSync(fileName, 'utf8')
    let lines = file.split('\r\r\n')
    
    function dateParse(date, time) {
        let d = moment.tz(
          date + " " + time,
          "MM/DD/YYYY HH:mm:ss",
          "America/Chicago"
        );
        return d.tz("UTC").format();
    }
    
    let arr = []
    
    for (let i = 1; i < lines.length; i++) {
        let obj = {}
        let data = lines[i].split('","')
    
        obj.time = data[1]
        obj.program_code = data[2]
        obj.series_title = data[3]
        obj.program_title = data[4]
        obj.guest = data[5]
        obj.date = data[0].replace('"', '')
        obj.date_str = dateParse(obj.date, obj.time)
    
        arr.push(obj)
    }

    return arr
}

let finalArr = []
let files = fs.readdirSync('csv')

files.forEach(n => {
    finalArr.push(parseCsv(`csv/${n}`))
})

fs.writeFileSync('exports/json/radio.json', JSON.stringify(_.flattenDeep(finalArr)))


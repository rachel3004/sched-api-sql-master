const fs = require("fs")
const request = require("request")
const EventEmitter = require('events')
const parse = require("./parse")
const month = 86400000 * 32
const _ = require('lodash')

const emitter = new EventEmitter

emitter.on('complete', () => {
    fs.writeFileSync('exports/json/radio.json', JSON.stringify(_.flattenDeep(_.compact(data))))
})

let dates = []
let data = []

for (let i = -2; i < 3; i++) {
    dates.push(new Date(Date.now() + month * i))
}

for (let j = 0; j < dates.length; j++) {
    request.post( "http://64.83.241.6/ScheduleResults2.cfm", {
        form: {
            Net: 3,
            Date: `${dates[j].getMonth() + 1}/1/${dates[j].getFullYear()}`,
            WholeMonth: "1"
            }
        }, (err, httpResponse, body) => {
            data[j] = parse(body)
            if (_.compact(data).length === 5) {
                emitter.emit('complete')
            }
        }
    )
}

const router    = require('express').Router()
const lib       = require('./lib')
const db        = require('./db')

function routes() {

    router.get('/', (req, res) => {
        res.send('please specify channel and date: /:channel/:date')
    })

    router.get('/:channel', (req, res) => {
        if (!lib.validChannel(req.params.channel)) {
            res.send('unkown channel')
        } else {
            res.send('please specify the date: /:channel/:date')
        }
    })

    router.get('/:channel/:date', (req, res) => {
        let {channel, date} = req.params

        if (!lib.validChannel(channel)) {
            res.send('unkown channel')
            return
        }
        if (!lib.validDate(date)) {
            res.send('invalid date format')
            return
        }

        db.dbQuery(channel, date, 0)
                .then((r) => {
                    const d = new Date()
                    console.log(`"${req.ip}" | "${d.toISOString()}" | "${req.method} ${req.originalUrl}" | "${req.useragent.source}"`)
                    res.json({schedule: r[0]})
                })
                .catch((e) => res.send(e))

    })

    router.get('/:channel/:date/:offset', (req, res) => {
        let {channel, date, offset} = req.params
        if (!lib.validChannel(channel)) {
            res.send('unkown channel')
            return
        }

        if (!lib.validDate(date)) {
            res.send('invalid date format')
            return
        }

        offset = parseInt(offset)
        db.dbQuery(channel, date, offset)
            .then((r) => {
                const d = new Date()
                    console.log(`"${req.ip}" | "${d.toISOString()}" | "${req.method} ${req.originalUrl}" | "${req.useragent.source}"`)
                res.json({schedule: r[0]})
            })
            .catch((e) => res.send(e))
    })


    return router
}

module.exports = routes



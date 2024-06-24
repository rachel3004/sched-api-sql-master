const mysql = require('mysql2')
const tz = require('timezone')

const pool = mysql.createPool({
    host:       'localhost',
    user:       'sched',
    password:   process.env.SCHED_API_DB_PWD,
    database:   'pg'
})

function dbQuery(channel, date, tzOffset) {
    return new Promise((resolve, reject) => {
        if (channel === 'radio') {
            pool.query(schedQueryRadio(date, tzOffset), (error, results) => {
                if (error) { return reject(error) }
                
                return resolve(results)
            })
        } else {
            pool.query(schedQuery(channel, date, tzOffset), (error, results) => {
                if (error) { return reject(error) }
                
                return resolve(results)
            })
        }
    })
}

module.exports = {
    dbQuery
}

// query helpers

function schedQuery(channel, date, tzOffset) {
    return `CALL getSched('${parseChannel(channel)}', '${date}', '${parseTz(tzOffset)}')`
}

function schedQueryRadio(date, tzOffset) {
    return `CALL getRadio('${date}', '${parseTz(tzOffset)}')`
}

function parseTz(tz) {
    const sign = Math.sign(Math.round(tz / 60)) < 0 ? '-' : '+'
    const hours = padNum(Math.abs(Math.round(tz / 60)), 2)
    const mins = padNum (Math.abs(Math.round( (tz / 60 - Math.round(tz / 60)) * 60)), 2)
    
    return `${sign}${hours}:${mins}`
}

function padNum(n, width, z) {
    z = z || '0';
    n = n + '';
    return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

function parseChannel(channel) {
    switch (channel) {
        case 'main':
        return '3ABN'
        case 'proc':
        return 'PROC'
        case 'dare':
        return 'DARE'
        case 'int':
        return 'INT'
        case 'kids':
        return 'KIDS'
        case 'lat':
        return 'LAT'
        case 'praise':
        return 'PRAIS'
    }
}

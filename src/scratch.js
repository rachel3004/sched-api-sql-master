const tz = require('timezone')

const d = tz('2018-01-02', '-1 day', '%Y-%m-%d')

console.log(d)

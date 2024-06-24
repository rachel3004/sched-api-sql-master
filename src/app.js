const app = require('express')();
const cors = require('cors');
const useragent = require('express-useragent');

app.use(cors());
app.use(useragent.express());

app.use('/daily', require('./dailyRouter')());

app.listen(3000, '', (err) => {
    if (err) throw err;

    console.log('Application listening in port 3000');
});

function sayHello(name) {
    console.log('Hello ' + name);
}

sayHello('Jane');
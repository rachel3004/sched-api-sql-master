
function validChannel(c) {
    if (
        c === "main" ||
        c === "proc" ||
        c === "dare" ||
        c === "lat" ||
        c === "kids" ||
        c === "int" ||
        c === "praise" ||
        c === "radio"
    ) {
        return true
    } else {
        return false
    }
}

function validDate(d) {
    let r =  /\d\d\d\d-\d\d-\d\d/.test(d)
    return r
}


module.exports = {
    validChannel,
    validDate
}
const fs = require("fs");
const jsdom = require("jsdom");
const { JSDOM } = jsdom;
const moment = require("moment-timezone");

function dateParse(date, time) {
  let d = moment.tz(
    date + " " + time,
    "MM/DD/YYYY HH:mm:ss",
    "America/Chicago"
  );
  return d.tz("UTC").format();
}

function parse(str) {
  let dom = new JSDOM(str);

  let re = /\d/;

  let days = dom.window.document.getElementsByTagName("Center");
  let daysData = dom.window.document.getElementsByTagName("table");

  let arr = [];

  for (let i = 0; i < days.length; i++) {
    let index = days[i].textContent.search(re);
    let end = days[i].textContent.length;

    let data = daysData[i].getElementsByTagName("tr");

    for (let j = 1; j < data.length; j++) {
      let rowData = {};
      let cells = data[j].getElementsByTagName("td");

      for (let k = 0; k < cells.length; k++) {
        switch (k) {
          case 0:
            rowData.time = cells[k].textContent;
          case 1:
            rowData.program_code = cells[k].textContent;
          case 2:
            rowData.duration = cells[k].textContent;
          case 3:
            rowData.series_title = cells[k].textContent;
          case 4:
            rowData.program_title = cells[k].textContent;
          case 5:
            rowData.guest = cells[k].textContent;
          case 6:
            rowData.date = days[i].textContent.slice(index, end);
          case 7:
            rowData.date_str = dateParse(rowData.date, rowData.time);
        }
        arr.push(rowData);
      }
    }
  }

  return arr;
}

module.exports = parse;

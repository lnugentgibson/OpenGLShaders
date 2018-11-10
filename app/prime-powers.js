const fs = require('fs');

function isComplete(resolve, reject, primes, min, max, i, err, body) {
    if(err) {
        console.error(err);
        reject(err);
        return;
    }
    var cur = JSON.parse('' + body);
    primes = primes.concat(cur.filter(p => p < max).reduce((ps, p) => {
        var e = 0;
        for(var f = p; f < max; f *= p) {
            e++;
            if(f > min)
                ps.push([p, e, f]);
        }
        return ps;
    }, []));
    if(cur[cur.length - 1] > max) {
        resolve(primes);
        return;
    }
    fs.readFile(`primes/primes-${('000' + i).substr(-3, 3)}.json`, isComplete.bind(this, resolve, reject, primes, min, max, i + 1));
}
new Promise((resolve, reject) => {
    fs.readFile(`primes/primes-000.json`, isComplete.bind(this, resolve, reject, [], 200, 300, 1));
}).then(primes => {
    console.log(primes.length);
});
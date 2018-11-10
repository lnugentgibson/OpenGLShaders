const fs = require('fs');

var primes = [];

function isPrime(n) {
    var f = Math.ceil(Math.sqrt(n));
    //console.log(`${n}: starting at ${f}`);
    for(; f > 1 && f < n; f--)
        if(n  - Math.round(n / f) * f == 0) {
            //console.log(`${n} is divisible by ${f}`);
            return false;
        }
    //console.log(`${n} is prime`);
    return true;
}

for(var n = 2; n < 1000000; n++) {
    if(isPrime(n)) {
        var cur;
        if(!primes.length)
            cur = primes[0] = [];
        else
            cur = primes[primes.length - 1];
        if(cur.length == 100)
            cur = primes[primes.length] = [];
        cur.push(n);
    }
}

primes.forEach((p, i) => {
    fs.writeFile(`primes\\primes-${('000' + i).substr(-3, 3)}.json`, JSON.stringify(p, null, 2), 'utf8', err => {
        if(err)
            console.error(err);
    });
})
#!/usr/bin/env node

function genpass(username, keyword, passphrase, concat, lesspower) {
    var password = '';
    var sha256 = require('js-sha256');
    var shapass = sha256(username + concat + keyword + concat + passphrase);
    for (var i = 0; i < shapass.length; i+=2) {
        var num = parseInt(shapass.substr(i, 2), 16);
        if (32 <= num && num <= 127 && num !== 92 && num !== 96 && num !== 34 && num !== 39) {
            if (lesspower) {
                if ((47 <= num && num <= 58) || (64 <= num && num <= 91) || (96 <= num && num <= 123)) {
                password = String.fromCharCode(num) + password;
                }
            } else {
                password = String.fromCharCode(num) + password;
            }
        }
    }
    if (password.length <= 7) {
        password = password + password;
    } else if (password.length >= 14) {
        password = password.substr(password.length - 14, 14);
    }
    return password;
}

console.log(genpass('', '', '', 'strongpassword', false));

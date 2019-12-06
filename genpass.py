#!/usr/bin/env python


def genpass(username, keyword, passphrase, concat='strongpassword', lesspower=False):
    password = ''
    from hashlib import sha256
    shapass = sha256(username + concat + keyword + concat + passphrase).hexdigest()
    for i in range(0, len(shapass), 2):
        num = int(shapass[i:i + 2], base=16)
        if 32 <= num and num <= 127 and num != 92 and num != 96 and num != 34 and num != 39:
            if lesspower:
                if (47 <= num and num <= 58) or (64 <= num and num <= 91) or (96 <= num and num <= 123):
                    password = chr(num) + password
            else:
                password = chr(num) + password

    if len(password) <= 7:
        password = password * 2
    elif len(password) >= 14:
        password = password[-14:]
    return password


if __name__ == '__main__':
    print genpass('', '', '')

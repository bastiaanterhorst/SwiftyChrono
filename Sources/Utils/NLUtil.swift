

import Foundation

let NL_WEEKDAY_OFFSET = [
    "zondag": 0,
    "zo": 0,
    "maandag": 1,
    "ma": 1,
    "dinsdag": 2,
    "di":2,
    "woensdag": 3,
    "wo": 3,
    "donderdag": 4,
    "do": 4,
    "vrijdag": 5,
    "vr": 5,
    "zaterdag": 6,
    "za": 6
]
let NL_WEEKDAY_WORDS_PATTERN = "(?:" + NL_WEEKDAY_OFFSET.keys.joined(separator: "|") + ")"

let NL_MONTH_OFFSET = [
    "januari": 1,
    "jan": 1,
    "jan.": 1,
    "februari": 2,
    "feb": 2,
    "feb.": 2,
    "maart": 3,
    "mrt": 3,
    "mrt.": 3,
    "april": 4,
    "apr": 4,
    "apr.": 4,
    "mei": 5,
    "juni": 6,
    "jun": 6,
    "jun.": 6,
    "juli": 7,
    "jul": 7,
    "jul.": 7,
    "augustus": 8,
    "aug": 8,
    "aug.": 8,
    "september": 9,
    "sep": 9,
    "sep.": 9,
    "sept": 9,
    "sept.": 9,
    "oktober": 10,
    "okt": 10,
    "okt.": 10,
    "november": 11,
    "nov": 11,
    "nov.": 11,
    "december": 12,
    "dec": 12,
    "dec.": 12
]
let NL_MONTH_OFFSET_PATTERN = "(?:" + NL_MONTH_OFFSET.keys.joined(separator: "|") + ")"

let NL_INTEGER_WORDS = [
    "een": 1,
    "twee": 2,
    "drie": 3,
    "vier": 4,
    "vijf": 5,
    "zes": 6,
    "zeven": 7,
    "acht": 8,
    "negen": 9,
    "tien": 10,
    "elf": 11,
    "twaalf": 12,
    "dertien": 13,
    "veertien": 14
]
let NL_INTEGER_WORDS_PATTERN = "(?:" + NL_INTEGER_WORDS.keys.joined(separator: "|") + ")"

// all need /n/r/m/s
let NL_ORDINAL_WORDS = [
    "eerste": 1,
    "tweede": 2,
    "derde": 3,
    "vierde": 4,
    "vijfde": 5,
    "zesde": 6,
    "zevende": 7,
    "achtste": 8,
    "negende": 9,
    "tiende": 10,
    "elfde": 11,
    "twaalfde": 12,
    "dertiende": 13,
    "veertiende": 14,
    "vijftiende": 15,
    "zestiende": 16,
    "zeventiende": 17,
    "achttiende": 18,
    "negentiende": 19,
    "twintigste": 20,
    "eenentwingigste": 21,
    "tweeentwintigste": 22,
    "drieentwintigste": 23,
    "vierentwintigste": 24,
    "vijfentwintigste": 25,
    "zesentwintigste": 26,
    "zevenentwintigste": 27,
    "achtentwintigste": 28,
    "negenentwintigste": 29,
    "dertigste": 30,
    "eenendertigste": 31
]

let NL_ORDINAL_WORDS_PATTERN = "(?:" + NL_ORDINAL_WORDS.keys.joined(separator: "|") + ")"

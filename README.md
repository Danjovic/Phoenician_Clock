# Phoenician_Clock
Digital clock with a LED bargraph display using Phoenician notation for individual digits.

## Introduction
Eevery digit of the (decimal) is displayed as a sequence of lit/unlit bars equivalent to the phoenician representation of digits 1 to 9. 

| Decimal | Phoenician |
|:---:|:---:|
| 1 | \| |
| 2 | \|\| |
| 3 | \|\|\| |
| 4 | \| \|\|\| |
| 5 | \|\| \|\|\| |
| 6 |  \|\|\|  \|\|\| |
| 7 | \| \|\|\| \|\|\| |
| 8 | \|\| \|\|\| \|\|\| |
| 9 | \|\|\| \|\|\| \|\|\| |

#### Dealing wiht the zero

The Phoenicians do not have a zero but it can be displayed as no segment lit. It is necessary, though, to justify the digits to the left or to the right to differentiate 10 from 01

| minute | Display |
|:---:|:---:|
| 05 | --------------\|\| \|\|\| |
| 50 | \|\| \|\|\|-------------- |

### How many bars ?
The biggest number to be displayed is 59. It takes at least 19 bars, being 6 for the digit 5 and 11 bars for the digit 9 plus two bars of spacing.
  
\|\|-\|\|\|--\|\|\|-\|\|\|-\|\|\|   

A couple of 10 segment Bargraph modules will be enough to represent the time.



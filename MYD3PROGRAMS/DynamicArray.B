:UNIENTRY PERSON


PERSON RECORD ID=1
 1 NAME=Kailash Kher
Column No.           1                  2
No            Children                Age
 1
Children=Ram
Age=6
Column No.           1                  2
No            Children                Age
 1                 Ram                  6
 2
Children=Mohan
Age=9
Column No.           1                  2
No            Children                Age
 1                 Ram                  6
 2               Mohan                  9
 3
Children=Gita
Age=12
Column No.           1                  2
No            Children                Age
 1                 Ram                  6
 2               Mohan                  9
 3                Gita                 12
 4
Children=

        PERSON RECORD ID==>1

  0 @ID=1
  1 NAME=Kailash Kher
2 ==>KIDS AGES

2 IS MULTI VALUED FIELD(S) SCREEN.

Enter 'DELETE' 'UNCHANGE' 'QUIT' or NUMBER to change
Change=


PERSON RECORD ID=2
 1 NAME=Vishal Bhagwat
Column No.           1                  2
No            Children                Age
 1
Children=Tina
Age=17
Column No.           1                  2
No            Children                Age
 1                Tina                 17
 2
Children=David
Age=22
Column No.           1                  2
No            Children                Age
 1                Tina                 17
 2               David                 22
 3
Children=

        PERSON RECORD ID==>2

  0 @ID=2
  1 NAME=Vishal Bhagwat
2 ==>KIDS AGES

2 IS MULTI VALUED FIELD(S) SCREEN.

Enter 'DELETE' 'UNCHANGE' 'QUIT' or NUMBER to change
Change=


PERSON RECORD ID=3
 1 NAME=Shreya Gohsal
Column No.           1                  2
No            Children                Age
 1
Children=Diva
Age=14
Column No.           1                  2
No            Children                Age
 1                Diva                 14
 2
Children=Sargam
Age=30
Column No.           1                  2
No            Children                Age
 1                Diva                 14
 2              Sargam                 30
 3
Children=Nisha
Age=13
Column No.           1                  2
No            Children                Age
 1                Diva                 14
 2              Sargam                 30
 3               Nisha                 13
 4
Children=

        PERSON RECORD ID==>3

  0 @ID=3
  1 NAME=Shreya Gohsal
2 ==>KIDS AGES

2 IS MULTI VALUED FIELD(S) SCREEN.

Enter 'DELETE' 'UNCHANGE' 'QUIT' or NUMBER to change
Change=


PERSON RECORD ID=
:LIST PERSON
LIST PERSON 18:27:03 Aug 11 2021 1
PERSON....

1
2
3
3 records listed

:LIST PERSON NAME KIDS AGES KID
LIST PERSON NAME KIDS AGES KIDS AGES 18:28:13 Aug 11 2021 1
PERSON   1
NAME     Kailash Kher
Children             Age Children             Age
Ram                    6 Ram                    6
Mohan                  9 Mohan                  9
Gita                  12 Gita                  12

PERSON   2
NAME     Vishal Bhagwat
Children             Age Children             Age
Tina                  17 Tina                  17
David                 22 David                 22

PERSON   3
NAME     Shreya Gohsal
Children             Age Children             Age
Diva                  14 Diva                  14
Sargam                30 Sargam                30
Nisha                 13 Nisha                 13

3 records listed

:AE PERSON
Record ids > 1
Top of "1" in "PERSON", 3 lines, 34 characters.
*--: L20
001: Kailash Kher
002: RamýMohanýGita
003: 6ý9ý12
Bottom.
*--:



Consider the following example:
A = 123V456S7890S2468V10F3691V33S12
B = 13V57S912F1234V8
$OPTIONS VEC.MATH
X = A + B
First, the function processing isolates the first field of each dynamic array, which
can be written as:
A <1> = 123V456S7890S2468V10
B <1> = 13V57S912
Then the first values of the first fields are isolated:
A <1, 1> = 123
B <1, 1> = 13
Then the first subvalues of the first values of the first fields are isolated and
added:
A <1, 1, 1> = 123
B <1, 1, 1> = 13
This produces the first subvalue of the first value of the first field of the result:
X <1, 1, 1> = 136
Since there are no more subvalues in the first value of either first field, the second
values of the first fields are isolated:
A <1, 2> = 456S7890S2468
B <1, 2> = 57S912
The first subvalues of the second values of the first fields are isolated and added:
A <1, 2, 1> = 456
B <1, 2, 1> = 57
This produces the first subvalue of the second value of the first field of the result:
X <1, 2, 1> = 513
Next the subvalues:
A <1, 2, 2> = 7890
B <1, 2, 2> = 912
are isolated and added to produce:
X <1, 2, 2> = 8802

Then the subvalues:
A <1, 2, 3> = 2468
B <1, 2, 3> = ""
are isolated and added to produce:
X <1, 2, 3> = 2468
Since B <1, 2, 3> does not exist, it is equal to an empty string. In arithmetic expressions
an empty string equals zero.
Since there are no more subvalues in either second value of the first fields, these
values are isolated:
A <1, 3> = 10
B <1, 3> = ""
Then the subvalues:
A <1, 3, 1> = 10
B <1, 3, 1> = ""
are isolated and added to produce:
X <1, 3, 1> = 10
Since there are no more subvalues or values in either first field, the second fields
of each dynamic array are isolated and the process repeats down to the subvalue
levels. The second fields can be written as follows:
A <2> = 3691V33S12
B <2> = 1234V8
Then the first values of the second fields are isolated:
A <2, 1> = 3691
B <2, 1> = 1234
Then the first subvalues of the first values of the second fields are isolated and
added:
A <2, 1, 1> = 3691
B <2, 1, 1> = 1234
This produces the first subvalue of the first value of the second field of the result:
X <2, 1, 1> = 4925
Then the second values of the second fields are isolated:
A <2, 2> = 33S12
B <2, 2> = 8
Then the first subvalues of the second values of the second fields are isolated and
added:
A <2, 2, 1> = 33
B <2, 2, 1> = 8
This produces the first subvalue of the second value of the second field of the
result:
X <2, 2, 1> = 41
Then the second subvalues of the second values of the second fields are isolated
and added:
A <2, 2, 2> = 12
B <2, 2, 2> = ""
This produces the second subvalue of the second value of the second field of the
result:
X <2, 2, 2> = 12
Since there are no more elements in either dynamic array, the result is:
X <1, 1, 1> = 136
X <1, 2, 1> = 513
X <1, 2, 2> = 8802
X <1, 2, 3> = 2468
X <1, 3, 1> = 10
X <2, 1, 1> = 4925
X <2, 2, 1> = 41
X <1, 2, 2> = 12
These elements are put into the resultant dynamic array, separated by the delimiter
delimiter
mark corresponding to the highest levels that are different (for example,
X<1,1,1> and X<1,2,1> have different value levels, so they are separated by a
value mark). This yields the following:
X = 136V513S8802S2468V10F4925V41S12



*:RUN BP DYNAMIC_DATA_PROG

*Sum = 136ý513ü8802ü2468ý10ţ4925ý41ü12
*:.x
*RUN BP DYNAMIC_DATA_PROG

*NUM1 = 123ý456ü7890ü2468ý10ţ3691ý33ü12
*NUM2 = 13ý57ü912ţ1234ý8
*Sum = 136ý513ü8802ü2468ý10ţ4925ý41ü12


# auto_id
*Admin*
 
1 - Create course :- 
	- course name 
	- course - event - workshop
	- topic 
	- course description 
	- price
	- offers 
	 -max students
	- logo 
	- time slots
	- need data from users 
	- instructor name [Account]

- firestore store Branch with course details 
- google sheet for students only // sheet id

*User* 
1 - List the courses 
[Register] -->  add student to sheet course  
[Account ] -->  firestore [register Courses for me]
	- يشوف غياب وحضور 
	- See my data 

operation
- my courses -> course -> scan -> [ QR , Scan from gallery ]

Instructor 
- see assign courses only 
- Create QR 
	{
	id , time slot , expire date
	}
- register students 
- see all student data

************//////////////////////////////*************************************
- add sheet with column names .
	- columns :  column names list 
	- name : course name
	- Emails : list of Email ["moneam.elbahy@gmail.com "]
	** return sheet id **

- add user to course with id 
	- sheet id
	- map of data 
	*done - fail*

- get all users from sheet 
	- sheet id
	*list of map*
[
	{
		userName : "ahmed" ,
		userId : "" ,
	},
]

- get specific user 
	- sheet id
	- userId
	{
		userName : "ahmed" ,
		userId : "123456" ,
		registration : {
			     	"date" : 1
				"date" : 0 
			     }
	},

- register user from mobile
	- sheet id 
	- userId

- register user from ESP
	- RFID

- delete any 
	- sheet id 
	+ userId



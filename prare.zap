
	.SEGMENT "0"


	.FUNCT	TOO-MANY-NEW:ANY:1:1,WHAT
	PRINTI	"[Warning: there are too many new "
	PRINT	WHAT
	PRINTR	"s.]"


	.FUNCT	NAKED-OOPS:ANY:0:0
	PRINTR	"[Please type a word(s) after OOPS.]"


	.FUNCT	CANT-OOPS:ANY:0:0
	PRINTR	"[There was no word to replace in that sentence.]"


	.FUNCT	CANT-AGAIN:ANY:0:0
	PRINTR	"[What do you want to do again?]"


	.FUNCT	CANT-USE-MULTIPLE:ANY:2:2,LOSS,WD
	SET	'CLOCK-WAIT,TRUE-VALUE
	PRINTI	"[You can't use more than one object at a time with """
	PRINTB	WD
	PRINTR	"""!]"


	.FUNCT	MAKE-ROOM-FOR-TOKENS:ANY:3:4,CNT,LEXV,WHERE,BEG,LEN,?TMP2,?TMP1
	ASSIGNED?	'BEG /?CND1
	SET	'BEG,P-LEXSTART
?CND1:	GETB	LEXV,0
	MUL	2,STACK >LEN
	MUL	P-LEXELEN,CNT
	ADD	WHERE,STACK
	LESS?	LEN,STACK \?CND3
	SUB	LEN,WHERE
	DIV	STACK,P-LEXELEN >CNT
	ICALL2	TOO-MANY-NEW,STR?54
?CND3:	GETB	LEXV,P-LEXWORDS >LEN
	ADD	CNT,LEN
	PUTB	LEXV,P-LEXWORDS,STACK
	MUL	2,WHERE
	ADD	LEXV,STACK >LEXV
	MUL	CNT,4 >CNT
	ADD	LEXV,CNT >?TMP1
	MUL	2,LEN >?TMP2
	SUB	WHERE,BEG
	SUB	?TMP2,STACK
	MUL	2,STACK
	COPYT	LEXV,?TMP1,STACK
	RTRUE	


	.FUNCT	REPLACE-ONE-TOKEN:ANY:5:5,N,FROM-LEXV,PTR,TO-LEXV,WHERE,CNT,X,?TMP1,?TMP2
	SUB	N,1 >CNT
	ZERO?	CNT /?CND1
	ICALL	MAKE-ROOM-FOR-TOKENS,CNT,TO-LEXV,WHERE
?CND1:	SET	'CNT,N
?PRG3:	DLESS?	'CNT,0 /TRUE
	ADD	PTR,P-LEXELEN >PTR
	GET	FROM-LEXV,PTR
	PUT	TO-LEXV,WHERE,STACK
	MUL	PTR,P-LEXELEN
	ADD	STACK,2 >X
	GETB	FROM-LEXV,X >?TMP2
	ADD	X,1
	GETB	FROM-LEXV,STACK >?TMP1
	MUL	WHERE,P-LEXELEN
	ADD	STACK,3
	CALL	INBUF-ADD,?TMP2,?TMP1,STACK
	ZERO?	STACK \?CND7
	ICALL2	TOO-MANY-NEW,STR?55
	RTRUE	
?CND7:	ADD	WHERE,P-LEXELEN >WHERE
	JUMP	?PRG3


	.FUNCT	V-$REFRESH:ANY:0:0
	GET	0,8
	BAND	STACK,-5
	PUT	0,8,STACK
	CLEAR	-1
	ICALL1	INIT-STATUS-LINE
	RTRUE	


	.FUNCT	PRINT-LEXV:ANY:0:3,QUIET,X,LEN,WD,IN-QUOTE,OWD
	ASSIGNED?	'X /?CND1
	MUL	QUIET,4
	ADD	TLEXV,STACK >X
?CND1:	ASSIGNED?	'LEN /?CND3
	SUB	P-LEN,QUIET >LEN
?CND3:	ZERO?	QUIET /?CCL6
	GRTR?	0,P-OFLAG \?CND5
?CCL6:	ZERO?	P-RESPONDED /?CCL11
	SUB	0,P-RESPONDED
	ICALL2	BE-PATIENT,STACK
	JUMP	?CND9
?CCL11:	SET	'P-RESPONDED,1
?CND9:	PRINTI	"[In other words:"
?CND5:	SET	'IN-QUOTE,FALSE-VALUE
	EQUAL?	QUIET,-1 \?CCL14
	SET	'OWD,W?APOSTROPHE
	JUMP	?PRG15
?CCL14:	SET	'OWD,0
?PRG15:	GET	X,0 >WD
	EQUAL?	WD,W?PERIOD,W?COMMA,W?APOSTROPHE /?CND17
	EQUAL?	WD,W?NO.WORD /?CND17
	EQUAL?	OWD,W?APOSTROPHE /?CND17
	EQUAL?	OWD,W?QUOTE \?CCL25
	ZERO?	IN-QUOTE \?CCL25
	SET	'IN-QUOTE,TRUE-VALUE
	JUMP	?CND17
?CCL25:	EQUAL?	WD,W?QUOTE \?CCL29
	ZERO?	IN-QUOTE /?CCL29
	SET	'IN-QUOTE,FALSE-VALUE
	JUMP	?CND17
?CCL29:	PRINTC	32
?CND17:	EQUAL?	WD,W?NO.WORD /?CND32
	CALL2	CAPITAL-NOUN?,WD
	ZERO?	STACK /?CCL36
	ICALL2	CAPITALIZE,X
	JUMP	?CND32
?CCL36:	EQUAL?	WD,0,W?INT.NUM,W?INT.TIM \?CCL38
	ADD	X,P-WORDLEN
	ICALL	BUFFER-PRINT,X,STACK,FALSE-VALUE,TRUE-VALUE
	JUMP	?CND32
?CCL38:	PRINTB	WD
?CND32:	DLESS?	'LEN,1 /?REP16
	EQUAL?	WD,W?NO.WORD /?CND41
	SET	'OWD,WD
?CND41:	ADD	X,4 >X
	JUMP	?PRG15
?REP16:	ZERO?	QUIET /?CCL45
	GRTR?	0,P-OFLAG \FALSE
?CCL45:	PRINTR	"]"


	.FUNCT	COPY-INPUT:ANY:0:1,QUIET,LEN,?TMP1
	COPYT	G-LEXV,P-LEXV,LEXV-LENGTH-BYTES
	GETB	P-LEXV,P-LEXWORDS >P-LEN
	GET	OOPS-TABLE,O-START >TLEXV
	COPYT	G-INBUF,P-INBUF,61
	GETB	P-LEXV,P-LEXWORDS
	MUL	4,STACK >LEN
	DEC	'LEN
	GETB	TLEXV,LEN >?TMP1
	DEC	'LEN
	GETB	TLEXV,LEN
	ADD	?TMP1,STACK
	PUT	OOPS-TABLE,O-END,STACK
	ZERO?	QUIET \FALSE
	CALL2	PRINT-LEXV,QUIET
	RSTACK	

	.ENDSEG

	.SEGMENT "0"


	.FUNCT	BUFFER-PRINT:ANY:2:4,BEG,END,CP,NOSP,WRD,NW,FIRST??,PN,TMP
	SET	'FIRST??,TRUE-VALUE
?PRG1:	EQUAL?	BEG,END /TRUE
	ZERO?	NOSP \?CTR6
	EQUAL?	NW,W?PERIOD,W?COMMA,W?APOSTROPHE \?CCL7
?CTR6:	SET	'NOSP,FALSE-VALUE
	JUMP	?CND5
?CCL7:	PRINTC	32
?CND5:	GET	BEG,0 >WRD
	ADD	BEG,P-WORDLEN
	EQUAL?	END,STACK \?CCL12
	SET	'NW,0
	JUMP	?CND10
?CCL12:	GET	BEG,P-LEXELEN >NW
?CND10:	EQUAL?	WRD,W?NO.WORD \?CCL15
	SET	'NOSP,TRUE-VALUE
	JUMP	?CND13
?CCL15:	EQUAL?	WRD,W?MY \?CCL17
	PRINTB	W?YOUR
	JUMP	?CND13
?CCL17:	EQUAL?	WRD,W?ME \?CCL19
	PRINTB	W?YOU
	SET	'PN,TRUE-VALUE
	JUMP	?CND13
?CCL19:	EQUAL?	WRD,W?ONE \?CCL21
	PRINTI	"object"
	JUMP	?CND13
?CCL21:	EQUAL?	WRD,FALSE-VALUE,W?ALL,W?PERIOD /?CCL23
	EQUAL?	WRD,W?APOSTROPHE /?CCL23
	GET	WRD,4 >TMP
	ZERO?	TMP \?CCL23
	GET	WRD,3
	ZERO?	STACK \?CCL23
	BTST	TMP,32768 /?PRD32
	BAND	TMP,4
	BAND	STACK,32767
	ZERO?	STACK \?CCL23
?PRD32:	BTST	TMP,32768 /?CTR22
	BAND	TMP,2
	BAND	STACK,32767
	ZERO?	STACK \?CCL23
?CTR22:	SET	'NOSP,TRUE-VALUE
	JUMP	?CND13
?CCL23:	CALL2	CAPITAL-NOUN?,WRD
	ZERO?	STACK /?CCL38
	ICALL2	CAPITALIZE,BEG
	SET	'PN,TRUE-VALUE
	JUMP	?CND13
?CCL38:	ZERO?	FIRST?? /?CND39
	ZERO?	PN \?CND39
	ZERO?	CP /?CND39
	EQUAL?	WRD,W?HER,W?HIM,W?YOUR /?CND39
	PRINTI	"the "
?CND39:	EQUAL?	WRD,W?IT \?CCL48
	CALL2	VISIBLE?,P-IT-OBJECT
	ZERO?	STACK /?CCL48
	PRINTD	P-IT-OBJECT
	JUMP	?CND46
?CCL48:	EQUAL?	WRD,W?THEM \?CCL52
	CALL2	VISIBLE?,P-THEM-OBJECT
	ZERO?	STACK /?CCL52
	PRINTD	P-THEM-OBJECT
	JUMP	?CND46
?CCL52:	EQUAL?	WRD,W?HER \?CCL56
	ZERO?	PN \?CCL56
	PRINTD	P-HER-OBJECT
	JUMP	?CND46
?CCL56:	EQUAL?	WRD,W?HIM \?CCL60
	ZERO?	PN \?CCL60
	PRINTD	P-HIM-OBJECT
	JUMP	?CND46
?CCL60:	EQUAL?	WRD,W?INT.NUM,W?INT.TIM \?CCL64
	GET	BEG,1
	PRINTN	STACK
	JUMP	?CND46
?CCL64:	ICALL2	WORD-PRINT,BEG
?CND46:	SET	'FIRST??,FALSE-VALUE
?CND13:	ADD	BEG,P-WORDLEN >BEG
	JUMP	?PRG1


	.FUNCT	CAPITALIZE:ANY:1:1,PTR,?TMP1
	GETB	PTR,3
	GETB	P-INBUF,STACK
	SUB	STACK,32
	PRINTC	STACK
	GETB	PTR,2
	SUB	STACK,1 >?TMP1
	GETB	PTR,3
	ADD	STACK,1
	CALL	WORD-PRINT,PTR,?TMP1,STACK
	RSTACK	


	.FUNCT	PRINT-PARSER-FAILURE:ANY:0:0,CLASS,OTHER,OTHER2,TMP,PR,N,X,?TMP1
	GET	ERROR-ARGS,1 >CLASS
	GET	ERROR-ARGS,2 >OTHER
	GET	ERROR-ARGS,3 >OTHER2
	EQUAL?	CLASS,PARSER-ERROR-ORPH-S \?CCL3
	GET	ORPHAN-S,O-LEXPTR
	SUB	STACK,P-LEXV
	DIV	STACK,2 >P-OFLAG
	PUT	ORPHAN-SR,1,0
	COPYT	G-LEXV,O-LEXV,LEXV-LENGTH-BYTES
	COPYT	G-INBUF,O-INBUF,61
	GET	OOPS-TABLE,O-START
	PUT	OOPS-TABLE,O-AGAIN,STACK
	ICALL	MAKE-ROOM-FOR-TOKENS,1,O-LEXV,P-OFLAG
	PUT	O-LEXV,P-OFLAG,W?NO.WORD
	PRINTI	"[Wh"
	GET	ORPHAN-S,O-VERB
	EQUAL?	STACK,W?WALK,W?GO,W?RUN \?CCL8
	PRINTI	"ere"
	JUMP	?CND6
?CCL8:	GET	ORPHAN-S,O-WHICH
	EQUAL?	STACK,1 \?CCL13
	GET	ORPHAN-S,O-SYNTAX
	GETB	STACK,4
	JUMP	?CND11
?CCL13:	GET	ORPHAN-S,O-SYNTAX
	GETB	STACK,8
?CND11:	EQUAL?	PERSONBIT,STACK \?CCL10
	PRINTI	"om"
	JUMP	?CND6
?CCL10:	PRINTI	"at"
?CND6:	PRINTC	32
	GET	ORPHAN-S,O-SUBJECT >PR
	ZERO?	PR /?CCL16
	GET	ORPHAN-S,O-VERB >TMP
	ADD	WORD-FLAG-TABLE,2 >?TMP1
	GET	WORD-FLAG-TABLE,0
	INTBL?	TMP,?TMP1,STACK,132 >X \?CCL21
	GET	X,1
	JUMP	?CND19
?CCL21:	PUSH	FALSE-VALUE
?CND19:	BTST	STACK,512 \?CCL16
	PRINTI	"did "
	ICALL2	TELL-THE,PR
	ICALL2	THIS-IS-IT,PR
	PRINTC	32
	JUMP	?CND14
?CCL16:	PRINTI	"do you want "
	EQUAL?	WINNER,PLAYER /?CND22
	PRINTD	WINNER
	PRINTC	32
?CND22:	PRINTI	"to "
?CND14:	GET	ORPHAN-S,O-VERB
	CALL2	ROOT-VERB,STACK
	PRINTB	STACK
	GET	ORPHAN-S,O-PART >TMP
	EQUAL?	TMP,0,1 /?CND24
	PRINTC	32
	PRINTB	TMP
?CND24:	GET	ERROR-ARGS,2 >TMP
	ZERO?	TMP /?CND26
	PRINTC	32
	GET	ORPHAN-S,O-OBJECT >PR
	ZERO?	PR /?CCL30
	ICALL2	TELL-THE,PR
	ICALL2	THIS-IS-IT,PR
	JUMP	?CND28
?CCL30:	ICALL2	NP-PRINT,TMP
?CND28:	GET	ORPHAN-S,O-SYNTAX >TMP
	ZERO?	TMP /?CND26
	GET	ORPHAN-S,O-WHICH
	EQUAL?	STACK,1 \?CCL35
	GET	TMP,1 >TMP
	JUMP	?CND33
?CCL35:	GET	TMP,3 >TMP
?CND33:	ZERO?	TMP /?CND26
	GETB	O-LEXV,P-LEXWORDS >N
	SUB	P-OFLAG,P-LEXELEN
	GET	O-LEXV,STACK >PR
	GET	PR,4
	ZERO?	STACK \?CND38
	GET	PR,3 >PR
?CND38:	EQUAL?	TMP,PR /?CND40
	ICALL	MAKE-ROOM-FOR-TOKENS,1,O-LEXV,P-OFLAG
	INC	'N
	PUT	O-LEXV,P-OFLAG,TMP
	ADD	P-OFLAG,P-LEXELEN >P-OFLAG
?CND40:	PUT	O-LEXV,P-OFLAG,W?NO.WORD
	MUL	P-WORDLEN,N
	ADD	1,STACK
	ICALL	INBUF-PRINT,TMP,O-INBUF,O-LEXV,STACK
	PRINTC	32
	PRINTB	TMP
?CND26:	PRINTR	"?]"
?CCL3:	EQUAL?	CLASS,PARSER-ERROR-ORPH-NP \?CND1
	CALL2	WHICH-PRINT,OTHER
	ZERO?	STACK \TRUE
?CND1:	EQUAL?	CLASS,PARSER-ERROR-NOMULT \?CCL47
	ICALL	CANT-USE-MULTIPLE,OTHER,OTHER2
	RTRUE	
?CCL47:	EQUAL?	CLASS,PARSER-ERROR-NOOBJ \?CCL49
	ICALL	CANT-FIND-OBJECT,OTHER,OTHER2
	RTRUE	
?CCL49:	EQUAL?	CLASS,PARSER-ERROR-TMNOUN \?CCL51
	GET	PARSE-RESULT,1
	ICALL2	TOO-MANY-NOUNS,STACK
	RTRUE	
?CCL51:	GRTR?	P-LEN,0 \?CND52
	SUB	OTLEXV,4 >OTHER2
	CALL2	CHANGE-AND-TO-THEN?,OTHER2
	ZERO?	STACK \?CCL53
	SET	'OTHER2,OTLEXV
	CALL2	CHANGE-AND-TO-THEN?,OTHER2
	ZERO?	STACK /?CND52
?CCL53:	ICALL	CHANGE-LEXV,OTHER2,W?THEN
	GET	OOPS-TABLE,O-LENGTH >P-LEN
	GET	OOPS-TABLE,O-START >TLEXV
	ICALL1	PRINT-LEXV
	CALL2	PARSE-IT,FALSE-VALUE
	RSTACK	
?CND52:	SET	'OTHER2,OTLEXV
	ZERO?	P-LEN \?PRD61
	CALL2	NAKED-ADJECTIVE?,OTHER2
	ZERO?	STACK \?CCL59
?PRD61:	SUB	OTLEXV,4 >OTHER2
	LESS?	P-LEXV,OTHER2 \?CND58
	LESS?	0,P-LEN \?CND58
	CALL2	NAKED-ADJECTIVE?,OTHER2
	ZERO?	STACK /?CND58
	GET	OTLEXV,0
	EQUAL?	STACK,W?COMMA,W?AND /?CCL59
	GET	OTLEXV,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD74
	PUSH	?TMP1
	JUMP	?PEN72
?PRD74:	GET	OTLEXV,0
	GET	STACK,3
	GET	STACK,4
?PEN72:	BAND	STACK,32768
	EQUAL?	STACK,-32768 \?CND58
	GET	OTLEXV,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD77
	PUSH	?TMP1
	JUMP	?PEN75
?PRD77:	GET	OTLEXV,0
	GET	STACK,3
	GET	STACK,4
?PEN75:	BAND	STACK,32776
	BAND	STACK,32767
	ZERO?	STACK /?CND58
?CCL59:	SUB	OTHER2,P-LEXV
	DIV	STACK,2
	ADD	P-LEXELEN,STACK >CLASS
	ICALL	MAKE-ROOM-FOR-TOKENS,1,P-LEXV,CLASS
	ICALL	MAKE-ROOM-FOR-TOKENS,1,G-LEXV,CLASS
	ADD	OTHER2,4
	ICALL	CHANGE-LEXV,STACK,W?ONE
	GETB	P-LEXV,P-LEXWORDS >P-LEN
	GET	OOPS-TABLE,O-START >TLEXV
	CALL2	PARSE-IT,FALSE-VALUE
	RSTACK	
?CND58:	CALL1	DONT-UNDERSTAND
	RSTACK	


	.FUNCT	NAKED-ADJECTIVE?:ANY:1:1,PTR,WD,?TMP1
	GET	PTR,0 >WD
	GET	WD,4 >?TMP1
	ZERO?	?TMP1 /?PRD6
	PUSH	?TMP1
	JUMP	?PEN4
?PRD6:	GET	WD,3
	GET	STACK,4
?PEN4:	BAND	STACK,32768
	ZERO?	STACK \FALSE
	GET	WD,4 >?TMP1
	ZERO?	?TMP1 /?PRD10
	PUSH	?TMP1
	JUMP	?PEN8
?PRD10:	GET	WD,3
	GET	STACK,4
?PEN8:	BAND	STACK,4
	BAND	STACK,32767
	ZERO?	STACK /FALSE
	GET	WD,4 >?TMP1
	ZERO?	?TMP1 /?PRD16
	PUSH	?TMP1
	JUMP	?PEN14
?PRD16:	GET	WD,3
	GET	STACK,4
?PEN14:	BTST	STACK,32768 /?PRD11
	GET	WD,4 >?TMP1
	ZERO?	?TMP1 /?PRD19
	PUSH	?TMP1
	JUMP	?PEN17
?PRD19:	GET	WD,3
	GET	STACK,4
?PEN17:	BAND	STACK,64
	BAND	STACK,32767
	ZERO?	STACK \FALSE
?PRD11:	EQUAL?	WD,W?ONE /FALSE
	RTRUE	


	.FUNCT	CHANGE-AND-TO-THEN?:ANY:1:1,PTR,?TMP1
	GET	PTR,0
	EQUAL?	STACK,W?AND,W?COMMA \FALSE
	ADD	PTR,4 >PTR
	GET	PTR,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD11
	PUSH	?TMP1
	JUMP	?PEN9
?PRD11:	GET	PTR,0
	GET	STACK,3
	GET	STACK,4
?PEN9:	BTST	STACK,32768 /?PRD6
	GET	PTR,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD14
	PUSH	?TMP1
	JUMP	?PEN12
?PRD14:	GET	PTR,0
	GET	STACK,3
	GET	STACK,4
?PEN12:	BAND	STACK,1
	BAND	STACK,32767
	ZERO?	STACK \TRUE
?PRD6:	GET	PTR,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD20
	PUSH	?TMP1
	JUMP	?PEN18
?PRD20:	GET	PTR,0
	GET	STACK,3
	GET	STACK,4
?PEN18:	BTST	STACK,32768 /?PRD15
	GET	PTR,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD23
	PUSH	?TMP1
	JUMP	?PEN21
?PRD23:	GET	PTR,0
	GET	STACK,3
	GET	STACK,4
?PEN21:	BAND	STACK,64
	BAND	STACK,32767
	ZERO?	STACK \TRUE
?PRD15:	GET	PTR,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD29
	PUSH	?TMP1
	JUMP	?PEN27
?PRD29:	GET	PTR,0
	GET	STACK,3
	GET	STACK,4
?PEN27:	BAND	STACK,32768
	EQUAL?	STACK,-32768 \FALSE
	GET	PTR,0
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD33
	PUSH	?TMP1
	JUMP	?PEN31
?PRD33:	GET	PTR,0
	GET	STACK,3
	GET	STACK,4
?PEN31:	BAND	STACK,32776
	BAND	STACK,32767
	ZERO?	STACK /FALSE
	RTRUE	


	.FUNCT	DONT-UNDERSTAND:ANY:0:0,?TMP1
	SET	'CLOCK-WAIT,TRUE-VALUE
	GETB	P-LEXV,P-LEXWORDS
	EQUAL?	1,STACK \?CND1
	GET	P-LEXV,P-LEXSTART
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD11
	PUSH	?TMP1
	JUMP	?PEN9
?PRD11:	GET	P-LEXV,P-LEXSTART
	GET	STACK,3
	GET	STACK,4
?PEN9:	BTST	STACK,32768 /?PRD6
	GET	P-LEXV,P-LEXSTART
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD14
	PUSH	?TMP1
	JUMP	?PEN12
?PRD14:	GET	P-LEXV,P-LEXSTART
	GET	STACK,3
	GET	STACK,4
?PEN12:	BAND	STACK,2
	BAND	STACK,32767
	ZERO?	STACK \?CCL2
?PRD6:	GET	P-LEXV,P-LEXSTART
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD19
	PUSH	?TMP1
	JUMP	?PEN17
?PRD19:	GET	P-LEXV,P-LEXSTART
	GET	STACK,3
	GET	STACK,4
?PEN17:	BTST	STACK,32768 /?CND1
	GET	P-LEXV,P-LEXSTART
	GET	STACK,4 >?TMP1
	ZERO?	?TMP1 /?PRD22
	PUSH	?TMP1
	JUMP	?PEN20
?PRD22:	GET	P-LEXV,P-LEXSTART
	GET	STACK,3
	GET	STACK,4
?PEN20:	BAND	STACK,4
	BAND	STACK,32767
	ZERO?	STACK /?CND1
?CCL2:	ICALL2	MISSING,STR?56
	RTRUE	
?CND1:	PRINTR	"[Sorry, but I don't understand. Please say that another way, or try something else.]"


	.FUNCT	MISSING:ANY:1:1,NV
	PRINTI	"[I think there's a "
	PRINT	NV
	PRINTR	" missing in that sentence!]"


	.FUNCT	CANT-FIND-OBJECT:ANY:2:2,NP,PART,TMP
	GET	NP,3
	ZERO?	STACK \?CCL3
	CALL	NP-CANT-SEE,NP,PART
	RSTACK	
?CCL3:	GET	PARSE-RESULT,1 >TMP
	PRINTI	"[There isn't anything to "
	ZERO?	TMP /?CCL6
	PRINTB	TMP
	EQUAL?	PART,0,1 /?CND4
	PRINTC	32
	PRINTB	PART
	JUMP	?CND4
?CCL6:	PRINTI	"do that to"
?CND4:	PRINTR	"!]"


	.FUNCT	NP-CANT-SEE:ANY:0:2,NP,SYN,TMP
	ASSIGNED?	'NP /?CND1
	CALL1	GET-NP >NP
?CND1:	GET	NP,2 >TMP
	ZERO?	TMP /?CCL5
	PRINTC	91
	ICALL2	TELL-CTHE,WINNER
	ICALL2	THIS-IS-IT,WINNER
	PRINTC	32
	BTST	SYN,64 \?CCL8
	BTST	SYN,128 /?CCL8
	EQUAL?	WINNER,PLAYER,ME \?CCL13
	PRINTI	"don't"
	JUMP	?CND11
?CCL13:	PRINTI	"doesn't"
?CND11:	PRINTI	" have"
	JUMP	?CND6
?CCL8:	PRINTI	"can't see"
?CND6:	PRINTC	32
	CALL2	CAPITAL-NOUN?,TMP
	ZERO?	STACK \?CTR15
	GET	NP,1 >TMP
	ZERO?	TMP /?CCL16
	GET	TMP,2
	ZERO?	STACK /?CCL16
?CTR15:	ICALL	NP-PRINT,NP,TRUE-VALUE
	JUMP	?CND14
?CCL16:	PRINTI	"any "
	ICALL2	NP-PRINT,NP
?CND14:	PRINTC	32
	GET	NP,5 >TMP
	ZERO?	TMP /?CCL23
	GETB	TMP,1
	EQUAL?	STACK,4 \?PRD27
	PRINTI	"in"
	JUMP	?CTR22
?PRD27:	GETB	TMP,1
	EQUAL?	STACK,6 \?CCL23
	GET	TMP,2 >TMP
	ZERO?	TMP /?CCL23
	GET	TMP,1
	PRINTB	STACK
?CTR22:	PRINTC	32
	GET	TMP,3
	ICALL2	TELL-THE,STACK
	GET	TMP,3
	ICALL2	THIS-IS-IT,STACK
	JUMP	?CND21
?CCL23:	PRINTI	"right "
	PRINTI	"here"
?CND21:	PRINTR	".]"
?CCL5:	CALL1	MORE-SPECIFIC
	RSTACK	


	.FUNCT	WINNER-SAYS-WHICH?:ANY:1:1,NP
	RFALSE	


	.FUNCT	WHICH-LIST?:ANY:2:2,NP,SR,CT
	GET	SR,1 >CT
	GET	SR,0
	GRTR?	CT,STACK /FALSE
	EQUAL?	CT,1 \TRUE
	GET	ORPHAN-SR+8,0
	EQUAL?	STACK,PSEUDO-OBJECT \TRUE
	RFALSE	


	.FUNCT	WHICH-PRINT:ANY:0:1,NP,PTR,NOUN,LEN,SZ,REM,VEC
	ASSIGNED?	'NP /?CND1
	CALL1	GET-NP >NP
?CND1:	GET	NP,8 >PTR
	GET	NP,2 >NOUN
?PRG3:	GET	PTR,0
	EQUAL?	NOUN,STACK \?CCL7
	SUB	PTR,P-LEXV
	DIV	STACK,2 >P-OFLAG
	COPYT	G-LEXV,O-LEXV,LEXV-LENGTH-BYTES
	COPYT	G-INBUF,O-INBUF,61
	GET	OOPS-TABLE,O-START
	PUT	OOPS-TABLE,O-AGAIN,STACK
	SET	'NOUN,ORPHAN-SR
	SET	'PTR,FALSE-VALUE
	GET	NOUN,1 >LEN
	GET	NOUN,0 >SZ
	EQUAL?	WINNER,PLAYER /?CCL13
	CALL2	WINNER-SAYS-WHICH?,NP >PTR
	ZERO?	PTR \?CCL13
	PRINTI	"""I don't understand "
	CALL	WHICH-LIST?,NP,NOUN
	ZERO?	STACK /?CCL18
	PRINTI	"if"
	JUMP	?CND11
?CCL7:	SUB	PTR,4 >PTR
	GRTR?	P-LEXV,PTR \?PRG3
	RFALSE	
?CCL18:	PRINTI	"which"
	ZERO?	NP /?CND11
	PRINTC	32
	ICALL2	NP-PRINT,NP
	JUMP	?CND11
?CCL13:	EQUAL?	PTR,TRUE-VALUE /TRUE
	PRINTI	"[Which"
	ZERO?	NP /?CND23
	PRINTC	32
	ICALL2	NP-PRINT,NP
?CND23:	PRINTI	" do"
?CND11:	PRINTI	" you mean"
	CALL	WHICH-LIST?,NP,NOUN
	ZERO?	STACK /?CND25
	ZERO?	PTR \?CCL28
	EQUAL?	WINNER,PLAYER \?CND27
?CCL28:	PRINTC	44
?CND27:	SET	'REM,LEN
	ADD	NOUN,8 >VEC
?PRG31:	PRINTC	32
	GET	VEC,0
	ICALL2	TELL-THE,STACK
	EQUAL?	REM,2 \?CCL35
	EQUAL?	LEN,2 /?CND36
	PRINTC	44
?CND36:	PRINTI	" or"
	JUMP	?CND33
?CCL35:	GRTR?	REM,2 \?CND33
	PRINTC	44
?CND33:	DLESS?	'REM,1 /?CND25
	DLESS?	'SZ,1 /?CND25
	ADD	VEC,2 >VEC
	JUMP	?PRG31
?CND25:	EQUAL?	WINNER,PLAYER /?CCL47
	ZERO?	PTR \?CCL47
	PRINTR	"."""
?CCL47:	PRINTR	"?]"


	.FUNCT	NP-PRINT:ANY:1:2,NP,DO-QUANT,LEN,OBJ,CT,?TMP1
	LESS?	0,NP \?CCL3
	GRTR?	NP,LAST-OBJECT /?CCL3
	CALL2	TELL-THE,NP
	RSTACK	
?CCL3:	GETB	NP,1
	EQUAL?	STACK,3 \?CCL7
?PRG8:	GET	NP,2 >LEN
	ZERO?	LEN /?CND10
	ICALL2	NP-PRINT,LEN
?CND10:	GET	NP,1 >NP
	ZERO?	NP /TRUE
	PRINTI	" and "
	JUMP	?PRG8
?CCL7:	GETB	NP,1
	EQUAL?	STACK,4 \?CCL16
	GET	NP,1 >LEN
	ZERO?	LEN /FALSE
	DEC	'LEN
?PRG20:	MUL	CT,2
	ADD	NOUN-PHRASE-HEADER-LEN,STACK
	GET	NP,STACK >OBJ
	ZERO?	OBJ /?CND22
	ICALL2	TELL-THE,OBJ
?CND22:	IGRTR?	'CT,LEN /TRUE
	PRINTI	", "
	JUMP	?PRG20
?CCL16:	ZERO?	DO-QUANT /?CND27
	GET	NP,3 >LEN
	ZERO?	LEN /?CND27
	CALL2	GET-QUANTITY-WORD,LEN
	PRINTB	STACK
	GET	NP,2
	ZERO?	STACK /?CND27
	PRINTC	32
?CND27:	GET	NP,1 >LEN
	ZERO?	LEN /?CND33
	ICALL2	ADJS-PRINT,LEN
?CND33:	GET	NP,8 >LEN
	ZERO?	LEN /?CCL37
	GET	LEN,0 >?TMP1
	GET	NP,2
	EQUAL?	?TMP1,STACK /?CTR36
	GET	LEN,0
	GET	STACK,4
	BAND	STACK,32768
	EQUAL?	STACK,-32768 \?CCL37
	GET	LEN,0
	GET	STACK,4
	BAND	STACK,32776
	BAND	STACK,32767
	ZERO?	STACK /?CCL37
	SUB	LEN,4 >LEN
	LESS?	P-LEXV,LEN \?CCL37
	GET	LEN,0 >?TMP1
	GET	NP,2
	EQUAL?	?TMP1,STACK \?CCL37
?CTR36:	ADD	LEN,P-WORDLEN
	ICALL	BUFFER-PRINT,LEN,STACK,FALSE-VALUE,TRUE-VALUE
	JUMP	?CND35
?CCL37:	GET	NP,2 >LEN
	ZERO?	LEN /?CND35
	PRINTB	LEN
?CND35:	GET	NP,4 >LEN
	ZERO?	LEN /?CND47
	CALL2	PMEM?,LEN
	ZERO?	STACK /?CND47
	GETB	LEN,1
	EQUAL?	STACK,2 \?CND47
	PRINTI	" of "
	ICALL2	NP-PRINT,LEN
?CND47:	GET	NP,6 >LEN
	ZERO?	LEN /FALSE
	CALL2	PMEM?,LEN
	ZERO?	STACK /FALSE
	GETB	LEN,1
	EQUAL?	STACK,2 \FALSE
	PRINTI	" except "
	CALL2	NP-PRINT,LEN
	RSTACK	


	.FUNCT	ADJS-PRINT:ANY:1:1,ADJT,LEN,WD,CT,TMP
	GET	ADJT,2 >LEN
	ZERO?	LEN /?CND1
	EQUAL?	LEN,PLAYER,ME \?CCL5
	PRINTI	"your "
	JUMP	?CND1
?CCL5:	ICALL2	NP-PRINT,LEN
	PRINTI	"'s "
?CND1:	GET	ADJT,4 >LEN
	ZERO?	LEN /FALSE
	ADD	ADJT,10 >ADJT
	GRTR?	LEN,ADJS-MAX-COUNT \?CND9
	SET	'LEN,ADJS-MAX-COUNT
?CND9:	DEC	'LEN
	MUL	2,LEN
	ADD	ADJT,STACK >ADJT
?PRG11:	GET	ADJT,0 >WD
	ZERO?	WD /?CND13
	EQUAL?	WD,W?MY \?CCL17
	PRINTI	"your "
	JUMP	?CND13
?CCL17:	EQUAL?	WD,W?INT.NUM,W?INT.TIM \?CCL19
	PRINTN	P-NUMBER
	PRINTC	32
	JUMP	?CND13
?CCL19:	EQUAL?	WD,W?NO.WORD /?CND13
	CALL2	CAPITAL-NOUN?,WD
	ZERO?	STACK /?CCL23
	GETB	P-LEXV,P-LEXWORDS >TMP
	ZERO?	TMP /?CCL23
	INTBL?	WD,P-LEXV+2,TMP,132 >TMP \?CCL23
	ICALL2	CAPITALIZE,TMP
	JUMP	?CND21
?CCL23:	PRINTB	WD
?CND21:	PRINTC	32
?CND13:	IGRTR?	'CT,LEN /TRUE
	SUB	ADJT,2 >ADJT
	JUMP	?PRG11


	.FUNCT	TOO-MANY-NOUNS:ANY:1:1,WD
	PRINTI	"[I can't understand that many nouns with "
	ZERO?	WD /?CCL3
	PRINTC	34
	PRINTB	WD
	PRINTC	34
	JUMP	?CND1
?CCL3:	PRINTI	"that verb"
?CND1:	PRINTR	".]"


	.FUNCT	INBUF-ADD:ANY:3:3,LEN,BEG,SLOT,DBEG,TMP,?TMP1
	GET	OOPS-TABLE,O-END >TMP
	ZERO?	TMP /?CCL3
	SET	'DBEG,TMP
	JUMP	?CND1
?CCL3:	GET	OOPS-TABLE,O-LENGTH
	MUL	P-WORDLEN,STACK >TMP
	GETB	G-LEXV,TMP >?TMP1
	ADD	TMP,1
	GETB	G-LEXV,STACK
	ADD	?TMP1,STACK >DBEG
?CND1:	SUB	LEN,1
	ADD	DBEG,STACK
	LESS?	INBUF-LENGTH,STACK /FALSE
	ADD	DBEG,LEN
	PUT	OOPS-TABLE,O-END,STACK
	ADD	P-INBUF,BEG >?TMP1
	ADD	G-INBUF,DBEG
	COPYT	?TMP1,STACK,LEN
	PUTB	G-LEXV,SLOT,DBEG
	SUB	SLOT,1
	PUTB	G-LEXV,STACK,LEN
	RTRUE	


	.FUNCT	INBUF-PRINT:ANY:4:4,WD,INBUF,LEXV,SLOT,DBEG,CTR,TMP,LEN,?TMP1
	SET	'LEN,11
	GET	OOPS-TABLE,O-END >TMP
	ZERO?	TMP /?CCL3
	SET	'DBEG,TMP
	JUMP	?CND1
?CCL3:	GET	OOPS-TABLE,O-LENGTH
	MUL	P-WORDLEN,STACK >TMP
	GETB	LEXV,TMP >?TMP1
	ADD	TMP,1
	GETB	LEXV,STACK
	ADD	?TMP1,STACK >DBEG
?CND1:	GETB	INBUF,0 >?TMP1
	SUB	LEN,1
	ADD	DBEG,STACK
	LESS?	?TMP1,STACK /FALSE
	ADD	INBUF,DBEG
	DIROUT	D-TABLE-ON,STACK
	PRINTB	WD
	DIROUT	D-TABLE-OFF
	ADD	1,DBEG
	GETB	INBUF,STACK >LEN
	ADD	2,DBEG >DBEG
	ADD	DBEG,LEN
	PUT	OOPS-TABLE,O-END,STACK
	PUTB	LEXV,SLOT,DBEG
	SUB	SLOT,1
	PUTB	LEXV,STACK,LEN
	RTRUE	


	.FUNCT	YES?:ANY:0:1,NO-Q,WORD,VAL
	ZERO?	NO-Q \?PRG3
	PRINTC	63
?PRG3:	PRINTI	"
>"
	PUTB	YES-INBUF,1,0
	READ	YES-INBUF,YES-LEXV
	GETB	YES-LEXV,P-LEXWORDS
	ZERO?	STACK /?CND6
	GET	YES-LEXV,P-LEXSTART >WORD
	ZERO?	WORD /?CND6
	GET	WORD,4
	BTST	STACK,32768 /?CCL12
	GET	WORD,4
	BAND	STACK,1
	BAND	STACK,32767
	ZERO?	STACK /?CCL12
	GET	WORD,3 >VAL
	JUMP	?CND10
?CCL12:	SET	'VAL,FALSE-VALUE
?CND10:	EQUAL?	VAL,ACT?YES \?CCL17
	SET	'VAL,TRUE-VALUE
	RETURN	VAL
?CCL17:	EQUAL?	VAL,ACT?NO /?CTR18
	EQUAL?	WORD,W?N \?CCL19
?CTR18:	SET	'VAL,FALSE-VALUE
	RETURN	VAL
?CCL19:	EQUAL?	VAL,ACT?RESTART \?CCL23
	ICALL1	V-RESTART
	JUMP	?CND6
?CCL23:	EQUAL?	VAL,ACT?RESTORE \?CCL25
	ICALL1	V-RESTORE
	JUMP	?CND6
?CCL25:	EQUAL?	VAL,ACT?QUIT \?CND6
	ICALL1	V-QUIT
?CND6:	PRINTI	"[Please type YES or NO.]"
	JUMP	?PRG3


	.FUNCT	SETUP-ORPHAN-NP:ANY:3:4,STR,OBJ1,OBJ2,OBJ3,NUM,VEC
	DIROUT	D-TABLE-ON,O-INBUF
	PRINT	STR
	DIROUT	D-TABLE-OFF
	PUTB	O-INBUF,0,INBUF-LENGTH
	LEX	O-INBUF,O-LEXV
	GETB	O-LEXV,P-LEXWORDS >NUM
	ZERO?	NUM /FALSE
	INTBL?	0,O-LEXV+2,NUM,132 /FALSE
	GETB	O-LEXV,P-LEXWORDS
	MUL	P-LEXELEN,STACK
	SUB	1,STACK >P-OFLAG
	PUT	OOPS-TABLE,O-AGAIN,P-LEXV+2
	SET	'VEC,ORPHAN-SR+8
	PUT	VEC,0,OBJ1
	PUT	VEC,1,OBJ2
	SET	'NUM,2
	ZERO?	OBJ3 /?CND6
	INC	'NUM
	PUT	VEC,2,OBJ3
?CND6:	PUT	ORPHAN-SR,1,NUM
	RTRUE	


	.FUNCT	INSERT-ADJS:ANY:1:1,E,CT,PTR,WD
	LESS?	P-OFLAG,0 \?CCL3
	SUB	0,P-OFLAG >PTR
	JUMP	?CND1
?CCL3:	SET	'PTR,P-OFLAG
?CND1:	EQUAL?	E,FALSE-VALUE,TRUE-VALUE /FALSE
	GET	E,2 >CT
	ZERO?	CT /?CND7
	CALL2	PMEM?,CT
	ZERO?	STACK /?CCL11
	GET	CT,2 >CT
	JUMP	?CND9
?CCL11:	EQUAL?	CT,PLAYER \?CCL13
	SET	'CT,W?MY
	JUMP	?CND9
?CCL13:	GETPT	CT,P?SYNONYM
	GET	STACK,0 >CT
?CND9:	EQUAL?	CT,W?MY \?CCL16
	CALL	INSERT-ADJS-WD,PTR,CT >PTR
	JUMP	?CND7
?CCL16:	CALL	INSERT-ADJS-WD,PTR,CT >PTR
	CALL	INSERT-ADJS-WD,PTR,W?APOSTROPHE >PTR
	CALL	INSERT-ADJS-WD,PTR,W?S >PTR
?CND7:	GET	E,4 >CT
	ZERO?	CT /FALSE
	ADD	E,10 >E
?PRG20:	DLESS?	'CT,0 /TRUE
	GET	E,CT >WD
	GET	ERROR-ARGS,3
	EQUAL?	WD,STACK /?PRG20
	CALL	INSERT-ADJS-WD,PTR,WD >PTR
	JUMP	?PRG20


	.FUNCT	INSERT-ADJS-WD:ANY:2:2,PTR,WD
	ICALL	MAKE-ROOM-FOR-TOKENS,1,G-LEXV,PTR
	PUT	G-LEXV,PTR,WD
	ADD	PTR,P-LEXELEN >PTR
	MUL	2,PTR
	SUB	STACK,1
	ICALL	INBUF-PRINT,WD,G-INBUF,G-LEXV,STACK
	RETURN	PTR

	.ENDSEG

	.ENDI
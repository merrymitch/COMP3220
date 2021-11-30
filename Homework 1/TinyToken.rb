#
#  Class Token - Encapsulates the tokens in TINY
#
#   @type - the type of token (Category)
#   @text - the text the token represents (Lexeme)
#
class Token
	attr_accessor :type
	attr_accessor :text

# This is the only part of this class that you need to 
# modify.
	EOF = "eof"
	LPAREN = "("
	RPAREN = ")"
	ADDOP  = "+"
	WS = "whitespace"
# add the rest of the tokens needed based on the grammar
# specified in the Scanner class "TinyScanner.rb"
    SUBOP = "-"
    MULTIOP = "*"
    DIVIOP = "/"
    EQUALOP = "="
    PRINT = "print"
    CHARACTERS = "characters"
    DIGIT = "digit"
#constructor
	def initialize(type,text)
		@type = type
		@text = text
	end
	
	def get_type
		return @type
	end
	
	def get_text
		return @text
	end
	
# to string method
	def to_s
		return "#{@type} #{@text}"
	end
end
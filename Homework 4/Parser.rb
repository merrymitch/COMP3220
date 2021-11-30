# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# EPSILON    -->   ""
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Lexer.rb"
class Parser < Scanner

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
			@errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		
		p = AST.new(Token.new("program","program"))
		
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
      
		return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        tm = term()
        if (@lookahead.type == Token::SUBOP or @lookahead.type == Token::ADDOP)
            etl = etail()
            etl.addChild(tm)
            return etl
        else
            return tm
        end
    end

    def term()
        factor = factor()
        if (@lookahead.type == Token::DIVOP or @lookahead.type == Token::MULTOP)
            ttl = ttail()
            ttl.addChild(factor)
            return ttl
        else
            return factor
        end
    end

    def factor()
        fct = AST.new(Token.new("factor", "factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            fct = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
				match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
            fct = AST.new(@lookahead)
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            fct = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
		return fct
    end

    def ttail()
        tl = AST.new(Token.new("ttail", "ttail"))
        if (@lookahead.type == Token::MULTOP)
            tl = AST.new(@lookahead)
            match(Token::MULTOP)
            tl.addChild(factor())
            tl2 = ttail()
            if (tl2 != nil)
                tl.addChild(tl2)
            end
        elsif (@lookahead.type == Token::DIVOP)
            tl = AST.new(@lookahead)
            match(Token::DIVOP)
            tl.addChild(factor())
            tl2 = ttail()
            if (tl2 != nil)
                tl.addChild(tl2)
            end
		else
			return nil
        end
        return tl
    end

    def etail()
        et = AST.new(Token.new("etail", "etail"))
        if (@lookahead.type == Token::ADDOP)
            et = AST.new(@lookahead)
            match(Token::ADDOP)
            et.addChild(term())
            et2 = etail()
            if (et2 != nil)
                et.addChild(et2)
            end
        elsif (@lookahead.type == Token::SUBOP)
            et = AST.new(@lookahead)
            match(Token::SUBOP)
            et.addChild(term())
            et2 = etail()
            if (et2 != nil)
                et.addChild(et2)
            end
		else
			return nil
        end
        return et
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end

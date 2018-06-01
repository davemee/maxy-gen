class Tokenizer
  TOKEN_TYPES = [
      [:escaped_identifier, /(\\[\S]+)(?=[-+{}])/],
      [:identifier, /([^-+{}()\\]+)(?=[-+{}])?/],
      [:dash, /(-)/]
  ]

  def initialize(pattern)
    @pattern = pattern
  end

  def tokenize
    tokens = []
    until @pattern.empty?
      tokens << tokenize_one_token
    end
    tokens
  end

  def tokenize_one_token
    TOKEN_TYPES.each do |type, re|
      re = /\A#{re}/
      if @pattern =~ re
        value = $1
        @pattern = @pattern[value.length..-1]
        puts @pattern
        return Token.new(type, value)
      end
    end

    raise RuntimeError.new "Couldn't match token on #{@pattern.inspect}"
  end
end

Token = Struct.new(:type, :value)
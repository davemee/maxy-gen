require "spec_helper"

include Maxy::Gen

RSpec.describe Tokenizer do
  it 'should tokenize a simple input string of type a-b-c' do
    tokens = Tokenizer.new('cycle~-*~-dac~').tokenize
    expect(tokens.map(&:type)).to eq([:identifier, :dash, :identifier, :dash, :identifier])
    expect(tokens.map(&:value)).to eq(%w(cycle~ - *~ - dac~))
  end

  it 'should tokenize an escaped identifier' do
    tokens = Tokenizer.new('sig~-\-~-cycle~').tokenize
    expect(tokens.map(&:type)).to eq([:identifier, :dash, :escaped_identifier, :dash, :identifier])
  end

  it 'should tokenize an escaped identifier at the end of the chain' do
    tokens = Tokenizer.new('sig~-\-~').tokenize
    expect(tokens.map(&:type)).to eq([:identifier, :dash, :escaped_identifier])
    expect(tokens.map(&:value)).to eq(%w(sig~ - \-~))
  end

  it 'should tokenize arguments' do
    tokens = Tokenizer.new('cycle~{440.}-\*~-dac~').tokenize
    expect(tokens.map(&:type)).to eq([:identifier, :arguments, :dash, :escaped_identifier, :dash, :identifier])
    expect(tokens.map(&:value)).to eq(%w(cycle~ {440.} - \*~ - dac~))
  end

  it 'should tokenize arguments after an escaped identifier' do
    tokens = Tokenizer.new('sig~-\*~{0.1}').tokenize
    expect(tokens.map(&:type)).to eq([:identifier, :dash, :escaped_identifier, :arguments])
    expect(tokens.map(&:value)).to eq(%w(sig~ - \*~ {0.1}))
  end

  it 'should tokenize a plus path split' do
    tokens = Tokenizer.new('loadbang-int{5}+int{7}').tokenize
    expect(tokens.map(&:type)).to eq([:identifier, :dash, :identifier, :arguments, :plus, :identifier, :arguments])
    expect(tokens.map(&:value)).to eq(%w(loadbang - int {5} + int {7}))
  end

  it 'should tokenize open and closed parens' do
    tokens = Tokenizer.new('inlet-(\*-outlet)+(trigger-outlet)').tokenize
    expect(tokens.map(&:type)).to eq([:identifier, :dash, :oparen, :escaped_identifier, :dash, :identifier, :cparen, :plus, :oparen, :identifier, :dash, :identifier, :cparen])
    expect(tokens.map(&:value)).to eq(%w(inlet - ( \* - outlet ) + ( trigger - outlet )))
  end
end
require "set"
require "benchmark"

class WordChainer
  ALPHABET = ("a".."z").to_a

  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp).to_set
  end

  def adjacent_words(word)
    adjacent_words = []
    (0...word.length).each do |dif_idx|
      ALPHABET.each do |letter|
        next if letter == word[dif_idx]
        dup_word = word.dup
        dup_word[dif_idx] = letter
        adjacent_words << dup_word if @dictionary.include?(dup_word)
      end
    end
    adjacent_words
  end

  def get_words
    puts "Base word:"
    base = gets.chomp
    puts "Target word:"
    target = gets.chomp
    [base, target]
  end

  def run
    base, target = get_words
    @current_words = [base]
    @all_seen_words = {base => nil}

    until @current_words.empty?
      @current_words = explore_current_words(target)
    end

    path = build_path(target)
    render(path)
  end

  def render(path)
    if path.length == 1
      puts "No possible path!"
    else
      p path.reverse
    end
  end

  def explore_current_words(target)
    new_current_words = {}
    @current_words.each do |word|
      adjacent_words(word).each do |adj_word|
        next if @all_seen_words.keys.include?(adj_word)
        @all_seen_words[adj_word] = word
        new_current_words[adj_word] = word
        return new_current_words if adj_word == target
      end
    end
    new_current_words.keys
  end

  def build_path(target)
    return [] if target.nil?
    path = [target]
    path << build_path(@all_seen_words[target])
    path.flatten
  end
end

if __FILE__ == $PROGRAM_NAME
  w = WordChainer.new('dictionary.txt')
  w.run
end

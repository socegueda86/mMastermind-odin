class Game
  COLORS = ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"]

  def initialize()
    @code = COLORS.map { |element| element[0] }.sample(4)
    @tries = []
    @win = false
  end

  def play
    loop do
      user_guess_method
      print_board(@tries)
      break if @win == true || @tries.length >= 12
    end
  end

  def user_guess_method
    user_guess = []
    user_guess << get_users_input
    user_guess << correct_matches(user_guess[0],@code)
    @tries << user_guess
  end

  def get_users_input
    while true
      puts "\nInput your selection by indicating the initial letter of the color separated by a dash. i.e.:\n\n'Red-Blue-Yellow-Green' would be --> 'R-B-Y-G'\n\n"
      user_input = gets.chomp.upcase
      user_input = user_input.split("-") 
      break if validate_user_input(user_input) 
    end
    user_input
  end

  def validate_user_input(user_input)
    compare = initials
    unless user_input.length != 4
      # next line uses .include to check if the initial of the each color is in COLORS initials,
      # Then its cheks if all comply with this condition (that the 4 values are valid values).
      if user_input.map { |color| compare.include?(color) }.all? { |value| value == true }
      return true
      end
    end
    false
  end

  def initials
    COLORS.map { |element| element[0] }.join
  end

  def correct_color_counter(user_input, code)
    counter = 0
    user_input.uniq.each do |i|
      counter += code.select { |j| j == i }.count
    end
    counter
  end

  def correct_match_counter(user_input, code)
    counter = 0
    user_input.each_with_index do |element, index|
      counter += 1 if element == code[index]
    end
    winner if counter == 4
    counter
  end

  def correct_matches(user_input,code) 
    [correct_match_counter(user_input, code), correct_color_counter(user_input, code)]
  end

  def print_board(tries)
    tries.each_with_index do |try, index|
      puts "#{double_digit_index(index)}|#{try[0][0]}|#{try[0][1]}|#{try[0][2]}|#{try[0][3]}| #{print_x_o(try[1])}"
    end
  end

  def double_digit_index(index)
    if index < 9
      "#{index + 1}. "
    else
      "#{index + 1}. "
    end
  end

  def print_x_o(x_o_array)
    return_value = ''
    x_o_array[0].times do
      return_value += 'x'
    end
    return_value += ' '
    (x_o_array[1] - x_o_array[0]).times do
      return_value += 'o'
    end
    return_value
  end

  def winner
    @win = true
    puts "\n\n ##### Congrats You,ve won! #####"
  end
end


a = Game.new
a.play

Class Player < Game

Class Human < Player 

Class Computer < Player 
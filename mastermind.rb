class Game
  COLORS = ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"]
  attr_accessor :tries, :win, :codemaker

  def initialize
    @codemaker =  computer_or_user == 1 ? ComputerCodeMaker.new(self) : HumanCodeMaker.new(self)
    @code = @codemaker.code     ## I'll change this to get it direct from Player Class
    @tries = []
    @win = false
  end

  def computer_or_user
    answer = 0
    loop do
      puts "Indicate who  will be the codemaker"
      puts "Press 1 for Computer"
      puts "Press 2 for User"
      puts "Press CTRL + C to exit"
      answer = gets.to_i
      break if answer == 1 || answer == 2
      puts "Invalid option"
    end
    answer
  end

  def play
    
    loop do
      @codemaker.guess
      print_board(@tries)
      puts "#############################################"
      break if @win == true || @tries.length >= 12
    end
  end

  def correct_color_counter(user_input, code)
    counter = 0
    user_input.uniq.each do |element|
      if code.any? { |element2| element2 == element}
        counter += [user_input.select{ |i| i == element}.count, code.select { |i| i == element}.count].min
      end
    end
      counter
  end

  def correct_match_counter(user_input, code)
    counter = 0
    user_input.each_with_index do |element, index|
      counter += 1 if element == code[index]
    end
    @codemaker.winner if counter == 4
    counter
  end

  def correct_matches(user_input)
    [correct_match_counter(user_input, @code), correct_color_counter(user_input, @code) - correct_match_counter(user_input, @code)]
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
      "#{index + 1}."
    end
  end

  def print_x_o(x_o_array)
    return_value = ''
    x_o_array[0].times do
      return_value += 'x'
    end
    return_value += ' '
    (x_o_array[1]).times do
      return_value += 'o'
    end
    return_value
  end
end

class ComputerCodeMaker < Game
  attr_reader :code, :guess
  def initialize(game)
    @game = game
    @code = 4.times.map{ COLORS.map { |element| element[0] }.sample}     
  end

  def guess  ##user
    user_guess = []
    user_guess << get_input
    user_guess << @game.correct_matches(user_guess[0])
    @game.tries << user_guess
  end
  
  def get_input  ####user
    while true
      puts "\nInput your selection by indicating the initial letter of the color separated by a dash. i.e.:\n\n'Red-Blue-Yellow-Green' would be --> 'R-B-Y-G'\n\n"
      user_input = gets.chomp.upcase
      user_input = user_input.split("-") 
      break if validate_input(user_input) 
    end
    user_input
  end
  
  def validate_input(user_input)  ##user
    compare = COLORS.map { |element| element[0] }.join
    unless user_input.length != 4
      # next line uses .include to check if the initial of the each color is in COLORS initials,
      # Then its cheks if all comply with this condition (that the 4 values are valid values).
      if user_input.map { |color| compare.include?(color) }.all? { |value| value == true }
      return true
      end
    end
    false
  end 

  def winner
    puts "\n\n ##### Congrats You,ve won! #####\n" if @game.win == false
    @game.win = true
    
  end
end


class HumanCodeMaker < Game 

  attr_reader :code, :guess
  def initialize(game)
    @game = game
    @code = get_code_from_user
    @positional_hash_of_arrays = {}
  end

  def guess
    computer_guess = []
    computer_guess << get_computers_input
    computer_guess << @game.correct_matches(computer_guess[0])
    if sum_of_x_in_repeated_intials_attemps(@positional_hash_of_arrays) < 4
      positional_hash_creator(computer_guess)  
    end
    @game.tries << computer_guess
  end
   
  def get_code_from_user
    user_input = nil
    loop do
      puts "\n\nInput the color code using the intial of the colors separated by a dash"
      puts "The available colors are 'Red, Blue, Yellow, Green, Purple, Orange'."
      puts "i.e. If you want your color to be 'Red Blue Yellow Green' then you should"
      puts "input the secuence as follows: R-B-Y-G"
      puts "Input your code: "
      user_input = gets.chomp.upcase
      user_input = user_input.split("-") 
      break if validate_input(user_input) 
      puts "Invalid input, please try again or press CTRL + C to exit.\n\n"
    end
    user_input
  end
  
  def validate_input(user_input)  ##user
    compare = COLORS.map { |element| element[0] }.join
    unless user_input.length != 4
      # next line uses .include to check if the initial of the each color is in COLORS initials,
      # Then its cheks if all comply with this condition (that the 4 values are valid values).
      if user_input.map { |color| compare.include?(color) }.all? { |value| value == true }
        return true
      end
    end
    false
  end 

  def winner
    puts "\n\n ##### Computer won! #####\n" if @game.win == false
    @game.win = true
  end

  def get_computers_input
    if @game.tries.count < 5 && sum_of_x_in_repeated_intials_attemps(@positional_hash_of_arrays) < 4
      p sum_of_x_in_repeated_intials_attemps(@positional_hash_of_arrays) 
      return only_initials_input
    end
    COLORS.map{ |color| color[0] }.sample(4)  ##### easy mode
  end  
 
  def only_initials_input
    returned_array = []
    4.times do
      returned_array.push(initials(@game.tries.count))
    end
    returned_array
  end

  def initials(index)
    COLORS[index][0]
  end

  def positional_hash_creator (computer_guess)  ##debug
    #the next 'unless' is to assure the array only consist of values that are present in the code
    unless @game.tries.count > 4 ### when tries.count == 4 we are on the 5th play
      unless computer_guess[1][0] == 0
        @positional_hash_of_arrays[computer_guess[0][0]] = [[1,2,3,4],[computer_guess[1][0]]]
      end
      return
    end
    @positional_hash_of_arrays[COLORS[-1][0]] = [[1,2,3,4], [4 - sum_of_x_in_repeated_intials_attemps(@positional_hash_of_arrays)]] 
  end
  

  def sum_of_x_in_repeated_intials_attemps(positional_hash_of_arrays)
    positional_hash_of_arrays.reduce(0) do |sum, value|
      sum += value[1][1][0]
      sum
     end
  end
end



a = Game.new

a.play



  
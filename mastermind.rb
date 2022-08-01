class Game
  COLORS = ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"]
  

  def initialize()
    @code = COLORS.map {|element| element[0]}.shuffle[0..3]
    @tries = []
    @win = false
  end

  def play; 
  #rules method one time
  #codemaker play one time (alredy on @code)
   #kernel loop 
     #user guess Fx (alredy on get_users_input)
     #analize
     # @tries << 
     #win?
     #print board
   #end of loopus
  
  end
  

def user_guess_method
  user_guess = []
  user_guess << get_users_input
  user_guess << correct_matches(user_guess[0],@code)
  @tries << user_guess
end


def get_users_input
  while true do
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
    #next line uses .include to check if the initial of the each color is in COLORS initials,
    #Then its cheks if all comply with this condition (that the 4 values are valid values).
    if user_input.map { |color| compare.include?(color) }.all? { |value| value == true }
    return true
    end  
  end
  false
end

def initials
  COLORS.map {|element| element[0]}.join
end

def correct_color_counter(user_input, code)
  counter = 0 
  user_input.each do |i|
    counter += code.select { |j| j == i}.count
  end
  counter
end

def correct_match_counter(user_input, code)
  counter = 0
  user_input.each_with_index do |element, index|
     counter+=1 if element == code[index]
  end
  counter
end

def correct_matches(user_input,code) 
  [correct_match_counter(user_input, code), correct_color_counter(user_input, code)]
end
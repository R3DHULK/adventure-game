class AdventureGame
  def initialize
    @player = { name: "", health: 100, inventory: [] }
    @current_room = 0
    @rooms = [
      {
        name: "Forest",
        description: "You are standing in a dark forest. There is a path to your left and right.",
        paths: [1, 2],
        items: [:stick]
      },
      {
        name: "River",
        description: "You see a wide river flowing swiftly. There is a boat on the shore.",
        paths: [0, 3],
        items: [:boat]
      },
      {
        name: "Cave",
        description: "You enter a cave. It's pitch black.",
        paths: [0, 4],
        items: [:torch]
      },
      {
        name: "Bridge",
        description: "You are on a rickety bridge over a deep ravine.",
        paths: [1, 5],
        items: []
      },
      {
        name: "Dark Tunnel",
        description: "You are in a dark tunnel. You can barely see anything.",
        paths: [2, 6],
        items: []
      },
      {
        name: "Mountain",
        description: "You climb to the top of the mountain. The view is spectacular.",
        paths: [3, 7],
        items: [:map]
      },
      {
        name: "Treasure Room",
        description: "You enter a room filled with treasure. There is a locked door on the other side.",
        paths: [4, 8],
        items: [:key]
      },
      {
        name: "Exit",
        description: "You find the exit! Congratulations on completing the game!",
        paths: [5, 9],
        items: []
      },
      {
        name: "Locked Room",
        description: "You enter a room with a locked door. There is a keyhole.",
        paths: [6],
        items: []
      },
      {
        name: "Trap Room",
        description: "You enter a room and suddenly the floor gives way beneath you!",
        paths: [7],
        items: []
      }
    ]
  end

  def start
    puts "Welcome to the Adventure Game!\n\n"
    print "Enter your name: "
    @player[:name] = gets.chomp

    while @player[:health] > 0 && @current_room != 7
      room = @rooms[@current_room]
      puts "\n#{room[:name]}"
      puts room[:description]
      puts "Your health: #{@player[:health]}"

      if !room[:items].empty?
        print "You see the following items: "
        puts room[:items].join(", ")
      end

      print "What would you like to do? "
      action = gets.chomp.downcase

      case action
      when "go left"
        @current_room = room[:paths][0]
      when "go right"
        @current_room = room[:paths][1]
      when "take"
        print "What item would you like to take? "
        item = gets.chomp.to_sym
        if room[:items].include?(item)
          @player[:inventory] << item
          room[:items].delete(item)
          puts "You picked up the #{item}."
        else
          puts "That item is not here."
        end
      when "inventory"
        puts "Your inventory: #{@player[:inventory]}"
      else
        puts "Invalid action."
      end

      if room[:name] == "Trap Room"
        puts "You fell into a trap and lost 20 health!"
        @player[:health] -= 20
      end

      if @player[:inventory].include?(:map) && room[:name] == "Treasure Room"
        puts "You used the map to find the key and unlocked the door!"
        @current_room = room[:paths][1]
      end

      if @player[:inventory].include?(:key) && room[:name] == "Locked Room"
        puts "You used the key to unlock the door!"
        @current_room = room[:paths][0]
      end
    end

    if @player[:health] <= 0
      puts "You died! Game over."
    else
      puts @rooms[7][:description]
      puts "You finished the game!"
    end
  end
end

game = AdventureGame.new
game.start

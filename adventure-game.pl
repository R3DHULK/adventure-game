#!/usr/bin/perl

# Text-based adventure game in Perl

# Define the possible actions and their corresponding functions
my %actions = (
    "look" => \&look,
    "move" => \&move,
    "take" => \&take,
    "use" => \&use,
    "quit" => \&quit,
);

# Define the game world as a hash of locations
my %world = (
    "cave" => {
        "description" => "You are in a dark cave. It smells damp and musty.",
        "north" => "tunnel",
        "items" => ["torch"],
    },
    "tunnel" => {
        "description" => "You are in a tunnel. You can hear dripping water.",
        "north" => "chamber",
        "south" => "cave",
    },
    "chamber" => {
        "description" => "You are in a chamber. There is a treasure chest.",
        "south" => "tunnel",
        "items" => ["key"],
    },
);

# Define the player's starting location and inventory
my $location = "cave";
my @inventory = ();

# Start the game
print "Welcome to the adventure game!\n";
print "You are in the $world{$location}->{'description'}.\n";

while (1) {
    # Prompt the player for their action
    print "> ";
    my $action = lc(<STDIN>);
    chomp($action);

    # Execute the player's action if it's valid
    if (exists $actions{$action}) {
        $actions{$action}->();
    } else {
        print "I don't understand that command.\n";
    }
}

# Function to look around the current location
sub look {
    print "$world{$location}->{'description'}\n";
    if (@{$world{$location}->{'items'}}) {
        print "You see the following items: ";
        print join(", ", @{$world{$location}->{'items'}}) . ".\n";
    } else {
        print "You don't see any items.\n";
    }
}

# Function to move to a different location
sub move {
    print "Which direction do you want to go? ";
    my $direction = lc(<STDIN>);
    chomp($direction);
    if (exists $world{$location}->{$direction}) {
        $location = $world{$location}->{$direction};
        print "You are now in the $world{$location}->{'description'}.\n";
    } else {
        print "You can't go that way.\n";
    }
}

# Function to take an item from the current location and add it to the player's inventory
sub take {
    print "What do you want to take? ";
    my $item = lc(<STDIN>);
    chomp($item);
    if (grep {$_ eq $item} @{$world{$location}->{'items'}}) {
        push @inventory, $item;
        print "You take the $item.\n";
        # Remove the item from the current location
        @{$world{$location}->{'items'}} = grep {$_ ne $item} @{$world{$location}->{'items'}};
    } else {
        print "You don't see a $item.\n";
    }
}

# Function to use an item from the player's inventory
sub use {
    print "What do you want to use? ";
    my $item = lc(<STDIN>);
    chomp($item);
    if (grep {$_ eq $item} @inventory) {
        if ($item eq "torch") {
            if ($location eq "cave") {
                print "You light the torch and can now see in the dark cave.\n";
            } else {
                print "You don't need to use the torch here.\n";
            }
        } elsif ($item eq "key") {
            if ($location eq "chamber") {
                print "You unlock the treasure chest with the key and find a valuable treasure inside!\n";
                quit();
            } else {
                print "You don't need to use the key here.\n";
            }
        } else {
            print "You can't use that item.\n";
        }
    } else {
        print "You don't have a $item.\n";
    }
}

# Function to quit the game
sub quit {
    print "Thanks for playing!\n";
    exit;
}

# Helper function to display the player's inventory
sub show_inventory {
    if (@inventory) {
        print "You have the following items: ";
        print join(", ", @inventory) . ".\n";
    } else {
        print "Your inventory is empty.\n";
    }
}

# Helper function to display the possible actions at the current location
sub show_actions {
    print "Possible actions: ";
    print join(", ", keys %actions) . ".\n";
}

# Helper function to display the possible directions to move at the current location
sub show_directions {
    my @directions = grep {$_ ne "description" && $_ ne "items"} keys %{$world{$location}};
    if (@directions) {
        print "Possible directions: ";
        print join(", ", @directions) . ".\n";
    } else {
        print "There are no directions to go from here.\n";
    }
}

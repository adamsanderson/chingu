require 'rubygems'
require File.join(File.dirname($0), "..", "lib", "chingu")
include Gosu
include Chingu

class Game < Chingu::Window
  def initialize
    super(640,400)
    self.input = {:esc => :exit, :space=>:next_transition}
    self.caption = "Example of Transitions (Space to cycle)"
    
    @ship = Ship.create(:x => 200, :y => 200, :image => Image["spaceship.png"])
    @tween_index = 0
    # Ignore the sorting, it's done to keep like tweening functions together
    @tweens = Transition::TWEEN_FUNCTIONS.keys.sort_by{|f| f.to_s.reverse}
    
  end
  
  def update
    @transition.update if @transition
  end
  
  def next_transition
    # Pick the next tweening function
    tween = @tweens[@tween_index]
    self.caption = tween
    
    # Create a Transition that runs for 1 second (1000 ticks) from 0 to 200, discard the transition after it is done
    @transition = Transition.new(1000, 0, 200, :after=>lambda{ @transition = nil}, :mode=>tween) do |value|
      @ship.y = value
    end
    
    # Increment the index
    @tween_index = (@tween_index + 1) % @tweens.length
  end
end

class Ship < GameObject
end

Game.new.show
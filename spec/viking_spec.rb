# Your code here
require 'viking'
require 'weapons/bow'
require 'weapons/axe'
require 'weapons/weapon' #throws error so does weapons/weapon
require 'weapons/fists' #throws error
describe Viking do
  #this will have to be refactored later, but using this for convenience now
  let (:v) {Viking.new}
  let (:v2) {Viking.new("Jimmy")}
  let (:v3) {Viking.new("dontmatter", 16, 0, Bow.new)}
  let (:b) {Bow.new}
  let (:v4) {Viking.new.pick_up_weapon(Bow.new)}
  
  describe '#name' do
    it 'takes a new name' do
      expect(v2.name).to eq("Jimmy")
    end
  end

  describe '#health' do 
    it 'sets a new health attribute' do
      expect(v3.health).to eq(16)
    end

    it 'cannot overwrite health' do
      expect do
        v3.health = 20
      end.to raise_error(NoMethodError)
    end
  end

  describe '#weapon' do
    it 'has no weapon to start out' do
      expect(v.weapon).to eq(nil)
    end
    #WHY YOU NO LIKE SCHWAD .... BELOW 
    it 'can be picked up' do
      v.pick_up_weapon(Bow.new)
      expect(v.weapon.class).to eq(Bow)
    end

    it 'raises exception if non weapon' do      
      expect do
        v.pick_up_weapon("whatup")
      end.to raise_error(RuntimeError)
    end

    it 'replaces weapon with new weapon' do
      v.pick_up_weapon(Bow.new)
      v.pick_up_weapon(Axe.new)
      expect(v.weapon.class).to eq(Axe)
    end
  end

  describe '#drop_weapon' do
    it 'drops a weapon' do
      v.pick_up_weapon(Bow.new)
      v.drop_weapon
      expect(v.weapon).to eq(nil)
    end
  end

  describe '#receive_attack' do
    it 'reduces health when attacked' do
      v.receive_attack(10)
      expect(v.health).to eq(90)
    end

    it 'calls take_damage when receiving attack' do
      expect(v).to receive(:take_damage)
      v.receive_attack(10)
    end
  end

  describe '#attack' do
    let (:enemy) {Viking.new}
    it 'reduces opponents health when attacking' do
      enemy.attack(v)
      expect(v.health).to be < (100)
    end

    it 'uses fists if no weapon' do
      allow(enemy).to receive(:damage_with_fists).and_return(2.5)
      expect(enemy).to receive(:damage_with_fists)
      enemy.attack(v)
    end

    it 'no weapon passes fist multiplier' do
      start_health = enemy.health
      v.attack(enemy)
      expect(enemy.health).to eq(start_health - 0.25 * v.strength)
    end

    let!(:axe){ Axe.new }
    it 'attacking with a weapon runs damage_with_weapon' do
      allow(enemy).to receive(:damage_with_weapon).and_return(10)
      enemy.pick_up_weapon(axe)
      expect(enemy).to receive :damage_with_weapon
      enemy.attack(v)
    end

    it 'attacking with a weapon deals damage equal to the Viking\'s trength times that Weapon\'s multiplier' do
      start_health = v.health
      enemy.pick_up_weapon(axe)
      enemy.attack(v)
      expect(v.health).to eq(start_health - 1 * enemy.strength)
    end

    let(:bow){ Bow.new(1) }

    it 'attacking using a Bow without enough arrows uses Fists nstead' do
        allow(enemy).to receive(:damage_with_fists).and_return(2.5)
        enemy.pick_up_weapon(bow)
        enemy.attack(v)
        expect(enemy).to receive :damage_with_fists
        enemy.attack(v)
      end

    it 'Killing a Viking raises an error' do
      enemy.pick_up_weapon(Bow.new)
      expect do
        5.times { enemy.attack(v) }
      end.to raise_error
    end
  end
end
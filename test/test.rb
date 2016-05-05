require 'awesome_print'
load 'util.rb'
load 'net.rb'
load 'a.rb'
load 'p.rb'
load 't.rb'
load 'internal.rb'
require 'mongoid'


STDOUT.sync = true

@counter = 0

# ================================================================================================================
puts Net.new("#{'='*100}\nTest if patient exists.\n\n").name

class Patients
    def initialize
        @patients = [
            {psn: '11111'},
            {psn: '22222'}]
    end

    def add(patient)
        @patients << patient
    end

    def exists?(psn)
        @patients.any? { |x| x[:psn] == psn }
    end
end

patients = Patients.new


T.new(
    name: 'received_new_patient_registration_message',
    guard: Proc.new {
        not patients.exists?(@patient_registration.psn) and @patient_registration.processed.nil?
    },
    fired: Proc.new {
        @wait_for_specimen.created_at = Time.now.strftime("%H:%M:%S")
        @wait_for_specimen.psn = @patient_registration.psn
        patients.add(psn: @patient_registration.psn)

        @patient_registration.processed = {T: 'received_new_patient_registration_message', ts: ts}
        puts "Patient added to the database"
    })

# ---------- Net: received_new_patient_registration_message ----------
P.new('patient_registration')
P.new('wait_for_specimen')

P['patient_registration'] >> T['received_new_patient_registration_message'] >> P['wait_for_specimen']

T.new(
    name: 'received_existing_patient_registration_message',
    guard: Proc.new {
        patients.exists?(@patient_registration.psn) and @patient_registration.processed.nil?
    },
    fired: Proc.new {
        @rejected_message_patient_registration.created_at = Time.now.strftime("%H:%M:%S")
        @rejected_message_patient_registration.psn = @patient_registration.psn
        @patient_registration.processed = {T: 'received_existing_patient_registration_message', ts: ts}
        puts "Patient already exists error."
        #File.open('here.txt','w'){|f| f.puts 'I am here'}
        o = `ls`
        puts o
    })
P.new('rejected_message_patient_registration')

# ---------- Net: received_existing_patient_registration_message ----------
P['patient_registration'] >> T['received_existing_patient_registration_message'] >> P['rejected_message_patient_registration']


# ---------- PROCESS ----------
# ---------- Receive Patient Registration ----------

t T['received_existing_patient_registration_message'].is_firable?,false, "Transitions are not firable at start"

P['patient_registration'].set {
        @created_at = Time.now.strftime("%H:%M:%S")
        @psn = '12345'
    }
t T['received_new_patient_registration_message'].is_firable?,true, "received_new_patient_registration_message is firable when patient doesn't exists"
t T['received_existing_patient_registration_message'].is_firable?,false, "received_existing_patient_registration_message is not firable when patient doesn't exists"

t T['received_new_patient_registration_message'].is_firable?,true, "Transitions are not firable at start"
t T['received_existing_patient_registration_message'].is_firable?,false, "Transitions are not firable at start"

t P[0].get(:@psn), "12345", 'Test: '

puts "\nStatus: received_new_patient_registration_message"
puts T['received_new_patient_registration_message'].inspect

puts "\nStatus: received_existing_patient_registration_message"
puts T['received_existing_patient_registration_message'].inspect

# ---------- FIRE ----------
T.fire
t T['received_new_patient_registration_message'].is_firable?, false, "received_new_patient_registration_message is not firable when patient exists"
t T['received_existing_patient_registration_message'].is_firable?, false, "received_existing_patient_registration_message is firable when patient exists"

puts "\nStatus: received_new_patient_registration_message"
puts T['received_new_patient_registration_message'].inspect

puts "\nStatus: received_existing_patient_registration_message"
puts T['received_existing_patient_registration_message'].inspect

puts "\nShow patient_registration output transitions:"
puts P['patient_registration'].outputs.map(&:to_h)

t P[0].get(:@psn), '12345', "Test: @psn is '12345'"
t P[0].to_h[:@psn], '12345', "Test: to_h should give us the @psn='12345'"

t P[0].set(:@psn,'66666'), P[0], "Update P variable"
t P[0].get(:@psn), '66666', "Test: @psn is '66666'"

t P[0].set { @psn='55555' }, P[0], "Update P variable"
t P[0].get(:@psn), '55555', "Test: @psn is '55555'"
puts '-'*80

# ---------- PROCESS ----------
# ---------- Receive Patient Registration ----------

P.clear
t T[0].is_firable?,false, "Transitions are not firable at start"

P['patient_registration'].set{
    @created_at = Time.now.strftime("%H:%M:%S")
    @psn = '12345' #'12345' #'11111'#
}

t T['received_new_patient_registration_message'].is_firable?, false, "received_new_patient_registration_message is not firable when patient exists"
t T['received_existing_patient_registration_message'].is_firable?, true, "received_existing_patient_registration_message is firable when patient exists"


puts "\nStatus: received_new_patient_registration_message"
puts T['received_new_patient_registration_message'].inspect

puts "\nStatus: received_existing_patient_registration_message"
puts T['received_existing_patient_registration_message'].inspect

# ---------- FIRE ----------
T.fire
t T['received_new_patient_registration_message'].is_firable?, false, "received_new_patient_registration_message is not firable when patient exists"
t T['received_existing_patient_registration_message'].is_firable?, false, "received_existing_patient_registration_message is firable when patient exists"

puts "\nStatus: received_new_patient_registration_message"
puts T['received_new_patient_registration_message'].inspect

puts "\nStatus: received_existing_patient_registration_message"
puts T['received_existing_patient_registration_message'].inspect


puts '-'*80

if false
    def safe_eval(str)
        Thread.start {
            $SAFE =3
            eval str
        }.value
    end
end


# ================================================================================================================
puts Net.new("Basic single connection\n").name

t t0=T.new, T[0], "Create: T0"
t p0=P.new, P[0], "Create: P0"

t t0 >> p0, P[0], 'Create: T0 >> P0'
t T[0].outputs, [P[0]], "Test: T0 >> P0 outputs"
t P[0].inputs, [T[0]], "Test: T0 >> P0 inputs"

t P.new >> T.new, T[1], 'Create: P1 >> T1'
t T[1].inputs, [P[1]], "Test: P1 >> T1 inputs"
t P[1].outputs, [T[1]], "Test: P1 >> T1 outputs"

t T.new << P.new, P[2], ""
t T[2].inputs, [P[2]], "Test: T0 >> P0 inputs"
t P[2].outputs, [T[2]], "Test: T0 >> P0 outputs"

t P.new << T.new, T[3], ""
t T[3].outputs, [P[3]], "Test: T0 >> P0 outputs"
t P[3].inputs, [T[3]], "Test: T0 >> P0 inputs"

# ================================================================================================================
puts Net.new("Basic right side array connection\n").name

t T.new >> [P.new], [P[0]], 'Create: T0 >> P0'
t T[0].outputs, [P[0]], "Test: T0 >> P0 outputs"
t P[0].inputs, [T[0]], "Test: T0 >> P0 inputs"

t P.new >> [T.new], [T[1]], ""
t T[1].inputs, [P[1]], "Test: T0 >> P0 inputs"
t P[1].outputs, [T[1]], "Test: T0 >> P0 outputs"

t T.new << [P.new], [P[2]], ""
t T[2].inputs, [P[2]], "Test: T0 >> P0 inputs"
t P[2].outputs, [T[2]], "Test: T0 >> P0 outputs"

t P.new << [T.new], [T[3]], ""
t T[3].outputs, [P[3]], "Test: T0 >> P0 outputs"
t P[3].inputs, [T[3]], "Test: T0 >> P0 inputs"

# ================================================================================================================
puts Net.new("1) Basic left side array connection\n").name

t [P.new, P.new] << T.new, T[0], "Create: [P0,P1] << T[0]"
t P[0].inputs, [T[0]], "Test: P0 << T0"
t P[1].inputs, [T[0]], "Test: P1 << T0"
t T[0].outputs, [P[0], P[1]], "Test: [P0,P1] << T0"

# ================================================================================================================
puts Net.new("2) Basic left side array connection\n").name

t [P.new, P.new] >> T.new, T[0], "Create: [P0,P1] >> T[0]"
t P[0].outputs, [T[0]], "Test: P0 >> T0"
t P[1].outputs, [T[0]], "Test: P1 >> T0"
t T[0].inputs, [P[0], P[1]], "Test: [P0,P1] >> T0"

# ================================================================================================================
puts Net.new("1) Basic left side array connection\n").name

t [P.new, P.new] << [T.new], [T[0]], "Create: [P0,P1] << [T[0]]"
t P[0].inputs, [T[0]], "Test: P0 << T0"
t P[1].inputs, [T[0]], "Test: P1 << [T0]"
t T[0].outputs, [P[0], P[1]], "Test: [P0,P1] << [T0]"

# ================================================================================================================
puts Net.new("Basic left and right side array connection\n").name

t [P.new, P.new] >> [T.new], [T[0]], "Create: [P0,P1] >> T[0]"
t P[0].outputs, [T[0]], "Test: P0 >> T0"
t P[1].outputs, [T[0]], "Test: P1 >> T0"
t T[0].inputs, [P[0], P[1]], "Test: [P0,P1] >> T0"


# ================================================================================================================
puts Net.new("1) Basic left side array connection\n").name

t [P.new, P.new] << [T.new, T.new], [T[0], T[1]], "Create: [P0,P1] << [T0,T1]"
t P[0].inputs, [T[0], T[1]], "Test: P0 << [T0,T1]"
t P[1].inputs, [T[0], T[1]], "Test: P1 << [T0,T1]"
t T[0].outputs, [P[0], P[1]], "Test: [P0,P1] << T0]"

# ================================================================================================================
puts Net.new("Basic left and right side array connection\n").name

t [P.new, P.new] >> [T.new, T.new], [T[0], T[1]], "Create: [P0,P1] >> [T0,T1]"
t P[0].outputs, [T[0], T[1]], "Test: P0 >> [T0,T1]"
t P[1].outputs, [T[0], T[1]], "Test: P1 >> T0"
t T[0].inputs, [P[0], P[1]], "Test: [P0,P1] >> T0"

# ================================================================================================================
puts Net.new("Basic initialization and guard\n").name

t T.new >> P.new(), P[0], 'Create: T0 >> P0'

t T[0].outputs, [P[0]], "Test: T0 >> P0 outputs"
t P[0].inputs, [T[0]], "Test: T0 >> P0 inputs"


# ================================================================================================================
puts Net.new("Basic initialization and guard\n").name

# --------------- P0 ---------------------
t p0 = P.new, P[0], "Create P0"
p0.set{
    @a = 1
    @b = 2
    @c = 3
}

# --------------- T0 ---------------------
t0 = T.new(
    guard: Proc.new{ @p0.a > 0 and @p0.b > 0 and @p0.c >0},
    fired: Proc.new{@p1.x = @p0.a + @p0.b; @p1.y = 0})

# --------------- P1 ---------------------
p1 = P.new(initialize: '@x = 0; @y = 1')


# --------------- Network ---------------------
t p0 >> t0 >> p1, P[1], 'Create: P0 >> T0 >> P1'

t p0.to_h, {:@a => 1, :@b => 2, :@c => 3}, 'Test: P[0] status'
t t0.inputs, [P[0]], "Test: T0 >> P0 outputs"
t p0.outputs, [t0], "Test: T0 >> P0 inputs"
t P[0].to_h, {:@a => 1, :@b => 2, :@c => 3}, "Before Fire: P0 status"
t P[1].to_h, {}, "Before Fire: P1 status"
t T[0].to_h, {:name=>"t0", :inputs=>[{:@a=>1, :@b=>2, :@c=>3}], :outputs=>[{}]},  "Before Fire: T0 status"

# --------------- Fire ---------------------
T[0].execute
 # ["t0", {:input => [["p0", {:@a => 1, :@b => 2, :@c => 3}]], :output => [["p1", {:@x => 3, :@y => 0}]]}]
#"Fire T0"

t P[0].status, ["p0", {:@a => 1, :@b => 2, :@c => 3}], "After Fire: P0 status"
t P[1].status, ["p1", {:@x => 3, :@y => 0}], "After Fire: P1 status"
t T[0].status, ["t0", {:input => [["p0", {:@a => 1, :@b => 2, :@c => 3}]], :output => [["p1", {:@x => 3, :@y => 0}]]}], "After Fire: T0 status"

# ================================================================================================================
Net.new('Water')

# --------------- Hydrogen ---------------------
t P.new(name: 'hydrogen', initialize: '@quantity=2'), P[0], "Create: the first P(Hydrogen_1)"

t P['hydrogen'], P[0], "Test: Find P('Hydrogen_1') by name"
t P.places.length, 1, 'Test: P.places is 1'
t P.places.map { |place| place.name == "ydrogen" }.length, 1, 'Test: find petrinet element which name is Hydrogen_1'
begin
    P.new(name: 'hydrogen', initialize: '@quantity=2')
    raise "Error: Two places with the same name"
rescue
    t true, true, 'Ps with the same name raises error'
end

# --------------- Oxygen ---------------------
t P.new(name: 'oxygen', initialize: '@quantity=1'), P[1], "Create: the first P(Hydrogen_1)"

t P['oxygen'], P[1], 'Test: find oxygen by name using [name]'
t P.places.length, 2, 'P.places is 2'
t P.places.select { |place| place.name == "oxygen" }.length, 1, 'petrinet contains oxygen'

# --------------- Water ---------------------
P.new(name: 'water', initialize: '@quantity=0')

t P['water'].name, 'water', 'get P "Water" by name'
t P.places.length, 3, 'P.places is 4'
t P.places.select { |place| place.name == "water" }.length, 1, 'petrinet contains water'
t T.transitions.length, 0, 'Ts size is 0'

# --------------- Make Water ---------------------
T.new(
    name: 'make_water',
    guard: '@hydrogen.quantity > 1 and @oxygen.quantity>0',
    fired: '@water.quantity += 1; @hydrogen.quantity -= 2; @oxygen.quantity -= 1')

t T.transitions.length, 1, 'Ts size is 1'
t T.transitions, [T['make_water']], 'Ts countain water'
t T['make_water'], T[0], 'get T "Make Water" by name '

# --------------- Network ---------------------
[P['hydrogen'], P['oxygen']] >> T['make_water'] >> P['water']

t P['hydrogen'].status, ["hydrogen", {:@quantity => 2}], "Before fire: hydrogen quantity 2"
t P['oxygen'].status, ["oxygen", {:@quantity => 1}], "Before fire: oxygen quantity 1"
t P['water'].status, ["water", {:@quantity => 0}], "Before fire: water quantity 0"

# --------------- FIRE: Make Water ---------------------
t T['make_water'].fire.status, ["make_water", {:input => [["hydrogen", {:@quantity => 0}], ["oxygen", {:@quantity => 0}]], :output => [["water", {:@quantity => 1}]]}], "Fire Make Water"

t P['hydrogen'].status, ["hydrogen", {:@quantity => 0}], "After fire: hydrogen quantity 0"
t P['oxygen'].status, ["oxygen", {:@quantity => 0}], "After fire: oxygen quantity 0"
t P['water'].status, ["water", {:@quantity => 1}], "After fire: water quantity 1"

# ================================================================================================================
Net.new('PTEN')

# pten_launch_date
P.new(name: 'pten_launch', initialize: Proc.new { @date = Time.new(2016, 1, 1) })
P.new(name: 'specimen_received', initialize: Proc.new { @date = Time.new(2015, 2, 1) })
P.new(name: 'pten_needed')
P.new(name: 'pten_complete')

T.new(
    name: 'is_pten_needed',
    guard: Proc.new { @pten_launch.date <= @specimen_received.date },
    fired: Proc.new { @pten_needed.date = Time.now })

T.new(
    name: 'is_pten_not_needed',
    guard: Proc.new { @pten_launch.date > @specimen_received.date },
    fired: Proc.new { @pten_complete.date = Time.now })

[P['pten_launch'], P['specimen_received']] >> T['is_pten_needed'] >> P[2]
[P['pten_launch'], P['specimen_received']] >> T['is_pten_not_needed'] >> P['pten_complete']

#puts '-'*80
puts "pten_needed(before): #{T['is_pten_needed'].status.inspect}"
t T['is_pten_needed'].status, ["is_pten_needed", {:input => [["pten_launch", {:@date => Time.new(2016, 1, 1)}], ["specimen_received", {:@date => Time.new(2015, 2, 1)}]], :output => [["pten_needed", {}]]}], "Before fire, is_pten_needed"
puts "pten_needed(after): #{T['is_pten_needed'].fire.status.inspect}"

puts "is_pten_not_needed(before): #{T['is_pten_not_needed'].status.inspect}"
T['is_pten_not_needed'].fire
puts "is_pten_not_needed(after): #{T['is_pten_not_needed'].status.inspect}"

puts '-'*80
# ================================================================================================================

Net.new('PTEN')

# pten_launch_date
P.new(name: 'pten_launch', initialize: Proc.new { @date = Time.new(2016, 1, 1) })
P.new(name: 'specimen_received', initialize: Proc.new { @date = Time.new(2016, 2, 1) })
P.new(name: 'pten_needed')
P.new(name: 'msg_pten_ordered', initialize: Proc.new { @date = nil })
P.new(name: 'pten_ordered', initialize: Proc.new { @date = nil })
P.new(name: 'msg_pten_result', initialize: Proc.new { @date = nil })
P.new(name: 'pten_complete', initialize: Proc.new { @date = nil })

T.new(
    name: 'is_pten_needed',
    guard:
        Proc.new { @pten_launch.date <= @specimen_received.date },
    fired:
        Proc.new { @pten_needed.date = Time.now })

T.new(
    name: 'is_pten_not_needed',
    guard:
        Proc.new { @pten_launch.date > @specimen_received.date },
    fired:
        Proc.new { @pten_complete.date=Time.now })

T.new(
    name: 'msg_pten_ordered_arrived',
    guard:
        Proc.new { not @msg_pten_ordered.date.nil? and @pten_needed.ordered_date.nil? },
    fired:
        Proc.new { @pten_ordered.date = Time.now; @pten_needed.ordered_date = Time.now })

T.new(
    name: 'msg_pten_result_arrived',
    guard:
        Proc.new { not @msg_pten_result.date.nil? },
    fired:
        Proc.new { @pten_complete.date = Time.now })


[P['pten_launch'], P['specimen_received']] >>
    T['is_pten_needed'] >>
    P['pten_needed']

[P['pten_launch'], P['specimen_received']] >>
    T['is_pten_not_needed'] >>
    P['pten_complete']

[P['pten_needed'], P['msg_pten_ordered']] >>
    T['msg_pten_ordered_arrived'] >>
    [P['pten_ordered'], P['msg_pten_result']] >>
    T['msg_pten_result_arrived'] >>
    P['pten_complete']


puts '-'*80
puts "pten_needed(before): #{T['is_pten_needed'].status.inspect}"
File.open('/tmp/is_pten_needed_before', 'w') { |f| f.write(T['is_pten_needed'].status.ai) }
puts "pten_needed(after): #{T['is_pten_needed'].fire.status.inspect}"
File.open('/tmp/is_pten_needed_after', 'w') { |f| f.write(T['is_pten_needed'].status.ai) }

puts "msg_pten_ordered(before): : #{P['msg_pten_ordered'].status.inspect}"
puts "msg_pten_ordered(after): : #{P['msg_pten_ordered'].update_state(Proc.new { @date = Time.now }).status.inspect}"

puts "msg_pten_ordered_arrived(before): #{T['msg_pten_ordered_arrived'].status.inspect}"
puts "msg_pten_ordered_arrived(after): #{T['msg_pten_ordered_arrived'].fire.status.inspect}"

puts "msg_pten_result(before): : #{P['msg_pten_result'].status.inspect}"

puts "msg_pten_result(after): : #{P['msg_pten_result'].update_state(Proc.new { @date = Time.now }).status.inspect}"
puts "msg_pten_ordered_arrived(before): #{T['msg_pten_result_arrived'].status.inspect}"
puts "msg_pten_ordered_arrived(after): #{T['msg_pten_result_arrived'].fire.status.inspect}"

puts '-'*80

# ================================================================================================================

puts Net.new("#{'='*100}\nTest if patient exists.\n\n").name

patients = [
    {psn: '11111', name: "John"},
    {psn: '22222', name: 'Paul'}
]
P.new(name: 'patient_registration')
P['patient_registration'].update_state(
    Proc.new {
        @psn = '12345' #'12345' #'11111'#
        @name='Jonas'
    })


T.new(
    name: 'received_new_patient_registration_message',
    guard: Proc.new {
        not patients.any? { |x| x[:psn] == @patient_registration.psn }
    },
    fired: Proc.new {
        @wait_for_specimen.date = Time.now
        @wait_for_specimen.psn = @patient_registration.psn
        @wait_for_specimen.name = @patient_registration.name
        patients << {psn: @patient_registration.psn, name: @patient_registration.name}
        puts "Patient added to the database"
    })
P.new(name: 'wait_for_specimen')


P['patient_registration'] >> T['received_new_patient_registration_message'] >> P['wait_for_specimen']

T.new(
    name: 'received_existing_patient_registration_message',
    guard: Proc.new {
        patients.any? { |x| x[:psn] == @patient_registration.psn }
    },
    fired: Proc.new {
        puts "Patient already exists error."
    })
P['patient_registration'] >> T['received_existing_patient_registration_message']

puts T['received_new_patient_registration_message'].status.inspect

# ---------- Fire ----------
T['received_new_patient_registration_message'].fire
T['received_existing_patient_registration_message'].fire


puts T['received_new_patient_registration_message'].status.inspect


puts '-'*80

if false
    def safe_eval(str)
        Thread.start {
            $SAFE =3
            eval str
        }.value
    end
end

# ================================================================================================================

#

=begin

Net.new('Test P>>T and T>>P')
P.new('Hydrogen_1')
P.new('Hydrogen_2')
P.new('Oxygen')
P.new('Water')
T.new('Make_Water')
P['Hydrogen_1'] >> T['Make_Water']
P['Hydrogen_2'] >> T['Make_Water']
P['Oxygen'] >> T['Make_Water']
T['Make_Water'] >> P['Water']
t T['Make_Water'].sources, [P['Hydrogen_1'], P['Hydrogen_2'], P['Oxygen']], 'Test: Make_Water sources and hydrogen and oxygen'
t T['Make_Water'].destinations, [P['Water']], 'Test: Make_Water destination is Water'

Net.new('Test P<<T and T<<P')
T.new('Make_Water') << P.new('Hydrogen_1')
T['Make_Water'] << P.new('Hydrogen_2')
T['Make_Water'] << P.new('Oxygen')
P.new('Water') << T['Make_Water']
t T['Make_Water'].sources, [P['Hydrogen_1'], P['Hydrogen_2'], P['Oxygen']], 'Test: Make_Water sources and hydrogen and oxygen'
t T['Make_Water'].destinations, [P['Water']], 'Test: Make_Water destination is Water'

1==1



t Net.new('thirtytwo'), Net.default, "Net.default to the only one Net created"
t Net['thirtytwo'], Net.default, "Net.default to the last one Net created"
Net.new('22')
t Net['thirtytwo'] != Net.default, true, "Net.default to the last one Net created"

# new petrinet

Net.new('petrinet_3')

t Net.default.places, [], 'Default petrinet should have no places'
t Net.default.transitions, [], 'Default petrinet should have no transitions'
t Net.default.arcs, [], 'Default petrinet should have no arcs'
t P.places, [], 'There should not be any places created yet'
t T.transitions, [], 'There should not be any places created yet'
t A.arcs, [], 'Test: first time there should not be any arcs created yet'

t P.new.name, 'P0', 'Create a new P with name Pn n=0...'
t Net.default.places.size, 1, 'Default petrinet should have ONE place'
t Net.default.places, [P[0]], 'Default petrinet should have P[0] place'
t Net.default.places, [P['P0']], 'Default petrinet should have P[\'P0\'] place'
t P[0].name, 'P0', 'P P[0] already exists check that the name is P0'
t P[0], P['P0'], 'Check that P[0] , P[\'0\'] are the same'
t P.places, [P[0]], 'P: there should be only one place and it should have id:0'

t T.transitions, [], 'T should be empty'
t T.new.name, 'T0', 'Create a new T with name Tn where n=[0..]'
t T['T0'], T[0], 'T get by name should be equal get by id'

t T[0].can_fire?, false, 'T#fire? shoudn\'t be ready to fire'

t P[0].class, P, 'P[0] should be a P'
t A.arcs, [], 'Test: Second time should not be any arcs created yet'

# Creating an Arc
p0=P[0]
t0=T[0]
t A.new(p0, t0, 'A0').class, A, 'Creating a new arc should return class Arc'

t A[0], A['A0'], 'Arc named A0 should be A[0]'
t Net.default.arcs, [A['A0']], 'Default petrinet should have A[\'A0\'] arc'
t Net.default.places, [P['P0']], 'Default petrinet should have P[\'P0\'] place'
t Net.default.transitions, [T['T0']], 'Default petrinet should have T[\'T0\'] transition'
t P.places, [P[0]], 'There should not be any places created yet'
t T.transitions, [T[0]], 'There should not be any places created yet'
t A.arcs, [A[0]], 'There should be only one'

t A[0].source, P[0], 'Sources should have P[0]'
t A[0].destination, T[0], 'Destination should be T[0]'
t A[0].marked?, false, 'Arc A[0] should be unmarked'
t T[0].all_inputs_marked?, false, 'T T[0] should be unmarked'
t T[0].can_fire?, false, 'T can not fire'
t A[0].mark, true, 'Mark P[0]'
t A[0].marked?, true, 'A[0] source P[0] should be marked now'
t T[0].all_inputs_marked?, true, 'T T[0] should be marked now'
t T[0].can_fire?, true, 'T should be able to fire'
t T[0].fire, true, 'Fire transition T[0]'

t A[0].marked?, false, 'A[0] should be unmarked'
t T[0].can_fire?, false, 'P should NOT be able to fire'

# mark P[1]

t T[0].all_inputs_marked?, false, 'T T[1] should be marked now'
t T[0].can_fire?, false, 'T should NOT be able to fire'
begin
    T[0].fire
    T true, false, 'Error T: did not raise error when unfirable transition is fired'
rescue => e
    t true, true, 'Raised correctly the inability of T0 to fire'
end

t A[0].mark, true, 'Mark: A0'
t A[0].marked?, true, 'A[0] source P[0] should be marked now'
t T[0].all_inputs_marked?, true, 'T T[0] should be marked now'
t T[0].can_fire?, true, 'T should be able to fire'
t T[0].fire, true, 'Fire transition T[0]'

t A[0].marked?, false, 'A[0] should be unmarked'
t T[0].can_fire?, false, 'T should NOT be able to fire'


# adding a second arc to T[0] with a new P

t P.new.class, P, "Creating P1"
t A.new(P[1], T[0], 'A1').class, A, 'Should be able to create new arc with new P and old T'
t Net.default.arcs, [A['A0'], A['A1']], 'Default petrinet should have two arcs A[\'A0\'] A[\'A1\']'
t Net.default.places, [P['P0'], P['P1']], 'Default petrinet should have two P P[\'P0\'] P[\'P1\']'
t Net.default.transitions, [T['T0']], 'Default petrinet should have still one T[\'T0\'] transition'

t T[0].all_inputs_marked?, false, 'T T[1] should be marked now'
t T[0].can_fire?, false, 'T should NOT be able to fire'


t A[0].mark, true, 'P[0] set @mark true'
t A[0].marked?, true, 'A[0] source P[0] should be marked now'

t T[0].all_inputs_marked?, false, 'T T[0] should be all_marked? false because A[1] is unmarked'
t T[0].can_fire?, false, 'T should NOT be able to fire because A[1] unmarked'

t A[0].marked?, true, 'A[0] should be unmarked'
t A[1].marked?, false, 'A[1] should be unmarked'

t A[1].mark, true, 'Mark P[1] with default behavior "@mark=true"'
t A[1].marked?, true, 'A[1] should be marked'

t T[0].can_fire?, true, "T[0] should be able to fire now"
t T[0].fire, true, "FIRE"

t A[0].marked?, false, 'A[0] should be marked'

t A[1].marked?, false, 'A[1] should be marked'


Net.new('petrinet_4')
t P.new("send biopsy test").class, P, "Create new P"
t P[0].name, "send biopsy test", 'P[0] should have the same name'


Net.new('arcs')
t petrinet.arcs.empty?, true, 'Petrinet arcs empty'

place0 = P.new('PPP', {initialize: "@count=150"})
t P[0], place0, 'P: retrieve by id using P[0]'

t place0.evaluate('@count'), 150, "P(#{place0.name}) initial value of 150 returned by place0.evaluate('@count')"

# Create first ARC
arc = A.new(place0, T.new('T0'), 'A0', marked?: "@count>200", mark: "@count+=200", unmark: "@count-=200")
t petrinet.arcs.size, 1, 'Petrinet arcs has one element'
t petrinet.arcs[0], arc, 'Petrinet the first element is arc'
t arc.source, P['PPP'], 'The arc source is A'
t arc.destination, T['T0'], 'The arc destination is T0'
t P['PPP'].outputs.size, 1, 'Place has an arc output'
t P['PPP'].outputs[0], arc, 'Place output is arc'
t T['T0'].inputs[0], arc, 'T T0 input is arc'
t T['T0'].all_inputs_marked?, false, 'Transaction T0 has all inputs (only one) UNmarked'

# Create second ARC
arc1 = A.new(T.new('T1'), place0, 'A1', {
                            marked?: "@count>200",
                            mark: "@count+=200",
                            unmark: "@count-=200"})

t T['T0'].all_inputs_marked?, false, 'Transaction T0 has all inputs (only one) UNmarked'
t arc1.mark, 350, 'Marking arc1 makes P0 count 350 '
t T['T0'].all_inputs_marked?, true, 'Transaction T0 has all inputs (only one) marked'
t arc.marked?, true, 'Source arc is marked'
t arc.unmark, 150, 'Source arc is decreased 200 to 150 because of unmark'
t T['T0'].all_inputs_marked?, false, 'Transaction T0 has all inputs (only one) UNmarked'
t arc.marked?, false, 'Source arc is un marked'

t petrinet.arcs.size, 2, 'Petrinet has two arcs.'
t petrinet.arcs[1], arc1, 'Petrinet the last element is arc1'
t arc1.source, T['T1'], 'The arc1 source is T1'
t arc1.destination, P['PPP'], 'The arc destination is A'
t P['PPP'].inputs.size, 1, 'P has an arc output'
t P['PPP'].inputs[0], arc1, 'P input is arc1'
t T['T1'].outputs[0], arc1, 'T T1 output is arc1'
t T['T0'].inputs.size, 1, 'T T0 has one input arc'
t T['T1'].outputs.size, 1, 'T T1 has one output arc'

t T['T0'].all_inputs_marked?, false, 'Transaction T0 has all inputs (only one) UNmarked'

n = P.places.count
t P.new('Virtual').class, P, 'Try a create a new P with []'
t P.places.count, n+1, 'There should be one more P than before'


puts Net.new("\nSPLIT Network\n-------").name
t A.new(P.new, T.new, 'A0').class, A, 'Create P0 -> A0 -> T0'
t P[0].outputs, [A[0]], 'Test: P0 -> A0'
t T[0].inputs, [A[0]], 'Test: A0 -> T0'

t A.new(T[0], P.new, 'A1').class, A, 'Create: T0 -> A1 ->P1'
t T[0].outputs, [A[1]], 'Test: T0 -> A1'
t P[1].inputs, [A[1]], 'Test: A1 -> P1'

t A.new(T[0], P.new).class, A, 'Create:  T0 -> A2 -> P2'
t A[0].marked?, false, 'Test: P0 unmarked'
t A[1].marked?, false, 'Test: P1 unmarked'
t A[2].marked?, false, 'Test: P2 unmarked'
t A[0].mark, true, 'Mark: P0'
t A[1].marked?, false, 'Test: P1 unmarked'
t A[2].marked?, false, 'Test: P2 unmarked'
t T[0].can_fire?, true, 'Test: T0.can_fire? to be true'
t T[0].fire, true, 'Fire: T0'
t A[0].marked?, false, 'Test: P0 unmarked'
t A[1].marked?, true, 'Test: P1 marked'
t A[2].marked?, true, 'Test: P2 marked'


# OR network

puts Net.new("\nOR Network\n-------").name

t A.new(P.new, T.new, 'A0').name, 'A0', "Create: P0 -> A0 -> T0"
t A[0].source, P[0], "P0 is source for A0"
t P[0].outputs.size, 1, "P0 has one arc"
t P[0].outputs, [A[0]], "P0 has one arc"

t A.new(P.new, T.new, 'A1').name, 'A1', "Create A1"
t A.new(T[0], P.new, 'A2').name, "A2", "Create A2"
t A.new(T[1], P[2], 'A3').name, 'A3', "Create A3"
t P[2].inputs.map(&:source), [T[0], T[1]], "P2 inputs are T0 and T1"


# AND network

puts Net.new("\nAND Network\n-------").name

t A.new(P.new, T.new).name, 'A0', "Create: P0 -> A0 -> T0"
t A[0].source, P[0], "Test: A0 <- P0"
t P[0].outputs.size, 1, "Test: P0 has one arc"
t P[0].outputs, [A[0]], "Test: P0 => [A0]"
t T[0].inputs, [A[0]], 'Test: T0 <- [A0]'

t A.new(P.new, T[0]).name, 'A1', 'Create: P1 -> A1 -> T0'
t A[1].source, P[1], "Test: A1 <- P1"
t A[1].destination, T[0], "Test: A1 -> T0"
t P[1].outputs, [A[1]], 'Test P1 => [A1]'
t T[0].inputs, [A[0], A[1]], 'Test: T0 <= [A0,A1]'

t A.new(T[0], P.new).name, "A2", "Create: T0 -> A2 -> P[2]"
t P[2].inputs, [A[2]], "Test: P2 <= A2"
t P[2].outputs, [], "Test: P2 => []"
t T[0].outputs, [A[2]], 'Test: T0 => [A2]'
t T[0].inputs, [A[0], A[1]], 'Test: T[0] <= [A0,A1]'
t A[2].source, T[0], "Test: A2 <- T0"
t A[2].destination, P[2], "Test: A2 -> P2"

puts Net.new("\nMultiple Arcs from a P Network\n-------").name


t A.new(P.new, T.new).name, 'A0', 'Create: P0 -> A0 -> T0'
t A.new(P.new, T[0]).name, 'A1', "Create P1 -> A1 -> T0"
t A.new(P[1], T.new).name, 'A2', "Create: P1 -> A2 -> T1"
t A.new(P.new, T[1]).name, 'A3', 'Create: P2 -> A3 -> T1'
t A.new(T[0], P.new).name, 'A4', 'Create: T0 -> A4 -> P3'
t A.new(T[1], P.new).name, 'A5', 'Create: T1 -> A5 -> P4'

t A[0].mark, true, 'Mark: A0'
t A[1].mark, true, "Mark: A1"
t T[0].fire, true, "Fire: T0"
t A[4].marked?, true, "Test: A4.marked? true"
t A[3].marked?, false, "Test: A3.marked? false"
t A[0].marked?, false, "Test: A0 marked? false"


puts Net.new("\nMultiple Arcs from a P Network second test\n-------").name


t A.new(P.new, T.new).name, 'A0', 'Create: P0 -> A0 -> T0'
t A.new(P.new, T[0]).name, 'A1', "Create P1 -> A1 -> T0"
t A.new(P[1], T.new).name, 'A2', "Create: P1 -> A2 -> T1"
t A.new(P.new, T[1]).name, 'A3', 'Create: P2 -> A3 -> T1'
t A.new(T[0], P.new).name, 'A4', 'Create: T0 -> A4 -> P3'
t A.new(T[1], P.new).name, 'A5', 'Create: T1 -> A5 -> P4'

t A[0].mark, true, 'Mark: P0'
t A[2].mark, true, "Mark: P1"
t T[0].can_fire?, true, "T0 can fire? is false"
t T[1].can_fire?, false, "T1 can fire? is true"
t T[0].fire, true, "T1 fire"
t A[5].marked?, false, "Test: P5.marked? true"
t A[3].marked?, false, "Test: P3.marked? true"
t A[4].marked?, true, "Test: P4.marked? false"

# nothing should happen when P0 and P2 are marked and T0 and T1 are fire
t A[0].marked?, false, "Test: P0 marked? false"
t A[1].marked?, false, "Test: P0 marked? false"
t A[2].marked?, false, "Test: P0 marked? false"

puts Net.new("\nMultiple Arcs from a P Network\n-------").name

t A.new(P.new, T.new, 'P0 -> A0 -> T0').name, 'P0 -> A0 -> T0', 'Create: P0 -> A0 -> T0'
t A.new(P.new, T[0]).name, 'A1', "Create P1 -> A1 -> T0"
t A.new(P[1], T.new).name, 'A2', "Create: P1 -> A2 -> T1"
t A.new(P.new, T[1]).name, 'A3', 'Create: P2 -> A3 -> T1'
t A.new(T[0], P.new).name, 'A4', 'Create: T0 -> A4 -> P3'
t A.new(T[1], P.new).name, 'A5', 'Create: T1 -> A5 -> P4'
t A.new(P[3], T.new).name, 'A6', 'Create: P3 -> A6 -> T2'
t A.new(P[4], T.new).name, 'A7', 'Create: P4 -> A7 -> T3'
t A.new(T[2], P.new).name, 'A8', 'Create: T2 -> A8 -> P5'
t A.new(T[3], P[5]).name, 'A9', 'Create: T2 -> A9 -> P5'

t P[0].mark, true, 'Mark: P0'
t P[1].mark, true, "Mark: P1"
t T[0].fire, true, "Fire: T0"
t T[1].fire, false, "Fire: T1"
t T[2].fire, true, "Fire: T0"
t T[3].fire, false, "Fire: T1"
t P[3].marked?, false, "Test: P3.marked? false"
t P[4].marked?, false, "Test: P4.marked? false"
t P[5].marked?, true, "Test: P5 marked? true"

t P.places.select(&:unmark).count, 0, "Unmark all places"

t P[0].mark, true, 'Mark: P0'
t P[2].mark, true, "Mark: P1"
t T[0].fire, false, "Fire: T0"
t T[1].fire, false, "Fire: T1"
t T[2].fire, false, "Fire: T0"
t P[3].marked?, false, "Test: P3.marked? true"
t P[4].marked?, false, "Test: P4.marked? false"
t P[5].marked?, false, "Test: P5 marked? true"

# nothing should happen when P0 and P2 are marked and T0 and T1 are fire
t P[0].marked?, true, "Test: P0 marked? false"
t P[1].marked?, false, "Test: P0 marked? false"
t P[2].marked?, true, "Test: P0 marked? false"

# test stable network

t P.places.select(&:unmark).count, 0, "Unmark all places"

t P[0].mark, true, 'Mark: P0'
t P[2].mark, true, "Mark: P1"

t T.fire, [], "Fire: all transitions and at least one should be true"

t P[3].marked?, false, "Test: P3.marked? true"
t P[4].marked?, false, "Test: P4.marked? false"
t P[5].marked?, false, "Test: P5 marked? true"

# nothing should happen when P0 and P2 are marked and T0 and T1 are fire
t P[0].marked?, true, "Test: P0 marked? false"
t P[1].marked?, false, "Test: P0 marked? false"
t P[2].marked?, true, "Test: P0 marked? false"


t P.places.select(&:unmark).count, 0, "Unmark all places"

t P[0].mark, true, 'Mark: P0'
t P[2].mark, true, "Mark: P1"

t T.fire_until_stable, nil, "Fire: all transitions and at least one should be true"

t P[3].marked?, false, "Test: P3.marked? true"
t P[4].marked?, false, "Test: P4.marked? false"
t P[5].marked?, false, "Test: P5 marked? true"

# nothing should happen when P0 and P2 are marked and T0 and T1 are fire
t P[0].marked?, true, "Test: P0 marked? false"
t P[1].marked?, false, "Test: P0 marked? false"
t P[2].marked?, true, "Test: P0 marked? false"

puts Net.new("\nP class: Implicit arc P << T \n-------").name
t P.new << T.new, T[0], "Create: arc P << T"
t A[0].source, T[0], "Test: T0 -> A0"
t A[0].destination, P[0], "Test A0 -> P0"
t A[T[0], P[0]], A[0], "Test: Find arc with [P0,T0]"

puts Net.new("\nP class: Implicit arc P >> T \n-------").name
t P.new >> T.new, T[0], "Create: arc P >> T"
t A[0].source, P[0], "Test: P0 -> A0"
t A[0].destination, T[0], "Test A0 -> T0"
t A[P[0], T[0]], A[0], "Find: Arc with P -> T"

puts Net.new("\nT class: Implicit arc T << P \n-------").name

t T.new << P.new, P[0], "Create: arc T << P"
t A[0].source, P[0], "Test: P0 -> A0"
t A[0].destination, T[0], "Test A0 -> T0"

puts Net.new("\nT class: Implicit arc T >> P \n-------").name
t T.new >> P.new, P[0], "Create: arc T >> P"
t A[0].source, T[0], "Test: P0 -> A0"
t A[0].destination, P[0], "Test A0 -> T0"

# implicit P >> T >> P
puts Net.new("\nP class: Implicit arc P << T \n-------").name
t P.new << T.new << P.new, P[1], "Create: arc P << T"
t A[0].source, T[0], "Test: T0 -> A0"
t A[0].destination, P[0], "Test A0 -> P0"
t A[1].source, P[1], "Test: T0 -> A0"
t A[1].destination, T[0], "Test A0 -> P0"

puts Net.new("\nP class: Implicit arc P >> T \n-------").name
t P.new >> T.new >> P.new, P[1], "Create: arc P >> T"
t A[0].source, P[0], "Test: P0 -> A0"
t A[0].destination, T[0], "Test A0 -> T0"
t A[1].source, T[0], "Test: P0 -> A0"
t A[1].destination, P[1], "Test A0 -> T0"

puts Net.new("\nT class: Implicit arc T << P \n-------").name
t T.new << P.new << T.new, T[1], "Create: arc T << P"
t A[0].source, P[0], "Test: P0 -> A0"
t A[0].destination, T[0], "Test A0 -> T0"
t A[1].source, T[1], "Test: P0 -> A0"
t A[1].destination, P[0], "Test A0 -> T0"

puts Net.new("\nT class: Implicit arc T >> P \n-------").name
t T.new >> P.new >> T.new, T[1], "Create: arc T >> P"
t A[0].source, T[0], "Test: T0 -> A0"
t A[0].destination, P[0], "Test A0 -> P0"
t A[1].source, P[0], "Test: P0 -> A1"
t A[1].destination, T[1], "Test A1 -> T1"


puts Net.new("\nA: Create new As P0 << [T0,T1,T2] \n-------").name
t P.new << [T.new, T.new, T.new], [T[0], T[1], T[2]], "Create: P0 << [T0,T1,T2]"
t A[T[0], P[0]], A[0], "Test: [T0,P0] is A0"
t A[T[1], P[0]], A[1], "Test: [T1,P0] is A1"
t A[T[2], P[0]], A[2], "Test: [T2,P0] is A2"
#puts Net.new("\nA: Create new As T << [P0,P1,P2] \n-------").name
#t T.new

puts Net.new("\nA: Create new As P0 << [T0,T1,T2] \n-------").name
t T.new << [P.new, P.new, P.new], [P[0], P[1], P[2]], "Create: P0 << [T0,T1,T2]"
t A[P[0], T[0]], A[0], "Test: [P0,T0] is A0"
t A[P[1], T[0]], A[1], "Test: [P1,T0] is A1"
t A[P[2], T[0]], A[2], "Test: [P2,T0] is A2"
#puts Net.new("\nA: Create new As T << [P0,P1,P2] \n-------").name
#t T.new

puts Net.new("\nA: Create new As P0 << [T0,T1,T2] \n-------").name
t T.new >> [P.new, P.new, P.new], [P[0], P[1], P[2]], "Create: P0 << [T0,T1,T2]"
t A[T[0], P[0]], A[0], "Test: [T0,P0] is A0"
t A[T[0], P[1]], A[1], "Test: [T0,P1] is A1"
t A[T[0], P[2]], A[2], "Test: [T0,P2] is A2"
puts T[0].destinations &:name


puts Net.new("\nA: Create new As [P0,P1,P2] << T0 \n-------").name

t [P.new, P.new, P.new] << T.new, T[0], "Create: [P0,P1,P2] << T0 "
t A[T[0], P[0]], A[0], "Test: [T0,P0] is A0"
t A[T[0], P[1]], A[1], "Test: [T0,P1] is A0"
t A[T[0], P[2]], A[2], "Test: [T0,P2] is A0"

puts Net.new("\nA: Create new As [P0,P1,P2] << T0 \n-------").name

t [P.new, P.new, P.new] >> T.new, T[0], 'Create: [P0,P1,P2] >> T0 '
t A[P[0], T[0]], A[0], "Test: [P0,T0] is A0"
t A[P[1], T[0]], A[1], "Test: [P1,T0] is A1"
t A[P[2], T[0]], A[2], "Test: [P2,T0] is A2"

puts Net.new("\nA: Create new As [P0,P1,P2] << T0 \n-------").name

t [T.new, T.new, T.new] << P.new, P[0], "Create: [P0,P1,P2] << T0 "
t A[P[0], T[0]], A[0], "Test: [T0,P0] is A0"
t A[P[0], T[1]], A[1], "Test: [T0,P1] is A0"
t A[P[0], T[2]], A[2], "Test: [T0,P2] is A0"

puts Net.new("\nA: Create new As [P0,P1,P2] << T0 \n-------").name

t [T.new, T.new, T.new] >> P.new, P[0], 'Create: [T0,T1,T2] >> P0 '
t A[T[0], P[0]], A[0], "Test: [T0,P0] is A0"
t A[T[1], P[0]], A[1], "Test: [T1,P0] is A1"
t A[T[2], P[0]], A[2], "Test: [T2,P0] is A2"

puts Net.new("\nTransition Fire \n-------").name

p = P.new('P0')
t0 = T.new('T0')
a = A.new(p, t0, 'A0')

t a.marked?, false, "A#marked? should be true"
a.mark
t a.marked?, true, "A#marked? should be false"
a.unmark
t a.marked?, false, "A#marked? should be true"


puts Net.new("\nTransition Fire \n-------").name

p = P.new('P0', {initialize: '@x=10'})
t0 = T.new('T0', {fired: 'puts "fire"'})
a = A.new(p, t0, 'A0', {mark: '@x+=1', unmark: '@x-=1', marked?: '@x>=10'})

t a.marked?, true, "A#marked? should be true"
t t0.can_fire?, true, "Test: T0 should be able to fire because source Ps are marked"
a.unmark
t a.marked?, false, "A#marked? should be false"
a.mark
t a.marked?, true, "A#marked? should be true"
a.mark
t a.marked?, true, "A#marked? should be true"
a.unmark
t a.marked?, true, "A#marked? should be false"
a.unmark
t a.marked?, false, "A#marked? should be false"
t t0.can_fire?, false, "Test: T0 should NOT be able to fire because source Ps are unmarked"
a.mark
t a.marked?, true, "A#marked? should be false"
t t0.can_fire?, true, "Test: T0 should be able to fire because source Ps are marked"

puts Net.new("\nTransition Fire with multiple inputs \n-------").name

p0 = P.new('P0', {initialize: '@x=10'})
p1 = P.new('P1', {initialize: '@y=5'})
t0 = T.new('T0', {fired: 'puts "T0 fire"'})
a0 = A.new(p0, t0, 'A0', {mark: '@x+=1', unmark: '@x-=1', marked?: '@x>10'})
a1 = A.new(p1, t0, 'A1', {mark: '@y+=1', unmark: '@y-=1', marked?: '@y>5'})

t a0.marked?, false, "A#marked? should be true"
t a1.marked?, false, "A#marked? should be true"

t t0.can_fire?, false, "Test: T0 should be able to fire because source Ps are marked"

a0.mark
t a0.marked?, true, 'Test: A0 is marked'
t a1.marked?, false, 'Test: A1 is marked'
t t0.can_fire?, false, 'Test: T0 can NOT fire becase P1 is unmarked'
a1.mark
t t0.can_fire?, true, 'Test: T0 CAN fire now'
t0.fire
t a0.marked?, false, 'Test: A0 is marked'
t a1.marked?, false, 'Test: A1 is marked'


puts Net.new("\nTransition Fire with multiple inputs and one output\n-------").name

p0 = P.new('P0', {initialize: '@x=10'})
p1 = P.new('P1', {initialize: '@y=5'})
p2 = P.new('P2', {initialize: '@z=0'})
t0 = T.new('T0', {fired: 'puts "T0 fire"'})
a0 = A.new(p0, t0, 'A0', {mark: '@x+=1', unmark: '@x-=1', marked?: '@x>10'})
a1 = A.new(p1, t0, 'A1', {mark: '@y+=1', unmark: '@y-=1', marked?: '@y>5'})
a2 = A.new(t0, p2, 'A2', {mark: '@z+=1', unmark: '@z-=1', marked?: '@z>0'})

t a0.marked?, false, "A#marked? should be true"
t a1.marked?, false, "A#marked? should be true"

t t0.can_fire?, false, "Test: T0 should be able to fire because source Ps are marked"

a0.mark
t a0.marked?, true, 'Test: A0 is marked'
t a1.marked?, false, 'Test: A1 is marked'
t a2.marked?, false, 'Test: A2 is UNmarked'
t t0.can_fire?, false, 'Test: T0 can NOT fire becase P1 is unmarked'
a1.mark
t t0.can_fire?, true, 'Test: T0 CAN fire now'
t0.fire
t a0.marked?, false, 'Test: A0 is marked'
t a1.marked?, false, 'Test: A1 is marked'
t a2.marked?, true, 'Test: A2 is marked'

puts Net.new("\nTransition Fire with multiple inputs and multiple output\n-------").name

p0 = P.new('P0', {initialize: '@x=10'})
p1 = P.new('P1', {initialize: '@y=5'})

t0 = T.new('T0', {fired: 'puts "T0 fire"'})

a0 = A.new(p0, t0, 'A0', {mark: '@x+=1', unmark: '@x-=1', marked?: '@x>10'})
a1 = A.new(p1, t0, 'A1', {mark: '@y+=1', unmark: '@y-=1', marked?: '@y>5'})


p2 = P.new('P2', {initialize: '@z=0'})
p3 = P.new('P3', {initialize: '@n=0'})

a2 = A.new(t0, p2, 'A2', {mark: '@z+=1', unmark: '@z-=1', marked?: '@z>0'})
a3 = A.new(t0, p3, 'A3', {mark: '@n+=1', unmark: '@n-=1', marked?: '@n>0'})

#-----------
t a0.marked?, false, "A#marked? should be true"
t a1.marked?, false, "A#marked? should be true"

t t0.can_fire?, false, "Test: T0 should be able to fire because source Ps are marked"

a0.mark
t a0.marked?, true, 'Test: A0 is marked'
t a1.marked?, false, 'Test: A1 is marked'
t a2.marked?, false, 'Test: A2 is UNmarked'
t a3.marked?, false, 'Test: A2 is UNmarked'

t t0.can_fire?, false, 'Test: T0 can NOT fire becase P1 is unmarked'
a1.mark
t t0.can_fire?, true, 'Test: T0 CAN fire now'
t0.fire
t a0.marked?, false, 'Test: A0 is marked'
t a1.marked?, false, 'Test: A1 is marked'
t a2.marked?, true, 'Test: A2 is marked'
t a3.marked?, true, 'Test: A2 is marked'


#============================================================================
puts Net.new("\nTransition Fire with multiple inputs and multiple output and multiple parallel transitions\n-------").name

p0 = P.new('P0', {initialize: '@x=10;@a=0'})
p1 = P.new('P1', {initialize: '@y=5;@b=0'})

t0 = T.new('T0', {fired: 'puts "T0 fire"'})

a0 = A.new(p0, t0, 'A0', {mark: '@x+=1', unmark: '@x-=1', marked?: '@x>10'})
a1 = A.new(p1, t0, 'A1', {mark: '@y+=1', unmark: '@y-=1', marked?: '@y>5'})

p2 = P.new('P2', {initialize: '@z=0;@aa=0'}) ###
p3 = P.new('P3', {initialize: '@n=0;@bb=0'}) ###

a2 = A.new(t0, p2, 'A2', {mark: '@z+=1', unmark: '@z-=1', marked?: '@z>0'})
a3 = A.new(t0, p3, 'A3', {mark: '@n+=1', unmark: '@n-=1', marked?: '@n>0'})

#--- second transition
t1 = T.new('T1', {fired: 'puts "T1 fire"'}) ###

a4 = A.new(p0, t1, 'A4', {mark: '@a+=1', unmark: '@a-=1', marked?: '@a>0'})
a5 = A.new(p1, t1, 'A5', {mark: '@b+=1', unmark: '@b-=1', marked?: '@b>0'})

a6 = A.new(t1, p2, 'A6', {mark: '@aa+=1', unmark: '@aa-=1', marked?: '@aa>0'})
a7 = A.new(t1, p3, 'A7', {mark: '@bb+=1', unmark: '@bb-=1', marked?: '@bb>0'})

#------ run
t a0.marked?, false, "A#marked? should be true"
t a1.marked?, false, "A#marked? should be true"

t t0.can_fire?, false, "Test: T0 should be able to fire because source Ps are marked"

a0.mark
t a0.marked?, true, 'Test: A0 is marked'
t a1.marked?, false, 'Test: A1 is marked'
t a2.marked?, false, 'Test: A2 is UNmarked'
t a3.marked?, false, 'Test: A2 is UNmarked'

t t0.can_fire?, false, 'Test: T0 can NOT fire becase P1 is unmarked'
a1.mark

t t0.can_fire?, true, 'Test: T0 CAN fire now'
t0.fire
#t1.fire

t a0.marked?, false, 'Test: A0 is UNmarked after fire'
t a1.marked?, false, 'Test: A1 is UNmarked after fire'
t a2.marked?, true, 'Test: A2 is marked after fire'
t a3.marked?, true, 'Test: A2 is marked after fire'


t a4.marked?, false, 'Test: A4 is marked'
t a5.marked?, false, 'Test: A5 is marked'
a4.mark
a5.mark
t a4.marked?, true, 'Test: A4 is marked'
t a5.marked?, true, 'Test: A5 is marked'
t a6.marked?, false, 'Test: A6 is UNmarked'
t a7.marked?, false, 'Test: A7 is UNmarked'

t t1.can_fire?, true, 'Test: T1 CAN fire now'
t1.fire

t a4.marked?, false, 'Test: 4 is UNmarked after fire'
t a5.marked?, false, 'Test: A5 is UNmarked after fire'
t a6.marked?, true, 'Test: A6 is marked after fire'
t a7.marked?, true, 'Test: A7 is marked after fire'

#=end

puts Net.new "\nTest check_options\n"
begin
    P.new('P0', {initializ: "@aaa=9"})
rescue => e
    t true, true, "Test: bad options should raise: #{e.message}"
end

puts Net.new "\nTest T fire\n"

a = [P.new, P.new] >> T.new
b = [P.new, P.new] >> T.new
c = [P.new, P.new] >> T.new

t ts = T.transitions.select(&:can_fire?), [], 'Test: not transition should be able to fire, return empty array'

m = a.inputs.map(&:mark)
t ts = T.transitions.select(&:can_fire?), [T[0]], 'Test: ONE transition should be able to fire, returns [T0]'

m = b.inputs.map(&:mark)
t ts = T.transitions.select(&:can_fire?), [T[0], T[1]], 'Test: ONE transition should be able to fire, returns [T0,T1]'

m = c.inputs.map(&:mark)
t ts = T.transitions.select(&:can_fire?), [T[0], T[1], T[2]], 'Test: ONE transition should be able to fire, returns [T0,T1,T2]'
=end

puts 'END'


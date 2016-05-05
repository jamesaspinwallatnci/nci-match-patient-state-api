load 'init.rb' unless $init_loaded
Node.destroy_all
Net.new("Test ostruct clear")

# 1)
P.new('a')

# 2)
T.new('t') {
    @a.not_empty?
}.execute {
    @a.clear
}

# 3)
P['a'] >> T['t']

# ----------------------------------------
ap P['a'].inspect

# 4)
P['a'].set('init_a', {aaa: 123})

ap P['a'].inspect
puts '-'*100

# ----------------------------------------

Net.new("Test 2")

# 'a' sends data to 'b'
P.new('a')
P.new('b')

T.new('t') {
    @a.not_empty?
}.execute {
    @b.aaa = @a.aaa
    @a.clear
}
# -------
P['a'] >> T['t'] >> P['b']
# -------

ap P['a'].inspect
ap P['b'].inspect
P['a'].set('init_a', {aaa: 123})
puts '='
ap P['a'].inspect
ap P['b'].inspect




describe Js2json do
  it 'should convert from JavaScript to JSON' do
    json = Js2json.js2json(<<-EOS)
function plus(a, b) {
  return a + b;
}

// Comment
({
  foo: "bar",
  "zoo": plus(1, 2),
  'BAZ': 'A' + 'B',
  plus: plus,
})
    EOS

    expect(json).to eq (<<-'EOS').chomp
{
  "foo": "bar",
  "zoo": 3,
  "BAZ": "AB",
  "plus": "function plus(a, b) {\n  return a + b;\n}"
}
    EOS
  end

  it 'should convert from JavaScript to JSON (with converter)' do
    conv = proc {|v| v.to_s }
    json = Js2json.js2json(<<-EOS, :conv => conv)
({
  foo: 100,
  bar: "200",
})
    EOS

    expect(json).to eq (<<-'EOS').chomp
{
  "foo": "100",
  "bar": "200"
}
    EOS
  end

  it 'should convert from JavaScript to JSON (with key converter)' do
    key_conv = proc {|v| v.to_s + '_' }
    json = Js2json.js2json(<<-EOS, :key_conv => key_conv)
({
  foo: 100,
  bar: "200",
})
    EOS

    expect(json).to eq (<<-'EOS').chomp
{
  "foo_": 100,
  "bar_": "200"
}
    EOS
  end

  it 'should convert from JavaScript to JSON (bachet script)' do
    expect {
      Js2json.js2json(<<-EOS)
{
  foo: 100,
  bar: "200",
}
      EOS
    }.to raise_error

    json = Js2json.js2json(<<-EOS, :bracket_script => true)
{
  foo: 100,
  bar: "200",
}
    EOS

    expect(json).to eq (<<-'EOS').chomp
{
  "foo": 100,
  "bar": "200"
}
    EOS
  end

  it 'should convert from JavaScript to JSON (use Ruby object)' do
    json = Js2json.js2json(<<-EOS)
Ruby.Kernel.require('net/http');

var page = Ruby.Net.HTTP.start('example.com', 80, function(http) {
  return http.get('/').body();
});

[page]
    EOS

    expect(json).to be =~ %r|<title>Example Domain</title>|
  end
end

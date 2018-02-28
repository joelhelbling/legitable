RSpec.describe Legitable::Table do
  When(:table) { subject.to_s }

  context 'data has varying width' do
    Given { subject << { foo: 'phew', bar: 'baarr', baz: 'bajh' } }
    Given { subject << { foo: 'phoolie', bar: 'bar', baz: 'bububububazzzz' } }

    Then { subject.headers == [:foo, :bar, :baz] }
    Then { expect(table).to look_like(<<-___) }
      FOO     | BAR   | BAZ           
      --------------------------------
      phew    | baarr | bajh          
      phoolie | bar   | bububububazzzz
    ___
  end

  context 'data has right-aligned fields' do
    Given(:subject) { described_class.new alignment: { bytes: :right } }
    Given { subject << { bytes: 12, file: 'foo.zip' } }
    Given { subject << { bytes: 1200, file: 'bar.zip' } }
    Given { subject << { bytes: 12000000, file: 'baz.zip' } }

    Then { expect(table).to look_like(<<-___) }
         BYTES | FILE   
      ------------------
            12 | foo.zip
          1200 | bar.zip
      12000000 | baz.zip
    ___
  end

  context 'change up the look!' do
    Given(:subject) do
      described_class.new alignment: { bytes: :right },
                          delimiter: '  ',
                          separator: '='
    end

    Given { subject << { bytes: 12, file: 'foo.zip' } }
    Given { subject << { bytes: 1200, file: 'bar.zip' } }
    Given { subject << { bytes: 12000000, file: 'baz.zip' } }

    Then { expect(table).to look_like(<<-___) }
         BYTES  FILE   
      =================
            12  foo.zip
          1200  bar.zip
      12000000  baz.zip
    ___
  end

  context 'with column processors' do
    Given(:subject) do
      described_class.new do
        formatting :bar do |value|
          "~~#{value}~~"
        end
      end
    end

    Given { subject << { foo: 'phew', bar: 'baarr', baz: 'bajh' } }
    Given { subject << { foo: 'phoolie', bar: 'bar', baz: 'bububububazzzz' } }

    Then { expect(table).to look_like(<<-___) }
      FOO     | BAR       | BAZ           
      ------------------------------------
      phew    | ~~baarr~~ | bajh          
      phoolie | ~~bar~~   | bububububazzzz
    ___
  end

  context 'with header processors' do
    Given(:subject) do
      described_class.new do
        formatting_headers do |header|
          header.capitalize
        end
      end
    end

    Given { subject << { foo: 'phew', bar: 'baarr', baz: 'bajh' } }
    Given { subject << { foo: 'phoolie', bar: 'bar', baz: 'bububububazzzz' } }

    Then { expect(table).to look_like(<<-___) }
      Foo     | Bar   | Baz           
      --------------------------------
      phew    | baarr | bajh          
      phoolie | bar   | bububububazzzz
    ___
  end

  context 'table with only one column' do
    Given { subject << { foo: 'foo' } }
    Given { subject << { foo: 'phew' } }
    Given { subject << { foo: 'foolishness' } }

    Then { expect(table).to look_like(<<-___) }
      FOO        
      -----------
      foo        
      phew       
      foolishness
    ___
  end

  context 'appending repeatedly' do
    Given do
      subject << { foo: 'foo' } \
              << { foo: 'phew' } \
              << { foo: 'foolishness' }
    end

    Then { expect(table).to look_like(<<-___) }
      FOO        
      -----------
      foo        
      phew       
      foolishness
    ___
  end
end

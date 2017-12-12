
RSpec.describe Legitable::Table do
  When(:result) { subject.to_s }

  context 'data has varying width' do
    Given { subject << { foo: 'phew', bar: 'baarr', baz: 'bajh' } }
    Given { subject << { foo: 'phoolie', bar: 'bar', baz: 'bububububazzzz' } }

    Then { subject.headers == [:foo, :bar, :baz] }
    Then do
      subject.to_s == <<-EOS
FOO     | BAR   | BAZ           
--------------------------------
phew    | baarr | bajh          
phoolie | bar   | bububububazzzz
      EOS
    end
  end

  context 'data has right-aligned fields' do
    Given(:subject) { described_class.new alignment: { bytes: :right } }
    Given { subject << { bytes: 12, file: 'foo.zip' } }
    Given { subject << { bytes: 1200, file: 'bar.zip' } }
    Given { subject << { bytes: 12000000, file: 'baz.zip' } }

    Then do
      subject.to_s == <<-EOS
   BYTES | FILE   
------------------
      12 | foo.zip
    1200 | bar.zip
12000000 | baz.zip
      EOS
    end
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

    Then do
      subject.to_s == <<-EOS
   BYTES  FILE   
=================
      12  foo.zip
    1200  bar.zip
12000000  baz.zip
      EOS
    end
  end

  context 'with column processors' do
    Given(:subject) do
      described_class.new do
        formatting :bar do |value|
          "__#{value}__"
        end
      end
    end

    Given { subject << { foo: 'phew', bar: 'baarr', baz: 'bajh' } }
    Given { subject << { foo: 'phoolie', bar: 'bar', baz: 'bububububazzzz' } }

    Then do
      subject.to_s == <<-EOS
FOO     | BAR       | BAZ           
------------------------------------
phew    | __baarr__ | bajh          
phoolie | __bar__   | bububububazzzz
      EOS
    end
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

    Then do
      subject.to_s == <<-EOS
Foo     | Bar   | Baz           
--------------------------------
phew    | baarr | bajh          
phoolie | bar   | bububububazzzz
      EOS
    end
  end
end

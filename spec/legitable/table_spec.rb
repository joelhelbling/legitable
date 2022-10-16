RSpec.describe Legitable::Table do
  Given(:table) { subject }

  context "data has varying width" do
    Given { table << {foo: "phew", bar: "baarr", baz: "bajh"} }
    Given { table << {foo: "phoolie", bar: "bar", baz: "bububububazzzz"} }

    Then { table.headers == [:foo, :bar, :baz] }
    Then { expect(table).to look_like(<<-___) }
      FOO     | BAR   | BAZ           
      --------------------------------
      phew    | baarr | bajh          
      phoolie | bar   | bububububazzzz
    ___
  end

  context "data has right-aligned fields" do
    Given(:table) { described_class.new alignment: {bytes: :right} }
    Given { table << {bytes: 12, file: "foo.zip"} }
    Given { table << {bytes: 1200, file: "bar.zip"} }
    Given { table << {bytes: 12000000, file: "baz.zip"} }

    Then { expect(table).to look_like(<<-___) }
         BYTES | FILE   
      ------------------
            12 | foo.zip
          1200 | bar.zip
      12000000 | baz.zip
    ___
  end

  context "change up the look!" do
    Given(:table) do
      described_class.new alignment: {bytes: :right},
        delimiter: "  ",
        separator: "="
    end

    Given { table << {bytes: 12, file: "foo.zip"} }
    Given { table << {bytes: 1200, file: "bar.zip"} }
    Given { table << {bytes: 12000000, file: "baz.zip"} }

    Then { expect(table).to look_like(<<-___) }
         BYTES  FILE   
      =================
            12  foo.zip
          1200  bar.zip
      12000000  baz.zip
    ___
  end

  context "markdown style" do
    Given(:table) { described_class.new style: :markdown }
    Given { table << {foo: "phew", bar: "baarr", baz: "bajh"} }
    Given { table << {foo: "phoolie", bar: "bar", baz: "bububububazzzz"} }

    Then { expect(table).to look_like(<<-___) }
      FOO     | BAR   | BAZ           
      --------|-------|---------------
      phew    | baarr | bajh          
      phoolie | bar   | bububububazzzz
    ___
  end

  context "with column processors" do
    Given(:table) do
      described_class.new do
        formatting :bar do |value|
          "~~#{value}~~"
        end
      end
    end

    Given { table << {foo: "phew", bar: "baarr", baz: "bajh"} }
    Given { table << {foo: "phoolie", bar: "bar", baz: "bububububazzzz"} }

    Then { expect(table).to look_like(<<-___) }
      FOO     | BAR       | BAZ           
      ------------------------------------
      phew    | ~~baarr~~ | bajh          
      phoolie | ~~bar~~   | bububububazzzz
    ___
  end

  context "with header processors" do
    Given(:table) do
      described_class.new do
        formatting_headers do |header|
          header.capitalize
        end
      end
    end

    Given { table << {foo: "phew", bar: "baarr", baz: "bajh"} }
    Given { table << {foo: "phoolie", bar: "bar", baz: "bububububazzzz"} }

    Then { expect(table).to look_like(<<-___) }
      Foo     | Bar   | Baz           
      --------------------------------
      phew    | baarr | bajh          
      phoolie | bar   | bububububazzzz
    ___
  end

  context "table with only one column" do
    Given { table << {foo: "foo"} }
    Given { table << {foo: "phew"} }
    Given { table << {foo: "foolishness"} }

    Then { expect(table).to look_like(<<-___) }
      FOO        
      -----------
      foo        
      phew       
      foolishness
    ___
  end

  context "appending repeatedly" do
    Given do
      table << {foo: "foo"} \
            << {foo: "phew"} \
            << {foo: "foolishness"}
    end

    Then { expect(table).to look_like(<<-___) }
      FOO        
      -----------
      foo        
      phew       
      foolishness
    ___
  end

  context "with an Array" do
    Given(:data) { [{foo: "foo"}, {foo: "phew"}, {foo: "fewlishniss"}] }

    When { table << data }

    Then { expect(table).to look_like(<<-___) }
      FOO        
      -----------
      foo        
      phew       
      fewlishniss
    ___
  end

  context "with an Enumerable" do
    Given(:data) { [{foo: "foo"}, {foo: "phew"}, {foo: "phewlissnesh"}].each }

    When { table << data }

    Then { expect(table).to look_like(<<-___) }
      FOO         
      ------------
      foo         
      phew        
      phewlissnesh
    ___
  end
end

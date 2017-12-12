require 'ostruct'

module Legitable
  class Table
    attr_reader :rows, :headers, :delimiter, :separator, :format

    def initialize(alignment: {}, delimiter: ' | ', separator: '-', &block)
      @rows = []
      @headers = []
      @format = {}
      @formatters = {}
      @alignment = alignment
      @delimiter = delimiter
      @separator = separator

      self.instance_eval(&block) unless block.nil?
    end

    def <<(row)
      initialize_headers(row) if headers.empty?
      add_row row
    end

    def to_s
      render_headers +
      rows.map do |row|
        headers.map do |header|
          render_cell(header, row[header])
        end.join(delimiter)
      end.join("\n") + "\n"
    end

    private

    def initialize_headers(row)
      @headers = row.keys
      headers.each do |header|
        format[header] = OpenStruct.new(
          width: header.to_s.length,
          formatter: @formatters[header] || default_formatter,
          align: @alignment[header] || :left
        )
      end
    end

    def add_row(row)
      rows << headers.inject({}) do |memo, header|
        formatter = format[header].formatter
        value = formatter.call(row[header].to_s).to_s
        if format[header].width < value.length
          format[header].width = value.length
        end
        memo[header] = value
        memo
      end
    end

    def render_headers
      headers.map do |header|
        render_cell(header, header_formatter.call(header))
      end.join(delimiter) + "\n" + (separator * row_width) + "\n"
    end

    def row_width
      width = (headers.size - 1) * delimiter.length
      headers.sum(width) do |header|
        format[header].width
      end
    end

    def render_cell(header, value)
      cell_width = format[header].width

      (format[header].align == :right) ?
        value.rjust(cell_width, ' ') :
        value.to_s + (' ' * (cell_width - value.to_s.length))
    end

    def formatting(header, &block)
      @formatters[header] = block ? block : default_formatter
    end

    def default_formatter
      @default_formatter ||= Proc.new {|value| value.to_s }
    end

    def formatting_headers(&block)
      @header_formatter = block
    end

    def header_formatter
      @header_formatter ||= Proc.new {|header| header.to_s.upcase }
    end
  end
end
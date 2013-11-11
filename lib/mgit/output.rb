module MGit
  module Output
    def pinfo(s)
      puts s.green
    end

    def pwarn
      puts s.yellow
    end

    def perror
      puts s.red
    end

    def ptable(table, options = {})
      puts TableOutputter.new(table, options).to_s
    end

  private

    class TableOutputter
      attr_reader :table, :options

      def initialize(table, options)
        @table = table
        @options = options
        raise ImplementationError.new('ptable called with invalid table') unless valid_table?
      end

      def to_s
        cw = column_widths
        
        if options[:columns]
          options[:columns].each_with_index do |c, i|
            cw[i] = c if c
          end
        end

        table.map do |row|
          row.map.with_index { |cell, i| justify(cell, cw[i]) }.join(' | ')
        end.join("\n")
      end

    private

      def valid_table?
        table.empty? || table.all? { |c| c.is_a?(Array) && c.size == table.first.size }
      end

      def columns
        table.first.size
      end

      def column(nth)
        table.map { |c| c[nth] }
      end

      def transpose
        (0..(columns - 1)).map { |i| column(i) }
      end

      def column_widths
        transpose.map do |col|
          col.map { |cell| cell.size }.max
        end
      end

      def justify(s, n)
       (s.size > n) ? (s[0..(n - 3)] + '...') : s.ljust(n, ' ')
      end
    end
  end
end

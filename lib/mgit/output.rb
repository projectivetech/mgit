module MGit
  module Output
    def psystem(s)
      print_to_screen s
    end

    def pinfo(s)
      print_to_screen s.green
    end

    def pwarn(s)
      print_to_screen s.yellow
    end

    def perror(s)
      print_to_screen s.red
    end

    def ptable(table, options = {})
      print_to_screen TableOutputter.new(table, options).to_s
    end

    private

    def print_to_screen(s)
      if Configuration.colors
        puts s
      else
        puts s.uncolorize
      end
    end

    class TableOutputter
      attr_reader :table, :options

      def initialize(table, options)
        @table = table
        @options = options
        @options[:columns] = []
        fail ImplementationError, 'ptable called with invalid table' unless valid_table?
      end

      def to_s
        return '' if table.empty?

        cw = column_widths

        table.map do |row|
          row.map.with_index do |cell, i|
            # Only justify the column if it is not the last one.
            # This avoids too many line breaks.
            i < (columns - 1) ? justify(cell, cw[i]) : cell
          end.join(' | ')
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
        column_max_widths.each_with_index.map do |c, i|
          (options[:columns].size > i && options[:columns][i]) ? options[:columns][i] : c
        end
      end

      def column_max_widths
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

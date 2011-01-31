require 'rdbi-driver-mock'

module RDBI
  class Driver
    class Mock < RDBI::Driver
      def initialize(*args)
        super(Mock::DBH, *args)
      end
    end

    # XXX STUB
    class Mock::STH < RDBI::Statement
      attr_accessor :result
      attr_accessor :affected_count
      attr_accessor :set_schema
      attr_accessor :input_type_map

      def initialize(query, dbh)
        super
        @set_schema = nil
        prep_finalizer
      end

      # just to be abundantly clear, this is a mock method intended to
      # facilitate tests.
      def new_execution(*binds)
        this_data = if result
                      result
                    else
                      (0..4).to_a.collect do |x|
                        binds.collect do |bind|
                          case bind
                          when Integer
                            bind + x
                          else
                            bind.to_s + x.to_s
                          end
                        end
                      end
                    end

        return Mock::Cursor.new(this_data), @set_schema || RDBI::Schema.new((0..9).to_a.map { |x| RDBI::Column.new(x) }), RDBI::Type.create_type_hash(RDBI::Type::Out)
      end
    end

    class Mock::DBH < RDBI::Database
      attr_accessor :next_action

      def new_statement(query)
        Mock::STH.new(query, self)
      end

      def ping
        connected? ? 10 : nil
      end

      def rollback
        super();
        "rollback called"
      end

      # XXX more methods to be defined this way.
      def commit(*args)
        super(*args)

        ret = nil

        if next_action
          ret = next_action.call(*args)
          self.next_action = nil
        end

        ret
      end
    end

    class Mock::Cursor < RDBI::Cursor
      def initialize(handle)
        super(handle.dup)
        @index = 0
      end

      def fetch(count=1)
        return [] if last_row?
        a = []
        count.times { a.push(next_row) }
        return a
      end

      def next_row
        retval = @handle[@index]
        @index += 1
        return retval
      end

      def result_count
        @handle.size
      end

      def affected_count
        16 # magic number
      end
      
      def first
        @handle.first
      end

      def last
        @handle.last
      end

      def rest
        oindex, @index = @index, @handle.size
        @handle[oindex, @index]
      end

      def all
        @handle.dup
      end

      def [](index)
        @handle[index]
      end

      def last_row?
        @index == @handle.size
      end

      def rewind
        raise StandardError, "cannot rewind without rewindable_result set to true" unless rewindable_result
        @index = 0
      end

      def empty?
        @handle.empty?
      end
    end
  end
end

# vim: syntax=ruby ts=2 et sw=2 sts=2

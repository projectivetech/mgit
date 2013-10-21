module MGit
  class NoCommandError < ArgumentError; end
  class UnknownCommandError < ArgumentError; end
  class CommandArgumentError < ArgumentError; end

  class TooFewArgumentsError < CommandArgumentError; end
  class TooManyArgumentsError < CommandArgumentError; end
end

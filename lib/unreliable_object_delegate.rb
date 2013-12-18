require 'timeout'

class UnreliableObjectDelegate
  def initialize target, timeout_in_seconds, max_attempts
    @target = target
    @timeout_in_seconds = timeout_in_seconds
    @max_attempts = max_attempts
  end

  def handle_failure_with_default_return default
    @default = default
  end

  def handle_failure_with_error error
    @error = error
  end

  def method_missing method, *args, &block
    (@max_attempts - 1).times do
      begin
        return try_call method, *args, &block
      rescue
        puts "WARNING - call to '#{@target.class}::#{method}' timed out after #{@timeout_in_seconds}s.  Attempting another call..."
      end
    end

    make_final_attempt method, *args, &block
  end

  def make_final_attempt method, *args, &block
    begin
      puts "SEVERE WARNING - There have now been #{@max_attempts} timeouts on calls to '#{@target.class}::#{method}' with args #{args}.  Making final attempt..."
      return try_call method, *args, &block
    rescue => e
      return @default if defined? @default
      raise @error.new(e) if defined? @error
      raise
    end
  end

  def try_call method, *args, &block
    Timeout::timeout(@timeout_in_seconds) do
      result = @target.send method, *args, &block
      puts "Unreliable method '#{@target.class}::#{method}' succeeded.  Result is #{result.to_s[0..300]}..."
      result
    end
  end
end

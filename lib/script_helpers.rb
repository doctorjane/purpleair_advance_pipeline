module ScriptHelpers
  def self.do_cmd(cmd)
    puts "doing >#{cmd}<"
    output = `#{cmd}`
    status = $?
    if !status.success?
      raise "'#{cmd}' failed with #{status}\n#{output}"
    end
    output
  end
end
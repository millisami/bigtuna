module BigTuna::VCS
  class Mercurial < Base
    NAME = "Mercurial"
    VALUE = "hg"

    def head_info
      info = {}
      command = "hg log --limit 1 --rev #{self.branch} --template='{node}\n{author|person}\n{author|email}\n{date|date}\n{desc}'"
      begin
        output = BigTuna::Runner.execute(self.source, command)
      rescue BigTuna::Runner::Error => e
        raise VCS::Error.new("Couldn't access repository log")
      end
      head_hash = output.stdout
      info[:commit] = head_hash.shift
      info[:author] = head_hash.shift
      info[:email] = head_hash.shift
      info[:committed_at] = Time.parse(head_hash.shift)
      info[:commit_message] = head_hash.join("\n")
      [info, command]
    end

    def clone(where_to)
      command = "hg clone -u #{self.branch} #{self.source} #{where_to}"
      BigTuna::Runner.execute(Dir.pwd, command)
    end
  end
end

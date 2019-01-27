require "json"
require "option_parser"

ssh_config = "~/.ssh/config"
dynamic_profiles_dir = "~/Library/Application Support/iTerm2/DynamicProfiles"
iterm_profile = "ssh_profiles.json"
verbose = false

OptionParser.parse! do |parser|
  parser.banner = "Usage: ssh_config_to_iterm_profiles [arguments]"
  parser.on("-c SSH_CONFIG", "--ssh-config=SSH_CONFIG", "path to ssh config") { |v|
    ssh_config = v
  }
  parser.on("-p DYNAMIC_PROFILE_DIR", "--profile-dir=DYNAMIC_PROFILE_DIR", "path to iTerm2 dynamic profiles dir") { |v|
    dynamic_profiles_dir = v
  }
  parser.on("-n PROFILE_NAME", "--outnameput=PROFILE_NAME", "generated profile name") { |v|
    iterm_profile = v
  }
  parser.on("-v", "--verbose", "verbose") {
    verbose = true
  }
  parser.on("-d", "--defaults", "Show defaults") {
    puts "Default values"
    puts sprintf("%20s: %s", "ssh_config", ssh_config)
    puts sprintf("%20s: %s", "dynamic_profiles_dir", dynamic_profiles_dir)
    puts sprintf("%20s: %s", "iterm_profile", iterm_profile)
    exit
  }
  parser.on("-h", "--help", "Show this help") { puts parser; exit }
end

ssh_config = File.expand_path(ssh_config)
dynamic_profiles_dir = File.expand_path(dynamic_profiles_dir)

host = nil
tag = nil

profile_parents = {
  /prod-/ => "Production",
}

profiles = JSON.build do |json|
  json.object do
    json.field "Profiles" do
      json.array do
        File.each_line(ssh_config) do |line|
          next if /\*/.match(line)
          if host.nil? && (matches = /^host\s+(\S+)/.match(line))
            host = matches[1]
          end
          if host
            profile_parents.each { |pattern, parent|
              if pattern =~ host
                tag = parent
              end
            }
            tag ||= "Default"
          end
          if host && tag
            command = "ssh #{host}"
            puts "... #{command} => #{tag}" if verbose
            json.object do
              json.field "Name", host
              json.field "Guid", host
              json.field "Command", command
              json.field "Dynamic Profile Parent Name", tag
              json.field "Custom Command", "Yes"
              json.field "Tags" do
                json.array do
                  json.string tag
                end
              end
            end
            host = tag = nil
          end
        end
      end
    end
  end
end

File.write(File.join(dynamic_profiles_dir, iterm_profile), profiles)
puts %Q{Wrote to "#{File.join(dynamic_profiles_dir, iterm_profile)}"}

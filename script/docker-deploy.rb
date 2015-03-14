def parse_args(*args)
  missing = []
  hash = {}
  args.each do |arg|
    value = ARGV.shift.to_s
    if value == ""
      missing << arg
    else
      hash[arg.to_sym] = value
    end
  end

  if !missing.empty?
    puts "ERROR: Missing args: #{missing.join(", ")}"
    exit(1)
  end

  hash
end

def docker_image_tag(project_name, subproject_name, tag)
  "%s/%s-%s:%s" % [env('DOCKER_INDEX_USERNAME'), project_name, subproject_name, tag]
end

def run(cmd)
  if cmd.match(/password/i)
    puts cmd.sub(/password.+/i, 'password [REDACTED]')
  else
    puts cmd
  end
  system(cmd)
end

def env(name)
  value = ENV[name].to_s
  if value == ""
    raise "Missing environment variable[%s]" % name
  end
  value
end

def docker(command)
  run("docker %s" % command)
end


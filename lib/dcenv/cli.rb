require 'dcenv'
require 'thor'

module Dcenv
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'Help message'

    desc "install", "Install container"
    def install(*args)
      if args.length >= 2
        cname = to_cname(args[0])
        iname = args[1]
      else
        cname = to_cname(args[0])
        iname = args[0]
      end
      
      system("docker", "run", "--name", cname, "-v", "#{Dir.home}:/root", "-dit", iname)
    end

    desc "uninstall", "Uninstall container"
    def uninstall(*args)
      system("docker", "rm", "-f", to_cname(args[0])) 
    end

    desc "exec", "Login/Execute container"
    def exec(*args)
      cname = to_cname(args[0])

      # TODO: Restart if container is stopped
      system("docker", "start", cname)
      system("docker", "exec", "-it", cname, "/bin/bash")
    end

    no_tasks do
      def to_cname(name)
        "dcenv-#{name}"
      end
      
      # Override method for support -h 
      # defined in /lib/thor/invocation.rb
      def invoke_command(task, *args)
        if task.name == "help" && args == [[]]
          print "dcenv #{Dcenv::VERSION}\n\n"
        end
        
        if options[:help]
          CLI.task_help(shell, task.name)
        else
          super
        end
      end
    end
  end
end

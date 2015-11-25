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
      name = args[0]
      cname = "dcenv-#{name}"
      
      # Support -v
      # Support "dcenv install rust schickling/rust"
      system("docker", "run", "--name", cname, "-dit", name) 
    end

    desc "exec", "Login to container"
    def exec(*args)
      name = args[0]
      cname = "dcenv-#{name}"

      # TODO: Restart if container is stopped
      system("docker", "start", cname)
      system("docker", "exec", "-it", cname, "/bin/bash")
    end

    no_tasks do
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

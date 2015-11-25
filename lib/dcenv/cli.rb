require 'dcenv'
require 'thor'

module Dcenv
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'Help message'

    desc "install", "Install container"
    def install
      # Support -v
      # Support "dcenv install rust schickling/rust"
      system("docker", "run", "--name", "dcenv-node", "-dit", "node") 
    end

    desc "exec", "Login to container"
    def exec
      # TODO: Restart if container is stopped
      system("docker", "start", "dcenv-node")
      system("docker", "exec", "-it", "dcenv-node", "/bin/bash")
    end

    desc "stop", "Stop container"
    def stop
      system("docker", "stop", "dcenv-node")
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
